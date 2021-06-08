-- FUNCTION: public.save_feesdetails(integer, character varying, integer, timestamp without time zone, timestamp without time zone, character varying)

-- DROP FUNCTION public.save_feesdetails(integer, character varying, integer, timestamp without time zone, timestamp without time zone, character varying);

CREATE OR REPLACE FUNCTION public.save_feesdetails(
	_feeid integer,
	_name character varying,
	_amount integer,
	_duedate timestamp without time zone,
	_invoice_date timestamp without time zone,
	_filer_type_id character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE userId int = 0;
declare feeids int = 0;
begin

if NOT EXISTS (SELECT 1 FROM fee_settings
				  	WHERE feeid = _feeId) then
	INSERT INTO public.fee_settings(
		feeid, name, amount, 
		duedate, invoice_date,status_code,created_by,created_at)
	VALUES (nextval('fees_id_seq'), _name, _amount, 
			_duedate, _invoice_date,'Active','Denver',now());		
		feeids  = (SELECT LASTVAL());	
		
  INSERT INTO public.fee_filer_type_mapping(
		fee_filer_map_id,fee_id,filertype_id,status_code,created_by,created_on)
	VALUES (nextval('fees_map_id_seq'),feeids, _filer_type_id,'Active','Denver',now());
					
	SELECT CURRVAL('fees_id_seq') INTO userId;
		if found then --inserted successfully
	  	return userId;
	else 
		return 0; -- inserted fail
	end if;
else
	update fee_settings set name = _name,  
 amount = _amount, duedate = _duedate,invoice_date = _invoice_date,updated_by='Denver',updated_on = now()
 where feeid = _feeId;
 
 update fee_filer_type_mapping set filertype_id = _filer_type_id,updated_by='Denver',updated_on = now()
 where fee_id = _feeId;
 return _feeId;
end if;

end
$BODY$;

ALTER FUNCTION public.save_feesdetails(integer, character varying, integer, timestamp without time zone, timestamp without time zone, character varying)
    OWNER TO devadmin;
