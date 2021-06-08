------------------------------------------Functions----------------------------------------

-- FUNCTION: public.save_lobbyist(character varying, character varying, integer, integer)

-- DROP FUNCTION public.save_lobbyist(character varying, character varying, integer, integer);

CREATE OR REPLACE FUNCTION public.save_lobbyist(
	_year character varying,
	_type character varying,
	_primarycontactid integer,
	_filercontactid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."lobbyist" ("year", "type", "primary_contact_id", "filer_contact_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_year, _type, _primarycontactid, _filercontactid, 'Denver', localtimestamp, 'Denver', localtimestamp, 'Active');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_lobbyist(character varying, character varying, integer, integer)
    OWNER TO devadmin;




    ----------------------------------------Functions------------------------------------