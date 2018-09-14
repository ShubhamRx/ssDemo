package com.ssDemo

import grails.transaction.Transactional
import grails.util.Holders
import org.springframework.web.multipart.MultipartFile

import javax.servlet.ServletException

@Transactional
class DocumentService {

    void saveProfilePhotoOfUser(MultipartFile file,String path,String Uid){
        file.transferTo(new File("${Holders.grailsApplication.config.uploadFolder}" + Uid + ".jpg"))
    }
}
