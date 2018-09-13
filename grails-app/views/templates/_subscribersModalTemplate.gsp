<div class="modal fade" id="subscribersModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Subscribers For : ${topic?.topicName}</h4>
            </div>

            <div class="modal-body">
                <g:if test="${subscribersList}">
                    <table class="table-responsive table">
                        <g:each in="${subscribersList}" var="subscriber">
                            <tr>
                                <td>
                                    <g:if test="${subscriber?.photo}">
                                        <g:img dir="images" file="${subscriber?.UID}.jpg" height="75px" width="90px"
                                               style="border-radius: 50%"/>
                                    </g:if>
                                    <g:else>
                                        <g:img dir="images" file="default.jpg" height="75px" width="90px"
                                               style="border-radius: 50%"/>
                                    </g:else>
                                    <br>@${subscriber?.username}
                                </td>
                                <td><label style="padding: 5px">${subscriber?.fullName}</label>
                                    <br><label style="padding: 5px">Total Subscriptions :</label>
                                </td>
                                <td>
                                    <br><br><label
                                        style="padding: 5px">${com.ssDemo.Subscription.countByUser(subscriber)}</label>
                                </td>
                            </tr>
                        </g:each>

                    </table>
                </g:if>
                <g:else>
                    No User Has Subscribed This Topic.
                </g:else>

            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>

        </div>
    </div>
</div>
