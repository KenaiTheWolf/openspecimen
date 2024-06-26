package com.krishagni.catissueplus.core.biospecimen.services;

import java.util.List;

import com.krishagni.catissueplus.core.biospecimen.events.ShareSpecimenListOp;
import com.krishagni.catissueplus.core.biospecimen.events.SpecimenInfo;
import com.krishagni.catissueplus.core.biospecimen.events.SpecimenListDetail;
import com.krishagni.catissueplus.core.biospecimen.events.SpecimenListSummary;
import com.krishagni.catissueplus.core.biospecimen.events.SpecimenListsFolderDetail;
import com.krishagni.catissueplus.core.biospecimen.events.SpecimenListsFolderSummary;
import com.krishagni.catissueplus.core.biospecimen.events.UpdateFolderCartsOp;
import com.krishagni.catissueplus.core.biospecimen.events.UpdateListSpecimensOp;
import com.krishagni.catissueplus.core.biospecimen.repository.SpecimenListCriteria;
import com.krishagni.catissueplus.core.biospecimen.repository.SpecimenListsCriteria;
import com.krishagni.catissueplus.core.biospecimen.repository.SpecimenListsFoldersCriteria;
import com.krishagni.catissueplus.core.common.events.EntityQueryCriteria;
import com.krishagni.catissueplus.core.common.events.RequestEvent;
import com.krishagni.catissueplus.core.common.events.ResponseEvent;
import com.krishagni.catissueplus.core.common.events.UserSummary;
import com.krishagni.catissueplus.core.de.events.QueryDataExportResult;
import com.krishagni.catissueplus.core.de.services.QueryService;

public interface SpecimenListService {
	ResponseEvent<List<SpecimenListSummary>> getSpecimenLists(RequestEvent<SpecimenListsCriteria> req);
	
	ResponseEvent<Long> getSpecimenListsCount(RequestEvent<SpecimenListsCriteria> req);
	
	ResponseEvent<SpecimenListDetail> getSpecimenList(RequestEvent<EntityQueryCriteria> req);
	
	ResponseEvent<SpecimenListDetail> createSpecimenList(RequestEvent<SpecimenListDetail> req);
	
	ResponseEvent<SpecimenListDetail> updateSpecimenList(RequestEvent<SpecimenListDetail> req);

	ResponseEvent<SpecimenListDetail> patchSpecimenList(RequestEvent<SpecimenListDetail> req);

	ResponseEvent<List<SpecimenInfo>> getListSpecimens(RequestEvent<SpecimenListCriteria> req);

	ResponseEvent<Integer> getListSpecimensCount(RequestEvent<SpecimenListCriteria> req);

	ResponseEvent<List<SpecimenInfo>> getListSpecimensSortedByRel(RequestEvent<EntityQueryCriteria> req);

	ResponseEvent<Integer>  updateListSpecimens(RequestEvent<UpdateListSpecimensOp> req);
	
	ResponseEvent<List<UserSummary>> shareSpecimenList(RequestEvent<ShareSpecimenListOp> req);
	
	ResponseEvent<SpecimenListDetail> deleteSpecimenList(RequestEvent<Long> req);

	ResponseEvent<Boolean> addChildSpecimens(RequestEvent<Long> req);

	ResponseEvent<QueryDataExportResult> exportSpecimenList(RequestEvent<SpecimenListCriteria> req);

	//
	// Specimen List Folder APIs
	//
	ResponseEvent<List<SpecimenListsFolderSummary>> getFolders(RequestEvent<SpecimenListsFoldersCriteria> req);

	ResponseEvent<Long> getFoldersCount(RequestEvent<SpecimenListsFoldersCriteria> req);

	ResponseEvent<SpecimenListsFolderDetail> getFolder(RequestEvent<EntityQueryCriteria> req);

	ResponseEvent<SpecimenListsFolderDetail> createFolder(RequestEvent<SpecimenListsFolderDetail> req);

	ResponseEvent<SpecimenListsFolderDetail> updateFolder(RequestEvent<SpecimenListsFolderDetail> req);

	ResponseEvent<SpecimenListsFolderDetail> deleteFolder(RequestEvent<EntityQueryCriteria> req);

	ResponseEvent<Integer> updateFolderCarts(RequestEvent<UpdateFolderCartsOp> req);

	//
	// Used for internal consumption purpose.
	//
	QueryDataExportResult exportSpecimenList(SpecimenListCriteria crit, QueryService.ExportProcessor proc);

	boolean toggleStarredSpecimenList(Long listId, boolean starred);
}
