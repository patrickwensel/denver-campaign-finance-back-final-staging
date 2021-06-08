-- FUNCTION: public.get_currentactiveusers(integer, integer, text, text, date, date, date, date)

-- DROP FUNCTION public.get_currentactiveusers(integer, integer, text, text, date, date, date, date);

CREATE OR REPLACE FUNCTION public.get_currentactiveusers(
	_filerid integer,
	_userid integer,
	_filertype text,
	_status text,
	_lastactivestartdate date,
	_lastactiveenddate date,
	_createdstartdate date,
	_createdenddate date)
    RETURNS TABLE(contactid integer, userid integer, username text, createdstartdate date, lastactivestartdate date, status character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filerIdVal int = 0;
DECLARE filertypeids text;
DECLARE userIdVal int = 0;
begin

return query
select * from(select c.contact_id,
ua.user_id,
c.first_name || ' ' || c.middle_name || ' ' || c.last_name as username,
c.created_at,
ua.last_seen,
tlup.name
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id
inner join user_account ua on ua.user_id = crm.user_id
inner join type_lookups tlup on tlup.type_id = ua.status and tlup.lookup_type_code='USER-STATUS') as t
where user_id = case when _userid = 0 then user_id else _userid end
and last_seen between _lastactivestartdate and _lastactiveenddate
and created_at between _createdstartdate and _createdenddate

;
end
$BODY$;

ALTER FUNCTION public.get_currentactiveusers(integer, integer, text, text, date, date, date, date)
    OWNER TO devadmin;
