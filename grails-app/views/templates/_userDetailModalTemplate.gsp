<div class="modal fade" id="userDetailModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">User Detail</h4>
            </div>

            <div class="modal-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                        <tr>
                            <td>
                                <g:if test="${user?.photo}">
                                    <g:img dir="images" file="${user?.UID}.jpg" height="120px" width="120px"/>
                                </g:if>
                                <g:else>
                                    <g:img dir="images" file="default.jpg" height="150px" width="150px"/>
                                </g:else>
                            </td>
                            <td>
                                <b>${user?.fullName}</b> Joined LinkSharing On <b>${user?.stringDateCreated()}</b> with Username <b>@${user?.username}</b> and Email Id <b>${user?.email}</b>.<br>
                                <b>${user?.username}</b> has created <b>${com.ssDemo.Topic.countByCreatedBy(user)}</b> topics since joining.<br>
                                <b>${user?.username}'s</b> total subscriptions till date : <b>${com.ssDemo.Subscription.countByUser(user)}</b>.
                            </td>
                        </tr>
                        </thead>

                    </table>

                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <td colspan="3"><h3>Topics</h3></td>
                        </tr>

                        <tr>
                            <th>TopicName</th>
                            <th>Visibility</th>
                            <th>Total Subscribers</th>
                            <th>Created On</th>
                        </tr>

                        </thead>

                        <tbody>
                        <g:if test="${topicList}">
                            <g:each in="${topicList}" var="topic">
                                <tr>
                                    <td>${topic?.topicName}</td>
                                    <td>${topic?.visibility}</td>
                                    <td>${com.ssDemo.Subscription.countByTopic(topic)}</td>
                                    <td>${topic?.dateCreatedString}</td>
                                </tr>
                            </g:each>
                        </g:if>
                        <g:else>

                            <tr>
                                <td>No Topics</td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>

                        </g:else>
                        </tbody>
                    </table>

                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <td colspan="3"><h3>Subscriptions</h3></td>
                        </tr>

                        <tr>
                            <th>TopicName</th>
                            <th>Visibility</th>
                            <th>Total Subscribers</th>
                        </tr>

                        </thead>

                        <tbody>
                        <g:if test="${subscriptionList}">
                            <g:each in="${subscriptionList}" var="subscription">
                                <tr>
                                    <td>${subscription?.topic?.topicName}</td>
                                    <td>${subscription?.topic?.visibility}</td>
                                    <td>${com.ssDemo.Subscription.countByTopic(subscription?.topic)}</td>
                                </tr>
                            </g:each>
                        </g:if>
                        <g:else>

                            <tr>
                                <td>No Subscriptions</td>
                                <td></td>
                                <td></td>
                            </tr>

                        </g:else>
                        </tbody>
                    </table>

                </div>
            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>

        </div>
    </div>
</div>
