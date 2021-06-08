------------------------------------------Functions----------------------------------------

DROP FUNCTION public.get_electioncycles();

CREATE OR REPLACE FUNCTION public.get_electioncycles(
	)
    RETURNS TABLE(electioncycleid integer, electioncycle character varying, electioncycletypeid character varying, electioncycletype character varying, startdate date, enddate date, electiondate date, description character varying, district character varying, iestartdate date, ieenddate date, officeids text, offices text, statusdesc character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin

	UPDATE public.election_cycle 
		SET status = 'COM'
	WHERE end_date < CURRENT_DATE
		AND status = 'ACT';
	
  return query
	SELECT ec.election_cycle_id, 
	   ec.name, 
	   ec.election_type_id, 
	   tl.name as etName,
	   ec.start_date, 
	   ec.end_date, 
	   ec.election_date,
	   ec."desc", 
	   ec.district, 
	   ec.ie_start_date, 
	   ec.ie_end_date,
	   string_agg(ecom.office_id::text,', ') officeids,
		string_agg(tlo.name::text,', ') offices,
		tks.name as statusDesc
	FROM public.election_cycle ec 
		INNER JOIN public.type_lookups tl ON ec.election_type_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
		INNER JOIN public.election_cycle_offices_mapping ecom ON ec.election_cycle_id = ecom.election_cycle_id
		INNER JOIN type_lookups tlo ON ecom.office_id = tlo.type_id
			AND tlo.lookup_type_code = 'OFF'
		LEFT JOIN public.type_lookups tks ON tks.type_id = ec.status
			AND tks.lookup_type_code ='ELECTION-STATUS'
	WHERE ec.status_code = 'ACTIVE'
		GROUP BY ec.election_cycle_id, 
	   ec.name, 
	   ec.election_type_id, 
	   tl.name,
	   ec.start_date, 
	   ec.end_date, 
	   ec.election_date,
	   ec."desc", 
	   ec.district, 
	   ec.ie_start_date, 
	   ec.ie_end_date,
	   tks.name
	ORDER BY 1;
 end
$BODY$;

ALTER FUNCTION public.get_electioncycles()
    OWNER TO devadmin;
	
	
DROP FUNCTION public.get_userentities(integer);

CREATE OR REPLACE FUNCTION public.get_userentities(
	userid integer)
    RETURNS TABLE(contactid integer, entityname text, entitytype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT l.lobbysit_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.lobbyist l ON l.lobbysit_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = l.filer_contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'L'
		AND coalesce(lower(l.status_code), 'active') = 'active'
	UNION
	SELECT com.committee_id, com.name as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.committee com ON com.committee_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'C'
		AND coalesce(lower(com.status_code), 'active') = 'active'
	UNION
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'IE'
		AND coalesce(lower(c.status_code), 'active') = 'active'
	UNION 
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'CO'
		AND coalesce(lower(c.status_code), 'active') = 'active';
 end
$BODY$;

ALTER FUNCTION public.get_userentities(integer)
    OWNER TO devadmin;
	
DROP FUNCTION public.get_userentitydetail(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_userentitydetail(
	_entityid integer,
	_entitytype character varying)
    RETURNS TABLE(contactid integer, entityname text, entitytype text, orgname text, primaryname text, candidatename text, treasurername text, electiondate text, publicfund text, ballotissue text, positiondesc text, purposedesc text, occupationdesc text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
	if _entitytype = 'AC-LOB' then
	  return query
		SELECT  l.lobbysit_id AS entity_Id,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(c.first_name, ' ', c.last_name) 
			ELSE
				CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
			END as entity_Name,
			CASE WHEN c.contact_type = 'I' THEN 'Individual'
				WHEN c.contact_type = 'O' THEN 'Organisation'
				ELSE ''
			END as entity_Type,
			text(c.org_name),
			CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(pc.first_name, ' ', pc.last_name) 
			ELSE
				CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
			END as primary_name,
			'' as candidate_name,
			'' as treasurer_name,
			'' as election_date,
			'' as public_fund,
			'' as ballot_issue,
			'' as position,
			'' as purpose,
			'' as occupation
		FROM public.lobbyist l 
			LEFT JOIN public.contact c ON l.filer_contact_id = c.contact_id
			INNER JOIN public.contact pc ON l.primary_contact_id = pc.contact_id
		WHERE l.lobbysit_id = _entityid;
	elsif _entitytype = 'AC-CAN' OR  _entitytype = 'AC-TST' then
		return query
		SELECT com.committee_id as entity_Id, 
				text(com.name) as entity_Name, 
				text(com.typeid) as entity_Type, 
				'' as org_name,
				'' as primary_name,
				CASE WHEN CONCAT(cc.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(cc.first_name, ' ', cc.last_name) 
				ELSE
					CONCAT(cc.first_name, ' ', cc.middle_name, ' ', cc.last_name)
				END as candidate_name,
				CASE WHEN CONCAT(tc.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(tc.first_name, ' ', tc.last_name) 
				ELSE
					CONCAT(tc.first_name, ' ', tc.middle_name, ' ', tc.last_name)
				END as treasurer_name,
				text(ec.election_date),
				'Active' as public_fund,
				text(bi.ballot_issue),
				text(com.position),
				text(com.purpose),
				'' as occupation
		FROM public.committee com
			INNER JOIN public.contact c ON c.contact_id = com.committee_contact_id
			LEFT JOIN public.contact cc ON com.candidate_contact_id = cc.contact_id
			LEFT JOIN public.contact tc ON com.treasurer_contact_id = tc.contact_id
			LEFT JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
			LEFT JOIN public.ballot_issue bi ON com.ballot_issue_id = bi.ballot_issue_id
		WHERE com.committee_id = _entityid;
	else
		return query
		SELECT c.contact_id as entity_Id, 
			   CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(c.first_name, ' ', c.last_name) 
			   ELSE
				CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
			   END as entity_Name, 
			   CASE WHEN f.entity_type = 'C' THEN 'Committee'
					WHEN f.entity_type = 'L' THEN 'Lobbyist'
					WHEN f.entity_type = 'IE' THEN 'Independent Expenditure'
					WHEN f.entity_type = 'CO' THEN 'Covered Official or Former City Employee'
			   ELSE
				''
			   END as entity_Type,
			   text(c.org_name),
			   '' as primary_name,
			   '' as candidate_name,
				'' as treasurer_name,
			   '' as election_date,
			   '' as public_fund,
			   '' as ballot_issue,
			   '' as position,
			   '' as purpose,
			   text(c.occupation)
		FROM public.contact_role_mapping crm
			 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
			 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
		WHERE c.contact_id = _entityid;
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_userentitydetail(integer, character varying)
    OWNER TO devadmin;




    ----------------------------------------Functions------------------------------------
	
	----------------------------------------Update Scripts -----------------------------
	UPDATE public.type_lookups
	SET "desc" = 'Completed',
		"name" = 'Completed'
WHERE "desc" = 'Complete'
	AND lookup_type_code ='ELECTION-STATUS'
	
	-----------------------------------------------------------------------