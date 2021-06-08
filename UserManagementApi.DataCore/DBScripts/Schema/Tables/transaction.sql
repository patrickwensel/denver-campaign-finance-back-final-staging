DROP TABLE public.transaction;

CREATE TABLE public.transaction
(
    transaction_id integer NOT NULL,
    txn_version_id integer NOT NULL,
    filer_id integer NOT NULL,
    txn_type_id character varying(15) COLLATE pg_catalog."default" NOT NULL,
    txn_amount double precision NOT NULL,
    txn_date date,
    contact_id integer NOT NULL,
    election_cycle_id integer,
    refund_or_paid_date date,
    refund_or_paid_amount double precision,
    refund_reason character varying(250) COLLATE pg_catalog."default",
    parent_transaction_id integer,
    notes character varying(250) COLLATE pg_catalog."default",
    contribution_type_id character varying(15) COLLATE pg_catalog."default",
    monetary_type_id character varying(15) COLLATE pg_catalog."default",
    post_election_exempt_flag boolean,
    txn_category_id character varying(15) COLLATE pg_catalog."default",
    txn_purpose character varying(250) COLLATE pg_catalog."default",
    fair_election_fund_flag boolean,
    electioneering_comm_flag boolean,
    independent_expn_flag boolean,
    nondonor_fund_flag boolean,
    nondonor_source character varying(100) COLLATE pg_catalog."default",
    nondonor_amount double precision,
    method_of_communication character varying(250) COLLATE pg_catalog."default",
    "IE_target_type" character varying(1) COLLATE pg_catalog."default",
    "position" character varying(1) COLLATE pg_catalog."default",
    ballot_issue_id integer,
    ballot_issue_desc character varying(250) COLLATE pg_catalog."default",
    candidate_name character varying(100) COLLATE pg_catalog."default",
    office_sought character varying(15) COLLATE pg_catalog."default",
    district character varying(30) COLLATE pg_catalog."default",
    admin_notes character varying(500) COLLATE pg_catalog."default",
    fef_status character varying(15) COLLATE pg_catalog."default",
    disbursement_id integer,
    refund_or_paid_flag boolean,
    CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.transaction
    OWNER to devadmin;