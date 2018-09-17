package com.ssDemo

import CommandObjects.PostCO
import CommandObjects.TopicCO
import CommandObjects.UserCO
import grails.converters.JSON
import com.ssDemo.Enums.Visibility
import grails.plugin.springsecurity.annotation.Secured
import org.springframework.web.multipart.MultipartFile

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class UserController {

    def springSecurityService
    def topicService
    def subscriptionService
    def userService
    def postService
    def inviteService


    def dashboard() {
        User user = springSecurityService.currentUser as User
        int noOfSubscriptions = subscriptionService.getSubscriptionCountOfUser(user)
        int noOfTopics = topicService.getTopicCountByUser(user)
        List<Topic> subscribedTopicList = topicService.getSubscribedTopicsList(user)
        List<Topic> unsubscribedTopicList = topicService.getUnsubscribedTopicList(subscribedTopicList)
        render(view: '/User/userDashboard', model: [user: user, noOfSubscriptions: noOfSubscriptions, noOfTopics: noOfTopics, subscribedTopicList: subscribedTopicList, unsubscribedTopicList: unsubscribedTopicList])
    }

    def createTopic(TopicCO topicCO) {
        topicCO.createdBy = User.findById(params.createdBy)
        topicCO.visibility = Visibility.valueOf(params.visibility)
        Topic topic = topicService.createTopic(topicCO)
        redirect(action: 'myTopic')
    }

    def myTopic() {
        User user = springSecurityService.currentUser as User
        List<Topic> myTopicList = topicService.getAllCreatedTopicOfUser(user)
        render(view: '/User/myTopics', model: [user: user, myTopicList: myTopicList])
    }

    def allTopic() {
        User user = springSecurityService.currentUser as User
        List<Topic> allTopicList = topicService.getAllTopicsForUser(user)
        render(view: '/User/allTopics', model: [user: user, allTopicList: allTopicList, showStatus: true])

    }

    def profile(){
        User user = springSecurityService.currentUser as User
        render(view: '/User/profile', model: [user: user])
    }

    def updateProfile(UserCO userCO){
        User user = springSecurityService.currentUser as User
        Map result=[:]
        user = userService.updateUserProfile(user,userCO)
        result.template = g.render(template: '/templates/profileTemplate', model: [user:user])
        result.status ="200"
        render result as JSON
    }

    def openShareTopicModal(){
        User user = springSecurityService.currentUser as User
        Map result = [:]
        Topic topic = topicService.getTopicById(params.topicId)
        List<User> userList = userService.getEligibleUsersForTopic(topic)
        result.template = g.render(template: '/templates/shareTopicModalTemplate', model: [user:user,topic:topic,userList:userList])
        result.status = "200"
        render result as JSON
    }

    def readNotification(){
        println("Controller: User, Action: readNotification")
        User user = springSecurityService.currentUser as User
        Invite invite = Invite.findById(params?.invitationId)
        String status = params?.status
        Map result = inviteService.takeActionOnInvitation(invite,status)
        result.template = g.render(template: '/templates/notificationTemplate', model: [user: user])
        render result as JSON
    }

    def editTopic(TopicCO topicCO){
        Topic topic = Topic.get(params.topicId)
        topicCO.visibility = Visibility.valueOf(params.visibility)
        topicService.editTopic(topic,topicCO)
        redirect(action: 'myTopic')
    }

    def updatePassword(){
        User user = springSecurityService.currentUser as User
        Map result = [:]
        String userPassword = user.password
        String newPassword = params?.newPassword
        String oldPassword = params?.oldPassword
        println("User Password = "+userPassword)
        println("New Password = "+newPassword)
        println("Old Password = "+oldPassword)
        println("Old Password Encoded = "+ springSecurityService.encodePassword(oldPassword))
        render result as JSON
    }

    def createPost(PostCO postCO){
        User user = springSecurityService.currentUser as User
        Topic topic = Topic.findById(params?.topic)
        postCO.user = user
        postCO.topic = topic
        MultipartFile file = request.getFile('document')
        postService.createPost(postCO,file)
        redirect(controller:'topic', action: 'showPost')
    }

    def myPost(){
        User user= springSecurityService.currentUser as User
        List<Post> postList = postService.getAllPostOfUser(user)
        List<Topic> subscribedTopics = topicService.getSubscribedTopicsList(user)
        render(view: '/User/posts', model: [user: user, posts: postList, subscribedTopics: subscribedTopics, myPost:true])
    }
}
