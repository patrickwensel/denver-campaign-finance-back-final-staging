CREATE OR REPLACE FUNCTION public.update_committecontact(
	_committeecontactid integer,
	_candidatecontactid integer,
	_contactid integer,
	_committeeothercontactid integer,
	_committeeid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
update public."committee" set committee_contact_id=_committeecontactid, other_contact_id=_committeeothercontactid, 
treasurer_contact_id=_contactid, candidate_contact_id=_candidatecontactid,  created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 
 update public."contact" set filerid = _filerid where "contact_id" = _contactid;
 
  return _committeeid;
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.update_committecontact(integer, integer, integer, integer, integer, integer)
    OWNER TO devadmin;
