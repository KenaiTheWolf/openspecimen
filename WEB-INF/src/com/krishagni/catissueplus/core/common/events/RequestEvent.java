
package com.krishagni.catissueplus.core.common.events;


public class RequestEvent<T> {
	private T payload;
	
	public RequestEvent() {		
	}
	
	public RequestEvent(T payload) {
		this.payload = payload;
	}
	
	public T getPayload() {
		return payload;
	}

	public void setPayload(T payload) {
		this.payload = payload;
	}

	public static <P> RequestEvent<P> request(P input) {
		return new RequestEvent<>(input);
	}
}
