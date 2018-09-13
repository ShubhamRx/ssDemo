package com.ssDemo

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_ADMIN'])
class AdminController {

    def springSecurityService

    def index() {}

    def listUser() {
        User user = springSecurityService.currentUser as User
        List<User> userList = User.list()
        render(view: '/admin/userList', model: [user: user, userList: userList])
    }

    def userDetail(){
        println("Controller: Admin, Action: userDetail")
        User user = springSecurityService.currentUser as User
        Map result = [:]
        User detailUser = User.findById(params?.userId)
        List<Topic> topicList = Topic.findAllByCreatedBy(detailUser)
        List<Subscription> subscriptionList = Subscription.findAllByUser(detailUser)
        result.status = "200"
        result.template = g.render(template: '/templates/userDetailModalTemplate', model: [user:detailUser, topicList: topicList, subscriptionList: subscriptionList])
        render result as JSON
    }
}
