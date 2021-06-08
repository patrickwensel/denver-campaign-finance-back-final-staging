DROP FUNCTION public.save_committeeothercontact(character varying, character varying, character varying, character varying, character varying, integer, character varying, integer);

CREATE OR REPLACE FUNCTION public.save_committeeothercontact(
	_contacttype character varying,
	_phone character varying,
	_email character varying,
	_altphone character varying,
	_altemail character varying,
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
SELECT other_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
if (_committeeid) > 0 then
 update public."contact" set "contact_type"=_contacttype, phone=_phone, email=_email, altphone=_altphone, altemail=_altemail,
filerid=_filerid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "phone", "email", "altphone", "altemail", "filerid", "status_code", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _phone, _email, _altphone, _altemail, _filerid, _statuscode, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;
end
$BODY$;