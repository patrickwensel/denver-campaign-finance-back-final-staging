--------------------------------tables-----------------------------------------

-- Table: public.filing_period

-- DROP TABLE public.filing_period;

CREATE TABLE public.filing_period
(
    filing_period_id integer NOT NULL DEFAULT nextval('filing_period_filing_period_id_seq'::regclass),
    name character varying(300) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(1000) COLLATE pg_catalog."default",
    start_date date,
    end_date date,
    due_date timestamp without time zone,
    election_cycle_id integer,
    status_code character varying(20) COLLATE pg_catalog."default",
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    item_threshold numeric(18,2),
    CONSTRAINT filing_period_pkey PRIMARY KEY (filing_period_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.filing_period
    OWNER to devadmin;
--------------------------------tables----------------------------------------------------------------------------------
-- Table: public.fine_settings

-- DROP TABLE public.fine_settings;

CREATE TABLE public.fine_settings
(
    fine_id integer NOT NULL DEFAULT nextval('fine_settings_fine_id_seq'::regclass),
    name character varying(300) COLLATE pg_catalog."default" NOT NULL,
    amount numeric(15,2) NOT NULL,
    grace_period integer,
    frequency character varying(1) COLLATE pg_catalog."default" NOT NULL,
    filertypeids character varying(300) COLLATE pg_catalog."default",
    status_code character varying(20) COLLATE pg_catalog."default",
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT fine_settings_pkey PRIMARY KEY (fine_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.fine_settings
    OWNER to devadmin;
--------------------------------tables----------------------------------------------------------------------------------
-- Table: public.fine_filer_type_mapping

-- DROP TABLE public.fine_filer_type_mapping;

CREATE TABLE public.fine_filer_type_mapping
(
    fine_filer_map_id integer NOT NULL DEFAULT nextval('fine_filer_type_mapping_fine_filer_map_id_seq'::regclass),
    fine_id integer NOT NULL,
    filer_type_id character varying COLLATE pg_catalog."default",
    status_code character varying(20) COLLATE pg_catalog."default",
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT fine_filer_type_mapping_pkey PRIMARY KEY (fine_filer_map_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.fine_filer_type_mapping
    OWNER to devadmin;
--------------------------------tables----------------------------------------------------------------------------------
-----------------------------------------------------------functions-----------------------------------------------------
-- FUNCTION: public.save_filingperioddetails(integer, character varying, character varying, date, date, timestamp without time zone, integer, numeric, text)

-- DROP FUNCTION public.save_filingperioddetails(integer, character varying, character varying, date, date, timestamp without time zone, integer, numeric, text);

CREATE OR REPLACE FUNCTION public.save_filingperioddetails(
	_filingperiodid integer,
	_filingperiodname character varying,
	_description character varying,
	_startdate date,
	_enddate date,
	_duedate timestamp without time zone,
	_electioncycleid integer,
	_itemthreshold numeric,
	_filertypeids text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filingperiod int = 0;
arr_split_data  text[];
r character varying; 
begin
   if(_filingperiodid)>0 
	THEN
	---  Filing Period
	update public.filing_period set "name" = _filingperiodname,
	"desc" = _description,
	start_date = _startdate,
	end_date = _enddate,
	due_date = _duedate,
	election_cycle_id = _electioncycleid,
	item_threshold = _itemthreshold,
	 updated_by='Denver',  updated_on=NOW()
	where filing_period_id =_filingperiodid;
	
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
	update  public.filing_period_filer_type_mapping set status_code='DELETED'
 	where filing_period_id = _filingperiodid ;
	FOREACH r IN array arr_split_data LOOP
	IF EXISTS (SELECT filing_period_filer_type_mapping_id FROM public.filing_period_filer_type_mapping where filing_period_id=_filingperiodid and filer_type_id=r) THEN
	
	
	update public.filing_period_filer_type_mapping set 
	status_code='ACTIVE',
	updated_by='Denver',
	updated_on=NOW() 
	where filing_period_id=_filingperiodid and filer_type_id=r;
	
	
	else
	
	INSERT INTO public.filing_period_filer_type_mapping(filing_period_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_filingperiodid, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
	End IF;
	
	END LOOP;
	---  Filing Period Filer TYpe
	
	return _filingperiodid;
	
		else
		
	INSERT INTO public.filing_period("name", "desc",
    start_date,
    end_date ,
    due_date,
    election_cycle_id,
	item_threshold,
	status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_filingperiodname, _description, _startdate, _enddate, _duedate, _electioncycleid, _itemthreshold, 'ACTIVE',
	'Denver',NOW(),'Denver',NOW());
	
	filingperiod = (SELECT LASTVAL());
			
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
			
	FOREACH r IN array arr_split_data LOOP
	INSERT INTO public.filing_period_filer_type_mapping(filing_period_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (filingperiod, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
			
END LOOP;

return	filingperiod;
	end if;

end
$BODY$;

ALTER FUNCTION public.save_filingperioddetails(integer, character varying, character varying, date, date, timestamp without time zone, integer, numeric, text)
    OWNER TO devadmin;

-----------------------------------------------------------functions-----------------------------------------------------
-- FUNCTION: public.get_filingperiodlist()

-- DROP FUNCTION public.get_filingperiodlist();

CREATE OR REPLACE FUNCTION public.get_filingperiodlist(
	)
    RETURNS TABLE(filingperiodid integer, filingperiodname character varying, description character varying, startdate date, enddate date, duedate timestamp without time zone, electioncycleid integer, electionstartdate date, electionenddate date, electionname character varying, itemthreshold numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fp.filing_period_id,
	fp."name",
	fp."desc",
	fp.start_date,
	fp.end_date,
	fp.due_date,
	fp.election_cycle_id,
	ec.start_date,
	ec.end_date,
	ec."name",
	fp.item_threshold
	from
	filing_period fp
	inner join election_cycle ec on ec.election_cycle_id = fp.election_cycle_id
	where fp.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_filingperiodlist()
    OWNER TO devadmin;

-----------------------------------------------------------functions-----------------------------------------------------

-- FUNCTION: public.get_filingperiodlistbyid(integer)

-- DROP FUNCTION public.get_filingperiodlistbyid(integer);

CREATE OR REPLACE FUNCTION public.get_filingperiodlistbyid(
	_filingperiodid integer)
    RETURNS TABLE(filingperiodid integer, filingperiodname character varying, description character varying, startdate date, enddate date, duedate timestamp without time zone, electioncycleid integer, filingperiodfilertypeids text, filertypeid character varying, filingperiodfileryypeid integer, itemthreshold numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fp.filing_period_id,
	fp."name",
	fp."desc",
	fp.start_date,
	fp.end_date,
	fp.due_date,
	fp.election_cycle_id,
	CAST (fpftm.filing_period_filer_type_mapping_id AS text),
	fpftm.filer_type_id,
	fpftm.filing_period_filer_type_mapping_id,
	fp.item_threshold
	from
	filing_period fp
	inner join filing_period_filer_type_mapping fpftm on fpftm.filing_period_id = fp.filing_period_id
	where fp.filing_period_id=_filingperiodid and fp.status_code='ACTIVE' and fpftm.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_filingperiodlistbyid(integer)
    OWNER TO devadmin;

-----------------------------------------------------------functions-----------------------------------------------------
-- FUNCTION: public.delete_filingperiod(integer)

-- DROP FUNCTION public.delete_filingperiod(integer);

CREATE OR REPLACE FUNCTION public.delete_filingperiod(
	_filingperiodid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update  public.filing_period set status_code='DELETED'
 where filing_period_id = _filingperiodid;
  update  public.filing_period_filer_type_mapping set status_code='DELETED'
 where filing_period_id = _filingperiodid;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_filingperiod(integer)
    OWNER TO devadmin;


-----------------------------------------------------------functions-----------------------------------------------------
-- FUNCTION: public.save_finesettingdetails(integer, character varying, numeric, integer, character varying, text)

-- DROP FUNCTION public.save_finesettingdetails(integer, character varying, numeric, integer, character varying, text);

CREATE OR REPLACE FUNCTION public.save_finesettingdetails(
	_fineid integer,
	_finename character varying,
	_amount numeric,
	_graceperiod integer,
	_frequency character varying,
	_filertypeids text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE fineid int = 0;
arr_split_data  text[];
r character varying; 
begin
   if(_fineid)>0 
	THEN
	---  Fine setting
	update public.fine_settings set "name" = _finename,
	amount = _amount,
	grace_period = _graceperiod,
	frequency = _frequency,
	filertypeids = _filertypeids,
	 updated_by='Denver',  updated_on=NOW()
	where fine_id =_fineid;
	
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
	update  public.fine_filer_type_mapping set status_code='DELETED'
 	where fine_id = _fineid ;
	FOREACH r IN array arr_split_data LOOP
	IF EXISTS (SELECT fine_filer_map_id FROM public.fine_filer_type_mapping where fine_id=_fineid and filer_type_id=r) THEN
	
	
	update public.fine_filer_type_mapping set 
	status_code='ACTIVE',
	updated_by='Denver',
	updated_on=NOW() 
	where fine_id=_fineid and filer_type_id=r;
	
	
	else
	
	INSERT INTO public.fine_filer_type_mapping(fine_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_fineid, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
	End IF;
	
	END LOOP;
	---  Filing Period Filer TYpe
	
	return _fineid;
	
		else
		
	INSERT INTO public.fine_settings("name", amount,
    grace_period,
    frequency ,
    filertypeids,
	status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_finename, _amount, _graceperiod, _frequency, _filertypeids, 'ACTIVE',
	'Denver',NOW(),'Denver',NOW());
	
	fineid = (SELECT LASTVAL());
			
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
			
	FOREACH r IN array arr_split_data LOOP
	INSERT INTO public.fine_filer_type_mapping(fine_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (fineid, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
			
END LOOP;

return	fineid;
	end if;

end
$BODY$;

ALTER FUNCTION public.save_finesettingdetails(integer, character varying, numeric, integer, character varying, text)
    OWNER TO devadmin;


-----------------------------------------------------------functions-----------------------------------------------------


-- FUNCTION: public.get_finesettinglistbyid(integer)

-- DROP FUNCTION public.get_finesettinglistbyid(integer);

CREATE OR REPLACE FUNCTION public.get_finesettinglistbyid(
	_fineid integer)
    RETURNS TABLE(fineid integer, finename character varying, amount numeric, graceperiod integer, frequency character varying, finefilertypeids character varying, finefilermapid integer, filertypeid character varying, filertype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fs.fine_id,
	fs."name",
	fs.amount,
	fs.grace_period,
	fs.frequency,
	fs.filertypeids,
	fsft.fine_filer_map_id,
	fsft.filer_type_id,
	tlkups."name"
	
	from
	fine_settings fs
	 inner join fine_filer_type_mapping fsft on fsft.fine_id = fs.fine_id
	 left join type_lookups  tlkups on tlkups.type_id = fsft.filer_type_id
	where fs.status_code='ACTIVE' and fsft.status_code='ACTIVE' and fs.fine_id =_fineid;
	
end
$BODY$;

ALTER FUNCTION public.get_finesettinglistbyid(integer)
    OWNER TO devadmin;

-----------------------------------------------------------functions-----------------------------------------------------

-- FUNCTION: public.get_finesettinglist()

-- DROP FUNCTION public.get_finesettinglist();

CREATE OR REPLACE FUNCTION public.get_finesettinglist(
	)
    RETURNS TABLE(fineid integer, finename character varying, amount numeric, graceperiod integer, frequency character varying, finefilertypeids character varying, finefilermapid integer, filertypeid character varying, filertype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fs.fine_id,
	fs."name",
	fs.amount,
	fs.grace_period,
	fs.frequency,
	fs.filertypeids,
	fsft.fine_filer_map_id,
	fsft.filer_type_id,
	tlkups."name"
	
	from
	fine_settings fs
	 inner join fine_filer_type_mapping fsft on fsft.fine_id = fs.fine_id
	 inner join type_lookups  tlkups on tlkups.type_id = fsft.filer_type_id
	where fs.status_code='ACTIVE' and fsft.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_finesettinglist()
    OWNER TO devadmin;



-----------------------------------------------------------functions-----------------------------------------------------

-- FUNCTION: public.delete_finesettings(integer)

-- DROP FUNCTION public.delete_finesettings(integer);

CREATE OR REPLACE FUNCTION public.delete_finesettings(
	_fineid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.fine_settings set status_code= 'DELETED' where fine_id =_fineid;
 update  public.fine_filer_type_mapping set status_code='DELETED'
 	where fine_id = _fineid ;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_finesettings(integer)
    OWNER TO devadmin;


-----------------------------------------------------------functions-----------------------------------------------------






-----------------------------------------------------------functions-----------------------------------------------------
