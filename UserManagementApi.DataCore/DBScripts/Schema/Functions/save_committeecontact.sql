CREATE OR REPLACE FUNCTION public.save_committeecontact(
	_contacttype character varying,
	_orgname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_statecode character varying,
	_zip character varying,
	_filerid integer,
	_statuscode character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE contactid integer;
begin
SELECT committee_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
if (_committeeid) > 0 then
 update public."contact" set "contact_type"=_contacttype, org_name=_orgname, address1=_address1,
address2=_address2, city=_city, state_code=_statecode, zip=_zip, filerid=_filerid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "org_name", "address1", "address2", "city", "state_code", "zip", "filerid", "status_code", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _orgname, _address1, _address2, _city, _statecode, _zip, _filerid, _statuscode, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_committeecontact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, integer)
    OWNER TO devadmin;
