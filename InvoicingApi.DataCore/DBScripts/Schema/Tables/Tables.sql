CREATE TABLE public.electioncycle
(
    id serial  NOT NULL,
    title character varying(1000) NOT NULL,
    description character varying(1000) NOT NULL,
	electiontypeid integer,
    startdate date,
    enddate date,
    electiondate date,
    district character varying(1000) NOT NULL,
    iestartdate date,
    ieenddate date,
	status integer,
	created_by character varying(1000) NOT NULL,
    created_on date,
	updated_by character varying(1000) NOT NULL,
    updated_on date,
    CONSTRAINT electioncycle_pkey PRIMARY KEY (id)
)


ALTER TABLE public.electioncycle
    OWNER to devadmin;

-------------------------------------------

CREATE TABLE public.electioncycleoffices
(
    id serial  NOT NULL,
    electioncycleid integer NOT NULL,
	officeid integer NOT NULL,
	created_by character varying(1000) NOT NULL,
    created_on date,
	updated_by character varying(1000) NOT NULL,
    updated_on date,
    CONSTRAINT electioncycleoffices_pkey PRIMARY KEY (id)
)


ALTER TABLE public.electioncycleoffices
    OWNER to devadmin;
------------------------------------------------------


CREATE TABLE public.filingperiod
(
    id serial  NOT NULL,
    title character varying(1000) NOT NULL,
    description character varying(1000) NOT NULL,
	electioncycleid integer,
    startdate date,
    enddate date,
    duedate date,
	created_by character varying(1000) NOT NULL,
    created_on date,
	updated_by character varying(1000) NOT NULL,
    updated_on date,
    CONSTRAINT filingperiod_pkey PRIMARY KEY (id)
)


ALTER TABLE public.filingperiod
    OWNER to devadmin;


------------------------------------

CREATE TABLE public.filingperiodfilerTypes
(
    id serial  NOT NULL,
    filingperiodid integer NOT NULL,
	filiertypeid integer NOT NULL,
	created_by character varying(1000) NOT NULL,
    created_on date,
	updated_by character varying(1000) NOT NULL,
    updated_on date,
    CONSTRAINT filingperiodfilerTypes_pkey PRIMARY KEY (id)
)


ALTER TABLE public.filingperiodfilerTypes
    OWNER to devadmin;

------------------------------------

CREATE TABLE public.events
(
    id serial  NOT NULL,
    title character varying(1000) NOT NULL,
    description character varying(1000) NOT NULL,
    submitteddatetime date time,
    bumbfilingduedate bool,
	created_by character varying(1000) NOT NULL,
    created_on date,
	updated_by character varying(1000) NOT NULL,
    updated_on date,
    CONSTRAINT events_pkey PRIMARY KEY (id)
)


ALTER TABLE public.events
    OWNER to devadmin;

--------------------------------------

CREATE TABLE public.eventfilerTypes
(
    id serial  NOT NULL,
    eventid integer NOT NULL,
	filiertypeid integer NOT NULL,
	created_by character varying(1000) NOT NULL,
    created_on date,
	updated_by character varying(1000) NOT NULL,
    updated_on date,
    CONSTRAINT eventfilerTypes_pkey PRIMARY KEY (id)
)


ALTER TABLE public.eventfilerTypes
    OWNER to devadmin;

------------------------------------