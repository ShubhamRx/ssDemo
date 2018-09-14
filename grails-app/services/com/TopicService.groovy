package com.ssDemo

import CommandObjects.PostCO
import CommandObjects.TopicCO
import com.ssDemo.Enums.Seriousness
import grails.transaction.Transactional
import grails.util.Holders

@Transactional
class TopicService {

    def serviceMethod() {

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
            subscription.seriousness = com.ssDemo.Enums.Seriousness.CASUAL
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

    Topic createTopic(TopicCO topicCO){
        Topic topic = new Topic()
        topic.properties = topicCO.properties
        if(topic.save()){
            Subscription subscription = new Subscription()
            subscription.user = topic.createdBy
            subscription.topic = topic
            subscription.seriousness = com.ssDemo.Enums.Seriousness.VERY_SERIOUS
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
        invite.status = com.ssDemo.Enums.InviteStatus.INVITED
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
        topic.properties = topicCO.properties
        if(topic.save()){
            return topic
        } else{
            return null
        }
    }

    List<Topic> getAllTopicsForUser(User user){
        List<Topic> publicTopicList = Topic.getPublicTopicList()
        List<Topic> subscribedTopicList = getSubscribedTopicsList(user)
        List<Topic> privateTopicList = subscribedTopicList - publicTopicList
        List<Topic> allTopicList = publicTopicList + privateTopicList
        return allTopicList
    }

    Post createPost(PostCO postCO,String path=null){
        Post post = new Post()
        post.properties = postCO.properties
        if(path){
            post.document = path
        }
        if(post.save()){
            return post
        } else{
            return null
        }
        return post
    }
}
