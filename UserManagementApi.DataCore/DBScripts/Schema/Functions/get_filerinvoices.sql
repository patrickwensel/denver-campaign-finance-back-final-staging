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
		 invoicetype.name,
		 inv.desc,
		 invoicestatus.name,
		 inv.amount,
		 inv.amount-Coalesce(sum(pay.amount),0.00) as remainingamt
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
 group by inv.invoice_id,invoicetype.name, invoicestatus.name
  order by inv.created_date desc;
 end
$BODY$;

ALTER FUNCTION public.get_filerinvoices(integer, character varying)
    OWNER TO devadmin;
