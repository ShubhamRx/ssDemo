package com.ssDemo

import com.ssDemo.Subscription
import com.ssDemo.User
import grails.transaction.Transactional

@Transactional
class SubscriptionService {

    List<Subscription> getSubscriptionsOfUser(User user){
        return Subscription.findAllByUser(user)
    }

}
