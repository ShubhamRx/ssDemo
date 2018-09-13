package com.ssDemo

import CommandObjects.UserCO
import com.ssDemo.Topic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

	private static final long serialVersionUID = 1

	transient springSecurityService
    def userService

	String username
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	String email
    String firstName
    String lastName
	Boolean photo
    Date dateCreated
    Date lastUpdated
    String UID = UUID.randomUUID()

    static hasMany = [topics:Topic,posts: Post]

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this)*.role
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
        password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}

	static transients = ['springSecurityService','fullName']

	static constraints = {
		password blank: false, password: true
		username blank: false, unique: true
		photo nullable: true, blank: false
	}

	static mapping = {
		password column: '`password`'
	}

    User(){

    }

    User(UserCO userCO){
        println("*******************************")
        println(userCO.password.class)
        println(userCO.password)
        this.username = userCO.username
        this.email = userCO.email
        this.password = userCO.password
        encodePassword()
        this.firstName = userCO.firstName
        this.lastName = userCO.lastName
    }

    String getFullName(){
        return this.firstName+" "+this.lastName
    }

	String stringDateCreated(){
        return this.dateCreated.format("dd-MMM-yyyy")
    }
}
