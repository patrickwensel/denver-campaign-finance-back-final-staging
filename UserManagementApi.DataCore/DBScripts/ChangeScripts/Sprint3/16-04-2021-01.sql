---------------------------------------------------------tables-------------------------------------

CREATE TABLE public.fee_settings
(
    feeid integer NOT NULL DEFAULT nextval('fee_settings_feeid_seq'::regclass),
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    amount integer,
    duedate timestamp without time zone,
    invoice_date timestamp without time zone,
    status_code character varying(255) COLLATE pg_catalog."default",
    created_by character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    updated_by character varying COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT fee_settings_pkey PRIMARY KEY (feeid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.fee_settings
    OWNER to devadmin;

-------------------------
-- Table: public.fee_filer_type_mapping

-- DROP TABLE public.fee_filer_type_mapping;

CREATE TABLE public.fee_filer_type_mapping
(
    fee_filer_map_id integer NOT NULL DEFAULT nextval('fee_filer_type_mapping_fee_filer_map_id_seq'::regclass),
    fee_id integer,
    filertype_id character varying COLLATE pg_catalog."default",
    status_code character varying(255) COLLATE pg_catalog."default",
    created_by character varying COLLATE pg_catalog."default",
    created_on timestamp without time zone,
    updated_by character varying COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT fee_filer_type_mapping_pkey PRIMARY KEY (fee_filer_map_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.fee_filer_type_mapping
    OWNER to devadmin;
    ----------------------------------------------------------------functions----------------------------------------
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
-----------------------------------------------------
-- FUNCTION: public.delete_feesettings(integer)

-- DROP FUNCTION public.delete_feesettings(integer);

CREATE OR REPLACE FUNCTION public.delete_feesettings(
	_fee_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.fee_settings set status_code= 'DELETED' where feeid =_fee_id;
 update  public.fee_filer_type_mapping set status_code='DELETED'
 	where fee_id = _fee_id ;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_feesettings(integer)
    OWNER TO devadmin;
-----------------------------------------------------------
-- FUNCTION: public.get_fees()

-- DROP FUNCTION public.get_fees();

CREATE OR REPLACE FUNCTION public.get_fees(
	)
    RETURNS TABLE(feeid integer, name character varying, amount integer, duedate timestamp without time zone, invoice_date timestamp without time zone, filername character varying, type_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
   select fee_settings.feeid,fee_settings.name,fee_settings.amount,fee_settings.duedate,fee_settings.invoice_date,type_lookups.name as filername ,type_lookups.type_id
  from fee_settings inner join fee_filer_type_mapping on  fee_settings.feeid = fee_filer_type_mapping.fee_id 
  inner join type_lookups on type_lookups.type_id = fee_filer_type_mapping.filertype_id
  where fee_settings.status_code='Active' order by fee_settings.feeid;
 end
$BODY$;

ALTER FUNCTION public.get_fees()
    OWNER TO devadmin;
----------------------------------------------------------
-- FUNCTION: public.get_feelistbyid(integer)

-- DROP FUNCTION public.get_feelistbyid(integer);

CREATE OR REPLACE FUNCTION public.get_feelistbyid(
	_feeid integer)
    RETURNS TABLE(feeid integer, name character varying, amount integer, duedate timestamp without time zone, invoice_date timestamp without time zone, type_id character varying, filername character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fee_settings.feeid,
	fee_settings."name",
	fee_settings.amount,
	fee_settings.duedate,
	fee_settings.invoice_date,
	fee_filer_type_mapping.filertype_id,
	type_lookups.name as filername
	from
	fee_settings 
	inner join fee_filer_type_mapping  on fee_filer_type_mapping.fee_id = fee_settings.feeid
	inner join type_lookups on type_lookups.type_id = fee_filer_type_mapping.filertype_id
	where fee_settings.feeid= _feeid and fee_settings.status_code='Active';
	
end
$BODY$;

ALTER FUNCTION public.get_feelistbyid(integer)
    OWNER TO devadmin;
-------------------------------------------------