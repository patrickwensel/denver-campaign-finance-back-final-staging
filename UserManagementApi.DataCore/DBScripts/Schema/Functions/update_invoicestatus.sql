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
