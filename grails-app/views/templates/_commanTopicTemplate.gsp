<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css"
      integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>

<div class="table-responsive">

    <table class="table table-hover table-striped" style="border: 1px solid gray;" id="topicTable">
        <thead>
        <tr style="background-color: rgba(70,188,220,.5);">
            <td>Topic Name</td>
            <td>Visibility</td>
            <td>Subscribers</td>
            <td>Created On</td>
            <g:if test="${showStatus}">
                <td>Status</td>
                <td>Action</td>
                <td>Owner</td>
            </g:if>
            <g:else>
                <td>Action</td>
            </g:else>
            <td>Subscribers</td>

        </tr>
        </thead>

        <g:if test="${topicList}">
            <g:each in="${topicList}" var="topic">

                <tbody>
                <tr>
                    <td>
                        <g:link controller="topic" action="showPost" params="[topicId: topic?.uuid]">${topic.topicName}</g:link>
                    </td>
                    <td>${topic.visibility}</td>
                    <td>${com.ssDemo.Subscription.countByTopic(topic)}</td>
                    <td>${topic.getDateCreatedString()}</td>
                    <g:if test="${showStatus}">
                        <g:if test="${com.ssDemo.Subscription.findByUserAndTopic(user, topic)}">
                            <td>
                                Subscribed
                            </td>
                            <td>
                                <button class="btn btn-link" id="share_${topic?.uuid}"
                                        onclick="share(${topic?.id}, ${user?.id})">
                                    <i class="fas fa-marker" style="color:deepskyblue"></i></button>
                                <g:if test="${topic?.createdBy?.id != user?.id}">
                                <button class="btn btn-link" id="unsubscribe_${topic?.uuid}"
                                        onclick="unsubscribe(${topic?.id}, ${user?.id})">
                                    <i class="fas fa-backspace" style="color: red"></i></button>
                                </g:if>
                            </td>

                        </g:if>
                        <g:else>
                            <td>
                                <g:select name="seriousness" class="form-group-sm"
                                          from="${com.ssDemo.Enums.Seriousness}"
                                          id="seriousness_${topic?.id}" noSelection="['': '- select any one']"/>
                            </td>
                            <td>
                                <input type="button" name="subscribe_${topic.id}" id="subscribe_${topic.id}"
                                       value="subscribe" class="btn btn-primary"
                                       onclick="subscribe(${topic.id}, ${user.id})">
                            </td>
                        </g:else>

                        <td>
                            <g:if test="${topic?.createdBy?.photo}">
                                <g:img dir="images" file="${topic?.createdBy?.UID}.jpg" height="25px" width="25px"/>
                            </g:if>
                            <g:else>
                                <g:img dir="images" file="default.jpg" height="25px" width="25px"/>
                            </g:else>
                            ${topic?.createdBy?.fullName}
                        </td>
                    </g:if>
                    <g:else>
                        <td>
                            <button class="btn btn-link" id="share_${topic?.uuid}"
                                    onclick="edit(${topic?.id}, ${user?.id}, '${topic?.topicName}', '${topic?.visibility}')"><i class="far fa-edit"
                                                                                  style="color: blue"></i></button>
                            <button class="btn btn-link" id="share_${topic?.uuid}"
                                    onclick="del(${topic?.id}, ${user?.id})"><i class="fas fa-trash-alt"
                                                                                  style="color:red;"></i></button>
                            <button class="btn btn-link" id="share_${topic?.uuid}"
                                    onclick="share(${topic?.id}, ${user?.id})">
                                <i class="fas fa-marker" style="color:deepskyblue"></i></button>
                        </td>
                    </g:else>
                    <td><button class="btn btn-link" id="list_${topic?.uuid}"
                                onclick="subscribersList(${topic?.id})">
                        <i class="fas fa-list-alt"></i></button></td>
                </tr>
                </tbody>

            </g:each>

        </g:if>

        <g:else>

            <tbody>
            <tr>
                <td>No Topic Found</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>

            </tbody>

        </g:else>
    </table>
</div>

<div id="shareTopicModalDiv">

</div>

<div id="editTopicModalDiv">
<g:render template="/templates/editTopicModalTemplate" model="[user: user]"/>
</div>

<div id="subscribersModalDiv">

</div>
<script>
    function subscribe(topicId, userId) {
        var seriousnessDiv = document.getElementById("seriousness_" + topicId);
        var seriousness = seriousnessDiv.value;
        var allTopicDiv = document.getElementById("allTopicsDiv");
        if (seriousness) {
            $.ajax({
                url: "${createLink(controller: 'topic', action:'subscribeFromAllTopicsAjax')}",
                data: {userId: userId, topicId: topicId, seriousness: seriousness},
                success: function (data) {
                    if (data.status == "200") {
                        $(allTopicDiv).html(data.template);
                        $.notify("Subscribed", "success");
                    } else {
                        $.notify("Error", "error");
                    }
                },
                error: function () {
                    $.notify("Error", "error");
                }
            })
        } else {
            $.notify("Please Select Seriousness Before Subscribing", "error");
        }

    }

    function share(topicId, userId) {
        var topicId = topicId;
        var userId = userId;
        var shareTopicModalDiv = document.getElementById("shareTopicModalDiv");
        $.ajax({
            url: "${createLink(controller:'user' ,action:'openShareTopicModal' )}",
            data: {userId: userId, topicId: topicId},
            success: function (data) {
                if (data.status == "200") {
                    $(shareTopicModalDiv).html(data.template);
                    $("#shareTopicModal").modal();
                } else {
                    $.notify("Not Able to Share This Topic");
                }
            },
            error: function () {
                $.notify("Not Able to open Share This Topic", "error");
            }
        })
    }

    function edit(topicId, userId, topicName, visibility){
        var topicId = topicId;
        var userId = userId;
        var topicName = topicName;
        var visibility = visibility;
        var editTopicModalDiv = document.getElementById("editTopicModalDiv");
        $("#editTopicModal #editTopicName").val(topicName);
        $("#editTopicModal #editVisibility").val(visibility);
        $("#editTopicModal #editTopicId").val(topicId);
        $("#editTopicModal").modal();


    }

    function del(topicId, userId){
        var topicId = topicId;
        var userId = userId;
        var commanTopicTemplateDiv = document.getElementById("myTopicsDiv");
        var delConfirm = confirm("Are You Sure To Delete");
        if(delConfirm){
            $.ajax({
                url: "${createLink(controller: 'topic', action: 'deleteTopic')}",
                data: {userId: userId, topicId: topicId},
                success: function (data) {
                    if(data.status=="200"){
                        $(commanTopicTemplateDiv).html(data.template);
                        $.notify("Topic Deleted Successfully","success");
                    } else{
                        $.notify("Not Able to Delete","error");
                    }
                },
                error: function () {
                    $.notify("Not Able To Delete","error");
                }
            })
        } else{
            $.notify("Deletion Aborted","success");
        }

    }

    function unsubscribe(topicId, userId){
        var topicId = topicId;
        var userId = userId;
        var allTopicDiv = document.getElementById("allTopicsDiv");
        $.ajax({
            url: "${createLink(controller: 'topic', action: 'unsubscribeFromAllTopicList')}",
            data: {userId: userId, topicId: topicId},
            success: function (data) {
                if (data.status == "200") {
                    $(allTopicDiv).html(data.template);
                    $.notify("Topic Unsubscribed ", "success");
                } else {
                    $.notify("Error", "error");
                }
            },
            error: function () {
                $.notify("Error", "error");
            }
        })
    }

    function subscribersList(topicId){
        var topicId = topicId;
        var subscribersModalDiv = document.getElementById("subscribersModalDiv");
        $.ajax({
            url: "${createLink(controller: 'topic', action: 'subscribersList')}",
            data: {topicId:topicId},
            success: function (data) {
                if(data.status=="200"){
                    $(subscribersModalDiv).html(data.template);
                    $("#subscribersModal").modal();
                } else{
                    $.notify("No Subscribers Found","error");
                }
            },
            error: function () {
                $.notify("Error","error");
            }
        })
    }
</script>

