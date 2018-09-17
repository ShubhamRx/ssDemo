package com.ssDemo

import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class PublicController {

    def springSecurityService
    def topicService

    def login(){
        if(springSecurityService.isLoggedIn()){
            redirect(controller:'user',action: 'dashboard')
        } else{
            List<Topic> topicList = topicService.getMostSubscribedTopics()
            println(topicList)
            render(view:'/login/auth', model:[topicList: topicList])
        }

    }


}
