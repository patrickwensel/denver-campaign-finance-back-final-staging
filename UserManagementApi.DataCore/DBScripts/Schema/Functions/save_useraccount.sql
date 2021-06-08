-- FUNCTION: public.save_useraccount(character varying, integer, character varying, character varying)

-- DROP FUNCTION public.save_useraccount(character varying, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_useraccount(
	_password character varying,
	_contactid integer,
	_status character varying,
	_salt character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."user_account" ("contact_id", "password", "status", "salt", "created_by", "created_at", "updated_by", "updated_on")
 values(_contactid, _password, _status, _salt, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_useraccount(character varying, integer, character varying, character varying)
    OWNER TO devadmin;
