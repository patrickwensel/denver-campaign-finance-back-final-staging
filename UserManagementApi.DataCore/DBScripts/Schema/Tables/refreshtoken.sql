CREATE TABLE public.refreshtoken
(
    id serial NOT NULL,
    tokenval character varying(1000),
    jwt_id character varying(1000),
    created_date date,
    expired_date date,
    is_used boolean,
    in_validated boolean,
    user_id character varying(100),
    created_by character varying(1000),
    created_on date,
    updated_by character varying(1000)  NOT NULL,
    updated_on date,
    CONSTRAINT refreshtoken_pkey PRIMARY KEY (id)
)