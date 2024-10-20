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
-- Name: tokutei_bs; Type: TABLE; Schema: public; Owner: cosmos
--

CREATE TABLE public.tokutei_bs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    tokutei_a_id uuid NOT NULL,
    title character varying NOT NULL,
    sort integer,
    content character varying,
    src_jpn text,
    src_eng text,
    src_nation jsonb,
    created_by uuid,
    updated_by uuid,
    deleted_by uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp(6) without time zone
);


ALTER TABLE public.tokutei_bs OWNER TO cosmos;

--
-- Name: TABLE tokutei_bs; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON TABLE public.tokutei_bs IS '特定技能試験の問題の補助情報を格納するテーブル';


--
-- Name: COLUMN tokutei_bs.id; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.id IS '各レコードの一意の識別子';


--
-- Name: COLUMN tokutei_bs.tokutei_a_id; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.tokutei_a_id IS '関連するtokuteiasテーブルのレコードのID';


--
-- Name: COLUMN tokutei_bs.title; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.title IS '特定種類';


--
-- Name: COLUMN tokutei_bs.sort; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.sort IS 'ソート';


--
-- Name: COLUMN tokutei_bs.content; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.content IS 'コンテンツB';


--
-- Name: COLUMN tokutei_bs.src_jpn; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.src_jpn IS '日本語ソース';


--
-- Name: COLUMN tokutei_bs.src_eng; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.src_eng IS '英語ソース';


--
-- Name: COLUMN tokutei_bs.src_nation; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.src_nation IS '国別ソース';


--
-- Name: COLUMN tokutei_bs.created_by; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.created_by IS '作成者';


--
-- Name: COLUMN tokutei_bs.updated_by; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.updated_by IS '更新者';


--
-- Name: COLUMN tokutei_bs.deleted_by; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.deleted_by IS '削除者';


--
-- Name: COLUMN tokutei_bs.created_at; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.created_at IS '作成日時';


--
-- Name: COLUMN tokutei_bs.updated_at; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.updated_at IS '更新日時';


--
-- Name: COLUMN tokutei_bs.deleted_at; Type: COMMENT; Schema: public; Owner: cosmos
--

COMMENT ON COLUMN public.tokutei_bs.deleted_at IS '削除日時';


--
-- Data for Name: tokutei_bs; Type: TABLE DATA; Schema: public; Owner: cosmos
--

INSERT INTO public.tokutei_bs VALUES ('ce8a20fc-22c2-4280-b037-ff3fa2a06744', '06040349-e736-4c79-8553-035ceef1c2c6', '接客業務', 2, NULL, '接客業務', 'Customer service', NULL, NULL, NULL, NULL, '2024-03-12 08:51:28.393585', '2024-03-12 08:51:28.393585', NULL);
INSERT INTO public.tokutei_bs VALUES ('84ec3667-5079-4932-b70a-16c33e23fee9', '06040349-e736-4c79-8553-035ceef1c2c6', 'レストランサービス業務', 3, NULL, 'レストランサービス業務', 'Restaurant service business', NULL, NULL, NULL, NULL, '2024-03-12 08:51:28.084468', '2024-03-12 08:51:28.084468', NULL);
INSERT INTO public.tokutei_bs VALUES ('5ea696e8-0347-42cd-ba03-d7739f12fa5d', '06040349-e736-4c79-8553-035ceef1c2c6', '企画・広報業務', 4, NULL, '企画・広報業務', 'Planning and public relations work', NULL, NULL, NULL, NULL, '2024-03-12 08:51:28.290142', '2024-03-12 08:51:28.290142', NULL);
INSERT INTO public.tokutei_bs VALUES ('19a2821a-9e05-4686-b27f-f34d174b429e', '06040349-e736-4c79-8553-035ceef1c2c6', '安全衛生・その他基礎知識', 5, NULL, '安全衛生・その他基礎知', 'Safety and health/other basic knowledge', NULL, NULL, NULL, NULL, '2024-03-12 08:51:28.182081', '2024-03-12 08:51:28.182081', NULL);
INSERT INTO public.tokutei_bs VALUES ('6ac56beb-abd4-454d-bcd9-c00801f45f80', '06040349-e736-4c79-8553-035ceef1c2c6', 'フロント業務', 1, NULL, 'フロント業務', 'Front desk operations', '{"JP": "フロント業務", "VN": "Khi thanh toán bằng thẻ tín dụng, phí thẻ có thể được thêm vào hóa đơn."}', NULL, NULL, NULL, '2024-03-12 08:51:27.98148', '2024-03-12 08:51:27.98148', NULL);


--
-- Name: tokutei_bs tokuteibs_pkey; Type: CONSTRAINT; Schema: public; Owner: cosmos
--

ALTER TABLE ONLY public.tokutei_bs
    ADD CONSTRAINT tokuteibs_pkey PRIMARY KEY (id);


--
-- Name: index_tokuteias_id_tokuteib_idx; Type: INDEX; Schema: public; Owner: cosmos
--

CREATE INDEX index_tokuteias_id_tokuteib_idx ON public.tokutei_bs USING btree (tokutei_a_id, title);


--
-- PostgreSQL database dump complete
--

