package CommandObjects

import com.ssDemo.Topic
import com.ssDemo.User
import grails.validation.Validateable

class PostCO implements Validateable{

    String subject
    String description
    Topic topic
    User user
    String link

    static constraints = {
        link(nullable: true)
    }
}