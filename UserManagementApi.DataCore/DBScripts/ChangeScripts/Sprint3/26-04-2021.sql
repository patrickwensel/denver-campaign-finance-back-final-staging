----------------------------------------------------Tables-----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- Table: public.filer_invoice

-- DROP TABLE public.filer_invoice;

CREATE TABLE public.filer_invoice
(
    invoice_id integer NOT NULL DEFAULT nextval('filer_invoice_invoice_id_seq'::regclass),
    invoice_type_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    filer_id integer NOT NULL,
    status character varying(100) COLLATE pg_catalog."default" NOT NULL,
    amount numeric(15,2),
    created_date date,
    CONSTRAINT filer_invoice_pkey PRIMARY KEY (invoice_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.filer_invoice
    OWNER to devadmin;


    -- Table: public.payment

-- DROP TABLE public.payment;

CREATE TABLE public.payment
(
    payment_id integer NOT NULL DEFAULT nextval('payment_payment_id_seq'::regclass),
    invoice_id integer NOT NULL,
    amount numeric(15,2) NOT NULL,
    date date,
    "user" character varying(100) COLLATE pg_catalog."default" NOT NULL,
    payment_method character varying(100) COLLATE pg_catalog."default" NOT NULL,
    filer_id integer NOT NULL,
    CONSTRAINT payment_invoice_pkey PRIMARY KEY (payment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.payment
    OWNER to devadmin;


-------------------------------------------------Functions---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION: public.get_filerinvoices(integer, character varying)

-- DROP FUNCTION public.get_filerinvoices(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_filerinvoices(
	_entityid integer,
	_entitytype character varying)
    RETURNS TABLE(invoiceid integer, invoicetype character varying, invoicedesc character varying, invoicestatus character varying, amount numeric, remainingamount numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filerid integer;
Begin

SELECT filer_id INTO filerid FROM public.filer where entity_id = _entityid
and entity_type = _entitytype;

  return query
  select inv.Invoice_Id,
		 inv.invoice_type_id,
		 inv.desc,
		 inv.status,
		 inv.amount,
		 inv.amount-Coalesce(sum(pay.amount,0.00)) as remainingamt
 from public.filer_invoice inv  
left join payment pay on
 pay.invoice_Id = inv.invoice_id
 left join type_lookups invoicetype  on 
 invoicetype.type_id =inv.invoice_type_id 
 and invoicetype.lookup_type_code='INVOICE_TYPE'
 left join type_lookups invoicestatus  on 
 invoicestatus.type_id =inv.status 
 and invoicestatus.lookup_type_code='INVOICE_STATUS'
 where inv.filer_id = filerid
 group by inv.invoice_id
  order by inv.created_date desc;
 end
$BODY$;

ALTER FUNCTION public.get_filerinvoices(integer, character varying)
    OWNER TO devadmin;

-- FUNCTION: public.get_fileroutstandingfeesummary(integer, character varying)

-- DROP FUNCTION public.get_fileroutstandingfeesummary(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_fileroutstandingfeesummary(
	_entity_id integer,
	_entity_type character varying)
    RETURNS TABLE(id integer, totalfine numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
Declare filerid int;

BEGIN

select  filer_id into filerid from public.filer where entity_type=_entity_type 
and entity_id =  _entity_id;

RETURN query 
	SELECT 1 AS ID, 
 sum( i.Fineamount - Coalesce(P.paidamount,0)) as totfineamount 
FROM
( SELECT pay.invoice_id,Coalesce(Sum(pay.amount),0.00) as paidamount FROM Payment pay
where pay.filer_id =filerid GROUP BY pay.invoice_id ) as P
 RIGHT JOIN
(SELECT inv.invoice_id,sum(inv.amount) as Fineamount FROM Filer_invoice inv where 
 inv.filer_id =filerid
GROUP BY inv.invoice_id) as i ON i.invoice_id = P.invoice_id
	UNION
	SELECT 2 AS ID,Coalesce(Sum(amount),0.00) AS TotalFineCollected from 
	public.payment where payment.filer_id =filerid
	UNION
	SELECT 3 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountwaived from 
	public.payment where payment_method='WAI' and payment.filer_id =70
	UNION
	SELECT 4 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountreduced from 
	public.payment where payment_method='RED' and payment.filer_id =filerid
	ORDER BY id;
END
$BODY$;

ALTER FUNCTION public.get_fileroutstandingfeesummary(integer, character varying)
    OWNER TO devadmin;

-- FUNCTION: public.get_invoiceinfofromid(integer)

-- DROP FUNCTION public.get_invoiceinfofromid(integer);

CREATE OR REPLACE FUNCTION public.get_invoiceinfofromid(
	_invoiceid integer)
    RETURNS TABLE(invoicetype character varying, invoiceDesc character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
Begin
RETURN query

SELECT invoicetype.name, inv.desc
from filer_invoice inv
left join type_lookups invoicetype 
on invoicetype.type_id = inv.invoice_type_id and lookup_type_code='INVOICE_TYPE'
  where inv.invoice_id=_invoiceid;
  

 
end
$BODY$;

ALTER FUNCTION public.get_invoiceinfofromid(integer)
    OWNER TO devadmin;

--FUNCTION: public.get_invoicesforadmin(integer)

-- DROP FUNCTION public.get_invoicesforadmin(integer);

CREATE OR REPLACE FUNCTION public.get_invoicesforadmin(
	_filerid integer)

	RETURNS TABLE(invoiceid integer, invoicetype character varying, invoicedesc character varying, invoicestatus character varying, amount numeric,
	remainingamount numeric, filername text, penaltyattachmentid integer)

	LANGUAGE 'plpgsql'

	COST 100

	VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE entitytyp character varying;

Begin

if (_filerid > 0)
	then

	select entity_type into entitytyp
from filer where filer_id=_filerid;

if (entitytyp = 'C') then
  return query
  select inv.Invoice_Id,
		 invoicetype.name,
		 inv.desc,
		 invoicestatus.name,
		 inv.amount,
		 inv.amount-COALESCE(P.paidamount,0.00) as remainingamount,
		Cast(C.name as text) as filername,
		 att.attachment_id
 from public.filer_invoice inv
 inner join filer fil on fil.filer_id = inv.filer_id
 left join penalty pen on pen.filer_id = fil.filer_id
  left join txn_file_attachment att on  att.record_id = pen.penalty_id
  inner join committee c on c.committee_id = fil.entity_id and fil.entity_type='C'
inner  JOIN LATERAL (
        SELECT 
            Coalesce(Sum(pay.amount),0.00) as paidamount

		FROM
            payment as pay
        WHERE 
            pay.invoice_id = inv.invoice_id
    ) as P ON 1 = 1
 left join type_lookups invoicetype  on 
 invoicetype.type_id =inv.invoice_type_id 
 and invoicetype.lookup_type_code='INVOICE_TYPE'
 left join type_lookups invoicestatus  on 
 invoicestatus.type_id =inv.status 
 and invoicestatus.lookup_type_code='INVOICE_STATUS'
 where inv.filer_id = _filerid
 group by inv.Invoice_Id, filername, invoicetype.name, invoicestatus.name,
P.paidamount, att.attachment_id
  order by inv.created_date desc;

elsif(entitytyp = 'L') then
  return query
  select inv.Invoice_Id,
		 invoicetype.name,
		 inv.desc,
		 invoicestatus.name,
		 inv.amount,
		 inv.amount-coalesce(P.paidamount,0.00) as remainingamount,
		 CASE WHEN L.type='LOB-O'  THEN cont.Org_name
		       WHEN CONCAT(cont.middle_name, 'ZZZ') = 'ZZZ' THEN cont.first_name || ' ' || cont.last_name
				ELSE  cont.first_name || ' ' || cont.middle_name || ' ' || cont.last_name
			END as filername,
			att.attachment_id
 from public.filer_invoice inv
 inner join filer fil on fil.filer_id = inv.filer_id
 left join penalty pen on pen.filer_id = fil.filer_id
  left join txn_file_attachment att on  att.record_id = pen.penalty_id
 inner join lobbyist L on L.lobbysit_id = fil.entity_id and fil.entity_type='L'
 left join contact  cont  on  cont.contact_id =L.filer_contact_id
INNER JOIN LATERAL (
        SELECT 
            Coalesce(Sum(pay.amount),0.00) as paidamount

		FROM
            payment as pay
        WHERE 
            pay.invoice_id = inv.invoice_id
    ) as P ON 1 = 1
left join type_lookups invoicetype  on 
 invoicetype.type_id =inv.invoice_type_id 
 and invoicetype.lookup_type_code='INVOICE_TYPE'
 left join type_lookups invoicestatus  on 
 invoicestatus.type_id =inv.status 
 and invoicestatus.lookup_type_code='INVOICE_STATUS'
 where inv.filer_id = _filerid
 group by inv.Invoice_Id, filername, invoicetype.name, invoicestatus.name,
P.paidamount, att.attachment_id
  order by inv.created_date desc;
end if;
else

	return query
  select inv.Invoice_Id,
		 invoicetype.name,
		 inv.desc,
		 invoicestatus.name,
		 inv.amount,
		 inv.amount-coalesce(P.paidamount,0.00) as remainingamount,
		 Cast(com.name as text) as filername,
		 att.attachment_id
 from public.filer_invoice inv
 inner join filer fil on fil.filer_id = inv.filer_id
 inner join committee Com on Com.Committee_id = fil.entity_id and fil.entity_type='C'
 left join penalty pen on pen.filer_id = fil.filer_id
  left join txn_file_attachment att on  att.record_id = pen.penalty_id
 inner JOIN LATERAL (
        SELECT 
            Coalesce(Sum(pay.amount),0.00) as paidamount

		FROM
            payment as pay
        WHERE 
            pay.invoice_id = inv.invoice_id
    ) as P ON 1 = 1
 left join type_lookups invoicetype  on 
 invoicetype.type_id =inv.invoice_type_id 
 and invoicetype.lookup_type_code='INVOICE_TYPE'
 left join type_lookups invoicestatus  on 
 invoicestatus.type_id =inv.status 
 and invoicestatus.lookup_type_code='INVOICE_STATUS'
 group by  inv.Invoice_Id, filername, invoicetype.name, invoicestatus.name,
P.paidamount, att.attachment_id
UNION 
 select inv.Invoice_Id,
		 invoicetype.name,
		 inv.desc,
		 invoicestatus.name,
		 inv.amount,
		 inv.amount-coalesce(P.paidamount,0.00) as remainingamount,
		 CASE WHEN L.type='LOB-O'  THEN Con.Org_name
		       WHEN CONCAT(con.middle_name, 'ZZZ') = 'ZZZ' THEN con.first_name || ' ' || con.last_name
				ELSE  con.first_name || ' ' || con.middle_name || ' ' || con.last_name
			END as filername,
			att.attachment_id
 from public.filer_invoice inv
 inner join filer fil on fil.filer_id = inv.filer_id
 inner join lobbyist L on L.lobbysit_id = fil.entity_id and fil.entity_type='L'
 Left join contact con on con.contact_id = L.filer_contact_id
 left join penalty pen on pen.filer_id = fil.filer_id
  left join txn_file_attachment att on  att.record_id = pen.penalty_id
  INNER JOIN LATERAL (
        SELECT 
            Coalesce(Sum(pay.amount),0.00) as paidamount

		FROM
            payment as pay
        WHERE 
            pay.invoice_id = inv.invoice_id
            
    ) as P ON 1 = 1
 left join type_lookups invoicetype  on 
 invoicetype.type_id =inv.invoice_type_id 
 and invoicetype.lookup_type_code='INVOICE_TYPE'
 left join type_lookups invoicestatus  on 
 invoicestatus.type_id =inv.status 
 and invoicestatus.lookup_type_code='INVOICE_STATUS'
  group by  inv.Invoice_Id,
  filername, invoicetype.name, invoicestatus.name,
		 P.paidamount,
	  att.attachment_id;

end IF;

end;
$BODY$;

ALTER FUNCTION public.get_invoicesforadmin(integer)

	OWNER TO devadmin;

-- FUNCTION: public.get_outstandingfeesummary(integer)

-- DROP FUNCTION public.get_outstandingfeesummary(integer);

CREATE OR REPLACE FUNCTION public.get_outstandingfeesummary(
	_filer_id integer)
    RETURNS TABLE(id integer, totalfine numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
IF (_filer_id > 0) THEN

RETURN query 
	SELECT 1 AS ID, 
 sum( i.Fineamount - Coalesce(P.paidamount,0)) as totfineamount 
FROM
( SELECT pay.invoice_id,Coalesce(Sum(pay.amount),0.00) as paidamount FROM Payment pay
where pay.filer_id =_filer_id GROUP BY pay.invoice_id ) as P
 RIGHT JOIN
(SELECT inv.invoice_id,sum(inv.amount) as Fineamount FROM Filer_invoice inv where 
 inv.filer_id =_filer_id
GROUP BY inv.invoice_id) as i ON i.invoice_id = P.invoice_id
	UNION
	SELECT 2 AS ID,Coalesce(Sum(amount),0.00) AS TotalFineCollected from 
	public.payment where payment.filer_id =_filer_id
	UNION
	SELECT 3 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountwaived from 
	public.payment where payment_method='WAI' and payment.filer_id =_filer_id
	UNION
	SELECT 4 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountreduced from 
	public.payment where payment_method='RED' and payment.filer_id =_filer_id
	ORDER BY id;
	
	
ELSE 

RETURN query 
	SELECT 1 AS ID, 
 sum( i.Fineamount - Coalesce(P.paidamount,0)) as totfineamount 
FROM
( SELECT pay.invoice_id,Coalesce(Sum(pay.amount),0.00) as paidamount FROM Payment pay
GROUP BY pay.invoice_id ) as P
 RIGHT JOIN
(SELECT inv.invoice_id,sum(inv.amount) as Fineamount FROM Filer_invoice inv
GROUP BY inv.invoice_id) as i ON i.invoice_id = P.invoice_id
	UNION
	SELECT 2 AS ID,Coalesce(Sum(amount),0.00) AS TotalFineCollected from 
	public.payment
	UNION
	SELECT 3 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountwaived from 
	public.payment where payment_method='WAI'
	UNION
	SELECT 4 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountreduced from 
	public.payment where payment_method='RED' 
	ORDER BY id;
END IF;

END
$BODY$;

ALTER FUNCTION public.get_outstandingfeesummary(integer)
    OWNER TO devadmin;

-- FUNCTION: public.update_invoicestatus(integer, character varying)

-- DROP FUNCTION public.update_invoicestatus(integer, character varying);

CREATE OR REPLACE FUNCTION public.update_invoicestatus(
	_invoiceid integer,
	_statustype character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
Begin

UPDATE filer_invoice SET
  status=_statustype 
  where invoice_id=_invoiceid;

return _invoiceid;
 
end
$BODY$;

ALTER FUNCTION public.update_invoicestatus(integer, character varying)
    OWNER TO devadmin;


-- FUNCTION: public.save_Transaction(integer, numeric, character varying, date, character varying, integer, integer)

-- DROP FUNCTION public."save_Transaction"(integer, numeric, character varying, date, character varying, integer, integer);

CREATE OR REPLACE FUNCTION public."save_Transaction"(
	_invoiceid integer,
	_amount numeric,
	_invoicedesc character varying,
	_paymentdate date,
	_user character varying,
	_paymentmethod integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
 insert into public.Payment 
  ( invoice_id,amount,"desc","date","user",payment_method,filer_id)
 values
 (_invoiceid,_amount,_invoicedesc,_paymentdate,_user,_paymentmethod,_filerid);
  return (SELECT LASTVAL());

END
$BODY$;

ALTER FUNCTION public."save_Transaction"(integer, numeric, character varying, date, character varying, integer, integer)
    OWNER TO devadmin;
    -- FUNCTION: public.get_paymenthistory(character varying, character varying, date, date, integer)

-- DROP FUNCTION public.get_paymenthistory(character varying, character varying, date, date, integer);

CREATE OR REPLACE FUNCTION public.get_paymenthistory(
	_searchval character varying,
	_filertype character varying,
	_mindate date,
	_maxdate date,
	_electioncycleid integer)
    RETURNS TABLE(invoicenumber integer, filername text, date text, amount text, description text, "user" text, paymentmethod text, type text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE sqlQuery character varying;
DECLARE whereClause character varying;
DECLARE arrValue text[];
DECLARE whereClauseValue character varying;
DECLARE val character varying;
DECLARE isCommaPresent boolean;
DECLARE conditionText character varying;
DECLARE fsDate date;
DECLARE feDate date;
DECLARE eleDate date;
DECLARE nYear double precision;
begin

if _mindate != null then
	SELECT EXTRACT(YEAR FROM _mindate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		fsDate := null;
	else
		fsDate := _mindate;
	end if;
	end if;
	if _maxdate != null then
	SELECT EXTRACT(YEAR FROM _maxdate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		feDate := null;
	else
		feDate := _maxdate;
	end if;
	end if;
	  whereClause := '';
	  sqlQuery := 'SELECT ph.invoicenumber,
					text(ph.filername) as fname,
					text(ph.type) as type,
					text(ph.description) as description,
					text(ph.date) as fsDate,
					text(ph.amount) as amount,
					text(ph.user) as user,
					text(ph.paymentmethod) as paymentmethod
			FROM public.get_paymenthistory() ph ';

		if CONCAT(_searchval, 'ZZZ') != 'ZZZ' then
			whereClause := ' WHERE LOWER(ph.filername) LIKE ' || '''%' || LOWER(trim(_searchval)) || '%''';
		end if;
		

		if CONCAT(_filertype, 'ZZZ') != 'ZZZ' then
			whereClauseValue := '';
			SELECT INTO arrValue regexp_split_to_array(_filertype,',');
			FOREACH val IN array arrValue LOOP
				if CONCAT(whereClauseValue, 'ZZZ') = 'ZZZ' then
					whereClauseValue := '''' || trim(val) || '';
				else
					whereClauseValue := whereClauseValue || ''',''' || trim(val) || '';
				end if;
			END LOOP;
			
			
			if CONCAT(whereClauseValue, 'ZZZ') != 'ZZZ' then
				whereClauseValue = whereClauseValue || '''';
				if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
					whereClause := whereClause || ' AND ';
				else
					whereClause := ' WHERE ';
				end if;
				whereClause := whereClause || ' ph.filerType IN (' || whereClauseValue || ')';
			end if;
		end if;
		
if _mindate != null then
		if CONCAT(fsDate, 'ZZZ') != 'ZZZ' AND CONCAT(feDate, 'ZZZ') != 'ZZZ' then
			if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
				whereClause := whereClause || ' AND ';
			else
				whereClause := ' WHERE ';
			end if;
			whereClause := whereClause || ' CAST(ph.date as TEXT) >= ' || '''' || _mindate || '''' || ' AND CAST(ph.date as TEXT) <= ' || '''' || _maxdate || ''''; 
		end if;
		end if ;

		-- Election Date
		if _electioncycleid != 0 then
		if CONCAT(_electioncycleid, 'ZZZ') != 'ZZZ' then
			if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
					whereClause := whereClause || ' AND ';
			else
				whereClause := ' WHERE ';
			end if;
			whereClause := whereClause || ' ph.electioncycleid = '''  || _electioncycleid || '''';
		end if;
		end if;
		
		--INSERT INTO public.debugdetails(param1) values(whereClause);
		sqlQuery := sqlQuery || whereClause;
		
		--INSERT INTO public.debugdetails(param1, param2) values(sqlQuery, 'Final');
		return query execute sqlQuery;
 end
$BODY$;

ALTER FUNCTION public.get_paymenthistory(character varying, character varying, date, date, integer)
    OWNER TO devadmin;

	------------------------------\

	-- FUNCTION: public.get_paymenthistory()

-- DROP FUNCTION public.get_paymenthistory();

CREATE OR REPLACE FUNCTION public.get_paymenthistory(
	)
    RETURNS TABLE(invoicenumber integer, filertype text, filername character varying, type character varying, description character varying, date date, amount numeric, "user" character varying, paymentmethod character varying, electioncycleid text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT Distinct p.invoice_id,
  		'AC-CAN' as filerType,
	    com.name as filerName,
		tl.name,
		p.desc,
		p.date, 
		p.amount,
		p.user, 
		p.payment_method,
		text(ec.election_cycle_id) as eid
FROM public.payment p
INNER JOIN public.filer f on p.filer_id = f.filer_id
INNER JOIN public.committee com on f.entity_id = com.committee_id
INNER JOIN public.filer_invoice fi on p.invoice_id = fi.invoice_id
LEFT JOIN public.type_lookups tl on fi.invoice_type_id = tl.lookup_type_code and tl.lookup_type_code = 'COM'
LEFT JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
UNION	
  SELECT Distinct p.invoice_id,
  		'AC-LOB' as filerType,
	    CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(pc.first_name, ' ', pc.last_name)
		ELSE 
			CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
		END as filerName,
		tl.name,
		p.desc,
		p.date, 
		p.amount,
		p.user, 
		p.payment_method,
		'' as eid
FROM public.payment p
INNER JOIN public.filer f on p.filer_id = f.filer_id
INNER JOIN public.lobbyist l on f.entity_id = l.lobbysit_id
INNER JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
INNER JOIN public.filer_invoice fi on p.invoice_id = fi.invoice_id
LEFT JOIN public.type_lookups tl on fi.invoice_type_id = tl.lookup_type_code	
UNION
  SELECT p.invoice_id,
  		CASE WHEN f.entity_type = 'IE' THEN 'AC-IEF' 
		ELSE 'AC-CFE' END as filerType,
	    CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(c.first_name, ' ', c.last_name)
		ELSE 
			CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
		END as filerName,
		tl.name,
		p.desc,
		p.date, 
		p.amount,
		p.user, 
		p.payment_method,
		'' as eid
FROM public.payment p
INNER JOIN public.filer f on p.filer_id = f.filer_id AND f.entity_type IN ('IE', 'CO')
INNER JOIN public.contact c on f.entity_id =c.contact_id and f.entity_type IN ('IE', 'CO')
INNER JOIN public.filer_invoice fi on p.invoice_id = fi.invoice_id
LEFT JOIN public.type_lookups tl on fi.invoice_type_id = tl.lookup_type_code;

 end
$BODY$;

ALTER FUNCTION public.get_paymenthistory()
    OWNER TO devadmin;

	------------------------------


CREATE OR REPLACE FUNCTION public.get_filerpaymenthistory(
	_filerid integer)
    RETURNS TABLE(invoicenumber integer, filername character varying, date date, amount numeric, description character varying, "user" character varying, paymentmethod character varying, type character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE entityid integer;
DECLARE entitytype character varying;
begin
SELECT entity_id, entity_type INTO entityid, entitytype FROM public.filer WHERE filer_id = _filerid;
if entitytype = 'C' then
return query
SELECT p.invoice_id, c.name, p.date, p.amount, p.desc, p.user, 
p.payment_method, tl.name
FROM public.payment p 
INNER JOIN public.filer f on p.filer_id = f.filer_id
INNER JOIN public.committee c on f.entity_id = c.committee_id
INNER JOIN public.filer_invoice fi on p.invoice_id = fi.invoice_id
LEFT JOIN public.type_lookups tl on fi.invoice_type_id = tl.lookup_type_code
Where p.filer_id = _filerid;
end if;
 end
$BODY$;

ALTER FUNCTION public.get_filerpaymenthistory(integer)
    OWNER TO devadmin;

	----------------------------


CREATE OR REPLACE FUNCTION public.get_entitypaymenthistory(
	_entityid integer,
	_entitytype character varying)
    RETURNS TABLE(invoicenumber integer, filername character varying, date date, amount numeric, description character varying, "user" character varying, paymentmethod character varying, type character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filrid integer;
begin
SELECT filer_id INTO filrid FROM public.filer WHERE entity_id = _entityid and entity_type = _entitytype;
return query
SELECT p.invoice_id, 
CASE 
WHEN _entitytype = 'C' then c.name
WHEN _entitytype = 'L' then concat(cl.first_name, ' ', cl.last_name) 
WHEN _entitytype = 'IE' then concat(cie.first_name, ' ', cie.last_name) 
WHEN _entitytype = 'CO' then concat(cc.first_name, ' ', cc.last_name) END as filername, 
p.date, p.amount, p.desc, p.user, 
p.payment_method, tl.name
FROM public.payment p 
LEFT JOIN public.committee c on _entityid = c.committee_id and _entitytype = 'C'
LEFT JOIN public.lobbyist l on _entityid = l.lobbysit_id and _entitytype = 'L'
LEFT JOIN public.contact cie on _entityid =cie.contact_id and _entitytype = 'IE'
LEFT JOIN public.contact cc on _entityid = cc.contact_id and _entitytype = 'CO'
LEFT JOIN public.contact cl on l.filer_contact_id = cl.contact_id
LEFT JOIN public.filer_invoice fi on p.invoice_id = fi.invoice_id
LEFT JOIN public.type_lookups tl on fi.invoice_type_id = tl.lookup_type_code
Where p.filer_id = filrid;
 end
$BODY$;

ALTER FUNCTION public.get_entitypaymenthistory(integer, character varying)
    OWNER TO devadmin;
