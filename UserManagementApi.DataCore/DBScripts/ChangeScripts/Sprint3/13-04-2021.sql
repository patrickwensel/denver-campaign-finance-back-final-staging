﻿----------------------------------------Functions------------------------------------


-- FUNCTION: public.save_filingperioddetails(integer, character varying, character varying, date, date, timestamp without time zone, integer, text)

-- DROP FUNCTION public.save_filingperioddetails(integer, character varying, character varying, date, date, timestamp without time zone, integer, text);

CREATE OR REPLACE FUNCTION public.save_filingperioddetails(
	_filingperiodid integer,
	_filingperiodname character varying,
	_description character varying,
	_startdate date,
	_enddate date,
	_duedate timestamp without time zone,
	_electioncycleid integer,
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
	status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_filingperiodname, _description, _startdate, _enddate, _duedate, _electioncycleid, 'ACTIVE',
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

ALTER FUNCTION public.save_filingperioddetails(integer, character varying, character varying, date, date, timestamp without time zone, integer, text)
    OWNER TO devadmin;



 ----------------------------------------Functions------------------------------------


-- FUNCTION: public.get_filingperiodlistbyid(integer)

-- DROP FUNCTION public.get_filingperiodlistbyid(integer);

CREATE OR REPLACE FUNCTION public.get_filingperiodlistbyid(
	_filingperiodid integer)
    RETURNS TABLE(filingperiodid integer, filingperiodname character varying, description character varying, startdate date, enddate date, duedate timestamp without time zone, electioncycleid integer, filingperiodfilertypeids text, filertypeid character varying, filingperiodfileryypeid integer) 
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
	fpftm.filing_period_filer_type_mapping_id
	from
	filing_period fp
	inner join filing_period_filer_type_mapping fpftm on fpftm.filing_period_id = fp.filing_period_id
	where fp.filing_period_id=_filingperiodid and fp.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_filingperiodlistbyid(integer)
    OWNER TO devadmin;



 ----------------------------------------Functions------------------------------------


-- FUNCTION: public.get_filingperiodlist()

-- DROP FUNCTION public.get_filingperiodlist();

CREATE OR REPLACE FUNCTION public.get_filingperiodlist(
	)
    RETURNS TABLE(filingperiodid integer, filingperiodname character varying, description character varying, startdate date, enddate date, duedate timestamp without time zone, electioncycleid integer, electionstartdate date, electionenddate date, electionname character varying) 
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
	ec."name"
	from
	filing_period fp
	inner join election_cycle ec on ec.election_cycle_id = fp.election_cycle_id
	where fp.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_filingperiodlist()
    OWNER TO devadmin;




 ----------------------------------------Functions------------------------------------



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
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_filingperiod(integer)
    OWNER TO devadmin;





 ----------------------------------------Functions------------------------------------





------------------------------------ Tables ---------------------------------



CREATE TABLE public.filing_period
(
    filing_period_id  SERIAL  PRIMARY KEY,
    name character varying(300) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(1000) COLLATE pg_catalog."default",
    start_date date,
    end_date date,
    due_date timestamp without time zone,
    election_cycle_id integer,
    status_code character varying(20),
 created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date

)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.filing_period
    OWNER to devadmin;
------------------------------------ Tables ---------------------------------
CREATE TABLE public.filing_period_filer_type_mapping
(
    filing_period_filer_type_mapping_id  SERIAL  PRIMARY KEY,
    filing_period_id integer NOT NULL,
    filer_type_id character varying COLLATE pg_catalog."default" ,
    status_code character varying(20),
 created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date

)
------------------------------------ Tables ---------------------------------