-- FUNCTION: public.get_outstandingfeesummary(integer)

-- DROP FUNCTION public.get_outstandingfeesummary(integer);

CREATE OR REPLACE FUNCTION public.get_outstandingfeesummary(
	_filer_id integer)
    RETURNS TABLE(id integer, totalfine numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
IF (_filer_id > 0) THEN

RETURN query 
	SELECT 1 AS ID, 
 Coalesce(sum( i.Fineamount - P.paidamount),0.00) as totfineamount 
FROM
( SELECT pay.invoice_id,Coalesce(Sum(pay.amount),0.00) as paidamount FROM Payment pay
where pay.filer_id =_filer_id GROUP BY pay.invoice_id ) as P
 RIGHT JOIN
(SELECT inv.invoice_id,sum(inv.amount) as Fineamount FROM Filer_invoice inv where 
 inv.filer_id =_filer_id
GROUP BY inv.invoice_id) as i ON i.invoice_id = P.invoice_id
	UNION
	SELECT 2 AS ID,Coalesce(Sum(amount),0.00) AS TotalFineCollected from 
	public.payment where payment.filer_id =_filer_id
	UNION
	SELECT 3 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountwaived from 
	public.payment where payment_method='WAI' and payment.filer_id =_filer_id
	UNION
	SELECT 4 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountreduced from 
	public.payment where payment_method='RED' and payment.filer_id =_filer_id
	ORDER BY id;
	
	
ELSE 

RETURN query 
	SELECT 1 AS ID, 
 sum( i.Fineamount - Coalesce(P.paidamount,0)) as totfineamount 
FROM
( SELECT pay.invoice_id,Coalesce(Sum(pay.amount),0.00) as paidamount FROM Payment pay
GROUP BY pay.invoice_id ) as P
 RIGHT JOIN
(SELECT inv.invoice_id,sum(inv.amount) as Fineamount FROM Filer_invoice inv
GROUP BY inv.invoice_id) as i ON i.invoice_id = P.invoice_id
	UNION
	SELECT 2 AS ID,Coalesce(Sum(amount),0.00) AS TotalFineCollected from 
	public.payment
	UNION
	SELECT 3 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountwaived from 
	public.payment where payment_method='WAI'
	UNION
	SELECT 4 AS ID,Coalesce(Sum(amount),0.00) AS Totalamountreduced from 
	public.payment where payment_method='RED' 
	ORDER BY id;
END IF;

END
$BODY$;

ALTER FUNCTION public.get_outstandingfeesummary(integer)
    OWNER TO devadmin;
