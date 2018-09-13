package com.ssDemo

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

import java.awt.Desktop

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class TopicController {

    def springSecurityService
    def topicService

    def index() {}

    def unsubscribeAjax() {
        println("Inside Unsubscribe Ajax Method")
        Map result = [:]
        User user = params.userId ? User.findById(params.userId) : springSecurityService.currentUser as User
        Topic topic = Topic.findById(params.topicId)
        Subscription subscription = Subscription.findByTopicAndUser(topic, user)
        println("Subscription " + subscription + " is Deleting")
        try {
            subscription.delete(flush: true)
            List<Topic> subscribedTopicList = topicService.getSubscribedTopicsList(user)
            List<Topic> unsubscribedTopicList = Topic.getPublicTopicList() - subscribedTopicList
            result.status = "200"
            result.subscribedTemplate = g.render(template: "/templates/subscribedTopicTemplate", model: [user: user, subscribedTopicList: subscribedTopicList])
            result.unsubscribedTemplate = g.render(template: "/templates/unsubscribedTopicTemplate", model: [user: user, unsubscribedTopicList: unsubscribedTopicList])
        }
        catch (Exception e) {
            result.status = "500"

        }
        render result as JSON
    }

    def subscribeAjax() {
        println("Inside Subscribe Ajax Method")
        Map result = [:]
        User user = params.userId ? User.findById(params.userId) : springSecurityService.currentUser as User
        com.ssDemo.Enums.Seriousness seriousness = com.ssDemo.Enums.Seriousness.valueOf(params.seriousness)
        Topic topic = Topic.findById(params.topicId)
        println("Getting Subscribed ")
        Subscription subscription = topicService.subscribeToTopic(user, topic, seriousness)
        if (subscription) {
            List<Topic> subscribedTopicList = topicService.getSubscribedTopicsList(user)
            List<Topic> unsubscribedTopicList = Topic.getPublicTopicList() - subscribedTopicList
            result.status = "200"
            result.subscribedTemplate = g.render(template: "/templates/subscribedTopicTemplate", model: [user: user, subscribedTopicList: subscribedTopicList])
            result.unsubscribedTemplate = g.render(template: "/templates/unsubscribedTopicTemplate", model: [user: user, unsubscribedTopicList: unsubscribedTopicList])
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def changeSeriousnessAjax() {
        println("Controller: Topic, Action: changeSeriousnessAjax")
        Map result = [:]
        User user = params.userId ? User.findById(params.userId) : springSecurityService.currentUser as User
        Topic topic = Topic.findById(params.topicId)
        com.ssDemo.Enums.Seriousness newSeriousness = com.ssDemo.Enums.Seriousness.valueOf(params.seriousness)
        Subscription subscription = Subscription.findByUserAndTopic(user, topic)
        com.ssDemo.Enums.Seriousness oldSeriousness = subscription.seriousness
        result.value = oldSeriousness
        if (oldSeriousness != newSeriousness) {
            subscription.seriousness = newSeriousness
            subscription.save()
            result.values = subscription.seriousness
            result.status = "200"
        } else {
            result.value = subscription.seriousness
            result.status = "500"
        }
        render result as JSON
    }

    def subscribeFromAllTopicsAjax() {
        println("Controller: Topic, Action: subscribeFromAllTopicsAjax")
        Map result = [:]
        User user = params.userId ? User.findById(params.userId) : springSecurityService.currentUser as User
        com.ssDemo.Enums.Seriousness seriousness = com.ssDemo.Enums.Seriousness.valueOf(params?.seriousness)
        Topic topic = Topic.findById(params.topicId)
        println("Getting Subscribed ")
        Subscription subscription = topicService.subscribeToTopic(user, topic, seriousness)
        if (subscription) {
            List<Topic> allTopicList = topicService.getAllTopicsForUser(user)
            result.status = "200"
            result.template = g.render(template: "/templates/commanTopicTemplate", model: [user: user, topicList: allTopicList, showStatus: true])
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def inviteUser() {
        User user = springSecurityService.currentUser as User
        Map result = [:]
        Topic topic = Topic.findById(params?.topicId)
        User targetUser = User.findById(params?.userId)
        Invite invite = topicService.inviteUser(user, targetUser, topic)
        if (invite) {
            result.status = "200"
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def deleteTopic() {
        User user = params.userId ? User.findById(params.userId) : springSecurityService.currentUser as User
        Map result = [:]
        Topic topic = Topic.findById(params.topicId)
        if (topic) {
            if (topicService.deleteTopic(topic)) {
                List<Topic> myTopicList = Topic.findAllByCreatedBy(user)
                result.template = g.render(template: '/templates/commanTopicTemplate', model: [user: user, topicList: myTopicList])
                result.status = "200"
            } else {
                result.status = "500"
            }
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def unsubscribeFromAllTopicList() {
        println("Controller: Topic, Action: unsubscribeFromAllTopicList")
        Map result = [:]
        User user = params.userId ? User.findById(params.userId) : springSecurityService.currentUser as User
        Topic topic = Topic.findById(params.topicId)
        Subscription subscription = Subscription.findByTopicAndUser(topic, user)
        println("Subscription " + subscription + " is Deleting")
        try {
            subscription.delete(flush: true)
            List<Topic> allTopicList = topicService.getAllTopicsForUser(user)
            allTopicList.each {
                println(it)
            }
            result.status = "200"
            result.template = g.render(template: "/templates/commanTopicTemplate", model: [user: user, topicList: allTopicList, showStatus: true])

        }
        catch (Exception e) {
            result.status = "500"

        }
        render result as JSON
    }

    def subscribersList() {
        println("Controller: Topic, Action: subscribersList")
        Map result = [:]
        User user = springSecurityService.currentUser as User
        Topic topic = Topic.findById(params?.topicId)
        List<User> userList = topic.subscribersList()
        if (userList) {
            result.status = "200"
            result.template = g.render(template: '/templates/subscribersModalTemplate', model: [topic: topic, subscribersList: userList])
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def showPost() {
        println("Controller: Topic, Action: showPost")
        User user = springSecurityService.currentUser as User
        List<Post> postList = []
        if(params?.topicId){
            Topic topic = Topic.findByUuid(params?.topicId)
            postList = Post.findAllByTopic(topic)
        } else{
            List<Topic> allTopicList = topicService.getAllTopicsForUser(user)
             postList = Post.findAllByTopicInList(allTopicList)
        }

        List<Topic> subscribedTopics = Subscription.findAllByUser(user)*.topic

        render(view: '/User/posts', model: [user: user, posts: postList, subscribedTopics: subscribedTopics])

    }

    def readDocument(){
        println("Controller: Topic, Action: readDocument")
        User user = springSecurityService.currentUser as User
        String path = params?.document
        println(path)
        File file = new File("${grailsApplication.config.documentFolder}"+path)
        if(path.substring(path.length()-3,path.length()).equals("pdf")){
            render file: file
        } else{
            render "File Is Not Pdf"
        }

    }
}
