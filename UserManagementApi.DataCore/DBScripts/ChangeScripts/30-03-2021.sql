-------------------------------------------------------------------------tables-------------------------------------------------------
------------------------------------------------------------------------------
--tablename:Appsetting
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------
CREATE TABLE public.app_setting
(
    app_id integer NOT NULL DEFAULT nextval('app_tenant_app_id_seq'::regclass),
    app_name character varying(40) COLLATE pg_catalog."default",
    theme_name character varying(100) COLLATE pg_catalog."default",
    logo_url character varying(50000) COLLATE pg_catalog."default",
    fav_icon character varying(50000) COLLATE pg_catalog."default",
    banner_image_url character varying(50000) COLLATE pg_catalog."default",
    seal_image_url character varying(50000) COLLATE pg_catalog."default",
    clerk_seal_image_url character varying(50000) COLLATE pg_catalog."default",
    header_image_url character varying(50000) COLLATE pg_catalog."default",
    footer_image_url character varying(50000) COLLATE pg_catalog."default",
    clerk_sign_image_url character varying(50000) COLLATE pg_catalog."default",
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT app_setting_pkey PRIMARY KEY (app_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.app_setting
    OWNER to devadmin;
------------------------------------------------------
------------------------------------------------------------------------------
--tablename:ballot_issue
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------

CREATE TABLE public.ballot_issue
(
    ballot_issue_id integer NOT NULL DEFAULT nextval('ballot_issue_ballot_issue_id_seq'::regclass),
    ballot_issue_code character varying(15) COLLATE pg_catalog."default" NOT NULL,
    ballot_issue character varying(100) COLLATE pg_catalog."default" NOT NULL,
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    sequence_no integer,
    isactive boolean,
    election_date date,
    election_cycle character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT ballot_issue_pkey PRIMARY KEY (ballot_issue_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ballot_issue
    OWNER to devadmin;
-------------------------------------------
    ------------------------------------------------------------------------------
--tablename:committee_type
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------

CREATE TABLE public.committee_type
(
    committetypeid integer NOT NULL DEFAULT nextval('committetype_sm_committetypeid_seq'::regclass),
    committetypename character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT committetype_sm_pkey PRIMARY KEY (committetypeid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.committee_type
    OWNER to devadmin;
    -------------------------------------------
 ------------------------------------------------------------------------------
--tablename:contribution_limits
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------

CREATE TABLE public.contribution_limits
(
    id integer NOT NULL DEFAULT nextval('contribution_limits_id_seq'::regclass),
    commitee_type_id character varying(100) COLLATE pg_catalog."default",
    office_type_id character varying(100) COLLATE pg_catalog."default",
    donor_type_id character varying(100) COLLATE pg_catalog."default",
    election_cycle_id integer NOT NULL,
    tenant_id integer NOT NULL,
    commitee_type character varying(100) COLLATE pg_catalog."default",
    office_type character varying(100) COLLATE pg_catalog."default",
    donor_type character varying(100) COLLATE pg_catalog."default",
    cont_limit numeric(6,2),
    election_year character varying(100) COLLATE pg_catalog."default",
    description character varying(500) COLLATE pg_catalog."default",
    CONSTRAINT contribution_limits_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.contribution_limits
    OWNER to devadmin;


    -------------------------------------------------------------------------------------
    

CREATE TABLE public.election
(
    id integer NOT NULL,
    election_date date NOT NULL,
    name character varying(300) COLLATE pg_catalog."default",
    "desc" character varying(1000) COLLATE pg_catalog."default",
    tenant_id integer,
    status_code character varying(3) COLLATE pg_catalog."default",
    "created_ by" character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT election_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.election
    OWNER to devadmin;
   
   ---------------------------------------------------------------------------


CREATE TABLE public.filer
(
    filer_id integer NOT NULL DEFAULT nextval('filer_filer_id_seq'::regclass),
    entity_type character varying(150) COLLATE pg_catalog."default",
    entity_id integer,
    categoryid integer,
    filer_status character varying(10) COLLATE pg_catalog."default",
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT filer_pkey PRIMARY KEY (filer_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.filer
    OWNER to devadmin;

 -----------------------------------------------------


CREATE TABLE public.matchinglimits
(
    matchingid integer NOT NULL DEFAULT nextval('matchinglimits_matchingid_seq'::regclass),
    qualifyingcontributionamount numeric(6,2),
    matchingcontributionamount numeric(6,2),
    numberrequiredqualifyingcontributions integer,
    matchingratio character varying COLLATE pg_catalog."default",
    contributionlimitsforparticipate integer,
    totalavailablefunds numeric(6,2),
    office_type_id character varying COLLATE pg_catalog."default",
    qualifyingoffices character varying COLLATE pg_catalog."default",
    startdate date NOT NULL,
    endate date NOT NULL,
    electioncycle character varying COLLATE pg_catalog."default",
    CONSTRAINT matchinglimits_pkey PRIMARY KEY (matchingid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.matchinglimits
    OWNER to devadmin;


-------------------------------------------
    -- Table: public.offices

-- DROP TABLE public.offices;

CREATE TABLE public.offices
(
    officeid integer NOT NULL DEFAULT nextval('offices_officeid_seq'::regclass),
    office character varying(120) COLLATE pg_catalog."default" NOT NULL,
    createddate date,
    updateddate date,
    CONSTRAINT offices_pkey PRIMARY KEY (officeid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.offices
    OWNER to devadmin;

 -------------------------------------------------
    -- Table: public.user_role_permission

-- DROP TABLE public.user_role_permission;

CREATE TABLE public.user_role_permission
(
    ind integer NOT NULL,
    modulename character varying(200) COLLATE pg_catalog."default" NOT NULL,
    tenantid integer NOT NULL,
    candidate integer,
    treasusrer integer,
    committeeofficer integer,
    primarylobbylist integer,
    lobbylist integer,
    official integer,
    CONSTRAINT userpermissionsettings_pkey PRIMARY KEY (ind)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.user_role_permission
    OWNER to devadmin;

    -------------------------------------------

    CREATE TABLE public.contact_role_mapping
(
    contact_role_mapping_id serial,
    user_id integer NULL,
    contact_id integer NULL,
    filer_id integer NULL,
    role_type_id integer NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT contact_role_mapping_pkey PRIMARY KEY (contact_role_mapping_id)
)
    --------------------------------------------------------END TABLE------------------------------------------------
    ---------------------------------------Functions---------------------------------------------
    -- FUNCTION: public.get_apptenant(integer)

-- DROP FUNCTION public.get_apptenant(integer);

CREATE OR REPLACE FUNCTION public.get_apptenant(
	_appid integer)
    RETURNS TABLE(appid integer, appname character varying, themename character varying, logourl character varying,
    favicon character varying, bannerimageurl character varying, sealimageurl character varying, clerksealimageurl character varying, 
    headerimageurl character varying, footerimageurl character varying, clerksignimageurl character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT app.app_id,
	app.app_name,
	app.theme_name,
	app.logo_url,
	app.fav_icon,
	app.banner_image_url,
	app.seal_image_url,
	app.clerk_seal_image_url,
	app.header_image_url,
	app.footer_image_url,
	app.clerk_sign_image_url
	FROM public.app_setting app where app.app_id=_appid;
end
$BODY$;

ALTER FUNCTION public.get_apptenant(integer)
    OWNER TO devadmin;

    -----------------------------------------------------------------------------------------------------------------------
    -- FUNCTION: public.delete_ballotissuesm(integer)

-- DROP FUNCTION public.delete_ballotissuesm(integer);

CREATE OR REPLACE FUNCTION public.delete_ballotissuesm(
	ballotissueid integer)
    RETURNS integer
begin
 delete from public."ballot_issue_sm"
 where "ballot_issue_id" = ballotissueid;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_ballotissuesm(integer)
    OWNER TO devadmin;

    ------------------------------------------------------------------------
    -- FUNCTION: public.delete_contributionlimits(integer)

-- DROP FUNCTION public.delete_contributionlimits(integer);

CREATE OR REPLACE FUNCTION public.delete_contributionlimits(
	_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 delete from public."contribution_limits"
 where "id" = _id;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_contributionlimits(integer)
    OWNER TO devadmin;

--------------------------------------------------------------------------------------
-- FUNCTION: public.delete_matchingdetails(integer)

-- DROP FUNCTION public.delete_matchingdetails(integer);

CREATE OR REPLACE FUNCTION public.delete_matchingdetails(
	_matchingid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 delete from public.matchinglimits
 where MatchingId = _matchingid;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_matchingdetails(integer)
    OWNER TO devadmin;
------------------------------------------------------------------------------------------
-- FUNCTION: public.get_ballotissuesm()

-- DROP FUNCTION public.get_ballotissuesm();

CREATE OR REPLACE FUNCTION public.get_ballotissuesm(
	)
    RETURNS TABLE(ballotid integer, ballotissuecode character varying, ballotissue character varying, createdby character varying,
    createdat date, updatedby character varying, updatedon date, electioncycle character varying, description character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT bism.ballot_issue_id, 
	bism.ballot_issue_code, 
	bism.ballot_issue, 
	bism.created_by, 
	bism.created_at, 
	bism.updated_by, 
	bism.updated_on,
	bism.election_cycle,
	bism.description FROM public.ballot_issue_sm bism;
end
$BODY$;

ALTER FUNCTION public.get_ballotissuesm()
    OWNER TO devadmin;
-------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION: public.get_committeebyballotid(character varying)

-- DROP FUNCTION public.get_committeebyballotid(character varying);

CREATE OR REPLACE FUNCTION public.get_committeebyballotid(
	ballotissuecode character varying)
    RETURNS TABLE(committeeid integer, committeename character varying, committeeposition character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
	SELECT com.id, com.name, com.position
		FROM public.committee com
	WHERE com.ballot_issue_no = ballotissuecode;
end
$BODY$;

ALTER FUNCTION public.get_committeebyballotid(character varying)
    OWNER TO devadmin;
--------------------------------------------------------------------------------
-- FUNCTION: public.get_committeetypedetails()

-- DROP FUNCTION public.get_committeetypedetails();

CREATE OR REPLACE FUNCTION public.get_committeetypedetails(
	)
    RETURNS TABLE(committetypeid integer, committetype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select ct.CommitteTypeId,ct.CommitteTypeName from public.committee_type ct
   order by CommitteTypeName;
 end
$BODY$;

ALTER FUNCTION public.get_committeetypedetails()
    OWNER TO devadmin;
-----------------------------------------------------------------------------------
-- FUNCTION: public.get_contributionlimits()

-- DROP FUNCTION public.get_contributionlimits();

CREATE OR REPLACE FUNCTION public.get_contributionlimits(
	)
    RETURNS TABLE(id integer, commiteetypeid character varying, officetypeid character varying, 
    donortypeid character varying, electioncycleid integer, tenantid integer, commiteetype character varying, 
    officetype character varying, donortype character varying, electionyear character varying, descript character varying, 
    contlimit numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT 
	contl.id,
	contl.commitee_type_id,
	contl.office_type_id,
	contl.donor_type_id,
	contl.election_cycle_id,
		contl.tenant_id,
    contl.commitee_type,
    contl.office_type,
    contl.donor_type,
	contl.election_year,
    contl.description,
	contl.cont_limit
	FROM public.contribution_limits contl;
end
$BODY$;

ALTER FUNCTION public.get_contributionlimits()
    OWNER TO devadmin;
-------------------------------------------------------------------------------------------------
-- FUNCTION: public.get_donortypes()

-- DROP FUNCTION public.get_donortypes();

CREATE OR REPLACE FUNCTION public.get_donortypes(
	)
    RETURNS TABLE(donortypeid character varying, donortype character varying, name character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
	SELECT Donor.lookup_type_code, Donor.type_id,  Donor.name
	FROM public.type_lookups Donor where Donor.lookup_type_code='FILER-TYPE';
end
$BODY$;

ALTER FUNCTION public.get_donortypes()
    OWNER TO devadmin;
---------------------------------------------------------------------------------------------------
-- FUNCTION: public.get_electionlist()

-- DROP FUNCTION public.get_electionlist();

CREATE OR REPLACE FUNCTION public.get_electionlist(
	)
    RETURNS TABLE(id integer, electiondate date, name character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT election.id, election.election_date,  election.name
	FROM public.election election;
end
$BODY$;

ALTER FUNCTION public.get_electionlist()
    OWNER TO devadmin;

-----------------------------------------------------------------------------------------------------
-- FUNCTION: public.get_matchingdetails()

-- DROP FUNCTION public.get_matchingdetails();

CREATE OR REPLACE FUNCTION public.get_matchingdetails(
	)
    RETURNS TABLE(matchingid integer, qualifyingcontributionamount numeric, matchingcontributionamount numeric,
    numberrequiredqualifyingcontributions integer, matchingratio character varying, contributionlimitsforparticipate integer, 
    totalavailablefunds numeric, officetypeid character varying, qualifyingoffices character varying, startdate date,
    enddate date, electioncycle character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT matchlimit.MatchingId,
matchlimit.QualifyingContributionAmount,
matchlimit.MatchingContributionAmount,
matchlimit.NumberRequiredQualifyingContributions,
matchlimit.MatchingRatio,
matchlimit.ContributionLimitsforParticipate,
matchlimit.totalavailablefunds,
matchlimit.office_type_id,
matchlimit.QualifyingOffices,
matchlimit.StartDate,
matchlimit.Endate, 
matchlimit.ElectionCycle from public.matchinglimits matchlimit;
  
  	
end
$BODY$;

ALTER FUNCTION public.get_matchingdetails()
    OWNER TO devadmin;
--------------------------------------------------------------------------------------------------------------
-- FUNCTION: public.get_officelistdetails()

-- DROP FUNCTION public.get_officelistdetails();

CREATE OR REPLACE FUNCTION public.get_officelistdetails(
	)
    RETURNS TABLE(officeid integer, officename character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select off.officeid, off.office from public.Offices off
   order by off.officeId;
 end
$BODY$;

ALTER FUNCTION public.get_officelistdetails()
    OWNER TO devadmin;
------------------------------------------------------------------------------------------------------
-- FUNCTION: public.get_userpermission()

-- DROP FUNCTION public.get_userpermission();

CREATE OR REPLACE FUNCTION public.get_userpermission(
	)
    RETURNS TABLE(ind integer, modulename character varying, tenantid integer, candidate integer, treasusrer integer, committeeofficer integer, primarylobbylist integer, lobbylist integer, official integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT 
	contl.ind,
	contl.Modulename,
	contl.TenantId,
	contl.Candidate,
	contl.treasusrer,
    contl.CommitteeOfficer,
    contl.PrimaryLobbyList,
    contl.LobbyList,
    contl.Official
	FROM public.user_role_permission contl;
end
$BODY$;

ALTER FUNCTION public.get_userpermission()
    OWNER TO devadmin;
------------------------------------------------------------------------------
-- FUNCTION: public.save_apptenant(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_apptenant(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_apptenant(
	appname character varying,
	themename character varying,
	logourl character varying,
	favicon character varying,
	bannerimageurl character varying,
	sealimageurl character varying,
	clerksealimageurl character varying,
	headerimageurl character varying,
	footerimageurl character varying,
	clerksignimageurl character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin

	
	INSERT INTO public.app_setting(
	app_name,
    theme_name,
    logo_url,
    fav_icon,
    banner_image_url,
    seal_image_url,
    clerk_seal_image_url,
    header_image_url,
    footer_image_url,
    clerk_sign_image_url,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (appname,
	themename,
	logourl,
	favicon,
	bannerimageurl,
	sealimageurl,
	clerksealimageurl,
    headerimageurl,
    footerimageurl,
    clerksignimageurl,
	'Denver',
	NOW(),
	'Denver',
	NOW());
			
	return (SELECT LASTVAL());
		--return 1; -- inserted fail
	

end
$BODY$;

-------------------------------------------------------------------------
-- FUNCTION: public.save_ballotissuesm(character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_ballotissuesm(character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_ballotissuesm(
	ballotissuecode character varying,
	ballotissue character varying,
	electioncycle character varying,
	_description character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE ballotissueid int = 0;
begin

	-- SELECT id = nextval(' ballot_issue_id');
	
	INSERT INTO public.ballot_issue_sm(ballot_issue_code, ballot_issue,
    created_by,
    created_at,
    updated_by,
    updated_on,
    election_cycle,description, cmtflag)
	VALUES (ballotissuecode, ballotissue,
			'Denver', NOW(), 'Denver',
			NOW(),
			electioncycle,_description,0);
			
	INSERT INTO public.ballot_issue(ballot_issue_code, ballot_issue,
    created_by,
    created_at,
    updated_by,
    updated_on,
	sequence_no,
	isactive,
    election_date,
	election_cycle)
	VALUES (ballotissuecode, ballotissue,
			'Denver', NOW(), 'Denver',
			NOW(),
			1,'true',NOW(),electioncycle);
			
			
		
			
	-- SELECT CURRVAL('ballot_issue_id') INTO ballotissueid;
	-- if found then --inserted successfully
	 -- 	return ballotissueid;
	-- else 
		return 1; -- inserted fail
	--end if;

end
$BODY$;

ALTER FUNCTION public.save_ballotissuesm(character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
----------------------------------------------------------------------------------------------------
-- FUNCTION: public.save_committetypes(character varying)

-- DROP FUNCTION public.save_committetypes(character varying);

CREATE OR REPLACE FUNCTION public.save_committetypes(
	committetypename character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 INSERT INTO public.committee_type(CommitteTypeName)
 values(committetypename);
  --return (SELECT LASTVAL());
 return 1;
end
$BODY$;

ALTER FUNCTION public.save_committetypes(character varying)
    OWNER TO devadmin;
--------------------------------------------------------------------------------------------------------
-- FUNCTION: public.save_contributionlimits(character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, numeric)

-- DROP FUNCTION public.save_contributionlimits(character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, numeric);

CREATE OR REPLACE FUNCTION public.save_contributionlimits(
	commiteetypeid character varying,
	officetypeid character varying,
	donortypeid character varying,
	electioncycleid integer,
	tenantid integer,
	commiteetype character varying,
	officetype character varying,
	donortype character varying,
	electionyear character varying,
	des character varying,
	contlimit numeric)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE Coid int = 0;
begin

	
	
	INSERT INTO public.contribution_limits(commitee_type_id,
	office_type_id,
	donor_type_id,
	election_cycle_id,
	tenant_id,
    commitee_type,
    office_type,
    donor_type,
	cont_limit,
    election_year,
    description)
	VALUES (commiteetypeid,
	officetypeid,
	donortypeid,
	electioncycleid,
	tenantid,
    commiteetype,
    officetype,
    donortype,
	contlimit,
    electionyear,
    des);
			
	
	if found then --inserted successfully
	 	 return 1;
	else 
		return 0; -- inserted fail
	end if;

end
$BODY$;

ALTER FUNCTION public.save_contributionlimits(character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, numeric)
    OWNER TO devadmin;
----------------------------------------------------------------
-- FUNCTION: public.save_matchingdetails(numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)

-- DROP FUNCTION public.save_matchingdetails(numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying);

CREATE OR REPLACE FUNCTION public.save_matchingdetails(
	qualifyingcontributionamount numeric,
	matchingcontributionamount numeric,
	numberrequiredqualifyingcontributions integer,
	matchingratio character varying,
	contributionlimitsforparticipate integer,
	_totalavailablefunds numeric,
	officetypeid character varying,
	qualifyingoffices character varying,
	startdate date,
	endate date,
	electioncycle character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin

	--SELECT id = nextval('user_account_id_seq');
	
	INSERT INTO public.MatchingLimits(
		 QualifyingContributionAmount,MatchingContributionAmount, NumberRequiredQualifyingContributions, 
		MatchingRatio, ContributionLimitsforParticipate, totalavailablefunds,office_type_id, QualifyingOffices, 
		StartDate, Endate, ElectionCycle)
	VALUES (qualifyingcontributionamount,matchingcontributionamount, numberrequiredqualifyingcontributions, 
			matchingratio, contributionlimitsforparticipate, _totalavailablefunds, officetypeid, qualifyingoffices,
			startdate, endate, electioncycle);
			

	if found then --inserted successfully
	  	return 1;
	else 
		return 0; -- inserted fail
	end if;

end
$BODY$;

ALTER FUNCTION public.save_matchingdetails(numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)
    OWNER TO devadmin;
-------------------------------------------------------------------------
-- FUNCTION: public.update_apptenant(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.update_apptenant(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.update_apptenant(
	appid integer,
	appname character varying,
	themename character varying,
	logourl character varying,
	favicon character varying,
	bannerimageurl character varying,
	sealimageurl character varying,
	clerksealimageurl character varying,
	headerimageurl character varying,
	footerimageurl character varying,
	clerksignimageurl character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin

	
	update  public.app_tenant set
	app_name = appname,
    theme_name = themename,
    logo_url = logourl ,
    fav_icon = favicon,
    banner_image_url = bannerimageurl,
    seal_image_url = sealimageurl,
    clerk_seal_image_url = clerksealimageurl,
    header_image_url = headerimageurl,
    footer_image_url = footerimageurl,
    clerk_sign_image_url = clerksignimageurl,
    updated_by = 'Denver',
    updated_on = NOW() where  app_id= appid;
    return 1; -- inserted fail
	

end
$BODY$;

ALTER FUNCTION public.update_apptenant(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
--------------------------------------------------------------
-- FUNCTION: public.update_ballotissuesm(integer, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.update_ballotissuesm(integer, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.update_ballotissuesm(
	_ballot_issue_id integer,
	_ballot_issue_code character varying,
	_ballot_issue character varying,
	_election_cycle character varying,
	_description character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public."ballot_issue_sm" set ballot_issue_code=_ballot_issue_code,  
 ballot_issue=_ballot_issue, election_cycle=_election_cycle, description=_description, 
 created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "ballot_issue_id" = _ballot_issue_id;
 return _ballot_issue_id;
end
$BODY$;

ALTER FUNCTION public.update_ballotissuesm(integer, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
------------------------------------------------------------
-- FUNCTION: public.update_committetypename(integer, character varying)

-- DROP FUNCTION public.update_committetypename(integer, character varying);

CREATE OR REPLACE FUNCTION public.update_committetypename(
	committeeid integer,
	committeename character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.Committee_type  set committetypename = committeename
 where committetypeid = committeeid;
 return committeeid;
end
$BODY$;

ALTER FUNCTION public.update_committetypename(integer, character varying)
    OWNER TO devadmin;
--------------------------------------------------------
-- FUNCTION: public.update_matchingdetails(integer, numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)

-- DROP FUNCTION public.update_matchingdetails(integer, numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying);

CREATE OR REPLACE FUNCTION public.update_matchingdetails(
	_matchingid integer,
	_qualifyingcontributionamount numeric,
	_matchingcontributionamount numeric,
	_numberrequiredqualifyingcontributions integer,
	_matchingratio character varying,
	_contributionlimitsforparticipate integer,
	_totalavailablefunds numeric,
	_officetypeid character varying,
	_qualifyingoffices character varying,
	_startdate date,
	_endate date,
	_electioncycle character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.matchinglimits set QualifyingContributionAmount=_qualifyingcontributionamount, 
 MatchingContributionAmount=_matchingcontributionamount,
 NumberRequiredQualifyingContributions=_numberrequiredqualifyingcontributions,
 MatchingRatio=_matchingratio, ContributionLimitsforParticipate=_contributionlimitsforparticipate,
 totalavailablefunds = _totalavailablefunds,office_type_id=_officetypeid,
 QualifyingOffices=_qualifyingoffices, StartDate=_startdate, EnDate=_endate, 
 ElectionCycle=_electioncycle
 where MatchingId = _matchingid;
 return _matchingid;
end
$BODY$;

ALTER FUNCTION public.update_matchingdetails(integer, numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)
    OWNER TO devadmin;
-------------------------------------------------------------------
-- FUNCTION: public.get_committeedetailsbyname(character varying)

DROP FUNCTION public.get_committeedetailsbyname(character varying);

CREATE OR REPLACE FUNCTION public.get_committeedetailsbyname(
	comname character varying)
    RETURNS TABLE(committeeid integer, committeename character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
 
  return query

 SELECT C.committee_id, C.name 
	FROM public.committee C
	WHERE LOWER(C.name) LIKE '%' || '' || LOWER(comname) || '' || '%'
		   ORDER BY C.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeedetailsbyname(character varying)
    OWNER TO devadmin;
------------------------------------------------------------------------------------------------