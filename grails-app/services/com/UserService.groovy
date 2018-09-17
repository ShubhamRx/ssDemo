package com.ssDemo

import CommandObjects.UserCO
import grails.transaction.Transactional
import com.ssDemo.Enums.InviteStatus
import org.springframework.web.multipart.MultipartFile

@Transactional
class UserService {

    def documentService

    User getUserById(String id){
        return User.get(id)
    }

    def bootstrapUser(User user, Role role) {
        if (!user.save()) {
            user.errors.allErrors.each {
                println(it)
            }
        } else {
            if (role) {
                UserRole.create(user, role).save()
            } else {
                println("Unable to find Role")
            }
            println("User Created with Role " + role?.authority)
        }
    }

    User createUserWithRole(UserCO userCO, MultipartFile file) {
        User user = new User()
        user.properties = userCO.properties
        String path = file.originalFilename
        if (path) {
            user.photo = true
            documentService.saveProfilePhotoOfUser(file, path, user.UID.toString())
        }
        if (user.save(flush: true)) {
            Role role = Role.findByAuthority("ROLE_USER")
            UserRole.create(user, role).save()
        }
        return user
    }

    User updateUserProfile(User user,UserCO userCO){
        user.firstName = userCO.firstName
        user.lastName = userCO.lastName
        return user.save(flush:true)
    }

    List<User> getEligibleUsersForTopic(Topic topic){
        List<User> subscribedUsers = Subscription.findAllByTopic(topic).user
        List<User> rejectedUsers = Invite.findAllByStatusAndForTopic(InviteStatus.REJECTED,topic)?.invitationTo
        return (User.list() - subscribedUsers - rejectedUsers)
    }
}
