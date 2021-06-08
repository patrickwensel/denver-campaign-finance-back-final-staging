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
