-- FUNCTION: public.get_userentitydetail(integer, character varying)

-- DROP FUNCTION public.get_userentitydetail(integer, character varying);

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
			text(pc.contact_type) as entity_Type,
			text(pc.org_name),
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
			LEFT JOIN public.contact c ON l.primary_contact_id = c.contact_id
			INNER JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
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
		      '' as entity_Name, 
			   text(c.contact_type) as entity_Type,
			   text(c.org_name),
			   '' as primary_name,
			   '' as candidate_name,
				'' as treasurer_name,
			   '' as election_date,
			   '' as public_fund,
			   '' as ballot_issue,
			   '' as position,
			   '' as purpose,
			   text(c.occupation) as occupation
		FROM public.contact_role_mapping crm
			 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
			 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
		WHERE c.contact_id = _entityid  and crm.status_code='ACTIVE';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_userentitydetail(integer, character varying)
    OWNER TO devadmin;
