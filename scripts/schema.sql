CREATE TABLE researcher
(
  id                   INTEGER                       NOT NULL,
  researcher_full_name CHARACTER VARYING(100) UNIQUE NOT NULL,
  title                CHARACTER VARYING(100) UNIQUE NOT NULL,
  first_name           CHARACTER VARYING(100),
  surname              CHARACTER VARYING(100),
  institution          CHARACTER VARYING(200) UNIQUE NOT NULL,
  postal_address       CHARACTER VARYING(255),
  physical_address     CHARACTER VARYING(255),
  telephone            INTEGER,
  fax_number           INTEGER,
  mobile_number        INTEGER,
  email                CHARACTER VARYING(255),
  country              CHARACTER VARYING(255),
  CONSTRAINT researcher_key PRIMARY KEY (id)
);

CREATE TABLE research_field
(
  id       INTEGER                       NOT NULL,
  category CHARACTER VARYING(100) UNIQUE NOT NULL,
  CONSTRAINT research_field_id_key PRIMARY KEY (id)
);

CREATE TABLE applicant_title
(
  applicant_id INTEGER                       NOT NULL,
  title        CHARACTER VARYING(100) UNIQUE NOT NULL REFERENCES researcher (title),
  CONSTRAINT applicant_title_key PRIMARY KEY (applicant_id)
);

CREATE TABLE institution
(
  institution_id INTEGER                       NOT NULL,
  institution    CHARACTER VARYING(100) UNIQUE NOT NULL REFERENCES researcher (institution),
  CONSTRAINT institution_key PRIMARY KEY (institution_id)
);


CREATE TABLE kingdom
(
  kingdom_id   INTEGER                NOT NULL,
  kingdom_name CHARACTER VARYING(100) NOT NULL unique,
  CONSTRAINT kingdom_key PRIMARY KEY (kingdom_id)
);


CREATE TABLE phylum
(
  phylum_id   INTEGER                NOT NULL,
  phylum_name CHARACTER VARYING(100) NOT NULL unique,
  kingdom     CHARACTER VARYING(100) NOT NULL REFERENCES kingdom (kingdom_name),
  CONSTRAINT phylum_key PRIMARY KEY (phylum_id)
);

create table class
(
  class_id INTEGER                NOT NULL,
  class    CHARACTER VARYING(100) NOT NULL UNIQUE,
  phylum   CHARACTER VARYING(100) NOT NULL REFERENCES phylum (phylum_name),
  CONSTRAINT class_key PRIMARY KEY (class_id)
);

create table "order"
(
  order_id   INTEGER                NOT NULL,
  order_name CHARACTER VARYING(100) NOT NULL  UNIQUE,
  class_name CHARACTER VARYING(100) NOT NULL REFERENCES class (class),
  CONSTRAINT order_key PRIMARY KEY (order_id)
);

create table family
(
  id         INTEGER                NOT NULL,
  family     CHARACTER VARYING(100) NOT NULL UNIQUE,
  order_name CHARACTER VARYING(100) NOT NULL REFERENCES "order" (order_name),
  CONSTRAINT family_key PRIMARY KEY (id)
);

create table cites_listings
(
  cites_id     INTEGER                NOT NULL,
  cites_status CHARACTER VARYING(100) NOT NULL UNIQUE,
  CONSTRAINT cites_listings_key PRIMARY KEY (cites_id)

);

create table iucn_status
(
  iucn_id     INTEGER                NOT NULL,
  iucn_status CHARACTER VARYING(100) NOT NULL unique,
  CONSTRAINT iucn_status_key PRIMARY KEY (iucn_id)
);

create table "nature_reserves"
(
  nature_id           INTEGER                NOT NULL,
  nature_reserve_name CHARACTER VARYING(100) NOT NULL UNIQUE,
  shortened_name      CHARACTER VARYING(100),
  reserve_manager     CHARACTER VARYING(100),
  telephone           INTEGER,
  fax                 INTEGER,
  email               CHARACTER VARYING(100),
  reserver_address    CHARACTER VARYING(255),
  CONSTRAINT nature_reserves_key PRIMARY KEY (nature_id)

);

create table biblio
(
  id                  INTEGER                NOT NULL,
  title               CHARACTER VARYING(100) not null UNIQUE,
  year_of_publication date,
  publication_type    CHARACTER VARYING(100),
  CONSTRAINT biblio_key PRIMARY KEY (id)
);

create table taxon
(
  taxon_id                  INTEGER                NOT NULL,
  taxon_name                CHARACTER VARYING(100) NOT NULL UNIQUE,
  image                     CHARACTER VARYING(200),
  identification            CHARACTER VARYING(255),
  family                    CHARACTER VARYING(100) NOT NULL REFERENCES family (family),
  genus                     CHARACTER VARYING(100),
  species                   CHARACTER VARYING(100),
  sub_species               CHARACTER VARYING(100),
  describer                 CHARACTER VARYING(100),
  year_described            date,
  taxanomy_notes            CHARACTER VARYING(255),
  undescribed_taxon         BOOLEAN DEFAULT FALSE,
  common_name               CHARACTER VARYING(100),
  alternative_name          CHARACTER VARYING(100),
  descrition                CHARACTER VARYING(255),
  distribution              CHARACTER VARYING(255),
  habitat                   CHARACTER VARYING(255),
  biology_and_breeding      CHARACTER VARYING(255),
  conservation              CHARACTER VARYING(255),
  cites_status              CHARACTER VARYING(100) NOT NULL REFERENCES cites_listings (cites_status),
  cites_details             CHARACTER VARYING(255),
  iucn_status_international CHARACTER VARYING(100) NOT NULL REFERENCES iucn_status (iucn_status),
  iucn_status_national      CHARACTER VARYING(100) NOT NULL REFERENCES iucn_status (iucn_status),
  iucn_status_limpopo       CHARACTER VARYING(100) NOT NULL REFERENCES iucn_status (iucn_status),
  provincial_reserves       CHARACTER VARYING(100) NOT NULL REFERENCES nature_reserves (nature_reserve_name),
  bibliography              CHARACTER VARYING(100) NOT NULL REFERENCES biblio (title),
  links                     CHARACTER VARYING(100),
  CONSTRAINT taxon_key PRIMARY KEY (taxon_id)
);

create table record_type
(
  record_id   INTEGER                NOT NULL,
  node_id     INTEGER,
  record_type CHARACTER VARYING(100) NOT NULL UNIQUE,
  CONSTRAINT record_type_key PRIMARY KEY (record_id)
);

create table locality_method
(
  locality_id     INTEGER                NOT NULL,
  node_id         INTEGER                NOT NULL,
  locality_method CHARACTER VARYING(100) NOT NULL unique,
  CONSTRAINT locality_method_key PRIMARY KEY (locality_id)
);

create table province
(
  provincial_id INTEGER                NOT NULL,
  province_name CHARACTER VARYING(100) NOT NULL UNIQUE,
  CONSTRAINT province_key PRIMARY KEY (provincial_id)
);

create table district_municipality
(
  district_id   INTEGER                NOT NULL,
  district_name CHARACTER VARYING(100) NOT NULL UNIQUE,
  province_name CHARACTER VARYING(100) NOT NULL REFERENCES province (province_name),
  CONSTRAINT district_municipality_key PRIMARY KEY (district_id)
);

create table local_municipality
(
  municipal_id               INTEGER                NOT NULL,
  municipal_name             CHARACTER VARYING(100) not null UNIQUE,
  district_numicipality_name CHARACTER VARYING(100) NOT NULL REFERENCES district_municipality (district_name),
  CONSTRAINT local_municipality_key primary key (municipal_id)
);

create table physiognomy
(
  phys_id     INTEGER                NOT NULL,
  node_id     CHARACTER VARYING(100),
  physiognomy CHARACTER VARYING(100) NOT NULL unique,
  CONSTRAINT physiognomy_key PRIMARY KEY (phys_id)
);

-- we will load this table from our database
CREATE TABLE farm_portion
(
  portion_id      INTEGER               NOT NULL,
  geom            geometry(Multipolygon, 4326),
  comments        CHARACTER VARYING(120),
  id              CHARACTER VARYING(60) NOT NULL UNIQUE,
  production_year date,
  CONSTRAINT farm_portion_key PRIMARY KEY (portion_id)
);

CREATE TABLE farms
(
  geom geometry(MultiPolygon, 4326),
  id   integer NOT NULL UNIQUE

);

CREATE TABLE land_status
(
  land_id  INTEGER               NOT NULL,
  category character varying(50) NOT NULL UNIQUE
);

CREATE TABLE protected_area
(
  id   INTEGER                NOT NULL UNIQUE,
  name CHARACTER VARYING(100) NOT NULL
);

CREATE TABLE research_application
(
  application_id             INTEGER                  NOT NULL,
  project_title              CHARACTER VARYING(100),
  refererence_number         CHARACTER VARYING(50),
  category                   CHARACTER VARYING UNIQUE NOT NULL REFERENCES research_field (category),
  application_date           date                     NOT NULL,
  date_recieved              date                     NOT NULL,
  principal_investigator     CHARACTER VARYING(100)   NOT NULL REFERENCES researcher (researcher_full_name),
  co_workers                 CHARACTER VARYING(100)   NOT NULL REFERENCES researcher (researcher_full_name),
  biodeversity_recomendation CHARACTER VARYING(255),
  taxanomy                   CHARACTER VARYING(100)   NOT NULL REFERENCES taxon (taxon_name),
  "references"               CHARACTER VARYING(100)   NOT NULL REFERENCES biblio (title),
  CONSTRAINT research_application_key PRIMARY KEY (application_id)
);

create table taxon_distribution
(
  distribution_date  date,
  distribution_time  date,
  field_number       CHARACTER VARYING(100),
  museum_number      CHARACTER VARYING(100),
  taxon              CHARACTER VARYING(100) NOT NULL REFERENCES taxon (taxon_name),
  record_type        CHARACTER VARYING(100) NOT NULL REFERENCES record_type (record_type),
  geom               geometry(MultiPoint, 4326),
  altitude           INTEGER,
  latitude           double precision,
  longitude          double precision,
  location           CHARACTER VARYING(100),
  qds                CHARACTER VARYING(100),
  locality_method    CHARACTER VARYING(100) NOT NULL REFERENCES locality_method (locality_method),
  observer           CHARACTER VARYING(100),
  accessioned_by     CHARACTER VARYING(100),
  remarks            CHARACTER VARYING(100),
  abuadance          INTEGER,
  abuadance_unit     CHARACTER VARYING(100),
  image              CHARACTER VARYING(100),
  data_evaluated     BOOLEAN DEFAULT FALSE,
  evaluator          CHARACTER VARYING(100),
  evaluation_notes   CHARACTER VARYING(100),
  local_municipality CHARACTER VARYING(100) NOT NULL REFERENCES local_municipality (municipal_name),
  farm               INTEGER                NOT NULL REFERENCES farms (id),
  farm_portion       CHARACTER VARYING(60)  NOT NULL REFERENCES farm_portion (id),
  eds                CHARACTER VARYING(100),
  pentad             CHARACTER VARYING(100),
  protected_area     INTEGER REFERENCES protected_area (id),
  physiognomy        CHARACTER VARYING(100) NOT NULL REFERENCES physiognomy (physiognomy),
  land_status        CHARACTER VARYING(50) REFERENCES land_status (category)
);


