-- FUNCTION: public.save_refreshtoken(character varying, character varying, date, date, boolean, boolean, character varying)

-- DROP FUNCTION public.save_refreshtoken(character varying, character varying, date, date, boolean, boolean, character varying);

CREATE OR REPLACE FUNCTION public.save_refreshtoken(
	_token character varying,
	_jwtid character varying,
	_createddate date,
	_expireddate date,
	_isused boolean,
	_invalidated boolean,
	_userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE refreshtokenId int = 0;
begin

	INSERT INTO public.refreshtoken(
		tokenval, jwt_id, 
		created_date, expired_date, is_used, 
		in_validated, user_id, created_by, created_on, 
		updated_by, updated_on)
	  VALUES ( _token, _jwtid, 
			  _createddate, _expireddate, _isused, 
			  _invalidated, _userid, 'Denver', localtimestamp, 
			  'Denver', localtimestamp);
			  
	
SELECT CURRVAL('refreshtoken_id_seq') INTO refreshtokenId;
	if found then 
	  	return refreshtokenId;
	else 
		return 0; 
	end if;
end
$BODY$;

ALTER FUNCTION public.save_refreshtoken(character varying, character varying, date, date, boolean, boolean, character varying)
    OWNER TO devadmin;
