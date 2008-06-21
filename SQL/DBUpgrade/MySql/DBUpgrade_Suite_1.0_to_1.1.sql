/*Create table and constraints*/
create table CATISSUE_ABSTRACT_POSITION (
	IDENTIFIER BIGINT not null auto_increment,
	POSITION_DIMENSION_ONE INTEGER,
	POSITION_DIMENSION_TWO INTEGER,
	primary key (IDENTIFIER)
)ENGINE = INNODB DEFAULT CHARSET = utf8;


create table CATISSUE_SPECIMEN_POSITION(
	IDENTIFIER BIGINT not null auto_increment,
	SPECIMEN_ID BIGINT,
	CONTAINER_ID BIGINT,
	primary key (IDENTIFIER),
	index FK_SPECIMEN_POSITION (IDENTIFIER),
	constraint FK_SPECIMEN_POSITION foreign key (IDENTIFIER) references CATISSUE_ABSTRACT_POSITION (IDENTIFIER),
	index FK_SPECIMEN (SPECIMEN_ID),
	constraint FK_SPECIMEN foreign key (SPECIMEN_ID) references CATISSUE_SPECIMEN (IDENTIFIER),
	index FK_STORAGE_CONTAINER (CONTAINER_ID),
	constraint FK_STORAGE_CONTAINER foreign key (CONTAINER_ID) references CATISSUE_STORAGE_CONTAINER (IDENTIFIER)
)ENGINE = INNODB DEFAULT CHARSET = utf8;


create table CATISSUE_CONTAINER_POSITION(
	IDENTIFIER BIGINT not null auto_increment,
	PARENT_CONTAINER_ID bigint,
	CONTAINER_ID BIGINT,
	primary key (IDENTIFIER),
	index FK_CONTAINER_POSITION (IDENTIFIER), 
	constraint FK_CONTAINER_POSITION foreign key (IDENTIFIER) references CATISSUE_ABSTRACT_POSITION (IDENTIFIER),
	index FK_CONTAINER (CONTAINER_ID),
	constraint FK_CONTAINER foreign key (CONTAINER_ID) references CATISSUE_CONTAINER (IDENTIFIER),
	index FK_OCCUPIED_CONTAINER (PARENT_CONTAINER_ID),
	constraint FK_OCCUPIED_CONTAINER foreign key (PARENT_CONTAINER_ID) references CATISSUE_CONTAINER (IDENTIFIER)
)ENGINE = INNODB DEFAULT CHARSET = utf8;


/*Temperory modify CATISSUE_ABSTRACT_POSITION to capture all SPECIMEN_POSITION DATA*/
ALTER TABLE CATISSUE_ABSTRACT_POSITION ADD SPECIMEN_ID BIGINT;
ALTER TABLE CATISSUE_ABSTRACT_POSITION ADD CONTAINER_ID BIGINT;
ALTER TABLE CATISSUE_ABSTRACT_POSITION ADD IS_SPECIMEN BIGINT;

/**Insert data of specimen*/
insert into CATISSUE_ABSTRACT_POSITION(SPECIMEN_ID,CONTAINER_ID,POSITION_DIMENSION_ONE,POSITION_DIMENSION_TWO,IS_SPECIMEN) select identifier,storage_container_identifier,position_dimension_one,position_dimension_two,1 from catissue_specimen where is_coll_prot_req=0 and activity_status in ('Active','Closed') and storage_container_identifier is not null and POSITION_DIMENSION_ONE is not null and POSITION_DIMENSION_TWO is not null ;
insert into CATISSUE_SPECIMEN_POSITION(IDENTIFIER,SPECIMEN_ID,CONTAINER_ID) select IDENTIFIER,SPECIMEN_ID,CONTAINER_ID FROM CATISSUE_ABSTRACT_POSITION;


/* drop Temperory columns from CATISSUE_ABSTRACT_POSITION*/
ALTER TABLE CATISSUE_ABSTRACT_POSITION DROP SPECIMEN_ID;
ALTER TABLE CATISSUE_ABSTRACT_POSITION DROP CONTAINER_ID;


/*Temperory modify CATISSUE_ABSTRACT_POSITION to capture all CONTAINER_POSITION DATA*/
ALTER TABLE CATISSUE_ABSTRACT_POSITION ADD PARENT_CONTAINER_ID BIGINT;
ALTER TABLE CATISSUE_ABSTRACT_POSITION ADD CONTAINER_ID BIGINT;

/*insert Storage container*/
insert into CATISSUE_ABSTRACT_POSITION(PARENT_CONTAINER_ID,CONTAINER_ID,POSITION_DIMENSION_ONE,POSITION_DIMENSION_TWO,IS_SPECIMEN) select a.parent_container_id,a.identifier,a.position_dimension_one,a.position_dimension_two,0 from catissue_container a join catissue_storage_container b on a.identifier=b.identifier where activity_status in ('Active','Closed') and POSITION_DIMENSION_ONE is not null and POSITION_DIMENSION_TWO is not null and PARENT_CONTAINER_ID is not null;
insert into CATISSUE_CONTAINER_POSITION(IDENTIFIER,PARENT_CONTAINER_ID,CONTAINER_ID) select IDENTIFIER,PARENT_CONTAINER_ID,CONTAINER_ID FROM CATISSUE_ABSTRACT_POSITION where IS_SPECIMEN=0;


/*insert Specimen array*/
insert into CATISSUE_ABSTRACT_POSITION(CONTAINER_ID,PARENT_CONTAINER_ID,POSITION_DIMENSION_ONE,POSITION_DIMENSION_TWO,IS_SPECIMEN) select a.identifier,b.storage_container_id,position_dimension_one,position_dimension_two,2 from catissue_container a, catissue_specimen_array b where a.identifier=b.identifier and a.activity_status in ('Active','Closed')and a.POSITION_DIMENSION_ONE is not null and a.POSITION_DIMENSION_TWO is not null and b.storage_container_id is not null;
insert into CATISSUE_CONTAINER_POSITION(IDENTIFIER,PARENT_CONTAINER_ID,CONTAINER_ID) select IDENTIFIER,PARENT_CONTAINER_ID,CONTAINER_ID FROM CATISSUE_ABSTRACT_POSITION where IS_SPECIMEN=2;

/* drop Temperory columns from CATISSUE_ABSTRACT_POSITION*/
ALTER TABLE CATISSUE_ABSTRACT_POSITION DROP PARENT_CONTAINER_ID;
ALTER TABLE CATISSUE_ABSTRACT_POSITION DROP CONTAINER_ID;
ALTER TABLE CATISSUE_ABSTRACT_POSITION DROP IS_SPECIMEN;

/*Drop columns from existing table*/
ALTER TABLE CATISSUE_CONTAINER DROP foreign key FK49B8DE5DB097B2E;
ALTER TABLE CATISSUE_SPECIMEN_ARRAY DROP foreign key FKECBF8B3EB3DFB11D;
ALTER TABLE CATISSUE_SPECIMEN DROP foreign key FK1674810432B31EAB;

ALTER TABLE CATISSUE_SPECIMEN DROP POSITION_DIMENSION_ONE;
ALTER TABLE CATISSUE_SPECIMEN DROP POSITION_DIMENSION_TWO;
ALTER TABLE CATISSUE_SPECIMEN DROP STORAGE_CONTAINER_IDENTIFIER;
ALTER TABLE CATISSUE_CONTAINER DROP POSITION_DIMENSION_ONE;
ALTER TABLE CATISSUE_CONTAINER DROP POSITION_DIMENSION_TWO;
ALTER TABLE CATISSUE_CONTAINER DROP PARENT_CONTAINER_ID;
ALTER TABLE CATISSUE_SPECIMEN_ARRAY DROP STORAGE_CONTAINER_ID;

--Insert CSM scripts
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'AbstractPosition','AbstractPosition Object','edu.wustl.catissuecore.domain.AbstractPosition',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'SpecimenPosition','SpecimenPosition Object','edu.wustl.catissuecore.domain.SpecimenPosition',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'ContainerPosition','ContainerPosition Object','edu.wustl.catissuecore.domain.ContainerPosition',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;

INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='AbstractPosition'),'2008-05-28' from CSM_PG_PE;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='SpecimenPosition'),'2008-05-28' from CSM_PG_PE;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='ContainerPosition'),'2008-05-28' from CSM_PG_PE;

/**Added a workaround so that edit of Container,specimen should work. NEED TO REMOVE */
ALTER TABLE CATISSUE_SPECIMEN ADD POSITION_DIMENSION_ONE integer;
ALTER TABLE CATISSUE_SPECIMEN ADD POSITION_DIMENSION_TWO integer;
ALTER TABLE CATISSUE_SPECIMEN ADD STORAGE_CONTAINER_IDENTIFIER bigint;
ALTER TABLE CATISSUE_CONTAINER ADD POSITION_DIMENSION_ONE integer;
ALTER TABLE CATISSUE_CONTAINER ADD POSITION_DIMENSION_TWO integer;
ALTER TABLE CATISSUE_CONTAINER ADD PARENT_CONTAINER_ID bigint;
ALTER TABLE CATISSUE_SPECIMEN_ARRAY ADD STORAGE_CONTAINER_ID bigint;

/*Distribution Protocol*/
create table CATISSUE_DISTRIBUTION_SPEC_REQ (
   IDENTIFIER bigint not null auto_increment,
   SPECIMEN_CLASS varchar(255) not null,
   SPECIMEN_TYPE varchar(50),
   TISSUE_SITE varchar(150),
   PATHOLOGY_STATUS varchar(50),
   QUANTITY double precision,
   DISTRIBUTION_PROTOCOL_ID bigint,
   CONSTRAINT `fk_distribution_protocol` FOREIGN KEY (`DISTRIBUTION_PROTOCOL_ID`) REFERENCES `CATISSUE_DISTRIBUTION_PROTOCOL` (`IDENTIFIER`),
   primary key (IDENTIFIER)
)ENGINE = INNODB DEFAULT CHARSET = utf8;

INSERT INTO CATISSUE_DISTRIBUTION_SPEC_REQ (SPECIMEN_CLASS,SPECIMEN_TYPE,TISSUE_SITE,PATHOLOGY_STATUS,QUANTITY,DISTRIBUTION_PROTOCOL_ID) select sp.IDENTIFIER, 
sp.SPECIMEN_CLASS, sp.SPECIMEN_TYPE, sp.PATHOLOGY_STATUS, q.QUANTITY, dsp.DISTRIBUTION_PROTOCOL_ID from CATISSUE_SPECIMEN_REQUIREMENT sp,
CATISSUE_DISTRIBUTION_SPE_REQ dsp, CATISSUE_QUANTITY q where sp.IDENTIFIER=dsp.SPECIMEN_REQUIREMENT_ID and sp.QUANTITY_ID=q.IDENTIFIER;

ALTER TABLE CATISSUE_SPECI_ARRAY_CONTENT ADD QUANTITY double precision;

UPDATE CATISSUE_SPECI_ARRAY_CONTENT sac set QUANTITY=(select QUANTITY from CATISSUE_QUANTITY q where sac.INITIAL_QUANTITY_ID=q.IDENTIFIER);

ALTER TABLE CATISSUE_DISTRIBUTION_SPE_REQ DROP foreign key FKE34A3688BE10F0CE;
ALTER TABLE CATISSUE_DISTRIBUTION_SPE_REQ DROP foreign key FKE34A36886B1F36E7;
ALTER TABLE CATISSUE_SPECI_ARRAY_CONTENT DROP foreign key FKBEA9D45892AB74B4;

ALTER TABLE CATISSUE_SPECI_ARRAY_CONTENT DROP INITIAL_QUANTITY_ID;
DROP TABLE CATISSUE_DISTRIBUTION_SPE_REQ;

INSERT INTO `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'DistributionSpecimenRequirement','DistributionSpecimenRequirement Object','edu.wustl.catissuecore.domain.DistributionSpecimenRequirement',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='DistributionSpecimenRequirement'),'2008-05-28' from CSM_PG_PE;

/** Specimen Model Related Change */

CREATE TABLE `CATISSUE_ABSTRACT_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,       
     `SPECIMEN_CLASS` varchar(50) NOT NULL default '',
     `SPECIMEN_TYPE` varchar(50) default NULL,                                                                                                                
     `LINEAGE` varchar(50) default NULL,                                                                                                              
     `PATHOLOGICAL_STATUS` varchar(50) default NULL,                                                                                                  
     `PARENT_SPECIMEN_ID` bigint(20) default NULL,                                                                                                    
     `SPECIMEN_CHARACTERISTICS_ID` bigint(20) default NULL,                                                                                           
     `INITIAL_QUANTITY` double default NULL,                                                                                                        
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      KEY `FK1674810456906G39` (`SPECIMEN_CHARACTERISTICS_ID`),                                                                                        
      CONSTRAINT `FK1674810456906G39` FOREIGN KEY (`SPECIMEN_CHARACTERISTICS_ID`) REFERENCES `catissue_specimen_char` (`IDENTIFIER`)                 
); 

CREATE TABLE `CATISSUE_CP_REQ_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,      
     `STORAGE_TYPE` varchar(255) NOT NULL default '',      
	 `COLLECTION_PROTOCOL_EVENT_ID` bigint(20) default NULL,
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      KEY `FK111110456906F39` (`COLLECTION_PROTOCOL_EVENT_ID`),                                                                                        
      CONSTRAINT `FK111110456906F39` FOREIGN KEY (`COLLECTION_PROTOCOL_EVENT_ID`) REFERENCES `catissue_coll_prot_event` (`IDENTIFIER`),
	  CONSTRAINT `FK_PARENT_CP_REQ_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_ABSTRACT_SPECIMEN` (`IDENTIFIER`)
);

CREATE TABLE `CATISSUE_MOL_REQ_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,   
	 `CONCENTRATION` double default NULL,
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_MOL_REQ_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_CP_REQ_SPECIMEN` (`IDENTIFIER`)                 
);

CREATE TABLE `CATISSUE_FLUID_REQ_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,       
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_FLUID_REQ_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_CP_REQ_SPECIMEN` (`IDENTIFIER`)                 
);

CREATE TABLE `CATISSUE_CELL_REQ_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,       
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_CELL_REQ_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_CP_REQ_SPECIMEN` (`IDENTIFIER`)                 
);

CREATE TABLE `CATISSUE_TISSUE_REQ_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,       
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_TISSUE_REQ_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_CP_REQ_SPECIMEN` (`IDENTIFIER`)                 
);

CREATE TABLE `CATISSUE_MOLECULAR_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,  
     `CONCENTRATION` double default NULL,
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_MOLECULAR_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_SPECIMEN` (`IDENTIFIER`)                 
);

CREATE TABLE `CATISSUE_FLUID_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,       
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_FLUID_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_SPECIMEN` (`IDENTIFIER`)                 
);

CREATE TABLE `CATISSUE_CELL_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,       
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_CELL_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_SPECIMEN` (`IDENTIFIER`)                 
);

CREATE TABLE `CATISSUE_TISSUE_SPECIMEN`
(                                                                                                                 
     `IDENTIFIER` bigint(20) NOT NULL auto_increment,       
      PRIMARY KEY  (`IDENTIFIER`),                                                                                                                     
      CONSTRAINT `FK_TISSUE_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_SPECIMEN` (`IDENTIFIER`)                 
); 

INSERT INTO `CATISSUE_ABSTRACT_SPECIMEN`(IDENTIFIER,SPECIMEN_CLASS,SPECIMEN_TYPE,LINEAGE,PATHOLOGICAL_STATUS,PARENT_SPECIMEN_ID,SPECIMEN_CHARACTERISTICS_ID,INITIAL_QUANTITY) SELECT 
IDENTIFIER,SPECIMEN_CLASS,TYPE,LINEAGE,PATHOLOGICAL_STATUS,PARENT_SPECIMEN_ID,SPECIMEN_CHARACTERISTICS_ID,QUANTITY FROM 
CATISSUE_SPECIMEN;

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `CATISSUE_CP_REQ_SPECIMEN`(IDENTIFIER,STORAGE_TYPE,COLLECTION_PROTOCOL_EVENT_ID) SELECT 
IDENTIFIER,POSITION_DIMENSION_ONE,SPECIMEN_COLLECTION_GROUP_ID FROM  CATISSUE_SPECIMEN WHERE IS_COLL_PROT_REQ = 1;

SET FOREIGN_KEY_CHECKS=1;

UPDATE CATISSUE_CP_REQ_SPECIMEN SET STORAGE_TYPE = 'Virtual' where STORAGE_TYPE=0;
UPDATE CATISSUE_CP_REQ_SPECIMEN SET STORAGE_TYPE = 'Auto'  where STORAGE_TYPE=1;
UPDATE CATISSUE_CP_REQ_SPECIMEN SET STORAGE_TYPE = 'Manual' where STORAGE_TYPE=2;

INSERT INTO `CATISSUE_MOL_REQ_SPECIMEN`(IDENTIFIER,CONCENTRATION) SELECT IDENTIFIER,CONCENTRATION FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Molecular' AND IS_COLL_PROT_REQ = 1;
INSERT INTO `CATISSUE_FLUID_REQ_SPECIMEN`(IDENTIFIER) SELECT  IDENTIFIER FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Fluid' AND  IS_COLL_PROT_REQ = 1;
INSERT INTO `CATISSUE_CELL_REQ_SPECIMEN`(IDENTIFIER) SELECT  IDENTIFIER FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Cell' AND  IS_COLL_PROT_REQ = 1;
INSERT INTO `CATISSUE_TISSUE_REQ_SPECIMEN`(IDENTIFIER) SELECT IDENTIFIER FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Tissue' AND  IS_COLL_PROT_REQ = 1;
INSERT INTO `CATISSUE_MOLECULAR_SPECIMEN`(IDENTIFIER,CONCENTRATION) SELECT IDENTIFIER,CONCENTRATION FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Molecular' AND  (IS_COLL_PROT_REQ IS NULL OR IS_COLL_PROT_REQ =0) ;
INSERT INTO `CATISSUE_FLUID_SPECIMEN`(IDENTIFIER) SELECT IDENTIFIER FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Fluid'  AND  (IS_COLL_PROT_REQ IS NULL OR IS_COLL_PROT_REQ =0) ;
INSERT INTO `CATISSUE_CELL_SPECIMEN`(IDENTIFIER) SELECT IDENTIFIER FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Cell'  AND  (IS_COLL_PROT_REQ IS NULL OR IS_COLL_PROT_REQ =0) ;
INSERT INTO `CATISSUE_TISSUE_SPECIMEN`(IDENTIFIER) SELECT IDENTIFIER FROM CATISSUE_SPECIMEN WHERE SPECIMEN_CLASS='Tissue'  AND  (IS_COLL_PROT_REQ IS NULL OR IS_COLL_PROT_REQ =0) ;


SET FOREIGN_KEY_CHECKS=0;
DELETE FROM  CATISSUE_EXTERNAL_IDENTIFIER WHERE SPECIMEN_ID IN(SELECT identifier FROM CATISSUE_SPECIMEN WHERE IS_COLL_PROT_REQ = 1);
DELETE FROM `CATISSUE_SPECIMEN` WHERE IS_COLL_PROT_REQ = 1;
alter table CATISSUE_SPECIMEN_EVENT_PARAM drop index FK753F33AD60773DB2; 
alter table CATISSUE_SPECIMEN_EVENT_PARAM DROP Foreign KEY FK753F33AD60773DB2;
alter table CATISSUE_SPECIMEN_EVENT_PARAM add index FK753F33AD60773DB2 (SPECIMEN_ID); 
alter table CATISSUE_SPECIMEN_EVENT_PARAM add constraint FK753F33AD60773DB2 foreign key (SPECIMEN_ID) references CATISSUE_ABSTRACT_SPECIMEN (IDENTIFIER);

SET FOREIGN_KEY_CHECKS=1;

ALTER TABLE `CATISSUE_SPECIMEN` DROP Foreign KEY FK16748104B189E99D;
ALTER TABLE `CATISSUE_SPECIMEN` DROP Foreign KEY FK1674810456906F39;

ALTER TABLE `CATISSUE_SPECIMEN` DROP KEY INDX_CATISSUE_SPECIMEN_CLASS; 
ALTER TABLE `CATISSUE_SPECIMEN` DROP KEY INDX_CATISSUE_SPECIMEN_TYPE ; 
ALTER TABLE `CATISSUE_SPECIMEN` DROP KEY INDX_CATISSUE_SPECIMEN_PATH ; 
ALTER TABLE `CATISSUE_SPECIMEN` DROP KEY INDX_CATISSUE_SPECIMEN_CONC; 
ALTER TABLE `CATISSUE_SPECIMEN` DROP KEY INDX_CATISSUE_SPECIMEN_QTY; 
ALTER TABLE `CATISSUE_SPECIMEN` DROP KEY INDX_CATISSUE_SPECIMEN_AVQTY;


ALTER TABLE `CATISSUE_SPECIMEN` ADD (`REQ_SPECIMEN_ID` bigint(20) default NULL);

ALTER TABLE `CATISSUE_SPECIMEN` DROP COLUMN  IS_COLL_PROT_REQ , DROP COLUMN POSITION_DIMENSION_ONE, 
DROP COLUMN POSITION_DIMENSION_TWO , DROP COLUMN SPECIMEN_CLASS ,
DROP COLUMN STORAGE_CONTAINER_IDENTIFIER,DROP COLUMN TYPE ,DROP COLUMN LINEAGE ,
DROP COLUMN PATHOLOGICAL_STATUS, DROP COLUMN PARENT_SPECIMEN_ID, DROP COLUMN SPECIMEN_CHARACTERISTICS_ID,
DROP COLUMN QUANTITY , DROP COLUMN CONCENTRATION;

SET FOREIGN_KEY_CHECKS=0;
UPDATE CATISSUE_SPECIMEN_COLL_GROUP scg SET Collection_Protocol_Event_Id = 
( SELECT Specimen_Coll_req_Group_Id FROM CATISSUE_COLL_PROT_EVENT scrg WHERE 
  scg.Collection_Protocol_Event_Id = scrg.identifier
);
SET FOREIGN_KEY_CHECKS=1;	

CREATE TABLE `catissue_coll_prot_event_tmp`
(                                                                                                                     
    `IDENTIFIER` bigint(20) NOT NULL auto_increment,                                                                                                            
    `CLINICAL_STATUS` varchar(50) default NULL,                                                                                                                 
    `COLLECTION_POINT_LABEL` varchar(255) default NULL,                                                                                                         
    `STUDY_CALENDAR_EVENT_POINT` double default NULL,                                                                                                           
    `COLLECTION_PROTOCOL_ID` bigint(20) default NULL,                                                                                                           
    PRIMARY KEY  (`IDENTIFIER`),                                                                                                                                
    UNIQUE KEY `COLLECTION_PROTOCOL_ID` (`COLLECTION_PROTOCOL_ID`,`COLLECTION_POINT_LABEL`),                                                                    
    KEY `FK17AE7715948304401` (`COLLECTION_PROTOCOL_ID`),                                                                                                        
    CONSTRAINT `FK17AE7715948304401` FOREIGN KEY (`COLLECTION_PROTOCOL_ID`) REFERENCES `catissue_collection_protocol` (`IDENTIFIER`),
    CONSTRAINT `FK_PARENT_COLL_PROTEVENT` FOREIGN KEY (`IDENTIFIER`) REFERENCES `catissue_abs_speci_coll_group` (`IDENTIFIER`)
);

insert into catissue_coll_prot_event_tmp(IDENTIFIER,CLINICAL_STATUS,                                                                                                                 
     COLLECTION_POINT_LABEL,STUDY_CALENDAR_EVENT_POINT,                                                                                                           
    COLLECTION_PROTOCOL_ID)
select SPECIMEN_COLL_REQ_GROUP_ID,CLINICAL_STATUS,                                                                                                                 
     COLLECTION_POINT_LABEL,STUDY_CALENDAR_EVENT_POINT,                                                                                                           
    COLLECTION_PROTOCOL_ID from catissue_coll_prot_event;

SET FOREIGN_KEY_CHECKS=0;
drop table catissue_coll_prot_event;
SET FOREIGN_KEY_CHECKS=1;
rename table catissue_coll_prot_event_tmp to catissue_coll_prot_event;

DROP TABLE CATISSUE_SPECI_COLL_REQ_GROUP;

ALTER TABLE  `CATISSUE_ABS_SPECI_COLL_GROUP`  ADD( NAME  varchar(255) DEFAULT NULL);
ALTER TABLE  `CATISSUE_ABS_SPECI_COLL_GROUP`  ADD INDEX (NAME) ,ADD UNIQUE (NAME);

Update CATISSUE_ABS_SPECI_COLL_GROUP ascg,CATISSUE_SPECIMEN_COLL_GROUP scg Set ascg.NAME = scg.NAME 
where scg.identifier = ascg.identifier;

ALTER TABLE  `CATISSUE_SPECIMEN_COLL_GROUP` DROP COLUMN NAME;


INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'AbstractSpecimen','AbstractSpecimen Object','edu.wustl.catissuecore.domain.AbstractSpecimen',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'RequirementSpecimen','RequirementSpecimen Object','edu.wustl.catissuecore.domain.RequirementSpecimen',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'MolReqSpecimen','MolReqSpecimen Object','edu.wustl.catissuecore.domain.MolecularRequirementSpecimen',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'FluidReqSpecimen','FluidReqSpecimen Object','edu.wustl.catissuecore.domain.FluidRequirementSpecimen',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'CellReqSpecimen','CellReqSpecimen Object','edu.wustl.catissuecore.domain.CellRequirementSpecimen',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;
INSERT into `CSM_PROTECTION_ELEMENT` select max(PROTECTION_ELEMENT_ID)+1,'TissueReqSpecimen','TissueReqSpecimen Object','edu.wustl.catissuecore.domain.TissueRequirementSpecimen',NULL,NULL,1,'2008-5-28' from CSM_PROTECTION_ELEMENT;

INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='AbstractSpecimen'),'2008-05-28' from CSM_PG_PE;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='RequirementSpecimen'),'2008-05-28' from CSM_PG_PE;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='MolReqSpecimen'),'2008-05-28' from CSM_PG_PE;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='FluidReqSpecimen'),'2008-05-28' from CSM_PG_PE;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='CellReqSpecimen'),'2008-05-28' from CSM_PG_PE;
INSERT INTO CSM_PG_PE select max(PG_PE_ID)+1,1,(select PROTECTION_ELEMENT_ID from csm_protection_element where PROTECTION_ELEMENT_NAME='TissueReqSpecimen'),'2008-05-28' from CSM_PG_PE;


CREATE INDEX INDX_CATISSUE_SPECIMEN_CLASS ON CATISSUE_ABSTRACT_SPECIMEN (SPECIMEN_CLASS);
CREATE INDEX INDX_CATISSUE_SPECIMEN_TYPE ON CATISSUE_ABSTRACT_SPECIMEN (SPECIMEN_TYPE);
CREATE INDEX INDX_CATISSUE_SPECIMEN_PATH ON CATISSUE_ABSTRACT_SPECIMEN (PATHOLOGICAL_STATUS);
CREATE INDEX INDX_CATISSUE_SPECIMEN_QTY ON CATISSUE_ABSTRACT_SPECIMEN (INITIAL_QUANTITY);
CREATE INDEX INDX_CATISSUE_SPECIMEN_AVQTY ON CATISSUE_SPECIMEN (AVAILABLE_QUANTITY);
CREATE INDEX INDX_MOL_REQ_SPECIMEN_CONC ON CATISSUE_MOL_REQ_SPECIMEN (CONCENTRATION);
CREATE INDEX INDX_MOLECULAR_SPECIMEN_CONC ON CATISSUE_MOLECULAR_SPECIMEN (CONCENTRATION);

Alter table catissue_specimen add KEY FK_REQ_SPECIMEN_ID(REQ_SPECIMEN_ID);
Alter table catissue_specimen add CONSTRAINT `FK_REQ_SPECIMEN_ID` FOREIGN KEY (`REQ_SPECIMEN_ID`) REFERENCES `CATISSUE_CP_REQ_SPECIMEN` (`IDENTIFIER`);
Alter table catissue_specimen add CONSTRAINT `FK_PARENT_SPECIMEN` FOREIGN KEY (`IDENTIFIER`) REFERENCES `CATISSUE_ABSTRACT_SPECIMEN` (`IDENTIFIER`);


