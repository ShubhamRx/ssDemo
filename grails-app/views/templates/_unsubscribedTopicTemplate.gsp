<div class="col-sm-12 circleHead">Topics</div>
<g:set var="userId" value="${user?.id}"/>

<g:if test="${unsubscribedTopicList}">
    <g:each in="${unsubscribedTopicList}" var="topic">
        <div class="col-sm-12 box-without-top-bottom">
            <div class="col-sm-3 ">
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
                        <g:link controller="topic" action="showPost" params="[topicId: topic?.uuid]">${topic?.topicName}</g:link>
                    </label>
                </div>

                <div class="col-sm-12">
                    <label style="font-size: medium">@${topic?.createdBy?.username}</label>
                </div>

                <div class="col-sm-6" style="margin-top: 5%">
                    Subscriptions
                </div>

                <div class="col-sm-6" style="margin-top: 5%">
                    <input type="button" name="subscribe_${topic?.id}" id="subscribe_${topic?.id}"
                           class="btn-link" value="subscribe" onclick="subscribe(${user?.id}, ${topic?.id})"/>
                </div>

                <div class="col-sm-6"  style="padding-left: 10%">
                    <label style="font-size: medium;color: deepskyblue">${com.ssDemo.Subscription.countByTopic(topic)}</label>
                </div>

                <div class="col-sm-6">
                    <g:if test="${!com.ssDemo.Subscription.findByUserAndTopic(user, topic)}">
                        <g:select from="${com.ssDemo.Enums.Seriousness}" name="seriousness" id="seriousness"
                                  noSelection="['': 'Select Any One']"/>
                    </g:if>

                </div>

            </div>

        </div>
    </g:each>
</g:if>
<g:else>
    <div class="col-sm-12 box-without-top-bottom">
        No Non-Subscribed Topic Exists.
    </div>
</g:else>

<script>
    function subscribe(userId, topicId) {
        var userId = userId;
        var topicId = topicId;
        var seriousnessObject = document.getElementById("seriousness");
        var seriousness = seriousnessObject.value;
        var subscribedDiv = document.getElementById("subscribedTopicDiv");
        var unsubscribedDiv = document.getElementById("UnsubscribedTopicListDiv");
        if (seriousness == "") {
            $.notify("Please Select Seriousness", "error");
        } else {
            $.ajax({
                url: "${createLink(controller: 'topic',action: 'subscribeAjax')}",
                data: {userId: userId, topicId: topicId, seriousness: seriousness},
                success: function (data) {
                    if (data.status == "200") {
                        $(subscribedDiv).html(data.subscribedTemplate);
                        $(unsubscribedDiv).html(data.unsubscribedTemplate);
                        $.notify("Topic Subscribed ", "success");
                    } else {
                        $.notify("Unable to Subscribe", "error")
                    }
                },
                error: function (data) {
                    $.notify("Unable to Subscribe", "error");
                }
            })
        }
    }
</script>