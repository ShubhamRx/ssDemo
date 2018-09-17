package com.ssDemo

import CommandObjects.UserCO
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.apache.tomcat.util.http.fileupload.FileUploadBase
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContext
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.multipart.MultipartFile

import javax.servlet.ServletException

@Secured(['permitAll'])
class SignUpController {

    def userService

    def openSignUpForm() {
        UserCO userCO = new UserCO()
        Map result = [:]
        result.template = g.render(template: '/templates/signUpTemplate', model: [userCO: userCO])
        render result as JSON
    }

    def userSignUp(UserCO userCO) {
        println("Controller: signUp, Action: userSignUp")
        if (userCO.validate()) {
            MultipartFile file = request.getFile('photo')
            User user = userService.createUserWithRole(userCO, file)
        } else {
            userCO.errors.allErrors.each {
                log.error(it)
            }
        }
        render(view: '/login/auth', model: [isSignUp: true, userCO: userCO, topicList: []])
    }
}