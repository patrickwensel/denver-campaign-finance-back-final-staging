-- FUNCTION: public.save_transaction(integer, numeric, character varying, date, character varying, character varying)

-- DROP FUNCTION public.save_transaction(integer, numeric, character varying, date, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_transaction(
	_invoiceid integer,
	_amount numeric,
	_description character varying,
	_paymentdate date,
	_user character varying,
	_paymentmethod character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filerid int;

BEGIN
select filer_id into filerid from payment where invoice_id =_invoiceid;

 insert into public.Payment 
  ( invoice_id,amount,"desc","date","user",payment_method,filer_id)
 values
 (_invoiceid,_amount,_description,_paymentdate,_user,_paymentmethod,filerid);
  return (SELECT LASTVAL());

END
$BODY$;

ALTER FUNCTION public.save_transaction(integer, numeric, character varying, date, character varying, character varying)
    OWNER TO devadmin;
