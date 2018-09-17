package com.ssDemo

import CommandObjects.PostCO
import grails.transaction.Transactional
import grails.util.Holders
import org.springframework.web.multipart.MultipartFile

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

    List<Post> getAllPostOfTopic(Topic topic){
        return Post.findAllByTopic(topic)
    }

    List<Post> getAllPostOfTopicList(List<Topic> allTopicList){
        return Post.findAllByTopicInList(allTopicList)
    }

    Post editPost(Post post,PostCO postCO){
        post.subject = postCO.subject
        post.description = postCO.description
        post.link = postCO.link
        return post.save(flush:true)
    }

    void createPost(PostCO postCO, MultipartFile file){
        String path = file.originalFilename
        Post post = new Post()
        post.properties = postCO.properties
        if(path && path.substring(path.length()-3,path.length()).equalsIgnoreCase("pdf"))
        {
            post.document = path
            file.transferTo(new File("${Holders.grailsApplication.config.documentFolder}"+path))
        }
        post.save(flush:true)
    }
}
