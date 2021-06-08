----------------------------------------tables-----------------------------------------
-- Table: public.contact_role_mapping

-- DROP TABLE public.contact_role_mapping;

CREATE TABLE public.contact_role_mapping
(
    contact_role_mapping_id integer NOT NULL DEFAULT nextval('contact_role_mapping_contact_role_mapping_id_seq'::regclass),
    user_id integer,
    contact_id integer,
    filer_id integer,
    role_type_id integer,
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    status_code character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT contact_role_mapping_pkey PRIMARY KEY (contact_role_mapping_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.contact_role_mapping
    OWNER to devadmin;
    ----------------------------------------------------------------------------------------------------
    -- FUNCTION: public.save_adduserdetails(character varying)

-- DROP FUNCTION public.save_adduserdetails(character varying);

CREATE OR REPLACE FUNCTION public.save_adduserdetails(
	_emailid character varying,
    _Entity_id integer,
	_Entity_Type character varying
)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filid integer;
declare con_id integer;
declare emailid int = 0;
declare roleIds integer;
begin
if  EXISTS (SELECT 1 FROM contact
				  	WHERE email = _emailId) then
SELECT contact_id into con_id from contact where email = _emailId;
SELECT filer_id INTO filid FROM public.filer where entity_id = _Entity_id and entity_type=_Entity_Type;
SELECT id INTO roleIds FROM public.role WHERE role = 'Invited';

 insert into public."email_messages" (receiver_id, subject, "message",sent_on,is_user_action_required, created_by, created_at)
 values(_emailId,'User Access Permission', 'To be Decided',localtimestamp,true, 'Denver', localtimestamp);
  emailid  = (SELECT LASTVAL());	
  
insert into public."contact_role_mapping" (contact_id, filer_id,role_type_id,created_by,created_at,status_code)
 values(con_id, filid,roleIds,'Denver', localtimestamp,'ACTIVE');

 insert into public."user_join_request" ("request_type", "filer_id", "user_email", "user_contact_id", "inviter_contact_id","email_msg_id" ,"created_by","created_at","status_code")
 values('I', filid, _emailId, con_id, 0,emailid, 'Denver', localtimestamp,'ACTIVE');
  return (SELECT LASTVAL());
  
		return 0; -- inserted fail
else

SELECT filer_id INTO filid FROM public.filer where entity_id = _Entity_id and entity_type=_Entity_Type;
SELECT id INTO roleIds FROM public.role WHERE role = 'Inviter';

 insert into public."email_messages" (email_type_id, receiver_id, subject, "message",sent_on,is_user_action_required, created_by, created_at)
 values(3, _emailId,'User Access Permission', 'To be Decided',localtimestamp,true, 'Denver', localtimestamp);
  emailid  = (SELECT LASTVAL());	
  


 insert into public."user_join_request" ("request_type", "filer_id", "user_email","email_msg_id" ,"created_by","created_at","status_code")
 values('I', filid, _emailId,emailid, 'Denver', localtimestamp,'ACTIVE');
  return (SELECT LASTVAL());

return 0; -- inserted fail

end if;
end
$BODY$;
-----------------------------------------------------------------------------

ALTER TABLE "contact_role_mapping" ADD status_code character varying (100);

