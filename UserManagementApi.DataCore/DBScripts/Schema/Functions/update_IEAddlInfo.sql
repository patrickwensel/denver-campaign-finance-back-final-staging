
-- DROP FUNCTION public.update_IEAddlInfo(integer, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.update_IEAddlInfo(
	contactId integer,
	filerType character varying,
	occupationDesc character varying,
	employer character varying,
	organisationName character varying,
	userId character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	if filerType = 'I' then
		UPDATE public.contact
			SET contact_type = filerType,
				org_name = employer,
				occupation = occupationDesc
		WHERE contact_id = contactId;
	else
		UPDATE public.contact
			SET contact_type = filerType,
				org_name = organisationName,
				occupation = null
		WHERE contact_id = contactId;
	end if;
 
  return contactId;

end
$BODY$;

ALTER FUNCTION public.update_IEAddlInfo(integer, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;

