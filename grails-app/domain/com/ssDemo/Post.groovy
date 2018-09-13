package com.ssDemo

class Post {

    String subject
    String description
    Date dateCreated
    Date lastUpdated
    String document
    String link
    String Uid = UUID.randomUUID()

    static belongsTo = [topic: Topic,user: User]

    static constraints = {
        document(nullable: true)
        link(nullable: true)
    }

    static mapping = {
        description sqlType: 'text'
        link sqlType: 'text'
        document sqlType: 'text'
    }

    String stringDateCreated(){
        return this.dateCreated.format("dd-MMM-yyyy")
    }
}
