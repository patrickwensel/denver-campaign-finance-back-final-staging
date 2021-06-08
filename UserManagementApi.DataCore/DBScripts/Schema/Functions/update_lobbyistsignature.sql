CREATE OR REPLACE FUNCTION public.update_lobbyistsignature(
	_lobbyistid integer,
	_signfirstname character varying,
	_signlastname character varying,
	_signemail character varying,
	_signimageurl character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public."lobbyist" set "sign_first_name"=_signfirstname, 
 "sign_last_name" = _signlastname,
 "sign_email" = _signemail,
 "sign_image_url" = _signimageurl

 where "lobbysit_id" = _lobbyistid;
 return _lobbyistid;
end
$BODY$;