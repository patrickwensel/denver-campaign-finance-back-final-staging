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
				sIEDate, eIEDate, 'ACTIVE', 
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