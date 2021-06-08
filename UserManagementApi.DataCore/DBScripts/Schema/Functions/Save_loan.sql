-- FUNCTION: public.save_loan(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, integer, character varying, integer, character varying, integer, timestamp without time zone, integer, character varying, integer, character varying, timestamp without time zone, boolean, integer)

-- DROP FUNCTION public.save_loan(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, integer, character varying, integer, character varying, integer, timestamp without time zone, integer, character varying, integer, character varying, timestamp without time zone, boolean, integer);

CREATE OR REPLACE FUNCTION public.save_loan(
	_contact_id integer,
	_firstname character varying,
	_lastname character varying,
	_addressre1 character varying,
	_addressre2 character varying,
	_city character varying,
	_statecode character varying,
	_zipcode integer,
	_occupation character varying,
	_employee character varying,
	_voterid integer,
	_entity_type character varying,
	_entity_id integer,
	_contact_type character varying,
	_loantype integer,
	_date_loan timestamp without time zone,
	_amount integer,
	_name_of_guarantor character varying,
	_amount_guaranteed integer,
	_interest_teams character varying,
	_duedate timestamp without time zone,
	_contactupdatedflag boolean,
	_loanid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare roleIds integer;
DECLARE _filerId integer;
DECLARE newcontactid int = 0;
declare newloanId int =0;

begin
			  
	SELECT filer_id INTO _filerId 
	FROM public.filer 
		WHERE entity_id = _entity_id 
			AND entity_type = _entity_type;
			
	if _contact_id = 0 then
	begin
		INSERT INTO public.contact(contact_type,first_name,last_name,org_name,address1,address2,
    city,
	state_code,
    zip,
    voter_id,
    occupation,							   
    status_code,
    created_by,
    created_at,
    updated_by,
    updated_on,version_id)
	VALUES (_contact_type, _firstname,_lastname,_employee,_addressre1,_addressre2,_city,
			_statecode,_zipcode,_voterid,_occupation,'ACTIVE','Denver',NOW(),'Denver',NOW(),null);			
			newcontactid  = (SELECT LASTVAL());	
					
		-- Get the current value from contact table
		SELECT currval('contact_contact_id_seq') INTO newcontactid;
	end;	
	else
		if contactupdatedflag = true then
		begin
			INSERT INTO public.contact(contact_type,first_name,last_name,org_name,address1,address2,
    city,
	state_code,
    zip,
    voter_id,
    occupation,							   
    status_code,
    created_by,
    created_at,
    updated_by,
    updated_on,version_id)
	VALUES (_contact_type, _firstname,_lastname,_employee,_addressre1,_addressre2,_city,
			_statecode,_zipcode,_voterid,_occupation,'ACTIVE','Denver',NOW(),'Denver',NOW(),null);			
			newcontactid  = (SELECT LASTVAL());	
			-- Get the current value from contact table
			SELECT currval('contact_contact_id_seq') INTO newcontactid;

		-- Update the version_id to contact table
	       UPDATE public.contact
				SET version_id = newcontactid
			WHERE contact_id = _contact_id;
		end;
		else
			newcontactid = _contact_id;
		end if;	
	end if;	
	-- Get Role Type from Role Table
SELECT id INTO roleIds FROM public.role WHERE role = 'Lender';
Insert into contact_role_mapping (contact_id, filer_id,role_type_id,created_by,created_at,status_code)
 values(newcontactid, _filerId,roleIds,'Denver', localtimestamp,'ACTIVE');
	
	
	if _loanId = 0 then
	begin
		-- 	Insert into contact table
		Insert into loan(loan_id, filer_id,loan_type,tenderid,loan_amount,loan_date,guarantor_name,guaranteed_amount,interest_rate,due_date,created_by,created_at)
 values(nextval('loan_id_seq'),filid,_loantype,_contact_id,_amount,_date_loan,_name_of_guarantor,_amount_guaranteed,_interest_teams,_duedate,'Denver', localtimestamp);
 return (SELECT LASTVAL());	

		-- Get the current value from contact table
		SELECT currval('loan_id_seq') INTO newloanId;
	end;
	end if;
	
	if _loanId = 0 then
		_loanId := newloanId;
	end if;
	
	return _loanId;

 end
$BODY$;

ALTER FUNCTION public.save_loan(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, integer, character varying, integer, character varying, integer, timestamp without time zone, integer, character varying, integer, character varying, timestamp without time zone, boolean, integer)
    OWNER TO devadmin;
