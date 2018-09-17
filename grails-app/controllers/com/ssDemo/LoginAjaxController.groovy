package com.ssDemo

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class LoginAjaxController {

    def openLogInForm(){
        Map result =[:]
        result.template = g.render(template: '/templates/userLogin')
        render result as JSON
    }
}
