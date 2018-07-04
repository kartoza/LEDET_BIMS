--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.1
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sites; Type: SCHEMA; Schema: -; Owner: timlinux
--

CREATE SCHEMA sites;


ALTER SCHEMA sites OWNER TO timlinux;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: timlinux
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO timlinux;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: timlinux
--

CREATE FUNCTION geomfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1)$_$;


ALTER FUNCTION public.geomfromtext(text) OWNER TO timlinux;

--
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: timlinux
--

CREATE FUNCTION geomfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1, $2)$_$;


ALTER FUNCTION public.geomfromtext(text, integer) OWNER TO timlinux;

--
-- Name: pnts_geometries(); Type: FUNCTION; Schema: public; Owner: timlinux
--

CREATE FUNCTION pnts_geometries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 IF NEW."geom" is NULL THEN
      UPDATE site SET geom = ST_SetSRID(ST_MakePoint(longitudegis,latitudegis),4326);
ELSE
    RETURN NULL;
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.pnts_geometries() OWNER TO timlinux;

--
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: timlinux
--

CREATE FUNCTION st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);$_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO timlinux;

--
-- Name: st_astext(bytea); Type: FUNCTION; Schema: public; Owner: timlinux
--

CREATE FUNCTION st_astext(bytea) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);$_$;


ALTER FUNCTION public.st_astext(bytea) OWNER TO timlinux;

--
-- Name: gist_geometry_ops; Type: OPERATOR FAMILY; Schema: public; Owner: timlinux
--

CREATE OPERATOR FAMILY gist_geometry_ops USING gist;


ALTER OPERATOR FAMILY public.gist_geometry_ops USING gist OWNER TO timlinux;

--
-- Name: gist_geometry_ops; Type: OPERATOR CLASS; Schema: public; Owner: timlinux
--

CREATE OPERATOR CLASS gist_geometry_ops
    FOR TYPE geometry USING gist FAMILY gist_geometry_ops AS
    STORAGE box2df ,
    OPERATOR 1 <<(geometry,geometry) ,
    OPERATOR 2 &<(geometry,geometry) ,
    OPERATOR 3 &&(geometry,geometry) ,
    OPERATOR 4 &>(geometry,geometry) ,
    OPERATOR 5 >>(geometry,geometry) ,
    OPERATOR 6 ~=(geometry,geometry) ,
    OPERATOR 7 ~(geometry,geometry) ,
    OPERATOR 8 @(geometry,geometry) ,
    OPERATOR 9 &<|(geometry,geometry) ,
    OPERATOR 10 <<|(geometry,geometry) ,
    OPERATOR 11 |>>(geometry,geometry) ,
    OPERATOR 12 |&>(geometry,geometry) ,
    OPERATOR 13 <->(geometry,geometry) FOR ORDER BY pg_catalog.float_ops ,
    OPERATOR 14 <#>(geometry,geometry) FOR ORDER BY pg_catalog.float_ops ,
    FUNCTION 1 (geometry, geometry) geometry_gist_consistent_2d(internal,geometry,integer) ,
    FUNCTION 2 (geometry, geometry) geometry_gist_union_2d(bytea,internal) ,
    FUNCTION 3 (geometry, geometry) geometry_gist_compress_2d(internal) ,
    FUNCTION 4 (geometry, geometry) geometry_gist_decompress_2d(internal) ,
    FUNCTION 5 (geometry, geometry) geometry_gist_penalty_2d(internal,internal,internal) ,
    FUNCTION 6 (geometry, geometry) geometry_gist_picksplit_2d(internal,internal) ,
    FUNCTION 7 (geometry, geometry) geometry_gist_same_2d(geometry,geometry,internal) ,
    FUNCTION 8 (geometry, geometry) geometry_gist_distance_2d(internal,geometry,integer);


ALTER OPERATOR CLASS public.gist_geometry_ops USING gist OWNER TO timlinux;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Group; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE "Group" (
    groupid character varying(250) NOT NULL,
    groupname character varying(25) NOT NULL,
    "Temp" smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE "Group" OWNER TO timlinux;

--
-- Name: Role; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE "Role" (
    roleid character varying(250) NOT NULL,
    "Name" character varying(50) NOT NULL,
    description character varying(255),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE "Role" OWNER TO timlinux;

--
-- Name: Rule; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE "Rule" (
    ruleid character varying(250) NOT NULL,
    "Name" character varying(50) NOT NULL,
    description character varying(255),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE "Rule" OWNER TO timlinux;

--
-- Name: User; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE "User" (
    userid character varying(250) NOT NULL,
    organisationid character varying(250),
    "Comment" character varying(50),
    passwordhint character varying(50),
    telephone character varying(50),
    email character varying(50),
    regionpolid character varying(250),
    regionalchampion smallint,
    firstname character varying(50),
    surname character varying(50),
    ntusername character varying(100),
    username character varying(50),
    "Password" character varying(50),
    passwordhash character varying(100),
    saltvalue character varying(100),
    faxnumber character varying(50),
    postaladdress character varying(250),
    postalcode character varying(50),
    qualifications character varying(250),
    sass4 double precision,
    ripvegindex double precision,
    faiindex double precision,
    other character varying(100),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE "User" OWNER TO timlinux;

--
-- Name: assessor; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE assessor (
    assessorid character varying(250) NOT NULL,
    organisationid character varying(250),
    "Comment" character varying(50),
    telephone character varying(50),
    email character varying(50),
    regionpolid character varying(250),
    firstname character varying(50),
    surname character varying(50),
    username character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE assessor OWNER TO timlinux;

--
-- Name: assessoruploaddate; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE assessoruploaddate (
    "Date" timestamp without time zone
);


ALTER TABLE assessoruploaddate OWNER TO timlinux;

--
-- Name: biobiochemlink; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biobiochemlink (
    biobiochemlinkid character varying(250),
    "ID" numeric(18,0),
    biositevisitbioid character varying(250),
    lngsitevisitbio bigint,
    biositevisitchemid character varying(250),
    lngsitevisitchem bigint,
    lngbiochemlink bigint,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biobiochemlink OWNER TO timlinux;

--
-- Name: biobiodate; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biobiodate (
    biobiodateid character varying(250),
    lngbiodate bigint,
    biodate character varying(20),
    biomonthid character varying(250),
    "Month" character varying(20),
    bioseasonid character varying(250),
    season character varying(20),
    "Year" integer,
    biowarningid character varying(250),
    warning character varying(20),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biobiodate OWNER TO timlinux;

--
-- Name: biobiotope; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biobiotope (
    biobiotopeid character varying(250),
    lngbiotope bigint,
    biotope character varying(85),
    biosassbiotopeid character varying(250),
    sassbiotope character varying(50),
    biobroadbiotopeid character varying(250),
    broadbiotope character varying(50),
    biospecificbiotopeid character varying(250),
    specificbiotope character varying(50),
    biosubstratumid character varying(250),
    substratum character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biobiotope OWNER TO timlinux;

--
-- Name: biobroadbiotope; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biobroadbiotope (
    biobroadbiotopeid character varying(250),
    broadbiotope character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biobroadbiotope OWNER TO timlinux;

--
-- Name: biochemcode; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biochemcode (
    biochemcodeid character varying(250),
    lngchemcode bigint,
    chemcode character varying(20),
    biochemunitid character varying(250),
    chemunit character varying(50),
    chemdescription character varying(255),
    decimalplace integer NOT NULL,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biochemcode OWNER TO timlinux;

--
-- Name: biochemdate; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biochemdate (
    biochemdateid character varying(250),
    lngchemdate bigint,
    chemdate character varying(20),
    biomonthid character varying(250),
    "Month" character varying(20),
    bioseasonid character varying(250),
    season character varying(20),
    "Year" integer,
    biowarningid character varying(250),
    warning character varying(20),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biochemdate OWNER TO timlinux;

--
-- Name: biochemunit; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biochemunit (
    biochemunitid character varying(250),
    chemunit character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biochemunit OWNER TO timlinux;

--
-- Name: bioclass; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE bioclass (
    bioclassid character varying(250),
    "Class" character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE bioclass OWNER TO timlinux;

--
-- Name: biofamily; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biofamily (
    biofamilyid character varying(250),
    "Family" character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biofamily OWNER TO timlinux;

--
-- Name: biogenusspecies; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biogenusspecies (
    biogenusspeciesid character varying(250),
    genusspecies character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biogenusspecies OWNER TO timlinux;

--
-- Name: biomonth; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biomonth (
    biomonthid character varying(250),
    "Month" character varying(20),
    "Order" integer,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biomonth OWNER TO timlinux;

--
-- Name: bioorder; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE bioorder (
    bioorderid character varying(250),
    "Order" character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE bioorder OWNER TO timlinux;

--
-- Name: biophylum; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biophylum (
    biophylumid character varying(250),
    phylum character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biophylum OWNER TO timlinux;

--
-- Name: biopolregion; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biopolregion (
    biopolregionid character varying(250),
    polregion character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biopolregion OWNER TO timlinux;

--
-- Name: bioreach; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE bioreach (
    bioreachid character varying(250),
    reach character varying(50),
    "Order" integer,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE bioreach OWNER TO timlinux;

--
-- Name: bioreference; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE bioreference (
    bioreferenceid character varying(250),
    author character varying(100),
    "Year" character varying(20),
    title character varying(255),
    journal character varying(255),
    originalreference integer NOT NULL,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE bioreference OWNER TO timlinux;

--
-- Name: bioregion; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE bioregion (
    bioregionid character varying(250),
    region character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE bioregion OWNER TO timlinux;

--
-- Name: biorivername; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biorivername (
    biorivernameid character varying(250),
    rivername character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biorivername OWNER TO timlinux;

--
-- Name: biosassbiotope; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biosassbiotope (
    biosassbiotopeid character varying(250),
    sassbiotope character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biosassbiotope OWNER TO timlinux;

--
-- Name: bioseason; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE bioseason (
    bioseasonid character varying(250),
    season character varying(20),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE bioseason OWNER TO timlinux;

--
-- Name: biosite; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biosite (
    biositeid character varying(250),
    lngsite bigint,
    sitecode character varying(15),
    description character varying(255),
    bioreachid character varying(250),
    reach character varying(50),
    biorivernameid character varying(250),
    rivername character varying(50),
    bioregionid character varying(250),
    bioregion character varying(50),
    biopolregionid character varying(250),
    polregion character varying(50),
    biowqregionid character varying(250),
    wqregion character varying(50),
    ecoregionid character varying(250),
    ecoregion2id character varying(250),
    altitude character varying(20),
    latitudedegree character varying(2),
    latitudeminute character varying(2),
    latitudesecond character varying(2),
    latitudec character varying(2),
    longitudedegree character varying(2),
    longitudeminute character varying(2),
    longitudesecond character varying(2),
    longitudec character varying(2),
    latitudegis numeric(10,5),
    longitudegis numeric(10,5),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biosite OWNER TO timlinux;

--
-- Name: biositevisitbio; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biositevisitbio (
    biositevisitbioid character varying(250),
    lngsitevisitbio bigint,
    biobiodateid character varying(250),
    lngbiodate bigint,
    biositeid character varying(250),
    lngsite bigint,
    sass integer,
    aspt numeric(18,0),
    nrfam integer,
    nrsassbiotopes integer,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biositevisitbio OWNER TO timlinux;

--
-- Name: biositevisitbiobiotope; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biositevisitbiobiotope (
    biositevisitbiobiotopeid character varying(250),
    lngsitevisitbiobiotope bigint,
    biositevisitbioid character varying(250),
    lngsitevisitbio bigint,
    biobiotopeid character varying(250),
    lngbiotope bigint,
    bioreferenceid character varying(250),
    lngreference bigint,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biositevisitbiobiotope OWNER TO timlinux;

--
-- Name: biositevisitbiobiotopetaxon; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biositevisitbiobiotopetaxon (
    biositevisitbiobiotopetaxonid character varying(250),
    lngsitevisitbiobiotopetaxon bigint,
    biositevisitbiobiotopeid character varying(250),
    lngsitevisitbiobiotope bigint,
    biotaxonid character varying(250),
    lngtaxon bigint,
    abundance numeric(18,4),
    present smallint,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biositevisitbiobiotopetaxon OWNER TO timlinux;

--
-- Name: biositevisitchem; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biositevisitchem (
    biositevisitchemid character varying(250),
    lngsitevisitchem bigint,
    biochemdateid character varying(250),
    lngchemdate bigint,
    biositeid character varying(250),
    lngsite bigint,
    bioreferenceid character varying(250),
    lngreference bigint,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biositevisitchem OWNER TO timlinux;

--
-- Name: biositevisitchemvalue; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biositevisitchemvalue (
    biositevisitchemvalueid character varying(250),
    lngsitevisitchemvalue bigint,
    biositevisitchemid character varying(250),
    lngsitevisitchem bigint,
    biochemcodeid character varying(250),
    lngchemcode bigint,
    chemvalue numeric(15,5),
    top smallint,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biositevisitchemvalue OWNER TO timlinux;

--
-- Name: biositevisittaxon; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biositevisittaxon (
    biositevisittaxonid character varying(250),
    biositevisitid character varying(250),
    lngsitevisit bigint,
    biosasstaxonid character varying(250),
    lngsasstaxon bigint,
    "Count" integer,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biositevisittaxon OWNER TO timlinux;

--
-- Name: biosoftware; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biosoftware (
    biosoftwareid character varying(250),
    licensedto character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biosoftware OWNER TO timlinux;

--
-- Name: biospecificbiotope; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biospecificbiotope (
    biospecificbiotopeid character varying(250),
    specificbiotope character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biospecificbiotope OWNER TO timlinux;

--
-- Name: biosubfamily; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biosubfamily (
    biosubfamilyid character varying(250),
    subfamily character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biosubfamily OWNER TO timlinux;

--
-- Name: biosuborder; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biosuborder (
    biosuborderid character varying(250),
    suborder character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biosuborder OWNER TO timlinux;

--
-- Name: biosubstratum; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biosubstratum (
    biosubstratumid character varying(250),
    substratum character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biosubstratum OWNER TO timlinux;

--
-- Name: biotaxon; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biotaxon (
    biotaxonid character varying(250),
    lngtaxon bigint NOT NULL,
    biophylumid character varying(250),
    phylum character varying(50),
    bioclassid character varying(250),
    "Class" character varying(50),
    bioorderid character varying(250),
    "Order" character varying(50),
    biosuborderid character varying(250),
    suborder character varying(50),
    biofamilyid character varying(250),
    "Family" character varying(50),
    biosubfamilyid character varying(250),
    subfamily character varying(50),
    biogenusspeciesid character varying(250),
    genusspecies character varying(50),
    taxon character varying(50),
    note character varying(8000),
    biosasstaxonid character varying(250),
    lngsasstaxon bigint,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biotaxon OWNER TO timlinux;

--
-- Name: biowarning; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biowarning (
    biowarningid character varying(250),
    warning character varying(20),
    "Type" character varying(50),
    description character varying(150),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biowarning OWNER TO timlinux;

--
-- Name: biowqregion; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE biowqregion (
    biowqregionid character varying(250),
    wqregion character varying(50),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE biowqregion OWNER TO timlinux;

--
-- Name: canopycover; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE canopycover (
    canopycoverid character varying(250) NOT NULL,
    canopycover character varying(100),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE canopycover OWNER TO timlinux;

--
-- Name: catchmentsecondary; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE catchmentsecondary (
    catchmentsecondaryid character varying(250) NOT NULL,
    catchmentsecondary character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE catchmentsecondary OWNER TO timlinux;

--
-- Name: chem; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE chem (
    chemid character varying(250) NOT NULL,
    chemcode character varying(15) NOT NULL,
    chemdescription character varying(255),
    chemunitid character varying(250),
    minimum numeric(10,2),
    maximum numeric(10,2),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE chem OWNER TO timlinux;

--
-- Name: chemunit; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE chemunit (
    chemunitid character varying(250) NOT NULL,
    chemunit character varying(10),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE chemunit OWNER TO timlinux;

--
-- Name: cvssitevisitbiotopetaxon_sitevisttaxon; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE cvssitevisitbiotopetaxon_sitevisttaxon (
    sitecode character varying(15),
    sitevisit timestamp without time zone,
    sassbiotope character varying(50),
    taxonname character varying(50),
    abundance character varying(1),
    "Owner" character varying(100),
    assessor character varying(100)
);


ALTER TABLE cvssitevisitbiotopetaxon_sitevisttaxon OWNER TO timlinux;

--
-- Name: cvssitevisitbiotopetaxon_sitevisttaxonerrors; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE cvssitevisitbiotopetaxon_sitevisttaxonerrors (
    sitecode character varying(15),
    sitevisit timestamp without time zone,
    sassbiotope character varying(50),
    taxonname character varying(50),
    abundance character varying(1),
    "Owner" character varying(100),
    assessor character varying(100),
    validation character varying(100)
);


ALTER TABLE cvssitevisitbiotopetaxon_sitevisttaxonerrors OWNER TO timlinux;

--
-- Name: datafileproperty; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE datafileproperty (
    datafilepropertyid character varying(250) NOT NULL,
    property character varying(70) NOT NULL,
    entrytext character varying(70),
    entrynumber numeric(10,2),
    entrydate timestamp without time zone,
    "Comment" character varying(255),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE datafileproperty OWNER TO timlinux;

--
-- Name: drainageregion; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE drainageregion (
    drainageregionid character varying(250) NOT NULL,
    "Name" character varying(150) NOT NULL,
    description character varying(255),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE drainageregion OWNER TO timlinux;

--
-- Name: dtproperties; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE dtproperties (
    id integer NOT NULL,
    objectid integer,
    property character varying(64) NOT NULL,
    value character varying(255),
    uvalue character varying(255),
    lvalue bytea,
    version integer NOT NULL
);


ALTER TABLE dtproperties OWNER TO timlinux;

--
-- Name: ecoregion; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE ecoregion (
    ecoregionid character varying(250) NOT NULL,
    ecoregion character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE ecoregion OWNER TO timlinux;

--
-- Name: ecoregion2; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE ecoregion2 (
    ecoregion2id character varying(250) NOT NULL,
    ecoregion2 character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE ecoregion2 OWNER TO timlinux;

--
-- Name: fish; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE fish (
    fishid character varying(250) NOT NULL,
    abbreviation character varying(50),
    taxon character varying(50),
    commonname character varying(50),
    "Family" character varying(50),
    originstatusid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE fish OWNER TO timlinux;

--
-- Name: fishintoleranceindexitem; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE fishintoleranceindexitem (
    fishintoleranceindexitemid character varying(250) NOT NULL,
    intoleranceindexitem character varying(50),
    itcomponent smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE fishintoleranceindexitem OWNER TO timlinux;

--
-- Name: formula; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE formula (
    formulaid character varying(250) NOT NULL,
    formula character varying(50) NOT NULL,
    constant numeric(10,2),
    constantdenominator numeric(10,2),
    formulamaximum numeric(10,2),
    detaillevel integer,
    displayorder smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE formula OWNER TO timlinux;

--
-- Name: formulacriterion; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE formulacriterion (
    formulacriterionid character varying(250) NOT NULL,
    formulacriterion character varying(255) NOT NULL,
    formulacriteriongroup character varying(50) NOT NULL,
    assessmentmethod character varying(50),
    "Temp" smallint,
    factor numeric(10,2),
    formulacriterionorder smallint,
    formulacriterionabbr character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE formulacriterion OWNER TO timlinux;

--
-- Name: formulanumerator; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE formulanumerator (
    formulanumeratorid character varying(250) NOT NULL,
    formulacriterionid character varying(250),
    formulaid character varying(250) NOT NULL,
    factor numeric(10,2),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE formulanumerator OWNER TO timlinux;

--
-- Name: formularesultgrouping; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE formularesultgrouping (
    formularesultgroupingid character varying(250) NOT NULL,
    formulagroup character varying(50),
    scorefrom numeric(10,2),
    scoreto numeric(10,2),
    status character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE formularesultgrouping OWNER TO timlinux;

--
-- Name: geology; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE geology (
    geologyid character varying(250) NOT NULL,
    geology character varying(30) NOT NULL,
    lithostratigraphicunit character varying(255),
    principlerocktypes character varying(255),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE geology OWNER TO timlinux;

--
-- Name: ihisitevisitresult; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE ihisitevisitresult (
    ihisitevisitresultid character varying(250) NOT NULL,
    sitevisitid character varying(250) NOT NULL,
    instreampercentage numeric(10,2),
    riparianzonepercentage numeric(10,2),
    instreamcategory character varying(50),
    riparianzonecategory character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE ihisitevisitresult OWNER TO timlinux;

--
-- Name: ihisitevisitriparianzone; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE ihisitevisitriparianzone (
    ihisitevisitriparianzoneid character varying(250) NOT NULL,
    sitevisitid character varying(250) NOT NULL,
    overallrate character varying(250),
    siterate character varying(250),
    upstreamrate character varying(250),
    ripariancomment character varying(100),
    upstreamcomment character varying(100),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE ihisitevisitriparianzone OWNER TO timlinux;

--
-- Name: ihisitevisitriparianzonecomponent; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE ihisitevisitriparianzonecomponent (
    ihisitevisitriparianzonecomponentid character varying(250) NOT NULL,
    sitevisitid character varying(250) NOT NULL,
    marginalrating numeric(10,1),
    nonmarginalrating numeric(10,1),
    rating numeric(10,1),
    confidence smallint,
    percentage numeric(10,2),
    ecology smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE ihisitevisitriparianzonecomponent OWNER TO timlinux;

--
-- Name: issuelog; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE issuelog (
    issuelogid character varying(250) NOT NULL,
    incidentnumber integer NOT NULL,
    screen character varying(100),
    description character varying(7000),
    incidenttype character varying(50),
    status character varying(50),
    priority smallint,
    estimatedeffort double precision,
    "Comment" character varying(255),
    loggedby character varying(100),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE issuelog OWNER TO timlinux;

--
-- Name: longitudinalzone; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE longitudinalzone (
    longitudinalzoneid character varying(250) NOT NULL,
    longitudinalzone character varying(50) NOT NULL,
    "Order" smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE longitudinalzone OWNER TO timlinux;

--
-- Name: organisation; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE organisation (
    organisationid character varying(250) NOT NULL,
    organisation character varying(255),
    description character varying(255),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE organisation OWNER TO timlinux;

--
-- Name: ownershiptransfer; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE ownershiptransfer (
    ownershiptransferid character varying(250) NOT NULL,
    transferfrom character varying(250) NOT NULL,
    transferto character varying(250) NOT NULL,
    "Timestamp" timestamp without time zone NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE ownershiptransfer OWNER TO timlinux;

--
-- Name: photoarea; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE photoarea (
    photoareaid character varying(250) NOT NULL,
    photoarea character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE photoarea OWNER TO timlinux;

--
-- Name: quaternarycatchment; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE quaternarycatchment (
    quaternarycatchmentid character varying(250) NOT NULL,
    quaternarycatchment character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE quaternarycatchment OWNER TO timlinux;

--
-- Name: querymasterdatamart; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE querymasterdatamart (
    refreshdate timestamp without time zone
);


ALTER TABLE querymasterdatamart OWNER TO timlinux;

--
-- Name: rainregion; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE rainregion (
    rainregionid character varying(250) NOT NULL,
    rainregion character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE rainregion OWNER TO timlinux;

--
-- Name: rate; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE rate (
    rateid character varying(250) NOT NULL,
    rate integer NOT NULL,
    description character varying(50),
    "Group" smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE rate OWNER TO timlinux;

--
-- Name: reach; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE reach (
    reachid character varying(250) NOT NULL,
    drainageregionid character varying(250),
    "Sequence" integer,
    sorter character varying(16),
    "Order" integer,
    "Source" smallint,
    code character varying(16),
    nextreachid character varying(250),
    "Name" character varying(150),
    firstreachcode character varying(16),
    kilometers numeric(18,0),
    hasname smallint,
    issource smallint,
    ismouth smallint,
    catchment character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE reach OWNER TO timlinux;

--
-- Name: reachrivermapping; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE reachrivermapping (
    reachrivermappingid character varying(250) NOT NULL,
    riverid character varying(250) NOT NULL,
    "Name" character varying(150) NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE reachrivermapping OWNER TO timlinux;

--
-- Name: referencedownload; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE referencedownload (
    referencedownloadid character varying(250),
    riverid character varying(250),
    "Type" integer,
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE referencedownload OWNER TO timlinux;

--
-- Name: referenceupload; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE referenceupload (
    referenceuploadid character varying(250),
    siteid character varying(250),
    sitevisitid character varying(250),
    relatedid character varying(250),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE referenceupload OWNER TO timlinux;

--
-- Name: regionbio; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE regionbio (
    regionbioid character varying(250) NOT NULL,
    region character varying(50) NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE regionbio OWNER TO timlinux;

--
-- Name: regionpol; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE regionpol (
    regionpolid character varying(250) NOT NULL,
    polregion character varying(50) NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE regionpol OWNER TO timlinux;

--
-- Name: regionwq; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE regionwq (
    regionwqid character varying(250) NOT NULL,
    wqregion character varying(50) NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE regionwq OWNER TO timlinux;

--
-- Name: river; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE river (
    riverid character varying(250) NOT NULL,
    drainageregionid character varying(250),
    rivername character varying(50),
    ownerid character varying(250),
    tribofid character varying(250),
    treeviewnodeid integer NOT NULL,
    treeviewsortorder integer,
    polregionid character varying(250),
    validated smallint NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE river OWNER TO timlinux;

--
-- Name: rulerole; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE rulerole (
    ruleroleid character varying(250) NOT NULL,
    ruleid character varying(250) NOT NULL,
    roleid character varying(250) NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE rulerole OWNER TO timlinux;

--
-- Name: sassbiotope; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sassbiotope (
    sassbiotopeid character varying(250) NOT NULL,
    "Order" smallint,
    sassbiotope character varying(50) NOT NULL,
    biotopeform smallint,
    description character varying(255),
    componentofbiotopeid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sassbiotope OWNER TO timlinux;

--
-- Name: sassvalidationstatus; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sassvalidationstatus (
    sassvalidationstatusid character varying(250) NOT NULL,
    status character varying(50) NOT NULL,
    colour integer,
    colourdescription character varying(50),
    missingind smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sassvalidationstatus OWNER TO timlinux;

--
-- Name: site; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE site (
    siteid character varying(250) NOT NULL,
    userid character varying(250),
    sitecode character varying(15),
    riverid character varying(250),
    site character varying(255),
    latitudegis numeric(10,5),
    longitudegis numeric(10,5),
    regionpolid character varying(250),
    regionbioid character varying(250),
    ecoregionid character varying(250),
    ecoregion2id character varying(250),
    regionwqid character varying(250),
    catchmentsecondaryid character varying(250),
    quaternarycatchmentid character varying(250),
    altitude integer,
    commentsitegeneral character varying(255),
    "Order" smallint,
    geologyid character varying(250),
    vegetationid character varying(250),
    rainregionid character varying(250),
    landownerdetail character varying(255),
    contactno character varying(50),
    watermanagementareaid character varying(250),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone,
    geom geometry(Point,4326)
);


ALTER TABLE site OWNER TO timlinux;

--
-- Name: sitegis; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitegis (
    sitegisid character varying(250) NOT NULL,
    siteid character varying(250),
    watermanagementareaid character varying(250),
    ecoregioniid character varying(250),
    ecoregioniiid character varying(250),
    quaternarycatchmentid character varying(250),
    catchmentsecondaryid character varying(250),
    vegetationtypeid character varying(250),
    geologicaltypeid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sitegis OWNER TO timlinux;

--
-- Name: sitephoto; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitephoto (
    sitephotoid character varying(250) NOT NULL,
    siteid character varying(250),
    photodate timestamp without time zone,
    photoareaid character varying(250) NOT NULL,
    spoolnum character varying(20),
    photonum character varying(20),
    "Comment" character varying(100),
    photo bytea,
    photopath text,
    guid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sitephoto OWNER TO timlinux;

--
-- Name: sitevisit; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitevisit (
    sitevisitid character varying(250) NOT NULL,
    siteid character varying(250),
    sitevisit timestamp without time zone,
    assessorid character varying(250),
    waterlevelid character varying(250),
    waterturbidityid character varying(250),
    "Average Velocity" numeric(18,0),
    "Average Depth" numeric(18,0),
    discharge numeric(18,0),
    canopycoverid character varying(250),
    userid character varying(250),
    sassdataversion character varying(50),
    invertebrateowner character varying(250),
    invertebrateassessor character varying(250),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE sitevisit OWNER TO timlinux;

--
-- Name: sitevisitbiotopetaxon; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitevisitbiotopetaxon (
    sitevisitbiotopetaxonid character varying(250) NOT NULL,
    sitevisitid character varying(250),
    taxonid character varying(250) NOT NULL,
    sassbiotopeid character varying(250),
    taxonabundanceid character varying(250),
    userid character varying(250),
    assessorid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sitevisitbiotopetaxon OWNER TO timlinux;

--
-- Name: sitevisitchem; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitevisitchem (
    sitevisitchemid character varying(250) NOT NULL,
    sitevisitid character varying(250),
    chemvalue numeric(10,2),
    "Comment" character varying(255),
    maxdetectablelimit smallint,
    userid character varying(250),
    assessorid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sitevisitchem OWNER TO timlinux;

--
-- Name: sitevisitsassbiotope; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitevisitsassbiotope (
    sitevisitsassbiotopeid character varying(250) NOT NULL,
    sitevisitid character varying(250) NOT NULL,
    sassbiotopeid character varying(250),
    biotopefraction character varying(250),
    userid character varying(250),
    assessorid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sitevisitsassbiotope OWNER TO timlinux;

--
-- Name: sitevisitstreamdimension; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitevisitstreamdimension (
    sitevisitstreamdimensionid character varying(250) NOT NULL,
    sitevisitid character varying(250) NOT NULL,
    streamdimensionid character varying(250),
    streamdimensioncategoryid character varying(250),
    "Comment" character varying(50),
    userid character varying(250),
    assessorid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sitevisitstreamdimension OWNER TO timlinux;

--
-- Name: sitevisittaxon; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE sitevisittaxon (
    sitevisittaxonid character varying(250) NOT NULL,
    sitevisitid character varying(250) NOT NULL,
    taxonid character varying(250),
    userid character varying(250),
    assessorid character varying(250),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE sitevisittaxon OWNER TO timlinux;

--
-- Name: spatialdata; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE spatialdata (
    spatialdataid integer NOT NULL,
    siteid character varying(250),
    sitecode character varying(15),
    regionpolid character varying(250),
    polregion character varying(50),
    watermanagementareaid character varying(250),
    watermanagementarea character varying(100),
    ecoregionid character varying(250),
    ecoregion character varying(50),
    catchmentsecondaryid character varying(250),
    catchmentsecondary character varying(50),
    quaternarycatchmentid character varying(250),
    quaternarycatchment character varying(50),
    regionbioid character varying(250),
    region character varying(50),
    vegetationid character varying(250),
    vegetation character varying(50),
    geologyid character varying(250),
    geology character varying(30),
    ecoregion2id character varying(250),
    ecoregion2 character varying(50),
    regionwqid character varying(250),
    regionwq character varying(50)
);


ALTER TABLE spatialdata OWNER TO timlinux;

--
-- Name: streamdimension; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE streamdimension (
    streamdimensionid character varying(250) NOT NULL,
    streamdimension character varying(50),
    "User" character varying(250) NOT NULL,
    bankheightindicator smallint,
    streamdimensionindicator smallint,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE streamdimension OWNER TO timlinux;

--
-- Name: streamdimensioncategory; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE streamdimensioncategory (
    streamdimensioncategoryid character varying(250) NOT NULL,
    streamdimensioncategory character varying(50),
    bankheightindicator smallint,
    streamdimensionindicator smallint,
    displayorder smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE streamdimensioncategory OWNER TO timlinux;

--
-- Name: taxon; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE taxon (
    taxonid character varying(250) NOT NULL,
    taxonk integer,
    taxonorder smallint,
    taxonname character varying(50),
    taxonsass4 character varying(50),
    groupid character varying(250),
    score smallint,
    sass5score integer,
    airbreather smallint,
    lifestage character varying(50),
    biobaseid integer,
    displayordersass4 integer,
    displayordersass5 integer,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE taxon OWNER TO timlinux;

--
-- Name: userrole; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE userrole (
    userroleid character varying(250) NOT NULL,
    userid character varying(250) NOT NULL,
    roleid character varying(250) NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE userrole OWNER TO timlinux;

--
-- Name: usersassvalidation; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE usersassvalidation (
    usersassvalidationid character varying(250) NOT NULL,
    rowid integer NOT NULL,
    userid character varying(250),
    validfrom timestamp without time zone,
    validto timestamp without time zone,
    status character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE usersassvalidation OWNER TO timlinux;

--
-- Name: vegetation; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE vegetation (
    vegetationid character varying(250) NOT NULL,
    vegetation character varying(50) NOT NULL,
    biome character varying(50),
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE vegetation OWNER TO timlinux;

--
-- Name: waterlevel; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE waterlevel (
    waterlevelid character varying(250) NOT NULL,
    waterlevel character varying(50),
    displayorder smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE waterlevel OWNER TO timlinux;

--
-- Name: watermanagementarea; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE watermanagementarea (
    watermanagementareaid character varying(250) NOT NULL,
    watermanagementarea character varying(100),
    watermanagementareanumber integer,
    displayorder smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE watermanagementarea OWNER TO timlinux;

--
-- Name: waterturbidity; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE waterturbidity (
    waterturbidityid character varying(250) NOT NULL,
    waterturbidity character varying(50) NOT NULL,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE waterturbidity OWNER TO timlinux;

--
-- Name: weir; Type: TABLE; Schema: public; Owner: timlinux
--

CREATE TABLE weir (
    weirid character varying(250) NOT NULL,
    station character varying(50),
    code character varying(10),
    typedescription character varying(50),
    latitudegis numeric(10,5),
    longitudegis numeric(10,5),
    "User" character varying(250),
    datefrom timestamp without time zone,
    datemodified timestamp without time zone,
    dateto timestamp without time zone
);


ALTER TABLE weir OWNER TO timlinux;

SET search_path = sites, pg_catalog;

--
-- Name: formulagroup; Type: TABLE; Schema: sites; Owner: timlinux
--

CREATE TABLE formulagroup (
    formulagroupid character varying(250) NOT NULL,
    formulagroup character varying(50) NOT NULL,
    formulaid character varying(250),
    factor numeric(10,2),
    detaillevel integer,
    displayorder smallint,
    "User" character varying(250) NOT NULL,
    datefrom timestamp without time zone NOT NULL,
    datemodified timestamp without time zone NOT NULL,
    dateto timestamp without time zone
);


ALTER TABLE formulagroup OWNER TO timlinux;

SET search_path = public, pg_catalog;

--
-- Name: Group Group_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY "Group"
    ADD CONSTRAINT "Group_pkey" PRIMARY KEY (groupid);


--
-- Name: Role Role_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY "Role"
    ADD CONSTRAINT "Role_pkey" PRIMARY KEY (roleid);


--
-- Name: Rule Rule_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY "Rule"
    ADD CONSTRAINT "Rule_pkey" PRIMARY KEY (ruleid);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY "User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (userid);


--
-- Name: assessor assessor_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY assessor
    ADD CONSTRAINT assessor_pkey PRIMARY KEY (assessorid);


--
-- Name: canopycover canopycover_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY canopycover
    ADD CONSTRAINT canopycover_pkey PRIMARY KEY (canopycoverid);


--
-- Name: catchmentsecondary catchmentsecondary_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY catchmentsecondary
    ADD CONSTRAINT catchmentsecondary_pkey PRIMARY KEY (catchmentsecondaryid);


--
-- Name: chemunit chemunit_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY chemunit
    ADD CONSTRAINT chemunit_pkey PRIMARY KEY (chemunitid);


--
-- Name: datafileproperty datafileproperty_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY datafileproperty
    ADD CONSTRAINT datafileproperty_pkey PRIMARY KEY (datafilepropertyid);


--
-- Name: drainageregion drainageregion_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY drainageregion
    ADD CONSTRAINT drainageregion_pkey PRIMARY KEY (drainageregionid);


--
-- Name: dtproperties dtproperties_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY dtproperties
    ADD CONSTRAINT dtproperties_pkey PRIMARY KEY (id, property);


--
-- Name: ecoregion2 ecoregion2_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ecoregion2
    ADD CONSTRAINT ecoregion2_pkey PRIMARY KEY (ecoregion2id);


--
-- Name: ecoregion ecoregion_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ecoregion
    ADD CONSTRAINT ecoregion_pkey PRIMARY KEY (ecoregionid);


--
-- Name: fish fish_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY fish
    ADD CONSTRAINT fish_pkey PRIMARY KEY (fishid);


--
-- Name: fishintoleranceindexitem fishintoleranceindexitem_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY fishintoleranceindexitem
    ADD CONSTRAINT fishintoleranceindexitem_pkey PRIMARY KEY (fishintoleranceindexitemid);


--
-- Name: formula formula_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY formula
    ADD CONSTRAINT formula_pkey PRIMARY KEY (formulaid);


--
-- Name: formulacriterion formulacriterion_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY formulacriterion
    ADD CONSTRAINT formulacriterion_pkey PRIMARY KEY (formulacriterionid);


--
-- Name: formulanumerator formulanumerator_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY formulanumerator
    ADD CONSTRAINT formulanumerator_pkey PRIMARY KEY (formulanumeratorid);


--
-- Name: formularesultgrouping formularesultgrouping_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY formularesultgrouping
    ADD CONSTRAINT formularesultgrouping_pkey PRIMARY KEY (formularesultgroupingid);


--
-- Name: geology geology_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY geology
    ADD CONSTRAINT geology_pkey PRIMARY KEY (geologyid);


--
-- Name: ihisitevisitresult ihisitevisitresult_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ihisitevisitresult
    ADD CONSTRAINT ihisitevisitresult_pkey PRIMARY KEY (ihisitevisitresultid);


--
-- Name: ihisitevisitriparianzone ihisitevisitriparianzone_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ihisitevisitriparianzone
    ADD CONSTRAINT ihisitevisitriparianzone_pkey PRIMARY KEY (ihisitevisitriparianzoneid);


--
-- Name: ihisitevisitriparianzonecomponent ihisitevisitriparianzonecomponent_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ihisitevisitriparianzonecomponent
    ADD CONSTRAINT ihisitevisitriparianzonecomponent_pkey PRIMARY KEY (ihisitevisitriparianzonecomponentid);


--
-- Name: organisation organisation_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (organisationid);


--
-- Name: ownershiptransfer ownershiptransfer_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ownershiptransfer
    ADD CONSTRAINT ownershiptransfer_pkey PRIMARY KEY (ownershiptransferid);


--
-- Name: photoarea photoarea_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY photoarea
    ADD CONSTRAINT photoarea_pkey PRIMARY KEY (photoareaid);


--
-- Name: quaternarycatchment quaternarycatchment_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY quaternarycatchment
    ADD CONSTRAINT quaternarycatchment_pkey PRIMARY KEY (quaternarycatchmentid);


--
-- Name: rainregion rainregion_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY rainregion
    ADD CONSTRAINT rainregion_pkey PRIMARY KEY (rainregionid);


--
-- Name: rate rate_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY rate
    ADD CONSTRAINT rate_pkey PRIMARY KEY (rateid);


--
-- Name: reach reach_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY reach
    ADD CONSTRAINT reach_pkey PRIMARY KEY (reachid);


--
-- Name: reachrivermapping reachrivermapping_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY reachrivermapping
    ADD CONSTRAINT reachrivermapping_pkey PRIMARY KEY (reachrivermappingid);


--
-- Name: regionbio regionbio_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY regionbio
    ADD CONSTRAINT regionbio_pkey PRIMARY KEY (regionbioid);


--
-- Name: regionpol regionpol_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY regionpol
    ADD CONSTRAINT regionpol_pkey PRIMARY KEY (regionpolid);


--
-- Name: regionwq regionwq_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY regionwq
    ADD CONSTRAINT regionwq_pkey PRIMARY KEY (regionwqid);


--
-- Name: river river_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY river
    ADD CONSTRAINT river_pkey PRIMARY KEY (riverid);


--
-- Name: rulerole rulerole_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY rulerole
    ADD CONSTRAINT rulerole_pkey PRIMARY KEY (ruleroleid);


--
-- Name: sassbiotope sassbiotope_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sassbiotope
    ADD CONSTRAINT sassbiotope_pkey PRIMARY KEY (sassbiotopeid);


--
-- Name: sassvalidationstatus sassvalidationstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sassvalidationstatus
    ADD CONSTRAINT sassvalidationstatus_pkey PRIMARY KEY (sassvalidationstatusid);


--
-- Name: site site_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pkey PRIMARY KEY (siteid);


--
-- Name: sitegis sitegis_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitegis
    ADD CONSTRAINT sitegis_pkey PRIMARY KEY (sitegisid);


--
-- Name: sitevisit sitevisit_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisit
    ADD CONSTRAINT sitevisit_pkey PRIMARY KEY (sitevisitid);


--
-- Name: sitevisitbiotopetaxon sitevisitbiotopetaxon_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitbiotopetaxon
    ADD CONSTRAINT sitevisitbiotopetaxon_pkey PRIMARY KEY (sitevisitbiotopetaxonid);


--
-- Name: sitevisitchem sitevisitchem_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitchem
    ADD CONSTRAINT sitevisitchem_pkey PRIMARY KEY (sitevisitchemid);


--
-- Name: sitevisitsassbiotope sitevisitsassbiotope_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitsassbiotope
    ADD CONSTRAINT sitevisitsassbiotope_pkey PRIMARY KEY (sitevisitsassbiotopeid);


--
-- Name: sitevisitstreamdimension sitevisitstreamdimension_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitstreamdimension
    ADD CONSTRAINT sitevisitstreamdimension_pkey PRIMARY KEY (sitevisitstreamdimensionid);


--
-- Name: sitevisittaxon sitevisittaxon_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisittaxon
    ADD CONSTRAINT sitevisittaxon_pkey PRIMARY KEY (sitevisittaxonid);


--
-- Name: streamdimension streamdimension_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY streamdimension
    ADD CONSTRAINT streamdimension_pkey PRIMARY KEY (streamdimensionid);


--
-- Name: streamdimensioncategory streamdimensioncategory_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY streamdimensioncategory
    ADD CONSTRAINT streamdimensioncategory_pkey PRIMARY KEY (streamdimensioncategoryid);


--
-- Name: taxon taxon_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY taxon
    ADD CONSTRAINT taxon_pkey PRIMARY KEY (taxonid);


--
-- Name: userrole userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (userroleid);


--
-- Name: usersassvalidation usersassvalidation_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY usersassvalidation
    ADD CONSTRAINT usersassvalidation_pkey PRIMARY KEY (usersassvalidationid);


--
-- Name: vegetation vegetation_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY vegetation
    ADD CONSTRAINT vegetation_pkey PRIMARY KEY (vegetationid);


--
-- Name: waterlevel waterlevel_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY waterlevel
    ADD CONSTRAINT waterlevel_pkey PRIMARY KEY (waterlevelid);


--
-- Name: watermanagementarea watermanagementarea_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY watermanagementarea
    ADD CONSTRAINT watermanagementarea_pkey PRIMARY KEY (watermanagementareaid);


--
-- Name: waterturbidity waterturbidity_pkey; Type: CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY waterturbidity
    ADD CONSTRAINT waterturbidity_pkey PRIMARY KEY (waterturbidityid);


SET search_path = sites, pg_catalog;

--
-- Name: formulagroup formulagroup_pkey; Type: CONSTRAINT; Schema: sites; Owner: timlinux
--

ALTER TABLE ONLY formulagroup
    ADD CONSTRAINT formulagroup_pkey PRIMARY KEY (formulagroupid);


SET search_path = public, pg_catalog;

--
-- Name: User User_regionpolid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY "User"
    ADD CONSTRAINT "User_regionpolid_fkey" FOREIGN KEY (regionpolid) REFERENCES regionpol(regionpolid);


--
-- Name: formulanumerator formulanumerator_formulacriterionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY formulanumerator
    ADD CONSTRAINT formulanumerator_formulacriterionid_fkey FOREIGN KEY (formulacriterionid) REFERENCES formulacriterion(formulacriterionid);


--
-- Name: formulanumerator formulanumerator_formulaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY formulanumerator
    ADD CONSTRAINT formulanumerator_formulaid_fkey FOREIGN KEY (formulaid) REFERENCES formula(formulaid);


--
-- Name: ihisitevisitresult ihisitevisitresult_sitevisitid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ihisitevisitresult
    ADD CONSTRAINT ihisitevisitresult_sitevisitid_fkey FOREIGN KEY (sitevisitid) REFERENCES sitevisit(sitevisitid);


--
-- Name: ihisitevisitriparianzone ihisitevisitriparianzone_sitevisitid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ihisitevisitriparianzone
    ADD CONSTRAINT ihisitevisitriparianzone_sitevisitid_fkey FOREIGN KEY (sitevisitid) REFERENCES sitevisit(sitevisitid);


--
-- Name: ihisitevisitriparianzonecomponent ihisitevisitriparianzonecomponent_sitevisitid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY ihisitevisitriparianzonecomponent
    ADD CONSTRAINT ihisitevisitriparianzonecomponent_sitevisitid_fkey FOREIGN KEY (sitevisitid) REFERENCES sitevisit(sitevisitid);


--
-- Name: reach reach_drainageregionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY reach
    ADD CONSTRAINT reach_drainageregionid_fkey FOREIGN KEY (drainageregionid) REFERENCES drainageregion(drainageregionid);


--
-- Name: reachrivermapping reachrivermapping_riverid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY reachrivermapping
    ADD CONSTRAINT reachrivermapping_riverid_fkey FOREIGN KEY (riverid) REFERENCES river(riverid);


--
-- Name: river river_ownerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY river
    ADD CONSTRAINT river_ownerid_fkey FOREIGN KEY (ownerid) REFERENCES "User"(userid);


--
-- Name: rulerole rulerole_ruleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY rulerole
    ADD CONSTRAINT rulerole_ruleid_fkey FOREIGN KEY (ruleid) REFERENCES "Rule"(ruleid);


--
-- Name: sassbiotope sassbiotope_componentofbiotopeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sassbiotope
    ADD CONSTRAINT sassbiotope_componentofbiotopeid_fkey FOREIGN KEY (componentofbiotopeid) REFERENCES sassbiotope(sassbiotopeid);


--
-- Name: site site_catchmentsecondaryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_catchmentsecondaryid_fkey FOREIGN KEY (catchmentsecondaryid) REFERENCES catchmentsecondary(catchmentsecondaryid);


--
-- Name: site site_ecoregion2id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_ecoregion2id_fkey FOREIGN KEY (ecoregion2id) REFERENCES ecoregion2(ecoregion2id);


--
-- Name: site site_ecoregionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_ecoregionid_fkey FOREIGN KEY (ecoregionid) REFERENCES ecoregion(ecoregionid);


--
-- Name: site site_geologyid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_geologyid_fkey FOREIGN KEY (geologyid) REFERENCES geology(geologyid);


--
-- Name: site site_quaternarycatchmentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_quaternarycatchmentid_fkey FOREIGN KEY (quaternarycatchmentid) REFERENCES quaternarycatchment(quaternarycatchmentid);


--
-- Name: site site_rainregionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_rainregionid_fkey FOREIGN KEY (rainregionid) REFERENCES rainregion(rainregionid);


--
-- Name: site site_regionbioid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_regionbioid_fkey FOREIGN KEY (regionbioid) REFERENCES regionbio(regionbioid);


--
-- Name: site site_regionpolid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_regionpolid_fkey FOREIGN KEY (regionpolid) REFERENCES regionpol(regionpolid);


--
-- Name: site site_riverid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_riverid_fkey FOREIGN KEY (riverid) REFERENCES river(riverid);


--
-- Name: site site_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_userid_fkey FOREIGN KEY (userid) REFERENCES "User"(userid);


--
-- Name: site site_watermanagementareaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_watermanagementareaid_fkey FOREIGN KEY (watermanagementareaid) REFERENCES watermanagementarea(watermanagementareaid);


--
-- Name: sitegis sitegis_siteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitegis
    ADD CONSTRAINT sitegis_siteid_fkey FOREIGN KEY (siteid) REFERENCES site(siteid);


--
-- Name: sitevisit sitevisit_canopycoverid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisit
    ADD CONSTRAINT sitevisit_canopycoverid_fkey FOREIGN KEY (canopycoverid) REFERENCES canopycover(canopycoverid);


--
-- Name: sitevisit sitevisit_siteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisit
    ADD CONSTRAINT sitevisit_siteid_fkey FOREIGN KEY (siteid) REFERENCES site(siteid);


--
-- Name: sitevisit sitevisit_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisit
    ADD CONSTRAINT sitevisit_userid_fkey FOREIGN KEY (userid) REFERENCES "User"(userid);


--
-- Name: sitevisit sitevisit_waterturbidityid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisit
    ADD CONSTRAINT sitevisit_waterturbidityid_fkey FOREIGN KEY (waterturbidityid) REFERENCES waterturbidity(waterturbidityid);


--
-- Name: sitevisitbiotopetaxon sitevisitbiotopetaxon_sassbiotopeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitbiotopetaxon
    ADD CONSTRAINT sitevisitbiotopetaxon_sassbiotopeid_fkey FOREIGN KEY (sassbiotopeid) REFERENCES sassbiotope(sassbiotopeid);


--
-- Name: sitevisitchem sitevisitchem_sitevisitid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitchem
    ADD CONSTRAINT sitevisitchem_sitevisitid_fkey FOREIGN KEY (sitevisitid) REFERENCES sitevisit(sitevisitid);


--
-- Name: sitevisitsassbiotope sitevisitsassbiotope_biotopefraction_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitsassbiotope
    ADD CONSTRAINT sitevisitsassbiotope_biotopefraction_fkey FOREIGN KEY (biotopefraction) REFERENCES rate(rateid);


--
-- Name: sitevisitsassbiotope sitevisitsassbiotope_sassbiotopeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitsassbiotope
    ADD CONSTRAINT sitevisitsassbiotope_sassbiotopeid_fkey FOREIGN KEY (sassbiotopeid) REFERENCES sassbiotope(sassbiotopeid);


--
-- Name: sitevisitsassbiotope sitevisitsassbiotope_sitevisitid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitsassbiotope
    ADD CONSTRAINT sitevisitsassbiotope_sitevisitid_fkey FOREIGN KEY (sitevisitid) REFERENCES sitevisit(sitevisitid);


--
-- Name: sitevisitstreamdimension sitevisitstreamdimension_sitevisitid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitstreamdimension
    ADD CONSTRAINT sitevisitstreamdimension_sitevisitid_fkey FOREIGN KEY (sitevisitid) REFERENCES sitevisit(sitevisitid);


--
-- Name: sitevisitstreamdimension sitevisitstreamdimension_streamdimensioncategoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitstreamdimension
    ADD CONSTRAINT sitevisitstreamdimension_streamdimensioncategoryid_fkey FOREIGN KEY (streamdimensioncategoryid) REFERENCES streamdimensioncategory(streamdimensioncategoryid);


--
-- Name: sitevisitstreamdimension sitevisitstreamdimension_streamdimensionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisitstreamdimension
    ADD CONSTRAINT sitevisitstreamdimension_streamdimensionid_fkey FOREIGN KEY (streamdimensionid) REFERENCES streamdimension(streamdimensionid);


--
-- Name: sitevisittaxon sitevisittaxon_sitevisitid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisittaxon
    ADD CONSTRAINT sitevisittaxon_sitevisitid_fkey FOREIGN KEY (sitevisitid) REFERENCES sitevisit(sitevisitid);


--
-- Name: sitevisittaxon sitevisittaxon_taxonid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY sitevisittaxon
    ADD CONSTRAINT sitevisittaxon_taxonid_fkey FOREIGN KEY (taxonid) REFERENCES taxon(taxonid);


--
-- Name: taxon taxon_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY taxon
    ADD CONSTRAINT taxon_groupid_fkey FOREIGN KEY (groupid) REFERENCES "Group"(groupid);


--
-- Name: userrole userrole_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_roleid_fkey FOREIGN KEY (roleid) REFERENCES "Role"(roleid);


--
-- Name: userrole userrole_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_userid_fkey FOREIGN KEY (userid) REFERENCES "User"(userid);


--
-- Name: usersassvalidation usersassvalidation_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: timlinux
--

ALTER TABLE ONLY usersassvalidation
    ADD CONSTRAINT usersassvalidation_userid_fkey FOREIGN KEY (userid) REFERENCES assessor(assessorid);


SET search_path = sites, pg_catalog;

--
-- Name: formulagroup formulagroup_formulaid_fkey; Type: FK CONSTRAINT; Schema: sites; Owner: timlinux
--

ALTER TABLE ONLY formulagroup
    ADD CONSTRAINT formulagroup_formulaid_fkey FOREIGN KEY (formulaid) REFERENCES public.formula(formulaid);


--
-- Name: public; Type: ACL; Schema: -; Owner: timlinux
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM timlinux;
GRANT ALL ON SCHEMA public TO timlinux;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

