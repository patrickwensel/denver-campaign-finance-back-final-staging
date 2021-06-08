-- FUNCTION: public.get_invoiceinfofromid(integer,integer)

-- DROP FUNCTION select public.get_invoiceinfofromid(integer,integer);

CREATE OR REPLACE FUNCTION public.get_invoiceinfofromid(
	_invoiceid integer,
    _filerid integer)
    RETURNS TABLE(invoicetype character varying, invoicedesc character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
Begin


if (_filerid >0) then 
RETURN query
SELECT invoicetype.name, inv.desc
from filer_invoice inv
left join type_lookups invoicetype 
on invoicetype.type_id = inv.invoice_type_id and lookup_type_code='INVOICE_TYPE'
  where inv.invoice_id=_invoiceid and inv.filer_id=_filerid;
  
  else
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
