
CREATE OR REPLACE FUNCTION public.save_maketreasurer(
	_contactid integer,
	_entityid integer,
	_entitytype character varying,
	_userid integer)
   RETURNS TABLE(emailmsgid integer,status text)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare _emailid character varying;
DECLARE filerid integer;
declare filercontactid integer;
declare filercontactemailid character varying;
declare emailmsgid int = 0;
declare expirydate date;
declare currentdate date;

begin	

--- Get Contact ID
SELECT email into _emailid from contact where contact_id = _contactid LIMIT 1;
--- Get Filer ID
SELECT filer_id INTO filerid FROM public.filer where entity_id = _entityid and entity_type=_entitytype LIMIT 1;
--- Get Filer Contact ID
SELECT contact_id INTO filercontactid FROM public.contact_role_mapping where filer_id = filerid and user_id=_userid LIMIT 1;
-- Get Expiry Date
expirydate =(SELECT DATE((SELECT NOW() + INTERVAL '2 DAY')));

currentdate = (SELECT DATE((SELECT NOW() + INTERVAL '0 DAY')));
	
	

if  EXISTS (
SELECT 1 FROM public."email_messages"  emsg 
inner join public.user_join_request ureq on emsg.email_message_id= ureq.email_msg_id
WHERE ureq.filer_id = filerid and emsg.email_type_id='MAKE-T' and emsg.expiry_datetime < currentdate and ureq.status_code='ACTIVE') then 

		insert into public."email_messages" ( email_type_id,receiver_id, subject, "message",sent_on,is_user_action_required, expiry_datetime, created_by, created_at)
		values( 'MAKE-T',_emailid,'User Access Permission', 'To be Decided',localtimestamp,true,expirydate, 'Denver', localtimestamp);

		emailmsgid = (SELECT LASTVAL());

		INSERT INTO public.user_join_request(request_type,
		filer_id,
		user_email,
		user_contact_id,
		inviter_contact_id,
		email_msg_id,
		user_join_note,created_by,created_at,status_code)
		VALUES ('I',filerid,_emailid,_contactid,filercontactid,emailmsgid,'','Denver',NOW(),'ACTIVE');
		
		return query
		select 	 email_message_id,'Invitation Sent' as status 
		from  public."email_messages" where email_message_id =emailmsgid;
				 

else
  
SELECT "email_message_id" into emailmsgid FROM public."email_messages"  emsg 
inner join public.user_join_request ureq on emsg.email_message_id= ureq.email_msg_id
WHERE ureq.filer_id = filerid and emsg.email_type_id='MAKE-T' and emsg.expiry_datetime < currentdate LIMIT 1;

return query
select 	 email_message_id,'Invitation Aleady Exist for the Selected User' as status 
from  public."email_messages" where email_message_id =emailmsgid;
			

end if;

end
$BODY$;

