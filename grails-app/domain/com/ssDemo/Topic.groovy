package com.ssDemo
import CommandObjects.TopicCO

import java.sql.Timestamp
import java.text.DateFormat
import java.text.SimpleDateFormat

class Topic {

    String topicName
    com.ssDemo.Enums.Visibility visibility
    Date dateCreated
    Date lastUpdated
    String uuid = UUID.randomUUID()

    static belongsTo = [createdBy: User]
    static hasMany = [posts: Post]

    static constraints = {
        uuid(nullable: false)
    }

    static transients = ['dateCreatedString','publicTopicList']

    Topic(){

    }

    Topic(TopicCO topicCO){
        this.topicName = topicCO.topicName
        this.visibility = topicCO.visibility
        this.createdBy = topicCO.createdBy
    }

    String getDateCreatedString(){
        this.dateCreated.format("dd-MM-yyyy")
    }

    static List<Topic> getPublicTopicList(){
        List<Topic> publicTopicList = Topic.createCriteria().list {
            eq('visibility', com.ssDemo.Enums.Visibility.PUBLIC)
        }
        return publicTopicList
    }

    List<User> subscribersList(){
        List<User> userList = Subscription.findAllByTopic(this)?.user
        return userList
    }
}
