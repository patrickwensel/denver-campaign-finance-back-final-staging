-- FUNCTION: public.update_apptenant(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.update_apptenant(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.update_apptenant(
	appid integer,
	appname character varying,
	themename character varying,
	logourl character varying,
	favicon character varying,
	bannerimageurl character varying,
	sealimageurl character varying,
	clerksealimageurl character varying,
	headerimageurl character varying,
	footerimageurl character varying,
	clerksignimageurl character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin

	
	update  public.app_setting set
	app_name = appname,
    theme_name = themename,
    logo_url = logourl ,
    fav_icon = favicon,
    banner_image_url = bannerimageurl,
    seal_image_url = sealimageurl,
    clerk_seal_image_url = clerksealimageurl,
    header_image_url = headerimageurl,
    footer_image_url = footerimageurl,
    clerk_sign_image_url = clerksignimageurl,
    updated_by = 'Denver',
    updated_on = NOW() where  app_id= appid;
	
			
	
		return 1; -- inserted fail
	

end
$BODY$;

ALTER FUNCTION public.update_apptenant(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
