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
            <th>Link</th>
            <g:if test="${myPost}">
                <th>Action</th>
            </g:if>
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
                    <td>
                        <g:if test="${post?.link}">
                            <g:link url="${post?.link}" target="_blank">Visit</g:link>
                        </g:if>
                        <g:else>
                            -
                        </g:else>
                    </td>
                    <g:if test="${myPost}">
                        <td>
                            <button class="btn btn-link" id="edit_${post?.id}"
                                    onclick="editPost(${post?.id})"><i class="far fa-edit"
                                                                   style="color: blue"></i></button>
                            <button class="btn btn-link" id="del_${post?.id}"
                                    onclick="delPost(${post?.id})"><i class="fas fa-trash-alt"
                                                                                style="color:red;"></i></button>
                        </td>
                    </g:if>
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
                <td></td>
                <td></td>
                <g:if test="${myPost}">
                    <td></td>
                </g:if>
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

    function editPost(postId){
        var postId = postId;
        var div = document.getElementById("postDiv");
        $.ajax({
            url: "${createLink(controller: 'post',action: 'opeEditPost')}",
            data: {postId: postId},
            success: function (data) {
                if(data.status=="200"){
                    $(div).html(data.template);
                } else{
                    $.notify("Unable To Edit Post","error");
                }
            },
            error: function () {
                $.notify("This Post Can not be Edited","error");
            }
        })
    }

    function delPost(postId){
        var postId= postId;
        var div = document.getElementById("postDiv");
        $.ajax({
            url: "${createLink(controller: 'post',action: 'deletePost')}",
            data: {postId: postId},
            success: function (data) {
                if(data.status=="200"){
                    $(div).html(data.template);
                    $.notify("Post Deleted","success");
                } else{
                    $.notify("Unable To Edit Post","error");
                }
            },
            error: function () {
                $.notify("This Post Can not be Edited","error");
            }
        })
    }
</script>