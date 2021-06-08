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
