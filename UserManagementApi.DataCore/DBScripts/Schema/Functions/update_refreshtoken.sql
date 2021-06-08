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
