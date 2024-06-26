package com.krishagni.catissueplus.core.common;

import java.util.LinkedHashSet;
import java.util.Set;

import org.hibernate.EmptyInterceptor;
import org.hibernate.Interceptor;
import org.hibernate.Transaction;

public class TransactionAwareInterceptor extends EmptyInterceptor implements Interceptor {
	private final ThreadLocal<Integer> activeTxns = ThreadLocal.withInitial(() -> 0);

	private final Set<TransactionEventListener> listeners = new LinkedHashSet<>();

	public void addListener(TransactionEventListener listener) {
		listeners.add(listener);
	}

	public void removeListener(TransactionEventListener listener) {
		listeners.remove(listener);
	}

	@Override
	public void afterTransactionBegin(Transaction tx) {
		activeTxns.set(activeTxns.get() + 1);
	}

	@Override
	public void afterTransactionCompletion(Transaction tx) {
		int txns = activeTxns.get();
		if (txns <= 1) {
			TransactionalThreadLocals.getInstance().cleanup();
			activeTxns.remove();
			listeners.forEach(TransactionEventListener::onFinishTransaction);
		} else {
			activeTxns.set(txns - 1);
		}
	}
}
