--------------------------------------Table Scripts-------------------------------------------------------------------------------

ALTER TABLE public.loan
ALTER COLUMN loan_type TYPE character varying(20);

ALTER TABLE public.transaction
ADD COLUMN description character varying(250);

--------------------------------------Table Scripts-------------------------------------------------------------------------------
 --------------------------------------Functions-------------------------------------------------------------------------------
 
 
 -- FUNCTION: public.save_contributiontxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)

-- DROP FUNCTION public.save_contributiontxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying);

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
	userid integer,
	_description character varying DEFAULT NULL::character varying)
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
DECLARE nYear double precision;
DECLARE _txndate date;
DECLARE _refundorpaiddate date;
begin
	SELECT EXTRACT(YEAR FROM txndate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_txndate := null;
	else
		_txndate := txndate;
	end if;
	
	SELECT EXTRACT(YEAR FROM refundorpaiddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_refundorpaiddate := null;
	else
		_refundorpaiddate := refundorpaiddate;
	end if;
	
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
			admin_notes, fef_status, disbursement_id, description)
			VALUES (nextval('transaction_id_seq'), txnVersionId, _filerId,
					txnTypeId, txnAmount, _txnDate,
					newContactId, electionCycleId, refundorpaidflag,
					_refundorpaiddate, refundOrPaidAmount, refundReason,
					_parentTxnId, notes, contributionTypeId,
					monetaryTypeId, postElectionExemptFlag, txnCategoryId,
					txnPurpose, fairElectionFundFlag, electioneeringCommFlag,
					IEFlag, nonDonorFundFlag, nonDonorSource,
					nonDonorAmount, methodOfCommunication, IETargetType,
					positionDesc, ballotIssueId, ballotIssueDesc,
					candidateName, officeSought, district,
					adminNotes, fefStatus, disbursementId, _description);

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

ALTER FUNCTION public.save_contributiontxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)
    OWNER TO devadmin;



-- FUNCTION: public.save_expendituretxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)

-- DROP FUNCTION public.save_expendituretxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying);

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
	userid integer,
	_description character varying DEFAULT NULL::character varying)
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
DECLARE nYear double precision;
DECLARE _txndate date;
DECLARE _refundorpaiddate date;
begin
	SELECT EXTRACT(YEAR FROM txndate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_txndate := null;
	else
		_txndate := txndate;
	end if;
	
	SELECT EXTRACT(YEAR FROM refundorpaiddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_refundorpaiddate := null;
	else
		_refundorpaiddate := refundorpaiddate;
	end if;
	
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
			admin_notes, fef_status, disbursement_id, description)
			VALUES (nextval('transaction_id_seq'), txnVersionId, _filerId,
					txnTypeId, txnAmount, _txnDate,
					newContactId, electionCycleId, refundorpaidflag,
					_refundorpaiddate, refundOrPaidAmount, refundReason,
					_parentTxnId, notes, contributionTypeId,
					monetaryTypeId, postElectionExemptFlag, txnCategoryId,
					txnPurpose, fairElectionFundFlag, electioneeringCommFlag,
					IEFlag, nonDonorFundFlag, nonDonorSource,
					nonDonorAmount, methodOfCommunication, IETargetType,
					positionDesc, ballotIssueId, ballotIssueDesc,
					candidateName, officeSought, district,
					adminNotes, fefStatus, disbursementId, _description);

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

ALTER FUNCTION public.save_expendituretxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)
    OWNER TO devadmin;


-- FUNCTION: public.save_ietxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)

-- DROP FUNCTION public.save_ietxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying);

CREATE OR REPLACE FUNCTION public.save_ietxn(
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
	userid integer,
	_description character varying DEFAULT NULL::character varying)
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
DECLARE nYear double precision;
DECLARE _txndate date;
DECLARE _refundorpaiddate date;
begin
	SELECT EXTRACT(YEAR FROM txndate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_txndate := null;
	else
		_txndate := txndate;
	end if;
	
	SELECT EXTRACT(YEAR FROM refundorpaiddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_refundorpaiddate := null;
	else
		_refundorpaiddate := refundorpaiddate;
	end if;
	
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
			admin_notes, fef_status, disbursement_id, description)
			VALUES (nextval('transaction_id_seq'), txnVersionId, _filerId,
					txnTypeId, txnAmount, _txnDate,
					newContactId, electionCycleId, refundorpaidflag,
					_refundorpaiddate, refundOrPaidAmount, refundReason,
					_parentTxnId, notes, contributionTypeId,
					monetaryTypeId, postElectionExemptFlag, txnCategoryId,
					txnPurpose, fairElectionFundFlag, electioneeringCommFlag,
					IEFlag, nonDonorFundFlag, nonDonorSource,
					nonDonorAmount, methodOfCommunication, IETargetType,
					positionDesc, ballotIssueId, ballotIssueDesc,
					candidateName, officeSought, district,
					adminNotes, fefStatus, disbursementId, _description);

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

ALTER FUNCTION public.save_ietxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)
    OWNER TO devadmin;


-- FUNCTION: public.save_unpaidobligationtxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)

-- DROP FUNCTION public.save_unpaidobligationtxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying);

CREATE OR REPLACE FUNCTION public.save_unpaidobligationtxn(
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
	userid integer,
	_description character varying DEFAULT NULL::character varying)
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
DECLARE nYear double precision;
DECLARE _txndate date;
DECLARE _refundorpaiddate date;
begin
	SELECT EXTRACT(YEAR FROM txndate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_txndate := null;
	else
		_txndate := txndate;
	end if;
	
	SELECT EXTRACT(YEAR FROM refundorpaiddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		_refundorpaiddate := null;
	else
		_refundorpaiddate := refundorpaiddate;
	end if;
	
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
			admin_notes, fef_status, disbursement_id, description)
			VALUES (nextval('transaction_id_seq'), txnVersionId, _filerId,
					txnTypeId, txnAmount, _txnDate,
					newContactId, electionCycleId, refundorpaidflag,
					_refundorpaiddate, refundOrPaidAmount, refundReason,
					_parentTxnId, notes, contributionTypeId,
					monetaryTypeId, postElectionExemptFlag, txnCategoryId,
					txnPurpose, fairElectionFundFlag, electioneeringCommFlag,
					IEFlag, nonDonorFundFlag, nonDonorSource,
					nonDonorAmount, methodOfCommunication, IETargetType,
					positionDesc, ballotIssueId, ballotIssueDesc,
					candidateName, officeSought, district,
					adminNotes, fefStatus, disbursementId, _description);

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

ALTER FUNCTION public.save_unpaidobligationtxn(integer, integer, integer, character varying, character varying, double precision, date, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, date, double precision, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, boolean, boolean, boolean, character varying, double precision, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, integer, character varying)
    OWNER TO devadmin;

 --------------------------------------Functions-------------------------------------------------------------------------------
 