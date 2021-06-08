CREATE OR REPLACE FUNCTION public.save_pacorsmalldonorcommittee(
	_committeename character varying,
	_committeetypeid character varying,
	_purpose character varying,
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
 update public."committee" set "name"=_committeename, typeid=_committeetypeid, purpose=_purpose,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("name", "typeid", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_committeename, _committeetypeid, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;
end
$BODY$;

ALTER FUNCTION public.save_pacorsmalldonorcommittee(character varying, character varying, character varying, integer)
    OWNER TO qaadmin;
