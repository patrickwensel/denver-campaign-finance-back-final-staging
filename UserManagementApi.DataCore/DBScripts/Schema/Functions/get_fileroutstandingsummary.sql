-- FUNCTION: public.get_fileroutstandingfeesummary(integer, character varying)

-- DROP FUNCTION public.get_fileroutstandingfeesummary(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_fileroutstandingfeesummary(
	_entity_id integer,
	_entity_type character varying)
    RETURNS TABLE(id integer, totalfine numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
Declare filerid int;

BEGIN

select  filer_id into filerid from public.filer where entity_type=_entity_type 
and entity_id =  _entity_id;

RETURN query 
	SELECT 1 AS ID, 
 Coalesce(sum( i.Fineamount - P.paidamount),0.00) as totfineamount 
FROM
( SELECT pay.invoice_id,Coalesce(Sum(pay.amount),0.00) as paidamount FROM Payment pay
where pay.filer_id =filerid GROUP BY pay.invoice_id ) as P
 RIGHT JOIN
(SELECT inv.invoice_id,sum(inv.amount) as Fineamount FROM Filer_invoice inv where 
 inv.filer_id =filerid
GROUP BY inv.invoice_id) as i ON i.invoice_id = P.invoice_id
	UNION
	SELECT 2 AS ID,Coalesce(Sum(amount),0.00) AS TotalFineCollected from 
	public.payment where payment.filer_id =filerid
	UNION
	SELECT 3 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountwaived from 
	public.payment where payment_method='WAI' and payment.filer_id =70
	UNION
	SELECT 4 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountreduced from 
	public.payment where payment_method='RED' and payment.filer_id =filerid
	ORDER BY id;
END
$BODY$;

ALTER FUNCTION public.get_fileroutstandingfeesummary(integer, character varying)
    OWNER TO devadmin;
