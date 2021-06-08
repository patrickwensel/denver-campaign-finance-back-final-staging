-- FUNCTION: public.get_userrefreshtokendetailbytoken(character varying)

-- DROP FUNCTION public.get_userrefreshtokendetailbytoken(character varying);

CREATE OR REPLACE FUNCTION public.get_userrefreshtokendetailbytoken(
	_token character varying)
    RETURNS TABLE(token character varying, jwtid character varying, createddate date, expireddate date, isused boolean, invalidated boolean, userid character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select 
		tokenval, 
		jwt_id, 
		created_date,
		expired_date,
		is_used,
		in_validated,
		user_id
		from public.refreshtoken WHERE tokenval = _token;
		
 end
$BODY$;

ALTER FUNCTION public.get_userrefreshtokendetailbytoken(character varying)
    OWNER TO devadmin;
