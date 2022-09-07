package com.krishagni.catissueplus.core.common.repository.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.collections4.CollectionUtils;

import com.krishagni.catissueplus.core.common.domain.Notification;
import com.krishagni.catissueplus.core.common.domain.UserNotification;
import com.krishagni.catissueplus.core.common.repository.AbstractDao;
import com.krishagni.catissueplus.core.common.repository.Criteria;
import com.krishagni.catissueplus.core.common.repository.UserNotificationDao;
import com.krishagni.catissueplus.core.common.repository.UserNotifsListCriteria;

public class UserNotificationDaoImpl extends AbstractDao<UserNotification> implements UserNotificationDao {
	@Override
	public Class<?> getType() {
		return UserNotification.class;
	}

	@Override
	public List<UserNotification> getUserNotifications(UserNotifsListCriteria crit) {
		Criteria<UserNotification> query = getUserNotificationsListCriteria(crit);
		return query.join("un.notification", "n")
			.orderBy(query.desc("n.creationTime"))
			.list(crit.startAt(), crit.maxResults());
	}

	@Override
	public Long getUnreadNotificationsCount(UserNotifsListCriteria crit) {
		Criteria<UserNotification> query = getUserNotificationsListCriteria(crit);
		return query.add(query.eq("un.status", UserNotification.Status.UNREAD))
			.getCount("un.id");
	}

	@Override
	public int markUserNotificationsAsRead(Long userId, Date notifsBefore) {
		return createNamedQuery(MARK_AS_READ)
			.setParameter("userId", userId)
			.setParameter("notifsBefore", notifsBefore)
			.executeUpdate();
	}

	@Override
	public void saveOrUpdate(Notification notification) {
		getCurrentSession().saveOrUpdate(notification);
	}

	private Criteria<UserNotification> getUserNotificationsListCriteria(UserNotifsListCriteria crit) {
		Criteria<UserNotification> query = createCriteria(UserNotification.class, "un");
		addIdsCondition(query, crit);
		return addUserCondition(query, crit);
	}

	private Criteria<UserNotification> addIdsCondition(Criteria<UserNotification> query, UserNotifsListCriteria crit) {
		if (CollectionUtils.isEmpty(crit.ids())) {
			return query;
		}

		return query.add(query.in("un.id", crit.ids()));
	}

	private Criteria<UserNotification> addUserCondition(Criteria<UserNotification> query, UserNotifsListCriteria crit) {
		Long userId = crit.userId();
		if (userId == null) {
			return query;
		}

		return query.join("un.user", "user").add(query.eq("user.id", userId));
	}

	private static final String FQN = UserNotification.class.getName();

	private static final String MARK_AS_READ = FQN + ".markNotifsAsRead";
}