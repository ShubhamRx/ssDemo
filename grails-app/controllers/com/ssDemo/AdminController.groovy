package com.ssDemo

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_ADMIN'])
class AdminController {

    def springSecurityService
    def topicService
    def subscriptionService

    def listUser() {
        User user = springSecurityService.currentUser as User
        List<User> userList = User.list()
        render(view: '/admin/userList', model: [user: user, userList: userList])
    }

    def userDetail(){
        User user = springSecurityService.currentUser as User
        Map result = [:]
        User detailUser = User.findById(params.userId)
        List<Topic> topicList = topicService.getAllCreatedTopicOfUser(detailUser)
        List<Subscription> subscriptionList = subscriptionService.getSubscriptionsOfUser(detailUser)
        result.status = "200"
        result.template = g.render(template: '/templates/userDetailModalTemplate', model: [user:detailUser, topicList: topicList, subscriptionList: subscriptionList])
        render result as JSON
    }
}