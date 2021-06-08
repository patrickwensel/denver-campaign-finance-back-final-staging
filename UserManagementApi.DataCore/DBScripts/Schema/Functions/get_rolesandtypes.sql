-- FUNCTION: public.get_rolesandtypes(integer)

-- DROP FUNCTION public.get_rolesandtypes(integer);

CREATE OR REPLACE FUNCTION public.get_rolesandtypes(
	_userid integer)
    RETURNS TABLE(roleid integer, role character varying, entityid integer, entitytype character varying, entityname character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select  
		r.id,
		r.role,
		f.entity_id,
		f.entity_type,
		CASE 
		WHEN (f.entity_id = cm.committee_id AND f.entity_type = 'C') THEN cm.name 
		WHEN (f.entity_id = lb.lobbysit_id AND f.entity_type = 'L') THEN concat(c.first_name,' ',c.last_name) END AS usertypename
		from public.contact c 
LEFT JOIN public.user_account ua ON c.contact_id = ua.contact_id
LEFT JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id
LEFT JOIN public.role r ON crm.role_type_id = r.id 
LEFT JOIN public.filer f ON crm.filer_id = f.filer_id
LEFT JOIN public.committee cm ON cm.committee_id = f.entity_id 
LEFT JOIN public.lobbyist lb ON lb.lobbysit_id = f.entity_id 
WHERE c.contact_id = _userid
	AND upper(coalesce(c.status_code,'ACTIVE')) = 'ACTIVE'
	 and crm.status_code='ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_rolesandtypes(integer)
    OWNER TO devadmin;
