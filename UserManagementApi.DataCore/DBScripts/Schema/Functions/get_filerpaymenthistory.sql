
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