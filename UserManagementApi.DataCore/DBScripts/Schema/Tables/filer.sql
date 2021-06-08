
﻿CREATE TABLE public.filer
(
    filer_id serial,
    entity_type character varying(150) NULL,
	entity_id integer,
    categoryid integer NULL,
    filer_status character varying(10) NULL,
	status_code character varying(10) NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT filer_pkey PRIMARY KEY (filer_id)
)
