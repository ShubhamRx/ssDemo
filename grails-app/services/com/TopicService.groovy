package com.ssDemo

import CommandObjects.PostCO
import CommandObjects.TopicCO
import com.ssDemo.Enums.Seriousness
import grails.transaction.Transactional
import grails.util.Holders
import com.ssDemo.Enums.InviteStatus
import grails.web.servlet.mvc.GrailsParameterMap
import org.xhtmlrenderer.css.parser.property.PrimitivePropertyBuilders

@Transactional
class TopicService {

    Integer getTopicCountByUser(User user){
        return Topic.countByCreatedBy(user)
    }

    Topic getTopicById(String id){
        return Topic.get(id)
    }

    Topic getTopicByUid(String uuid){
        return Topic.findByUuid(uuid)
    }

    def bootstrapTopic(TopicCO topicCO){
        Topic topic= new Topic(topicCO)
        if(!topic.save()){
            topic.errors.allErrors.each {
                println(it)
            }
        } else{
            Subscription subscription = new Subscription()
            subscription.topic = topic
            subscription.user = topic.createdBy
            subscription.seriousness = Seriousness.CASUAL
            subscription.save()
            println("Topic "+topic.topicName+" Created By "+topic.createdBy)
        }
    }

    List<Topic> getSubscribedTopicsList(User user){
        List<Topic> subscribedTopicList = Subscription.createCriteria().list() {
            eq('user',user)
            projections{
                property('topic')
            }
        }
        return subscribedTopicList
    }

    List<Topic> getUnsubscribedTopicList(List<Topic> subscribedTopicList){
        return(Topic.getPublicTopicList() - subscribedTopicList)
    }

    Topic createTopic(TopicCO topicCO){
        Topic topic = new Topic()
        topic.properties = topicCO.properties
        if(topic.save()){
            Subscription subscription = new Subscription()
            subscription.user = topic.createdBy
            subscription.topic = topic
            subscription.seriousness = Seriousness.VERY_SERIOUS
            subscription.save()
            return topic
        } else{
            return null
        }

    }

    Subscription subscribeToTopic(User user,Topic topic,Seriousness seriousness){
        Subscription subscription = new Subscription()
        subscription.topic = topic
        subscription.user = user
        subscription.seriousness = seriousness
        if(subscription.save()){
            return subscription
        } else{
            return null
        }
    }

    Invite inviteUser(User user,User targetUser,Topic topic){
        Invite invite = new Invite()
        invite.invitedBy = user
        invite.invitationTo = targetUser
        invite.forTopic = topic
        invite.status = InviteStatus.INVITED
        if(invite.save()){
            return invite
        } else{
            return null
        }
    }

    void deleteSubscriptionsForTopic(Topic topic){
        Subscription.findAllByTopic(topic).each {
            it.delete()
        }
    }

    void deleteInviteForTopic(Topic topic){
        Invite.findAllByForTopic(topic).each {
            it.delete()
        }
    }

    void deletePostForTopic(Topic topic){
        Post.findAllByTopic(topic).each {
            String path = it.document
            if(path){
                File file = new File("${Holders.grailsApplication.config.documentFolder}"+path)
                if(file.exists()){
                    println("File Found....Deleting File")
                    file.delete()
                    println("File Deleted")
                } else{
                    println("No File For This Topic....Deleting Topic")
                }
            }
            it.delete()
        }
    }

    Boolean deleteTopic(Topic topic){
        deleteInviteForTopic(topic)
        deleteSubscriptionsForTopic(topic)
        deletePostForTopic(topic)
        topic.delete()
        println("Topic Deleted = "+Topic.exists(topic.id))
        return Topic.exists(topic.id)
    }

    Topic editTopic(Topic topic, TopicCO topicCO){
        topic.topicName = topicCO.topicName
        topic.visibility = topicCO.visibility
        return topic.save(flush:true)
    }

    List<Topic> getAllTopicsForUser(User user){
        List<Topic> publicTopicList = Topic.getPublicTopicList()
        List<Topic> subscribedTopicList = getSubscribedTopicsList(user)
        List<Topic> privateTopicList = subscribedTopicList - publicTopicList
        List<Topic> allTopicList = publicTopicList + privateTopicList
        return allTopicList
    }

    List<Topic> getAllCreatedTopicOfUser(User user){
        return Topic.findAllByCreatedBy(user)
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
