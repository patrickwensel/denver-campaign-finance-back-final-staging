
------------------------------------Functions------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

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
	----------------------------


-----------------------------Tables----------------------------------------

CREATE TABLE public.email_messages
(
    email_message_id serial,
    email_type_id character varying(15) NULL,
    txn_ref_id character varying(100) NULL,
    receiver_id character varying(1000) NULL,
    subject character varying(250) NULL,
	message character varying(2000) NULL,
	sent_on date NULL,
	is_user_action_required bool NULL,
	expiry_datetime date NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT email_messages_pkey PRIMARY KEY (email_message_id)
)



-----------------------------Tables----------------------------------------



-------------------------Table-column- changes----------------------------------------
ALTER TABLE public."email_messages" 
ALTER COLUMN email_type_id TYPE character varying(15)

-------------------------Table-column- changes----------------------------------------


-------------------------Script-changes----------------------------------------



