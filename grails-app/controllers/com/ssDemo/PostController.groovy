package com.ssDemo

import CommandObjects.PostCO
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER','ROLE_ADMIN'])
class PostController {

    def springSecurityService

    def index() { }

    def opeEditPost(){
        println("Controller: Post, Action: openEditPost")
        User user = springSecurityService.currentUser as User
        Map result = [:]
        Post post = Post.findById(params?.postId)
        result.template = g.render(template: '/templates/editPostTemplate', model: [post: post])
        result.status = "200"
        render result as JSON
    }

    def deletePost(){
        println("Controller: Post, Action: deletePost")
        User user = springSecurityService.currentUser as User
        Map result = [:]
        Post post = Post.findById(params?.postId)
        String path = post?.document
        if(path){
            File file = new File("${grailsApplication.config.documentFolder}"+path)
            if(file.exists()){
                println("File Found....Deleting File")
                file.delete()
                println("File Deleted")
            } else{
                println("No File For This Topic....Deleting Topic")
            }
        }
        post.delete(flush:true)
        if(!Post.exists(post.id)){
            result.status = "200"
            List<Post> postList = Post.findAllByUser(user)
            List<Topic> subscribedTopics = Subscription.findAllByUser(user)*.topic
            result.template = g.render(template: '/templates/postTemplate',model:[user:user, posts: postList, subscribedTopics: subscribedTopics, myPost:true])
        } else{
            result.status = "500"
        }
        render result as JSON
    }

    def editPost(PostCO postCO){
        println("Controller: Post, Action: editPost")
        User user= springSecurityService.currentUser as User
        Post post = Post.findById(params?.postId)
        post.subject = params?.subject
        post.description = params?.description
        post.link = params?.link
        post.save()
        redirect(controller: 'user', action: 'myPost')
    }
}
