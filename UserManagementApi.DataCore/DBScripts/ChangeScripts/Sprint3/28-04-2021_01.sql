---------------------------------------Functions------------------------------------
DROP FUNCTION public.get_contactbyname(integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.get_contactbyname(
	entityid integer,
	entitytype character varying,
	searchname character varying)
    RETURNS TABLE(contactid integer, fullname text, filerid integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE _filerId int = 0;
begin
	
   SELECT filer_id INTO _filerId 
   FROM public.filer 
   	WHERE entity_id = entityId 
		AND entity_type = entityType;
   
  	  return query
	  SELECT c.contact_id, 
			CASE WHEN c.contact_type = 'CON-I' THEN
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END 
			ELSE
				text(c.org_name)
			END AS fName,
			crm.filer_id
		FROM public.contact_role_mapping crm
			INNER JOIN public.contact c ON crm.contact_id = c.contact_id
			INNER JOIN (SELECT "id" AS roleId FROM public.role 
						   WHERE role IN ('Payee', 
										  'Lender', 
										  'Contributor')) tr ON tr.roleId = crm.role_type_id
		WHERE crm.filer_id = _filerId
		 AND lower(crm.status_code) = 'active'
		 AND coalesce(c.version_id, 0) = 0
		 AND (lower(c.first_name) LIKE '%' || lower(searchname) || '%' OR
			  lower(c.last_name) LIKE '%' || lower(searchname) || '%' OR 
			  lower(c.org_name) LIKE '%' || lower(searchname) || '%')
		ORDER BY 1 DESC
		LIMIT 5;
	

 end
$BODY$;

ALTER FUNCTION public.get_contactbyname(integer, character varying, character varying)
    OWNER TO devadmin;


DROP FUNCTION public.save_contributiontxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer);

CREATE OR REPLACE FUNCTION public.save_contributiontxn(
	txnid integer,
	txnversionid integer,
	entityid integer,
	entitytype character varying,
	txntypeid character varying,
	txnamount double precision,
	txndate date,
	contactid integer,
	contacttype character varying,
	firstname character varying,
	lastname character varying,
	employername character varying,
	occupationdesc character varying,
	voterid character varying,
	caddress1 character varying,
	caddress2 character varying,
	cityname character varying,
	statecode character varying,
	zipcode character varying,
	electioncycleid integer,
	refundorpaidflag boolean,
	refundorpaiddate date,
	refundorpaidamount double precision,
	refundreason character varying,
	parenttxnid integer,
	notes character varying,
	contributiontypeid character varying,
	monetarytypeid character varying,
	postelectionexemptflag boolean,
	txncategoryid character varying,
	txnpurpose character varying,
	fairelectionfundflag boolean,
	electioneeringcommflag boolean,
	ieflag boolean,
	nondonorfundflag boolean,
	nondonorsource character varying,
	nondonoramount double precision,
	methodofcommunication character varying,
	ietargettype character varying,
	positiondesc character varying,
	ballotissueid integer,
	ballotissuedesc character varying,
	candidatename character varying,
	officesought character varying,
	district character varying,
	adminnotes character varying,
	fefstatus character varying,
	disbursementid integer,
	roletype character varying,
	contactupdatedflag boolean,
	userid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newTransactionId integer = 0;
DECLARE newContactId integer = 0;
DECLARE roleTypeId integer = 0;
DECLARE _filerId integer = 0;
DECLARE _parentTxnId int;
begin

	if parentTxnId = 0 then
		_parentTxnId = null;
	else
		_parentTxnId := parentTxnId;
	end if;
			  
	SELECT filer_id INTO _filerId 
	FROM public.filer 
		WHERE entity_id = entityId 
			AND entity_type = entityType;
			
	if contactid = 0 then
	begin
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on, altphone, 
			altemail, version_id)
			VALUES (nextval('contact_contact_id_seq'), contactType, firstName, 
					null, lastName, employerName, 
					cAddress1, cAddress2, cityName, 
					stateCode, null, zipCode, 
					null, null, occupationDesc, 
					voterId, null, _filerid, 
					'ACTIVE', 'Denver', localtimestamp, 
					'Denver', localtimestamp, null, 
					null, null);
					
		-- Get the current value from contact table
		SELECT currval('contact_contact_id_seq') INTO newContactId;
	end;	
	else
		if contactupdatedflag = true then
		begin
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on, altphone, 
			altemail, version_id)
			VALUES (nextval('contact_contact_id_seq'), contactType, firstName, 
					null, lastName, employerName, 
					cAddress1, cAddress2, cityName, 
					stateCode, null, zipCode, 
					null, null, occupationDesc, 
					voterId, null, _filerid, 
					'ACTIVE', 'Denver', localtimestamp, 
					'Denver', localtimestamp, null, 
					null, null);
					
			-- Get the current value from contact table
			SELECT currval('contact_contact_id_seq') INTO newContactId;

		-- Update the version_id to contact table
	       UPDATE public.contact
				SET version_id = newContactId
			WHERE contact_id = contactid;
		end;
		else
			newContactId = contactid;
		end if;	
	end if;	
	-- Get Role Type from Role Table
	SELECT id into roleTypeId FROM public.role WHERE role = roleType;

	INSERT INTO public.contact_role_mapping(
		contact_role_mapping_id, user_id, contact_id, 
		filer_id, role_type_id, created_by, 
		created_at, updated_by, updated_on, 
		status_code)
		VALUES (nextval('contact_role_mapping_contact_role_mapping_id_seq'), userId, newContactId, 
				_filerId, roleTypeId, 'Denver', 
				localtimestamp, 'Denver', localtimestamp, 
				'ACTIVE');
	
	
	if txnId = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.transaction(
			transaction_id, txn_version_id, filer_id, 
			txn_type_id, txn_amount, txn_date, 
			contact_id, election_cycle_id, refund_or_paid_flag, 
			refund_or_paid_date, refund_or_paid_amount, refund_reason, 
			parent_transaction_id, notes, contribution_type_id, 
			monetary_type_id, post_election_exempt_flag, txn_category_id, 
			txn_purpose, fair_election_fund_flag, electioneering_comm_flag, 
			independent_expn_flag, nondonor_fund_flag, nondonor_source, 
			nondonor_amount, method_of_communication, "IE_target_type", 
			"position", ballot_issue_id, ballot_issue_desc, 
			candidate_name, office_sought, district, 
			admin_notes, fef_status, disbursement_id)
			VALUES (nextval('transaction_id_seq'), txnVersionId, _filerId,
					txnTypeId, txnAmount, txnDate,
					newContactId, electionCycleId, refundorpaidflag,
					refundorpaiddate, refundOrPaidAmount, refundReason,
					_parentTxnId, notes, contributionTypeId,
					monetaryTypeId, postElectionExemptFlag, txnCategoryId,
					txnPurpose, fairElectionFundFlag, electioneeringCommFlag,
					IEFlag, nonDonorFundFlag, nonDonorSource,
					nonDonorAmount, methodOfCommunication, IETargetType,
					positionDesc, ballotIssueId, ballotIssueDesc,
					candidateName, officeSought, district,
					adminNotes, fefStatus, disbursementId);

		-- Get the current value from contact table
		SELECT currval('transaction_id_seq') INTO newTransactionId;
	end;
	end if;
	
	if txnId = 0 then
		txnId := newTransactionId;
	end if;
	
	return txnId;

 end
$BODY$;

ALTER FUNCTION public.save_contributiontxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer)
    OWNER TO devadmin;


DROP FUNCTION public.save_expendituretxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer);

CREATE OR REPLACE FUNCTION public.save_expendituretxn(
	txnid integer,
	txnversionid integer,
	entityid integer,
	entitytype character varying,
	txntypeid character varying,
	txnamount double precision,
	txndate date,
	contactid integer,
	contacttype character varying,
	firstname character varying,
	lastname character varying,
	employername character varying,
	occupationdesc character varying,
	voterid character varying,
	caddress1 character varying,
	caddress2 character varying,
	cityname character varying,
	statecode character varying,
	zipcode character varying,
	electioncycleid integer,
	refundorpaidflag boolean,
	refundorpaiddate date,
	refundorpaidamount double precision,
	refundreason character varying,
	parenttxnid integer,
	notes character varying,
	contributiontypeid character varying,
	monetarytypeid character varying,
	postelectionexemptflag boolean,
	txncategoryid character varying,
	txnpurpose character varying,
	fairelectionfundflag boolean,
	electioneeringcommflag boolean,
	ieflag boolean,
	nondonorfundflag boolean,
	nondonorsource character varying,
	nondonoramount double precision,
	methodofcommunication character varying,
	ietargettype character varying,
	positiondesc character varying,
	ballotissueid integer,
	ballotissuedesc character varying,
	candidatename character varying,
	officesought character varying,
	district character varying,
	adminnotes character varying,
	fefstatus character varying,
	disbursementid integer,
	roletype character varying,
	contactupdatedflag boolean,
	userid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newTransactionId integer = 0;
DECLARE newContactId integer = 0;
DECLARE roleTypeId integer = 0;
DECLARE _filerId integer = 0;
DECLARE _parentTxnId int;
begin

	if parentTxnId = 0 then
		_parentTxnId = null;
	else
		_parentTxnId := parentTxnId;
	end if;
			  
	SELECT filer_id INTO _filerId 
	FROM public.filer 
		WHERE entity_id = entityId 
			AND entity_type = entityType;
			
	if contactid = 0 then
	begin
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on, altphone, 
			altemail, version_id)
			VALUES (nextval('contact_contact_id_seq'), contactType, firstName, 
					null, lastName, employerName, 
					cAddress1, cAddress2, cityName, 
					stateCode, null, zipCode, 
					null, null, occupationDesc, 
					voterId, null, _filerid, 
					'ACTIVE', 'Denver', localtimestamp, 
					'Denver', localtimestamp, null, 
					null, null);
					
		-- Get the current value from contact table
		SELECT currval('contact_contact_id_seq') INTO newContactId;
	end;	
	else
		if contactupdatedflag = true then
		begin
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on, altphone, 
			altemail, version_id)
			VALUES (nextval('contact_contact_id_seq'), contactType, firstName, 
					null, lastName, employerName, 
					cAddress1, cAddress2, cityName, 
					stateCode, null, zipCode, 
					null, null, occupationDesc, 
					voterId, null, _filerid, 
					'ACTIVE', 'Denver', localtimestamp, 
					'Denver', localtimestamp, null, 
					null, null);
					
			-- Get the current value from contact table
			SELECT currval('contact_contact_id_seq') INTO newContactId;

		-- Update the version_id to contact table
	       UPDATE public.contact
				SET version_id = newContactId
			WHERE contact_id = contactid;
		end;
		else
			newContactId = contactid;
		end if;	
	end if;	
	-- Get Role Type from Role Table
	SELECT id into roleTypeId FROM public.role WHERE role = roleType;

	INSERT INTO public.contact_role_mapping(
		contact_role_mapping_id, user_id, contact_id, 
		filer_id, role_type_id, created_by, 
		created_at, updated_by, updated_on, 
		status_code)
		VALUES (nextval('contact_role_mapping_contact_role_mapping_id_seq'), userId, newContactId, 
				_filerId, roleTypeId, 'Denver', 
				localtimestamp, 'Denver', localtimestamp, 
				'ACTIVE');
	
	
	if txnId = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.transaction(
			transaction_id, txn_version_id, filer_id, 
			txn_type_id, txn_amount, txn_date, 
			contact_id, election_cycle_id, refund_or_paid_flag, 
			refund_or_paid_date, refund_or_paid_amount, refund_reason, 
			parent_transaction_id, notes, contribution_type_id, 
			monetary_type_id, post_election_exempt_flag, txn_category_id, 
			txn_purpose, fair_election_fund_flag, electioneering_comm_flag, 
			independent_expn_flag, nondonor_fund_flag, nondonor_source, 
			nondonor_amount, method_of_communication, "IE_target_type", 
			"position", ballot_issue_id, ballot_issue_desc, 
			candidate_name, office_sought, district, 
			admin_notes, fef_status, disbursement_id)
			VALUES (nextval('transaction_id_seq'), txnVersionId, _filerId,
					txnTypeId, txnAmount, txnDate,
					newContactId, electionCycleId, refundorpaidflag,
					refundorpaiddate, refundOrPaidAmount, refundReason,
					_parentTxnId, notes, contributionTypeId,
					monetaryTypeId, postElectionExemptFlag, txnCategoryId,
					txnPurpose, fairElectionFundFlag, electioneeringCommFlag,
					IEFlag, nonDonorFundFlag, nonDonorSource,
					nonDonorAmount, methodOfCommunication, IETargetType,
					positionDesc, ballotIssueId, ballotIssueDesc,
					candidateName, officeSought, district,
					adminNotes, fefStatus, disbursementId);

		-- Get the current value from contact table
		SELECT currval('transaction_id_seq') INTO newTransactionId;
	end;
	end if;
	
	if txnId = 0 then
		txnId := newTransactionId;
	end if;
	
	return txnId;

 end
$BODY$;

ALTER FUNCTION public.save_expendituretxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer)
    OWNER TO devadmin;

---------------------------------------Functions------------------------------------

---------------------------------------Tables------------------------------------
DROP TABLE public.transaction;

CREATE TABLE public.transaction
(
    transaction_id integer NOT NULL,
    txn_version_id integer NOT NULL,
    filer_id integer NOT NULL,
    txn_type_id character varying(15) COLLATE pg_catalog."default" NOT NULL,
    txn_amount double precision NOT NULL,
    txn_date date,
    contact_id integer NOT NULL,
    election_cycle_id integer,
    refund_or_paid_date date,
    refund_or_paid_amount double precision,
    refund_reason character varying(250) COLLATE pg_catalog."default",
    parent_transaction_id integer,
    notes character varying(250) COLLATE pg_catalog."default",
    contribution_type_id character varying(15) COLLATE pg_catalog."default",
    monetary_type_id character varying(15) COLLATE pg_catalog."default",
    post_election_exempt_flag boolean,
    txn_category_id character varying(15) COLLATE pg_catalog."default",
    txn_purpose character varying(250) COLLATE pg_catalog."default",
    fair_election_fund_flag boolean,
    electioneering_comm_flag boolean,
    independent_expn_flag boolean,
    nondonor_fund_flag boolean,
    nondonor_source character varying(100) COLLATE pg_catalog."default",
    nondonor_amount double precision,
    method_of_communication character varying(250) COLLATE pg_catalog."default",
    "IE_target_type" character varying(1) COLLATE pg_catalog."default",
    "position" character varying(1) COLLATE pg_catalog."default",
    ballot_issue_id integer,
    ballot_issue_desc character varying(250) COLLATE pg_catalog."default",
    candidate_name character varying(100) COLLATE pg_catalog."default",
    office_sought character varying(15) COLLATE pg_catalog."default",
    district character varying(30) COLLATE pg_catalog."default",
    admin_notes character varying(500) COLLATE pg_catalog."default",
    fef_status character varying(15) COLLATE pg_catalog."default",
    disbursement_id integer,
    refund_or_paid_flag boolean,
    CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.transaction
    OWNER to devadmin;
---------------------------------------Tables------------------------------------
