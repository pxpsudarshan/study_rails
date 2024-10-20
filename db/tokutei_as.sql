--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12
-- Dumped by pg_dump version 12.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tokutei_as; Type: TABLE; Schema: public; Owner: cosmos
--

CREATE TABLE public.tokutei_as (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    content character varying,
    src_jpn text,
    src_eng text,
    src_nation jsonb,
    sort integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_by uuid,
    updated_by uuid,
    deleted_by uuid
);


ALTER TABLE public.tokutei_as OWNER TO cosmos;

--
-- Name: TABLE tokutei_as; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON TABLE public.tokutei_as IS '特定技能試験のタイトルを格納するテーブル';


--
-- Name: COLUMN tokutei_as.id; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.id IS '各レコードの一意の識別子';


--
-- Name: COLUMN tokutei_as.title; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.title IS '特定技能';


--
-- Name: COLUMN tokutei_as.content; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.content IS 'コンテンツA';


--
-- Name: COLUMN tokutei_as.src_jpn; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.src_jpn IS '日本語ソース';


--
-- Name: COLUMN tokutei_as.src_eng; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.src_eng IS '英語ソース';


--
-- Name: COLUMN tokutei_as.src_nation; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.src_nation IS '国別ソース';


--
-- Name: COLUMN tokutei_as.sort; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.sort IS 'ソート';


--
-- Name: COLUMN tokutei_as.created_at; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.created_at IS '作成日時';


--
-- Name: COLUMN tokutei_as.updated_at; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.updated_at IS '更新日時';


--
-- Name: COLUMN tokutei_as.deleted_at; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.deleted_at IS '削除日時';


--
-- Name: COLUMN tokutei_as.created_by; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.created_by IS '作成者';


--
-- Name: COLUMN tokutei_as.updated_by; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.updated_by IS '更新者';


--
-- Name: COLUMN tokutei_as.deleted_by; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_as.deleted_by IS '削除者';


--
-- Data for Name: tokutei_as; Type: TABLE DATA; Schema: public; Owner: cosmos
--

INSERT INTO public.tokutei_as VALUES ('06040349-e736-4c79-8553-035ceef1c2c6', '特定技能試験【宿泊】', NULL, '特定技能試験【宿泊】', 'Specific skill test [accommodation]', NULL, 1, '2024-03-12 08:51:27.974967', '2024-03-12 08:51:27.974967', NULL, NULL, NULL, NULL);


--
-- Name: tokutei_as tokuteias_pkey; Type: CONSTRAINT; Schema: public; Owner: cosmos
--

ALTER TABLE ONLY public.tokutei_as
    ADD CONSTRAINT tokuteias_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

