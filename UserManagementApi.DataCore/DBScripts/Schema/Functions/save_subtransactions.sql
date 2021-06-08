-- FUNCTION: public.save_subtransactions(integer, character varying, integer, timestamp without time zone)

-- DROP FUNCTION public.save_subtransactions(integer, character varying, integer, timestamp without time zone);
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.save_subtransactions(
	_loanid integer,
	_sub_transactiontype character varying,
	_sub_transactionamount integer,
	_sub_transaction_date timestamp without time zone)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE loanid integer;
begin
Insert into loan_sub_transaction (loan_sub_id, loan_id,type,amount,subloan_date)
 values(nextval('subtransaction_id_seq'),_loanid,_sub_transactiontype,_sub_transactionAmount,_sub_transaction_date);
 return (SELECT LASTVAL());	
end
$BODY$;

ALTER FUNCTION public.save_subtransactions(integer, character varying, integer, timestamp without time zone)
    OWNER TO devadmin;
