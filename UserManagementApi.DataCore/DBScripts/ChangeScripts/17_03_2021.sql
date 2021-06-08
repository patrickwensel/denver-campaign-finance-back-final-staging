--------------------------Tables----------------------------------------------------
CREATE TABLE public.refreshtoken
(
    id serial NOT NULL,
    tokenval character varying(1000),
    jwt_id character varying(1000),
    created_date date,
    expired_date date,
    is_used boolean,
    in_validated boolean,
    user_id character varying(100),
    created_by character varying(1000),
    created_on date,
    updated_by character varying(1000)  NOT NULL,
    updated_on date,
    CONSTRAINT refreshtoken_pkey PRIMARY KEY (id)
)
--------------------------Tables----------------------------------------------------
--------------------------Functions----------------------------------------------------
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


	--------------------------------------------

	-- FUNCTION: public.update_refreshtoken(boolean, character varying)

-- DROP FUNCTION public.update_refreshtoken(boolean, character varying);

CREATE OR REPLACE FUNCTION public.update_refreshtoken(
	_isused boolean,
	_token character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
  
	UPDATE public.refreshtoken 
		SET is_used = _isused 
	WHERE tokenval = _token;
	
	return 1;
 end
$BODY$;

ALTER FUNCTION public.update_refreshtoken(boolean, character varying)
    OWNER TO devadmin;


	----------------------------------------
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


--------------------------Functions----------------------------------------------------
--------------------------Triggers----------------------------------------------------

--------------------------Triggers----------------------------------------------------