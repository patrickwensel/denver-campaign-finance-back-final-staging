-- FUNCTION: public.get_apptenant(integer)

-- DROP FUNCTION public.get_apptenant(integer);

CREATE OR REPLACE FUNCTION public.get_apptenant(
	_appid integer)
    RETURNS TABLE(appid integer, appname character varying, themename character varying, logourl character varying, favicon character varying, bannerimageurl character varying, sealimageurl character varying, clerksealimageurl character varying, headerimageurl character varying, footerimageurl character varying, clerksignimageurl character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT app.app_id,
	app.app_name,
	app.theme_name,
	app.logo_url,
	app.fav_icon,
	app.banner_image_url,
	app.seal_image_url,
	app.clerk_seal_image_url,
	app.header_image_url,
	app.footer_image_url,
	app.clerk_sign_image_url
	FROM public.app_setting app where app.app_id=_appid;
end
$BODY$;

ALTER FUNCTION public.get_apptenant(integer)
    OWNER TO devadmin;
