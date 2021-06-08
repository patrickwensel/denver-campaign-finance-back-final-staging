-- FUNCTION: public.get_userdetail(character varying)

-- DROP FUNCTION public.get_userdetail(character varying);

CREATE OR REPLACE FUNCTION public.get_userdetail(
	useremailid character varying)
    RETURNS TABLE(userid integer,contactid integer, emailid character varying, pwd character varying, saltkey character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
        select      
		ua.user_id,
		ua.contact_id, 
		c.email,
		ua.password,
		ua.salt
		from public.contact c 
		INNER JOIN public.user_account ua ON c.contact_id = ua.contact_id
 		WHERE email = userEmailId;

		IF EXISTS (SELECT email FROM public.contact where email=userEmailId) THEN
  		 insert into public.sessionuser (emailid,userid) values(userEmailId,userEmailId);
 	 	END IF;		
 end
$BODY$;

ALTER FUNCTION public.get_userdetail(character varying)
    OWNER TO devadmin;