/* Adding WUSTLKey column in CATISSUE_USER table */
ALTER TABLE CATISSUE_USER ADD WUSTLKEY varchar2(100) UNIQUE;

/**  Bug 13225 -  Clinical Diagnosis subset at CP definition level 
 */
create table CATISSUE_CLINICAL_DIAGNOSIS (
   IDENTIFIER number(19,0) not null ,
   CLINICAL_DIAGNOSIS varchar(255),
   COLLECTION_PROTOCOL_ID number(19,0),
   primary key (IDENTIFIER),
   CONSTRAINT FK_CD_COLPROT FOREIGN KEY (COLLECTION_PROTOCOL_ID) REFERENCES CATISSUE_COLLECTION_PROTOCOL
);
create sequence CATISSUE_CLINICAL_DIAG_SEQ;
