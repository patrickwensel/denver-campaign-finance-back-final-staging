-- FUNCTION: public.get_userentities(integer)

-- DROP FUNCTION public.get_signaturedetail(integer);

CREATE OR REPLACE FUNCTION public.get_signaturedetail(
	lobbyistid integer)
    RETURNS TABLE(firstName character varying, lastName character varying, email character varying, signature character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT sign_first_name,
	   sign_last_name, 
	   sign_email, 
	   sign_image_url
	FROM public.lobbyist
		WHERE lobbysit_id = lobbyistid;
 end
$BODY$;

ALTER FUNCTION public.get_signaturedetail(integer)
    OWNER TO devadmin;
