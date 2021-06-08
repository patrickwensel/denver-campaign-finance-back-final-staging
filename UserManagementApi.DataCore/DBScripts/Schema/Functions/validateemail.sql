-- FUNCTION: public.validateemail(character varying)

-- DROP FUNCTION public.validateemail(character varying);

CREATE OR REPLACE FUNCTION public.validateemail(
	useremailid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 IF EXISTS (SELECT email FROM public.contact where email=useremailid) THEN
  		 return 1;
		 ELSE
		  return 0;
 	 	END IF;

end
$BODY$;

ALTER FUNCTION public.validateemail(character varying)
    OWNER TO devadmin;
