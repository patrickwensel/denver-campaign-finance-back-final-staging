CREATE OR REPLACE FUNCTION public.save_candidatecontact(
	_contacttype character varying,
	_firstname character varying,
	_lastname character varying,
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
SELECT candidate_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
if (_committeeid) > 0 then
 update public."contact" set "contact_type"=_contacttype, first_name=_firstname, last_name=_lastname,
filerid=_filerid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "first_name", "last_name", "filerid", "status_code", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _firstname, _lastname, _filerid, _statuscode, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_candidatecontact(character varying, character varying, character varying, integer, character varying, integer)
    OWNER TO devadmin;
