package com.ssDemo

import CommandObjects.PostCO
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER','ROLE_ADMIN'])
class PostController {

    def springSecurityService
    def postService
    def topicService

    def index() { }

    def opeEditPost(){
        User user = springSecurityService.currentUser as User
        Map result = [:]
        Post post = postService.getPostById(params.postId)
        result.template = g.render(template: '/templates/editPostTemplate', model: [post: post])
        result.status = "200"
        render result as JSON
    }

    def deletePost(){
        User user = springSecurityService.currentUser as User
        Map result = [:]
        Post post = postService.getPostById(params.postId)
        if(!postService.deletePost(post)){
            List<Post> postList = postService.getAllPostOfUser(user)
            List<Topic> subscribedTopics = topicService.getSubscribedTopicsList(user)
            result.status = "200"
            result.template = g.render(template: '/templates/postTemplate',model:[user:user, posts: postList, subscribedTopics: subscribedTopics, myPost:true])
        }
        else{
            result.status = "500"
        }
        render result as JSON
    }

    def editPost(PostCO postCO){
        User user= springSecurityService.currentUser as User
        Post post = postService.getPostById(params.postId)
        postService.editPost(post,postCO)
        redirect(controller: 'user', action: 'myPost')
    }
}
