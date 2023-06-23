
package com.krishagni.catissueplus.core.biospecimen.domain.factory;

import com.krishagni.catissueplus.core.common.errors.ErrorCode;

public enum SpecimenErrorCode implements ErrorCode {
	ACCESS_DENIED,
	
	NOT_FOUND,

	NOT_FOUND_IN_CP,
	
	INVALID_SPECIMEN_CLASS,
	
	INVALID_SPECIMEN_TYPE,
	
	INVALID_VISIT,
	
	VISIT_REQUIRED,

	ID_REQUIRED,
	
	LABEL_REQUIRED,
	
	DUP_LABEL,

	DUP_LABEL_IN_CP,
	
	INVALID_LABEL,
	
	MANUAL_LABEL_NOT_ALLOWED,

	MANUAL_BARCODE_NOT_ALLOWED,
	
	DUP_BARCODE,

	DUP_BARCODE_IN_CP,

	DUP_ADDL_LABEL,

	DUP_ADDL_LABEL_IN_CP,
	
	INVALID_LINEAGE,

	CANNOT_CHG_LINEAGE,
	
	INVALID_COLL_STATUS,
	
	INVALID_QTY,

	ALIQUOT_QTY_REQ,
	
	PARENT_REQUIRED,
	
	PARENT_NF_BY_VISIT_AND_SR,
	
	COLL_PARENT_REQ,
	
	COLL_OR_MISSED_PARENT_REQ,
	
	COLL_OR_PENDING_PARENT_REQ,

	COLL_OR_NC_PARENT_REQ,
	
	SPECIMEN_CLASS_REQUIRED,
	
	SPECIMEN_TYPE_REQUIRED,
	
	INVALID_ANATOMIC_SITE,
	
	ANATOMIC_SITE_NOT_SAME_AS_PARENT,
	
	INVALID_LATERALITY,
	
	LATERALITY_NOT_SAME_AS_PARENT,
	
	INVALID_PATHOLOGY_STATUS,

	PATHOLOGY_NOT_SAME_AS_PARENT,
	
	COLL_DATE_REQUIRED,
	
	INVALID_CREATION_DATE,

	EDIT_NOT_ALLOWED,

	RESV_EDIT_NOT_ALLOWED,

	STORE_NOT_ALLOWED,

	PROC_NOT_ALLOWED,
	
	AVBL_QTY_GT_INIT_QTY,
	
	REF_ENTITY_FOUND,
	
	NO_PRINTER_CONFIGURED,
	
	NO_SPECIMENS_TO_PRINT,
	
	PRINT_ERROR,
	
	NOT_AVAILABLE_FOR_DIST,
	
	INVALID_BIOHAZARDS,
	
	INVALID_COLL_PROC,
	
	INVALID_COLL_CONTAINER,
	
	INVALID_RECV_QUALITY,
	
	INVALID_QTY_OR_CNT,

	ALIQUOT_CNT_N_QTY_REQ,

	NOT_COLLECTED,
	
	INVALID_FREEZE_THAW_CYCLES,

	UQ_LBL_CP_CHG_NA,

	UQ_BC_CP_CHG_NA,

	INVALID_DISPOSE_STATUS,

	CONTAINER_ACCESS_DENIED,

	PARENT_CONTAINER_REQ,

	CONTAINER_TYPE_REQ,

	EXT_ID_NO_NAME_VALUE,

	EXT_ID_DUP_NAME,

	VISIT_CHG_NOT_ALLOWED,

	LABELS_SRCH_LIMIT_MAXED,

	LOC_NOT_SPECIFIED,

	NO_SPMN_AT_LOC,

	DIMLESS_CONTAINER,

	EVT_ID_REQ,

	INV_EVT_ID,

	DEL_NOT_FOUND,

	PARENT_DELETED,

	PRIMARY_NOT_RCVD,

	POOL_SAME_CP_REQ,

	UPDATE_LIMIT_MAXED,

	REQ_LINEAGE_MISMATCH,

	REQ_TYPE_MISMATCH,

	REQ_PARENT_MISMATCH,

	CHILDREN_LIMIT_MAXED,

	MULTI_KIT_LABELS,

	NO_KIT_LABEL,

	NOT_ACTIVE,

	ALIQUOT_REQ;

	public String code() {
		return "SPECIMEN_" + this.name();
	}
}
