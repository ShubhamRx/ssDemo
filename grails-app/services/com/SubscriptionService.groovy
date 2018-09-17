package com.ssDemo

import com.ssDemo.Enums.Seriousness
import grails.transaction.Transactional

@Transactional
class SubscriptionService {

    List<Subscription> getSubscriptionsOfUser(User user){
        return Subscription.findAllByUser(user)
    }

    Integer getSubscriptionCountOfUser(User user){
        return Subscription.countByUser(user)
    }

    Subscription getSubscriptionByUserAndTopic(User user,Topic topic){
        return Subscription.findByTopicAndUser(topic, user)
    }

    Boolean deleteSubscription(Subscription subscription){
        subscription.delete(flush:true)
        return Subscription.exists(subscription.id)
    }

    Subscription changeSeriousness(Subscription subscription, Seriousness seriousness){
        subscription.seriousness = seriousness
        return subscription.save(flush:true)
    }
}
