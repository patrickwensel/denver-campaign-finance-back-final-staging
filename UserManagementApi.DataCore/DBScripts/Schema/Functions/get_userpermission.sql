-- FUNCTION: public.get_userpermission()

-- DROP FUNCTION public.get_userpermission();

CREATE OR REPLACE FUNCTION public.get_userpermission(
	)
    RETURNS TABLE(ind integer, modulename character varying, tenantid integer, candidate integer, treasusrer integer, committeeofficer integer, primarylobbylist integer, lobbylist integer, official integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT 
	contl.ind,
	contl.Modulename,
	contl.TenantId,
	contl.Candidate,
	contl.treasusrer,
    contl.CommitteeOfficer,
    contl.PrimaryLobbyList,
    contl.LobbyList,
    contl.Official
	FROM public.user_role_permission contl;
end
$BODY$;

ALTER FUNCTION public.get_userpermission()
    OWNER TO devadmin;
