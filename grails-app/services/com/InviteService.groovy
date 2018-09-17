package com.ssDemo

import grails.transaction.Transactional
import com.ssDemo.Enums.InviteStatus
import com.ssDemo.Enums.Seriousness

@Transactional
class InviteService {

    def topicService

    Map<String,String> takeActionOnInvitation(Invite invite,String status){
        Map inviteResult = [:]
        if(status == "READ"){
            invite.status = InviteStatus.PENDING
            inviteResult.msg = "Invitation Read"
            inviteResult.status = "200"
        } else if(status == "ACCEPT"){
            Subscription subscription = topicService.subscribeToTopic(invite.invitationTo,invite.forTopic,Seriousness.SERIOUS)
            if(subscription){
                invite.status = InviteStatus.ACCEPTED
                inviteResult.msg = "Invitation Accepted"
                inviteResult.status = "200"
            } else{
                inviteResult.status = "500"
            }

        } else if(status == "REJECT"){
            invite.status = InviteStatus.REJECTED
            inviteResult.msg = "Invitation Rejected"
            inviteResult.status = "200"
        }
        invite.save(flush:true)
        return inviteResult
    }
}
