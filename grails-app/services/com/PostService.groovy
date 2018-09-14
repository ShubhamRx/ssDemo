package com.ssDemo

import CommandObjects.PostCO
import grails.transaction.Transactional
import grails.util.Holders

@Transactional
class PostService {

    Post getPostById(String id){
        return Post.get(id)
    }

    Boolean deletePost(Post post){
        if(post?.document){
            deleteDocument(post)
        }
        post.delete(flush:true)
        return Post.exists(post.id)
    }

    void deleteDocument(Post post){
        String path = post.document
        File file = new File("${Holders.grailsApplication.config.documentFolder}"+path)
        if(file.exists()) {
            file.delete()
        }
    }

    List<Post> getAllPostOfUser(User user){
        return Post.findAllByUser(user)
    }

    Post editPost(Post post,PostCO postCO){
        post.subject = postCO.subject
        post.description = postCO.description
        post.link = postCO.link
        return post.save(flush:true)
    }
}
