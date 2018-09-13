<div class="table-responsive">
    <table class="table">
        <tr align="right">
            <td colspan="5"><input type="button" name="createPost" id="createPost" class="btn btn-primary" value="Post"
                                   style="width: 10%" onclick="openCreatePostModal()"></td>
        </tr>
    </table>

    <table class="table table-hover" style="border: 1px solid gray">
        <thead>
        <tr style="background-color:  rgba(70,188,220,.5);">
            <th>On Topic</th>
            <th>Posted By</th>
            <th>Subject</th>
            <th>Description</th>
            <th>Posted On</th>
            <th>Document</th>
        </tr>
        </thead>
    <tbody>
        <g:if test="${posts}">
            <g:each in="${posts}" var="post">
                <tbody>
                <tr>
                    <td>${post?.topic?.topicName}</td>
                    <td>
                        <g:if test="${post?.user?.photo}">
                            <g:img dir="images" file="${post?.user?.UID}.jpg" height="25px" width="25px"/>
                        </g:if>
                        <g:else>
                            <g:img dir="images" file="default.jpg" height="25px" width="25px"/>
                        </g:else>
                        ${post?.user?.fullName}
                    </td>
                    <td>${post?.subject}</td>
                    <td>${post?.description}</td>
                    <td>${post?.stringDateCreated()}</td>
                    <td>
                        <g:if test="${post?.document}">
                            <g:link controller="topic" action="readDocument" params="[document:post?.document]">Open</g:link>
                        </g:if>
                        <g:else>
                            -
                        </g:else>
                    </td>
                </tr>
                </tbody>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td>No Posts Available</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        </g:else>
    </tbody>
    </table>
</div>

<div id="createPostModalDiv">
    <g:render template="/templates/createPostModalTemplate" model="[user: user, subscribedTopics: subscribedTopics]"/>
</div>

<script>
    function openCreatePostModal() {
        $("#createPostModal").modal();
    }
</script>