-- Table: public.txn_file_attachment

-- DROP TABLE public.txn_file_attachment;

CREATE TABLE public.txn_file_attachment
(
    attachment_id integer NOT NULL DEFAULT nextval('txn_file_attachment_attachment_id_seq'::regclass),
    attachment_type_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    record_id integer NOT NULL,
    file_url character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    file_mime_type character varying(10) COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.txn_file_attachment
    OWNER to devadmin;


    --------------------------------------Functions-------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------
    
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
    
end if;
 
end
$BODY$;

ALTER FUNCTION public.get_invoiceinfofromid(integer)
    OWNER TO devadmin;
