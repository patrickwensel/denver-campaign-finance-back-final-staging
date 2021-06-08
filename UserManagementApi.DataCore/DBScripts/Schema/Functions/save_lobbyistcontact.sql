CREATE OR REPLACE FUNCTION public.save_lobbyistcontact(
	_contacttype character varying,
	_orgname character varying,
	_firstname character varying,
	_lastname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_state character varying,
	_zip character varying,
	_phone character varying,
	_email character varying,
	_lobbyistid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE contactid integer;
begin
SELECT filer_contact_id INTO contactid FROM public.lobbyist where lobbysit_id = _lobbyistid;
if (_lobbyistid) > 0 then

  update public."contact" set contact_type=_contacttype, org_name=_orgname, first_name=_firstname, last_name=_lastname,
address1=_address1, address2=_address2,  "city" = _city,
state_code=_state, zip=_zip, phone = _phone, email = _email,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "org_name", "first_name", "last_name", "address1", "address2", "city", "state_code", "zip" , "phone", "email", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_contacttype, _orgname, _firstname, _lastname, _address1, _address2, _city, _state, _zip, _phone, _email, 'Denver', localtimestamp, 'Denver', localtimestamp, 'Active');
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_lobbyistcontact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO devadmin;