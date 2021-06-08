-- FUNCTION: public.save_finesettingdetails(integer, character varying, numeric, integer, character varying, text)

-- DROP FUNCTION public.save_finesettingdetails(integer, character varying, numeric, integer, character varying, text);

CREATE OR REPLACE FUNCTION public.save_finesettingdetails(
	_fineid integer,
	_finename character varying,
	_amount numeric,
	_graceperiod integer,
	_frequency character varying,
	_filertypeids text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE fineid int = 0;
arr_split_data  text[];
r character varying; 
begin
   if(_fineid)>0 
	THEN
	---  Fine setting
	update public.fine_settings set "name" = _finename,
	amount = _amount,
	grace_period = _graceperiod,
	frequency = _frequency,
	filertypeids = _filertypeids,
	 updated_by='Denver',  updated_on=NOW()
	where fine_id =_fineid;
	
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
	update  public.fine_filer_type_mapping set status_code='DELETED'
 	where fine_id = _fineid ;
	FOREACH r IN array arr_split_data LOOP
	IF EXISTS (SELECT fine_filer_map_id FROM public.fine_filer_type_mapping where fine_id=_fineid and filer_type_id=r) THEN
	
	
	update public.fine_filer_type_mapping set 
	status_code='ACTIVE',
	updated_by='Denver',
	updated_on=NOW() 
	where fine_id=_fineid and filer_type_id=r;
	
	
	else
	
	INSERT INTO public.fine_filer_type_mapping(fine_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_fineid, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
	End IF;
	
	END LOOP;
	---  Filing Period Filer TYpe
	
	return _fineid;
	
		else
		
	INSERT INTO public.fine_settings("name", amount,
    grace_period,
    frequency ,
    filertypeids,
	status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_finename, _amount, _graceperiod, _frequency, _filertypeids, 'ACTIVE',
	'Denver',NOW(),'Denver',NOW());
	
	fineid = (SELECT LASTVAL());
			
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
			
	FOREACH r IN array arr_split_data LOOP
	INSERT INTO public.fine_filer_type_mapping(fine_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (fineid, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
			
END LOOP;

return	fineid;
	end if;

end
$BODY$;

ALTER FUNCTION public.save_finesettingdetails(integer, character varying, numeric, integer, character varying, text)
    OWNER TO devadmin;
