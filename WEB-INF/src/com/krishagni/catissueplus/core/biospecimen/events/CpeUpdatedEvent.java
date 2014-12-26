package com.krishagni.catissueplus.core.biospecimen.events;

import com.krishagni.catissueplus.core.common.errors.ObjectCreationException;
import com.krishagni.catissueplus.core.common.events.EventStatus;
import com.krishagni.catissueplus.core.common.events.ResponseEvent;

public class CpeUpdatedEvent extends ResponseEvent {
	private CollectionProtocolEventDetail cpe;

	public CollectionProtocolEventDetail getCpe() {
		return cpe;
	}

	public void setCpe(CollectionProtocolEventDetail cpe) {
		this.cpe = cpe;
	}
	
	public static CpeUpdatedEvent ok(CollectionProtocolEventDetail cpe) {
		CpeUpdatedEvent resp = new CpeUpdatedEvent();
		resp.setCpe(cpe);
		resp.setStatus(EventStatus.OK);
		return resp;
	}
	
	public static CpeUpdatedEvent badRequest(Exception e) {
		CpeUpdatedEvent resp = new CpeUpdatedEvent();
		resp.setStatus(EventStatus.BAD_REQUEST);
		resp.setException(e);
		if (e instanceof ObjectCreationException) {
			ObjectCreationException oce = (ObjectCreationException)e;
			resp.setErroneousFields(oce.getErroneousFields());
			resp.setMessage(oce.getMessage());
		}
		
		return resp;
	}

	public static CpeUpdatedEvent serverError(Exception e) {
		CpeUpdatedEvent resp = new CpeUpdatedEvent();
		resp.setStatus(EventStatus.INTERNAL_SERVER_ERROR);
		resp.setException(e);
		return resp;
	}
}
