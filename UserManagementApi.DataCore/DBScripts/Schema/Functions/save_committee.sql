CREATE OR REPLACE FUNCTION public.save_committee(
	_name character varying,
	_committeetypeid character varying,
	_officesoughtid character varying,
	_district character varying,
	_electioncycleid integer,
	_committeewebsite character varying,
	_bankname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_statecode character varying,
	_zip character varying,
	_registrationstatus character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
if (_committeeid) > 0 then
 update public."committee" set "name"=_name, typeid=_committeetypeid, office_sought_id=_officesoughtid,
district=_district, election_cycle_id=_electioncycleid,  "campaign_website" = _committeewebsite,
bank_name=_bankname, bank_address1=_address1, bank_address2=_address2, bank_city = _city, bank_state_code = _statecode,bank_zip =_zip,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("name", "typeid", "office_sought_id", "district", "election_cycle_id", 
								 "campaign_website", "bank_name", "bank_address1" , "bank_address2", "bank_city", 
								 "bank_state_code", "bank_zip", "registration_status", "created_by", "created_at", 
								 "updated_by", "updated_on", "status_code")
 values(_name, _committeetypeid, _officesoughtid, _district, _electioncycleid, _committeewebsite, _bankname, _address1, _address2, _city, _statecode, _zip, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp, 'NEW');
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_committee(character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO qaadmin;
