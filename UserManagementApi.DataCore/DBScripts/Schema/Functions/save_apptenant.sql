-- FUNCTION: public.save_apptenant(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_apptenant(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_apptenant(
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

	
	INSERT INTO public.app_setting(
	app_name,
    theme_name,
    logo_url,
    fav_icon,
    banner_image_url,
    seal_image_url,
    clerk_seal_image_url,
    header_image_url,
    footer_image_url,
    clerk_sign_image_url,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (appname,
	themename,
	logourl,
	favicon,
	bannerimageurl,
	sealimageurl,
	clerksealimageurl,
    headerimageurl,
    footerimageurl,
    clerksignimageurl,
	'Denver',
	NOW(),
	'Denver',
	NOW());
			
	return (SELECT LASTVAL());
		--return 1; -- inserted fail
	

end
$BODY$;

ALTER FUNCTION public.save_apptenant(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
