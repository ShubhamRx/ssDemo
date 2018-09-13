<%@ page import="com.ssDemo.Subscription" %>
<div class="col-sm-12 circleHead">Subscribtions</div>
<g:if test="${subscribedTopicList}">
    <g:each in="${subscribedTopicList}" var="topic">

        <div class="col-sm-12 box-without-top-bottom">
            <div class="col-sm-3" style="padding-left: 0px;">
                <g:if test="${topic?.createdBy?.photo}">
                    <g:img dir="images" file="${topic?.createdBy?.UID}.jpg" height="130px" width="110px"/>
                </g:if>
                <g:else>
                    <g:img dir="images" file="default.jpg" height="130px" width="110px"/>
                </g:else>
            </div>

            <div class="col-sm-9" style="border-left: 1px solid gray">
                <div class="col-sm-12">
                    <label style="font-size: x-large">
                        <g:link controller="topic" action="showPost" params="[topicId: topic?.uuid]"> ${topic?.topicName} </g:link>
                    </label>
                </div>

                <div class="col-sm-12">
                    <label style="font-size: medium">@${topic?.createdBy?.username}</label>
                </div>

                <div class="col-sm-6 " style="margin-top: 3%">
                    Subscriptions
                </div>

                <div class="col-sm-6 " style="margin-top: 3%">
                    <g:if test="${topic?.createdBy?.id != user?.id}">
                        <input type="button" name="unsubscribe_${topic?.id}" id="unsubscribe_${topic?.id}"
                               class="btn-link" value="Unsubscribe" onclick="unsubscribe(${user?.id}, ${topic?.id})"/>
                    </g:if>
                    <g:else>
                        <input type="button" class="btn btn-block" value="Unsubscribe" disabled/>
                    </g:else>
                </div>

                <div class="col-sm-6 " style="padding-left: 10%;margin-top: 2%">
                    <label style="font-size: medium;color: deepskyblue">${com.ssDemo.Subscription.countByTopic(topic)}</label>
                </div>

                <div class="col-sm-6" style="margin-top: 2%">
                    <g:select name="seriousness_${topic?.id}" id="seriousness_${topic?.id}"
                              from="${com.ssDemo.Enums.Seriousness}"
                              value="${com.ssDemo.Subscription.findByUserAndTopic(user, topic).seriousness}"
                              onChange="changeSeriousness(${user?.id},${topic?.id})"/>
                </div>
            </div>
        </div>
    </g:each>
</g:if>
<g:else>
    <div class="col-sm-12 box-without-top-bottom">
        You Have Not Subscribed To Any Topic
    </div>
</g:else>

<script>
    function unsubscribe(userId, topicId) {
        var userId = userId;
        var topicId = topicId;
        var subscribedDiv = document.getElementById("subscribedTopicDiv");
        var unsubscribedDiv = document.getElementById("UnsubscribedTopicListDiv");
        $.ajax({
            url: "${createLink(controller: 'topic', action: 'unsubscribeAjax')}",
            data: {userId: userId, topicId: topicId},
            success: function (data) {
                if (data.status == "200") {
                    $(subscribedDiv).html(data.subscribedTemplate);
                    $(unsubscribedDiv).html(data.unsubscribedTemplate);
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


    function changeSeriousness(userId, topicId) {
        var userId = userId;
        var topicId = topicId;
        var seriousnessSelectBox = document.getElementById("seriousness_" + topicId);
        var seriousness = seriousnessSelectBox.value;
        $.ajax({
            url: "${createLink(controller: 'topic', action: 'changeSeriousnessAjax')}",
            data: {userId: userId, topicId: topicId, seriousness: seriousness},
            success: function (data) {
                if (data.status == "200") {
                    $.notify("Status Changed Successfully", "success");
                } else {
                    $.notify("Error", "error");
                }
            },
            error: function () {
                $.notify("Error", "error");
            }
        })
    }
</script>
