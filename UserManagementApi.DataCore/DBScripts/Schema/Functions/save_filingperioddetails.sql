

CREATE OR REPLACE FUNCTION public.save_filingperioddetails(
	_filingperiodid integer,
	_filingperiodname character varying,
	_description character varying,
	_startdate date,
	_enddate date,
	_duedate timestamp without time zone,
	_electioncycleid integer,
	_itemthreshold numeric,
	_filertypeids text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filingperiod int = 0;
arr_split_data  text[];
r character varying; 
begin
   if(_filingperiodid)>0 
	THEN
	---  Filing Period
	update public.filing_period set "name" = _filingperiodname,
	"desc" = _description,
	start_date = _startdate,
	end_date = _enddate,
	due_date = _duedate,
	election_cycle_id = _electioncycleid,
	item_threshold = _itemthreshold,
	 updated_by='Denver',  updated_on=NOW()
	where filing_period_id =_filingperiodid;
	
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
	update  public.filing_period_filer_type_mapping set status_code='DELETED'
 	where filing_period_id = _filingperiodid ;
	FOREACH r IN array arr_split_data LOOP
	IF EXISTS (SELECT filing_period_filer_type_mapping_id FROM public.filing_period_filer_type_mapping where filing_period_id=_filingperiodid and filer_type_id=r) THEN
	
	
	update public.filing_period_filer_type_mapping set 
	status_code='ACTIVE',
	updated_by='Denver',
	updated_on=NOW() 
	where filing_period_id=_filingperiodid and filer_type_id=r;
	
	
	else
	
	INSERT INTO public.filing_period_filer_type_mapping(filing_period_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_filingperiodid, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
	End IF;
	
	END LOOP;
	---  Filing Period Filer TYpe
	
	return _filingperiodid;
	
		else
		
	INSERT INTO public.filing_period("name", "desc",
    start_date,
    end_date ,
    due_date,
    election_cycle_id,
	item_threshold,
	status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (_filingperiodname, _description, _startdate, _enddate, _duedate, _electioncycleid, _itemthreshold, 'ACTIVE',
	'Denver',NOW(),'Denver',NOW());
	
	filingperiod = (SELECT LASTVAL());
			
	select into arr_split_data regexp_split_to_array(_filertypeids,',');
			
	FOREACH r IN array arr_split_data LOOP
	INSERT INTO public.filing_period_filer_type_mapping(filing_period_id,filer_type_id,status_code,
    created_by,
    created_at,
    updated_by,
    updated_on)
	VALUES (filingperiod, r, 'ACTIVE',
			'Denver',
			NOW(),'Denver',NOW());
			
END LOOP;

return	filingperiod;
	end if;

end
$BODY$;

ALTER FUNCTION public.save_filingperioddetails(integer, character varying, character varying, date, date, timestamp without time zone, integer, numeric, text)
    OWNER TO devadmin;
