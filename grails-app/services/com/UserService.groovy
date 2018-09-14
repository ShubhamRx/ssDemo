package com.ssDemo

import CommandObjects.UserCO
import grails.transaction.Transactional
import org.springframework.web.multipart.MultipartFile

@Transactional
class UserService {

    def documentService

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

}
