package com.ssDemo

import CommandObjects.PostCO
import CommandObjects.TopicCO
import com.ssDemo.User
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.authentication.encoding.BCryptPasswordEncoder
import org.springframework.web.multipart.MultipartFile

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class UserController {

    def springSecurityService
    def topicService

    def index() {}

    @Secured(['ROLE_ADMIN', 'ROLE_USER'])
    def dashboard() {
        User user = springSecurityService.currentUser as User
        int noOfSubscriptions = Subscription.countByUser(user)
        int noOfTopics = Topic.countByCreatedBy(user)
        List<Topic> subscribedTopicList = topicService.getSubscribedTopicsList(user)
        List<Topic> unsubscribedTopicList = Topic.getPublicTopicList() - subscribedTopicList
        render(view: '/User/userDashboard', model: [user: user, noOfSubscriptions: noOfSubscriptions, noOfTopics: noOfTopics, subscribedTopicList: subscribedTopicList, unsubscribedTopicList: unsubscribedTopicList])
    }

    @Secured(['ROLE_ADMIN', 'ROLE_USER'])
    def createTopic(TopicCO topicCO) {
        println("Controller: User, Action: createTopic");
        topicCO.createdBy = User.findById(params.createdBy)
        topicCO.visibility = com.ssDemo.Enums.Visibility.valueOf(params.visibility)
        Topic topic = topicService.createTopic(topicCO)
        redirect(action: 'myTopic')

    }

    def myTopic() {
        User user = springSecurityService.currentUser as User
        List<Topic> myTopicList = Topic.findAllByCreatedBy(user)
        render(view: '/User/myTopics', model: [user: user, myTopicList: myTopicList])
    }

    def allTopic() {
        User user = springSecurityService.currentUser as User
        List<Topic> allTopicList = topicService.getAllTopicsForUser(user)
        render(view: '/User/allTopics', model: [user: user, allTopicList: allTopicList, showStatus: true])

    }

    def profile(){
        println("Controller: User, Action: profile")
        User user = springSecurityService.currentUser as User
        render(view: '/User/profile', model: [user: user])
    }

    def updateProfile(){
        println("Controller: User, Action: updateProfile")
        User user = params?.userId ? User.findById(params.userId): springSecurityService.currentUser as User
        Map result=[:]
        Long userId = user.id
        String firstName = params.firstName
        String lastName = params.lastName
        User.executeUpdate("update User set firstName = ?, lastName = ? where id = ?",[firstName,lastName,userId])
        println("Executed Succesfully")
        result.template = g.render(template: '/templates/profileTemplate', model: [user:User.findById(userId)])
        result.status ="200"
        println("Rendered")
        render result as JSON
    }

    def openShareTopicModal(){
        println("Controller: User, Action: openShareTopicModal")
        User user = params?.userId ? User.findById(params?.userId) : springSecurityService.currentUser as User
        Map result = [:]
        Topic topic = Topic.findById(params.topicId)
        List<User> userList = User.list() - Subscription.findAllByTopic(topic).user - Invite.findAllByStatusAndForTopic(com.ssDemo.Enums.InviteStatus.REJECTED,topic)?.invitationTo ?: []
        result.template = g.render(template: '/templates/shareTopicModalTemplate', model: [user:user,topic:topic,userList:userList])
        result.status = "200"
        render result as JSON
    }

    def readNotification(){
        println("Controller: User, Action: readNotification")
        User user = springSecurityService.currentUser as User
        Invite invite = Invite.findById(params?.invitationId)
        String status = params?.status
        Map result=[:]
        if(status == "READ"){
            invite.status = com.ssDemo.Enums.InviteStatus.PENDING
            invite.save(flush:true)
            result.msg = "Invitation Read"
            result.status = "200"
        } else if(status == "ACCEPT"){
            Subscription subscription = topicService.subscribeToTopic(invite.invitationTo,invite.forTopic,com.ssDemo.Enums.Seriousness.SERIOUS)
            if(subscription){
                invite.status = com.ssDemo.Enums.InviteStatus.ACCEPTED
                invite.save(flush:true)
                result.msg = "Invitation Accepted"
                result.status = "200"
            } else{
                result.status = "500"
            }

        } else if(status == "REJECT"){
            invite.status = com.ssDemo.Enums.InviteStatus.REJECTED
            invite.save(flush:true)
            result.msg = "Invitation Rejected"
            result.status = "200"
        }
        result.template = g.render(template: '/templates/notificationTemplate', model: [user: user])
        render result as JSON
    }

    def editTopic(TopicCO topicCO){
        println("Controller: User, Action: editTopic")
        topicCO.createdBy = User.findById(params.createdBy)
        topicCO.visibility = com.ssDemo.Enums.Visibility.valueOf(params.visibility)
        Topic topic = Topic.get(params.topicId)
        topic = topicService.editTopic(topic,topicCO)
        redirect(action: 'myTopic')

    }

    def updatePassword(){
        println("Controller: User,Action: updatePassword")
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
        println("Controller: User, Action: createPost")
        User user = params?.userID ? User.findById(params?.userID) : springSecurityService.currentUser as User
        Topic topic = Topic.findById(params?.topic)
        postCO.user = user
        postCO.topic = topic
        MultipartFile file = request.getFile('document')
        String path = file.originalFilename
        if(path && path.substring(path.length()-3,path.length()).equalsIgnoreCase("pdf"))
        {
            file.transferTo(new File("${grailsApplication.config.documentFolder}"+path))
            println("Content Type = "+file.contentType)
            Post post = topicService.createPost(postCO,path)
        } else if(!path) {
            Post post = topicService.createPost(postCO)
        }
        redirect(controller:'topic', action: 'showPost')
    }

    def myPost(){
        println("Controller: User, Action: myPost")
        User user= springSecurityService.currentUser as User
        List<Post> postList = Post.findAllByUser(user)
        List<Topic> subscribedTopics = Subscription.findAllByUser(user)*.topic
        render(view: '/User/posts', model: [user: user, posts: postList, subscribedTopics: subscribedTopics, myPost:true])
    }
}
