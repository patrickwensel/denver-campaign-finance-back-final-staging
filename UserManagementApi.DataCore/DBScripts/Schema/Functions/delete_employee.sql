-- FUNCTION: public.delete_employee(integer, character varying)

-- DROP FUNCTION public.delete_employee(integer, character varying);

CREATE OR REPLACE FUNCTION public.delete_employee(
	contactid integer,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	
	UPDATE public.contact
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE contact_id = contactId;
	
	return contactId;
 end
$BODY$;

ALTER FUNCTION public.delete_employee(integer, character varying)
    OWNER TO devadmin;
