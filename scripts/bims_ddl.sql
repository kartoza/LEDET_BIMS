create table spatial_ref_sys
(
	srid integer not null
		constraint spatial_ref_sys_pkey
			primary key
		constraint spatial_ref_sys_srid_check
			check ((srid > 0) AND (srid <= 998999)),
	auth_name varchar(256),
	auth_srid integer,
	srtext varchar(2048),
	proj4text varchar(2048)
)
;

create table researcher
(
	id integer not null
		constraint researcher_key
			primary key,
	researcher_full_name varchar(100) not null
		constraint researcher_researcher_full_name_key
			unique,
	title varchar(100) not null
		constraint researcher_title_key
			unique,
	first_name varchar(100),
	surname varchar(100),
	institution varchar(200) not null
		constraint researcher_institution_key
			unique,
	postal_address varchar(255),
	physical_address varchar(255),
	telephone integer,
	fax_number integer,
	mobile_number integer,
	email varchar(255),
	country varchar(255)
)
;

create table research_field
(
	id integer not null
		constraint research_field_id_key
			primary key,
	category varchar(100) not null
		constraint research_field_category_key
			unique
)
;

create table applicant_title
(
	applicant_id integer not null
		constraint applicant_title_key
			primary key,
	title varchar(100) not null
		constraint applicant_title_title_key
			unique
		constraint applicant_title_title_fkey
			references researcher (title)
)
;

create table institution
(
	institution_id integer not null
		constraint institution_key
			primary key,
	institution varchar(100) not null
		constraint institution_institution_key
			unique
		constraint institution_institution_fkey
			references researcher (institution)
)
;

create table kingdom
(
	kingdom_id integer not null
		constraint kingdom_key
			primary key,
	kingdom_name varchar(100) not null
		constraint kingdom_kingdom_name_key
			unique
)
;

create table phylum
(
	phylum_id integer not null
		constraint phylum_key
			primary key,
	phylum_name varchar(100) not null
		constraint phylum_phylum_name_key
			unique,
	kingdom varchar(100) not null
		constraint phylum_kingdom_fkey
			references kingdom (kingdom_name)
)
;

create table class
(
	class_id integer not null
		constraint class_key
			primary key,
	class varchar(100) not null
		constraint class_class_key
			unique,
	phylum varchar(100) not null
		constraint class_phylum_fkey
			references phylum (phylum_name)
)
;

create table "order"
(
	order_id integer not null
		constraint order_key
			primary key,
	order_name varchar(100) not null
		constraint order_order_name_key
			unique,
	class_name varchar(100) not null
		constraint order_class_name_fkey
			references class (class)
)
;

create table family
(
	id integer not null
		constraint family_key
			primary key,
	family varchar(100) not null
		constraint family_family_key
			unique,
	order_name varchar(100) not null
		constraint family_order_name_fkey
			references "order" (order_name)
)
;

create table cites_listings
(
	cites_id integer not null
		constraint cites_listings_key
			primary key,
	cites_status varchar(100) not null
		constraint cites_listings_cites_status_key
			unique
)
;

create table iucn_status
(
	iucn_id integer not null
		constraint iucn_status_key
			primary key,
	iucn_status varchar(100) not null
		constraint iucn_status_iucn_status_key
			unique
)
;

create table nature_reserves
(
	nature_id integer not null
		constraint nature_reserves_key
			primary key,
	nature_reserve_name varchar(100) not null
		constraint nature_reserves_nature_reserve_name_key
			unique,
	shortened_name varchar(100),
	reserve_manager varchar(100),
	telephone integer,
	fax integer,
	email varchar(100),
	reserver_address varchar(255)
)
;

create table biblio
(
	id integer not null
		constraint biblio_key
			primary key,
	title varchar(100) not null
		constraint biblio_title_key
			unique,
	year_of_publication date,
	publication_type varchar(100)
)
;

create table taxon
(
	taxon_id integer not null
		constraint taxon_key
			primary key,
	taxon_name varchar(100) not null
		constraint taxon_taxon_name_key
			unique,
	image varchar(200),
	identification varchar(255),
	family varchar(100) not null
		constraint taxon_family_fkey
			references family (family),
	genus varchar(100),
	species varchar(100),
	sub_species varchar(100),
	describer varchar(100),
	year_described date,
	taxanomy_notes varchar(255),
	undescribed_taxon boolean default false,
	common_name varchar(100),
	alternative_name varchar(100),
	descrition varchar(255),
	distribution varchar(255),
	habitat varchar(255),
	biology_and_breeding varchar(255),
	conservation varchar(255),
	cites_status varchar(100) not null
		constraint taxon_cites_status_fkey
			references cites_listings (cites_status),
	cites_details varchar(255),
	iucn_status_international varchar(100) not null
		constraint taxon_iucn_status_international_fkey
			references iucn_status (iucn_status),
	iucn_status_national varchar(100) not null
		constraint taxon_iucn_status_national_fkey
			references iucn_status (iucn_status),
	iucn_status_limpopo varchar(100) not null
		constraint taxon_iucn_status_limpopo_fkey
			references iucn_status (iucn_status),
	provincial_reserves varchar(100) not null
		constraint taxon_provincial_reserves_fkey
			references nature_reserves (nature_reserve_name),
	bibliography varchar(100) not null
		constraint taxon_bibliography_fkey
			references biblio (title),
	links varchar(100)
)
;

create table record_type
(
	record_id integer not null
		constraint record_type_key
			primary key,
	node_id integer,
	record_type varchar(100) not null
		constraint record_type_record_type_key
			unique
)
;

create table locality_method
(
	locality_id integer not null
		constraint locality_method_key
			primary key,
	node_id integer not null,
	locality_method varchar(100) not null
		constraint locality_method_locality_method_key
			unique
)
;

create table province
(
	province_id integer not null
		constraint province_key
			primary key,
	province_name varchar(100) not null
)
;

create table district_municipality
(
	district_id integer not null
		constraint district_municipality_key
			primary key,
	district_name varchar(100) not null,
	province_id integer
		constraint district_municipality_province_provincial_id_fk
			references province
)
;

create table local_municipality
(
	municipal_id integer not null
		constraint local_municipality_key
			primary key,
	municipal_name varchar(100) not null
		constraint local_municipality_municipal_name_key
			unique,
	district_id integer
		constraint local_municipality_district_municipality_district_id_fk
			references district_municipality
)
;

create table physiognomy
(
	phys_id integer not null
		constraint physiognomy_key
			primary key,
	node_id varchar(100),
	physiognomy varchar(100) not null
		constraint physiognomy_physiognomy_key
			unique
)
;

create table farm_portion
(
	portion_id integer not null
		constraint farm_portion_key
			primary key,
	geom geometry(MultiPolygon,4326),
	comments varchar(120),
	id varchar(60) not null
		constraint farm_portion_id_key
			unique,
	production_year date
)
;

create table farms
(
	geom geometry(MultiPolygon,4326),
	id integer not null
		constraint farms_id_key
			unique
)
;

create table land_status
(
	land_id integer not null,
	category varchar(50) not null
		constraint land_status_category_key
			unique
)
;

create table protected_area
(
	id integer not null
		constraint protected_area_id_key
			unique,
	name varchar(100) not null
)
;

create table research_application
(
	application_id integer not null
		constraint research_application_key
			primary key,
	project_title varchar(100),
	refererence_number varchar(50),
	category varchar not null
		constraint research_application_category_key
			unique
		constraint research_application_category_fkey
			references research_field (category),
	application_date date not null,
	date_recieved date not null,
	principal_investigator varchar(100) not null
		constraint research_application_principal_investigator_fkey
			references researcher (researcher_full_name),
	co_workers varchar(100) not null
		constraint research_application_co_workers_fkey
			references researcher (researcher_full_name),
	biodeversity_recomendation varchar(255),
	taxanomy varchar(100) not null
		constraint research_application_taxanomy_fkey
			references taxon (taxon_name),
	"references" varchar(100) not null
		constraint research_application_references_fkey
			references biblio (title)
)
;

create table taxon_distribution
(
	distribution_date date,
	distribution_time date,
	field_number varchar(100),
	museum_number varchar(100),
	taxon varchar(100) not null
		constraint taxon_distribution_taxon_fkey
			references taxon (taxon_name),
	record_type varchar(100) not null
		constraint taxon_distribution_record_type_fkey
			references record_type (record_type),
	geom geometry(MultiPoint,4326),
	altitude integer,
	latitude double precision,
	longitude double precision,
	location varchar(100),
	qds varchar(100),
	locality_method varchar(100) not null
		constraint taxon_distribution_locality_method_fkey
			references locality_method (locality_method),
	observer varchar(100),
	accessioned_by varchar(100),
	remarks varchar(100),
	abuadance integer,
	abuadance_unit varchar(100),
	image varchar(100),
	data_evaluated boolean default false,
	evaluator varchar(100),
	evaluation_notes varchar(100),
	local_municipality varchar(100) not null
		constraint taxon_distribution_local_municipality_fkey
			references local_municipality (municipal_name),
	farm integer not null
		constraint taxon_distribution_farm_fkey
			references farms (id),
	farm_portion varchar(60) not null
		constraint taxon_distribution_farm_portion_fkey
			references farm_portion (id),
	eds varchar(100),
	pentad varchar(100),
	protected_area integer
		constraint taxon_distribution_protected_area_fkey
			references protected_area (id),
	physiognomy varchar(100) not null
		constraint taxon_distribution_physiognomy_fkey
			references physiognomy (physiognomy),
	land_status varchar(50)
		constraint taxon_distribution_land_status_fkey
			references land_status (category)
)
;


