package com.ssDemo

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import com.ssDemo.Enums.Seriousness

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class TopicController {

    def springSecurityService
    def topicService
    def subscriptionService
    def userService
    def postService

    def unsubscribeAjax() {
        Map result = [:]
        User user = springSecurityService.currentUser as User
        Topic topic = topicService.getTopicById(params.topicId)
        Subscription subscription = subscriptionService.getSubscriptionByUserAndTopic(user,topic)
        if(!subscriptionService.deleteSubscription(subscription))
        {
            List<Topic> subscribedTopicList = topicService.getSubscribedTopicsList(user)
            List<Topic> unsubscribedTopicList = topicService.getUnsubscribedTopicList(subscribedTopicList)
            result.status = "200"
            result.subscribedTemplate = g.render(template: "/templates/subscribedTopicTemplate", model: [user: user, subscribedTopicList: subscribedTopicList])
            result.unsubscribedTemplate = g.render(template: "/templates/unsubscribedTopicTemplate", model: [user: user, unsubscribedTopicList: unsubscribedTopicList])
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def subscribeAjax() {
        Map result = [:]
        User user = springSecurityService.currentUser as User
        Seriousness seriousness = Seriousness.valueOf(params.seriousness)
        Topic topic = topicService.getTopicById(params.topicId)
        Subscription subscription = topicService.subscribeToTopic(user, topic, seriousness)
        if (subscription) {
            List<Topic> subscribedTopicList = topicService.getSubscribedTopicsList(user)
            List<Topic> unsubscribedTopicList = topicService.getUnsubscribedTopicList(subscribedTopicList)
            result.status = "200"
            result.subscribedTemplate = g.render(template: "/templates/subscribedTopicTemplate", model: [user: user, subscribedTopicList: subscribedTopicList])
            result.unsubscribedTemplate = g.render(template: "/templates/unsubscribedTopicTemplate", model: [user: user, unsubscribedTopicList: unsubscribedTopicList])
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def changeSeriousnessAjax() {
        Map result = [:]
        User user =  springSecurityService.currentUser as User
        Topic topic = topicService.getTopicById(params.topicId)
        Seriousness newSeriousness = Seriousness.valueOf(params.seriousness)
        Subscription subscription = subscriptionService.getSubscriptionByUserAndTopic(user, topic)
        subscription = subscriptionService.changeSeriousness(subscription, newSeriousness)
        result.value = subscription.seriousness
        result.status = "200"
        render result as JSON
    }

    def subscribeFromAllTopicsAjax() {
        Map result = [:]
        User user = springSecurityService.currentUser as User
        Seriousness seriousness = Seriousness.valueOf(params.seriousness)
        Topic topic = topicService.getTopicById(params.topicId)
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
        Topic topic = topicService.getTopicById(params.topicId)
        User targetUser = userService.getUserById(params.userId)
        Invite invite = topicService.inviteUser(user, targetUser, topic)
        if (invite) {
            result.status = "200"
        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def deleteTopic() {
        User user = springSecurityService.currentUser as User
        Map result = [:]
        Topic topic = topicService.getTopicById(params.topicId)
        if (topic) {
            if (topicService.deleteTopic(topic)) {
                List<Topic> myTopicList = topicService.getAllCreatedTopicOfUser(user)
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
        Map result = [:]
        User user = springSecurityService.currentUser as User
        Topic topic = topicService.getTopicById(params.topicId)
        Subscription subscription = subscriptionService.getSubscriptionByUserAndTopic(user,topic)
        if(!subscriptionService.deleteSubscription(subscription))
        {
            List<Topic> allTopicList = topicService.getAllTopicsForUser(user)
            result.status = "200"
            result.template = g.render(template: "/templates/commanTopicTemplate", model: [user: user, topicList: allTopicList, showStatus: true])

        } else {
            result.status = "500"
        }
        render result as JSON
    }

    def subscribersList() {
        Map result = [:]
        User user = springSecurityService.currentUser as User
        Topic topic = topicService.getTopicById(params?.topicId)
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
        User user = springSecurityService.currentUser as User
        List<Post> postList = []
        if(params.topicId){
            Topic topic = topicService.getTopicByUid(params.topicId)
            postList = postService.getAllPostOfTopic(topic)
        } else{
            List<Topic> allTopicList = topicService.getAllTopicsForUser(user)
            postList = postService.getAllPostOfTopicList(allTopicList)
        }
        List<Topic> subscribedTopics = topicService.getSubscribedTopicsList(user)
        render(view: '/User/posts', model: [user: user, posts: postList, subscribedTopics: subscribedTopics])

    }

    def readDocument(){
        User user = springSecurityService.currentUser as User
        String path = params.document
        File file = new File("${grailsApplication.config.documentFolder}"+path)
        if(file.exists() && path.substring(path.length()-3,path.length()).equalsIgnoreCase("pdf")){
            render(file: file , contentType: "application/pdf")
        } else{
            redirect(action:'showPost')
        }
    }
}
