<div class="modal fade" id="shareTopicModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Share Topic : ${topic?.topicName}</h4>
            </div>

            <div class="modal-body">
                <g:if test="${userList}">
                    <form action="${createLink(controller: 'topic', action: 'shareTopic')}" id="shareTopicForm">
                        <table class="table-responsive table">
                            <g:each in="${userList}" var="targetUser">
                                <tr>
                                    <td>
                                        <g:if test="${targetUser?.photo}">
                                            <g:img dir="images" file="${targetUser?.UID}.jpg" height="75px" width="90px"
                                                   style="border-radius: 50%"/>
                                        </g:if>
                                        <g:else>
                                            <g:img dir="images" file="default.jpg" height="75px" width="90px"
                                                   style="border-radius: 50%"/>
                                        </g:else>
                                        <br>@${targetUser?.username}
                                    </td>
                                    <td><label style="padding: 5px">${targetUser?.fullName}</label>
                                        <br><label style="padding: 5px">Total Subscriptions :</label>
                                    </td>
                                    <td>
                                        <label style="padding: 5px">
                                            <input type="button" id="invite_${targetUser?.id}"
                                                                           class="btn btn-primary"
                                                                           value="Invite ${targetUser?.firstName}"
                                                                           onclick="invite(${targetUser?.id}, ${topic?.id})" />
                                            <input type="button" id="pending_${targetUser?.id}"
                                                   class="btn btn-info" value="Pending" disabled/>
                                            <g:if test="${com.ssDemo.Invite.findByInvitationToAndForTopic(targetUser,topic)}">
                                                <script>
                                                        $("#pending_${targetUser?.id}").show();
                                                        $("#invite_${targetUser?.id}").hide();
                                                </script>
                                            </g:if>
                                            <g:else>
                                                <script>
                                                    $("#invite_${targetUser?.id}").show();
                                                    $("#pending_${targetUser?.id}").hide();
                                                </script>
                                            </g:else>
                                        </label>


                                        <br><label
                                            style="padding: 5px">${com.ssDemo.Subscription.countByUser(targetUser)}</label>
                                    </td>
                                </tr>
                            </g:each>

                        </table>
                    </form>
                </g:if>
                <g:else>
                    No User To Share Topic With, Exists.
                </g:else>

            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>

        </div>
    </div>
</div>

<script>
    function invite(userId, topicId) {
        var userId = userId;
        var topicId = topicId;
        var inviteBtn = document.getElementById("invite_" + userId);
        var pendingBtn = document.getElementById("pending_"+userId);
        $.ajax({
            url: "${createLink(controller:'topic' ,action:'inviteUser')}",
            data: {userId: userId, topicId: topicId},
            success: function (data) {
                if (data.status == "200") {
                    $(inviteBtn).hide();
                    $(pendingBtn).show();
                    $.notify("User Invited", "success");
                } else{
                    $(inviteBtn).show();
                    $(pendingBtn).hide();
                    $.notify("Not Able To Invite This User","error");
                }
            },
            error: function () {
                $(inviteBtn).show();
                $(pendingBtn).hide();
                $.notify("Not Able To Invite This User", "error");
            }
        })
    }
</script>