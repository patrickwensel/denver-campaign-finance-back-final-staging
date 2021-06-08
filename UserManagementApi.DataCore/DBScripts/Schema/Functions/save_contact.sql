-- FUNCTION: public.save_contact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_contact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_contact(
	_contacttype character varying,
	_firstname character varying,
	_lastname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_state character varying,
	_zip character varying,
	_phone character varying,
	_email character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."contact" ("contact_type", "first_name", "last_name", "address1", "address2", "city", "state_code", "zip" , "phone", "email", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_contacttype, _firstname, _lastname, _address1, _address2, _city, _state, _zip, _phone, _email, 'Denver', localtimestamp, 'Denver', localtimestamp, 'Active');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
