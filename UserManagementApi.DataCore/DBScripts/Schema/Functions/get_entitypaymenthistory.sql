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