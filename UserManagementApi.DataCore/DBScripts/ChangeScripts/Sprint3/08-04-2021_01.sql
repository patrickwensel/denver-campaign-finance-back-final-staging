---------------------------------------Functions------------------------------------------
DROP FUNCTION public.delete_electioncycle(integer, character varying);

CREATE OR REPLACE FUNCTION public.delete_electioncycle(
	electioncycleid integer,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	UPDATE public.election_cycle
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE election_cycle_id = electioncycleid;
	
	UPDATE public.election_cycle_offices_mapping
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE election_cycle_id = electioncycleid;
	
	return electioncycleid;
	
 end
$BODY$;

ALTER FUNCTION public.delete_electioncycle(integer, character varying)
    OWNER TO devadmin;
	
DROP FUNCTION public.delete_electioncycleofficebyid(integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.delete_electioncycleofficebyid(
	electioncycleid integer,
	officeid character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	UPDATE public.election_cycle_offices_mapping
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE election_cycle_id = electioncycleid
		AND office_id = officeId;
	
	return electioncycleid;
	
 end
$BODY$;

ALTER FUNCTION public.delete_electioncycleofficebyid(integer, character varying, character varying)
    OWNER TO devadmin;
	
DROP FUNCTION public.get_electioncyclebyid(integer);

CREATE OR REPLACE FUNCTION public.get_electioncyclebyid(
	ecycleid integer)
    RETURNS TABLE(electioncycleid integer, electionname character varying, electiontypeid character varying, electiontypedesc character varying, startdate date, enddate date, electiondate date, status character varying, statusdesc character varying, description character varying, district character varying, iestartdate date, ieenddate date, electioncyclestatus character varying, officeids character varying, offices character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE tOfficeIds character varying;
DECLARE tOffices character varying;
begin

  	SELECT string_agg(ecom.office_id::text,', ') officeids,
		string_agg(tl.name::text,', ') offices INTO tOfficeIds, tOffices
	FROM election_cycle_offices_mapping ecom
		INNER JOIN type_lookups tl ON ecom.office_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
	WHERE ecom.election_cycle_id = eCycleId
		AND status_code = 'ACTIVE'
	GROUP BY ecom.election_cycle_id;
 
  return query
  SELECT ec.election_cycle_id, ec.name, 
  		ec.election_type_id, electiontype.name as electionType, ec.start_date, 
		ec.end_date, ec.election_date, 
		ec.status, electionstatus.name as statusDesc, ec."desc", 
		ec.district, ec.ie_start_date, 
		ec.ie_end_date, ec.status_code,
		tOfficeIds, tOffices
	FROM public.election_cycle ec 
		LEFT JOIN public.type_lookups electionstatus ON ec.status = electionstatus.type_id 
			AND electionstatus.lookup_type_code = 'ELECTION-STATUS'
		LEFT JOIN public.type_lookups electiontype ON ec.election_type_id = electiontype.type_id 
			AND electiontype.lookup_type_code = 'ELECTION-TYPE'
	WHERE ec.election_cycle_id = eCycleId;
 end
$BODY$;

ALTER FUNCTION public.get_electioncyclebyid(integer)
    OWNER TO devadmin;
	


DROP FUNCTION public.save_electioncycle(integer, character varying, character varying, date, date, date, character varying, character varying, character varying, date, date, character varying);

CREATE OR REPLACE FUNCTION public.save_electioncycle(
	electioncycleid integer,
	electionname character varying,
	electiontypeid character varying,
	startdate date,
	enddate date,
	electiondate date,
	electioncyclestatus character varying,
	description character varying,
	districtdesc character varying,
	iestartdate date,
	ieenddate date,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newElectionCycleId integer = 0;
DECLARE sDate date;
DECLARE eDate date;
DECLARE sIEDate date;
DECLARE eIEDate date;
DECLARE nYear double precision;
begin
	SELECT EXTRACT(YEAR FROM startdate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		sDate := null;
	else
		sDate := startdate;
	end if;
	
	SELECT EXTRACT(YEAR FROM enddate) INTO nYear;
	if nYear = 1 OR nYear = 9999 then
		eDate := null;
	else
		eDate := enddate;
	end if;
	
	SELECT EXTRACT(YEAR FROM iestartdate) INTO nYear;
	if nYear = 1 OR nYear = 9999 then
		sIEDate := null;
	else
		sIEDate := iestartdate;
	end if;
	
	SELECT EXTRACT(YEAR FROM ieenddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		eIEDate := null;
	else
		eIEDate := ieenddate;
	end if;
	
	if electionCycleId = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.election_cycle(
			election_cycle_id, name, election_type_id, 
			start_date, end_date, election_date, 
			status, "desc", district, 
			ie_start_date, ie_end_date, status_code, 
			created_by, created_at, updated_by, 
			updated_on)
		VALUES (nextval('election_cycle_id_seq'), electionName, electionTypeId, 
				sDate, eDate, electionDate, 
				electionCycleStatus, description, districtDesc, 
				sIEDate, ieEndDate, 'ACTIVE', 
				'Denver', localtimestamp, 'Denver', 
				localtimestamp);

		-- Get the current value from election_cycle table
		SELECT currval('election_cycle_id_seq') INTO newElectionCycleId;
	end;
	else
	begin
		UPDATE public.election_cycle
		SET name=electionName, 
			election_type_id=electionTypeId, 
			start_date=sDate, end_date=eDate, 
			election_date=electionDate, status=electionCycleStatus, 
			"desc"=description, district=districtDesc, 
			ie_start_date=sIEDate, 
			ie_end_date=eIEDate, 
			status_code=electionCycleStatus,
			updated_by='Denver', 
			updated_on=localtimestamp
		WHERE election_cycle_id = electionCycleId;
	end;
	end if;

	if electionCycleId = 0 then
		electionCycleId := newElectionCycleId;
	end if;
	
	return electionCycleId;
 end
$BODY$;

ALTER FUNCTION public.save_electioncycle(integer, character varying, character varying, date, date, date, character varying, character varying, character varying, date, date, character varying)
    OWNER TO devadmin;
	

DROP FUNCTION public.save_electioncycleofficesmapping(integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_electioncycleofficesmapping(
	electioncycleid integer,
	officeid character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newElectionCycleOfficesMapId integer = 0;
begin
	if NOT EXISTS (SELECT 1 FROM election_cycle_offices_mapping
				  	WHERE election_cycle_id = electionCycleId
				  		AND office_id = officeId) then
		INSERT INTO public.election_cycle_offices_mapping(
				election_office_map_id, election_cycle_id, office_id, 
				status_code, created_by, created_at, 
				updated_by, updated_on)
		VALUES (nextval('election_cycle_offices_mapping_id_seq'), electionCycleId, officeId, 
				'ACTIVE', 'Denver', localtimestamp, 
				'Denver', localtimestamp);

		-- Get the current value from election_cycle_offices_mapping table
		SELECT currval('election_cycle_offices_mapping_id_seq') INTO newElectionCycleOfficesMapId;
	else
		UPDATE public.election_cycle_offices_mapping
			SET status_code = 'ACTIVE'
		WHERE election_cycle_id = electioncycleid
			AND office_id = officeid;
	end if;
	
	if newElectionCycleOfficesMapId = 0 then
		newElectionCycleOfficesMapId = electioncycleid;
	end if;
	
	return newElectionCycleOfficesMapId;
 end
$BODY$;

ALTER FUNCTION public.save_electioncycleofficesmapping(integer, character varying, character varying)
    OWNER TO devadmin;
	

---------------------------------------Functions------------------------------------------

---------------------------------------Tables------------------------------------------

DROP TABLE public.election_cycle;

CREATE TABLE public.election_cycle
(
    election_cycle_id integer NOT NULL,
    name character varying(200) COLLATE pg_catalog."default" NOT NULL,
    election_type_id character varying(10) COLLATE pg_catalog."default" NOT NULL,
    start_date date,
    end_date date,
    election_date date NOT NULL,
    status character varying(10) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(1000) COLLATE pg_catalog."default",
    district character varying(100) COLLATE pg_catalog."default",
    ie_start_date date,
    ie_end_date date,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT election_cycle_pkey PRIMARY KEY (election_cycle_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.election_cycle
    OWNER to devadmin;
	

DROP TABLE public.election_cycle_offices_mapping;

CREATE TABLE public.election_cycle_offices_mapping
(
    election_office_map_id integer NOT NULL,
    election_cycle_id integer,
    office_id character varying(10) COLLATE pg_catalog."default",
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT election_cycle_offices_mapping_pkey PRIMARY KEY (election_office_map_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.election_cycle_offices_mapping
    OWNER to devadmin;
---------------------------------------Tables------------------------------------------

---------------------------------------Sequence------------------------------------------
DROP SEQUENCE public.election_cycle_id_seq;

CREATE SEQUENCE public.election_cycle_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public.election_cycle_id_seq
    OWNER TO devadmin;
	
	
DROP SEQUENCE public.election_cycle_offices_mapping_id_seq;

CREATE SEQUENCE public.election_cycle_offices_mapping_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public.election_cycle_offices_mapping_id_seq
    OWNER TO devadmin;
	

DROP SEQUENCE public.lobbyist_client_id_seq;

CREATE SEQUENCE public.lobbyist_client_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public.lobbyist_client_id_seq
    OWNER TO devadmin;
	

DROP SEQUENCE public.lobbyist_relationship_id_seq;

CREATE SEQUENCE public.lobbyist_relationship_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public.lobbyist_relationship_id_seq
    OWNER TO devadmin;
---------------------------------------Sequence------------------------------------------
