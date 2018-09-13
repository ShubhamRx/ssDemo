package com.ssDemo

import CommandObjects.UserCO
import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class PublicController {

    def springSecurityService
    def index() { }

    def login(){
        if(springSecurityService.isLoggedIn()){
            redirect(controller:'user',action: 'dashboard')
        } else{
            List<Topic> topicList = getMostSubscribedTopics()
            println(topicList)
            render(view:'/login/auth', model:[topicList: topicList])
        }

    }

    List<Topic> getMostSubscribedTopics(){
        def topicWithNumberOfSubscriptions = Subscription.withCriteria {
            projections{
                groupProperty('topic')
                count()
            }
        }

        SortedMap<Integer, Topic> topicMap=new TreeMap<>()

        topicWithNumberOfSubscriptions.each{
            topicMap.put(it[1] as Integer,it[0] as Topic)
        }

        Map reverseTopicMap = [:]
        topicMap.reverseEach{ key, value ->
            reverseTopicMap[key] = value
        }

        List<Topic> topicList = []

        topicList.add(reverseTopicMap[1] as Topic)
        topicList.add(reverseTopicMap[2] as Topic)

        return topicList
    }
}
