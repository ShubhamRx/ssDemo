<%@ page import="com.ssDemo.Topic" %>
<div class="table-responsive">
    <table class="table table-hover table-striped" style="border: 1px solid gray;" id="userTable">
        <thead>
        <tr style="background-color: rgba(70,188,220,.5);">
            <td>User</td>
            <td>Username</td>
            <td>Email</td>
            <td>First Name</td>
            <td>Last Name</td>
            <td>Topics Owns</td>
            <td>Subscribed To</td>
        </tr>
        </thead>

        <g:if test="${userList}">
            <g:each in="${userList}" var="thisUser">
                <tbody>
                <tr >
                    <td>
                        <g:if test="${thisUser?.photo}">
                            <g:img dir="images" file="${thisUser?.UID}.jpg" height="30px" width="30px"/>
                        </g:if>
                        <g:else>
                            <g:img dir="images" file="default.jpg" height="30px" width="30px"/>
                        </g:else>
                    </td>
                    <td><button class="btn btn-info" style="width: 80%" onclick="userDetailForAdmin(${thisUser.id})"> @${thisUser.username}</button></td>
                    <td>${thisUser.email}</td>
                    <td>${thisUser.firstName}</td>
                    <td>${thisUser.lastName}</td>
                    <td>${com.ssDemo.Topic.countByCreatedBy(thisUser)}</td>
                    <td>${com.ssDemo.Subscription.countByUser(thisUser)}</td>
                </tr>
                </tbody>
            </g:each>
        </g:if>
        <g:else>
            <tbody>
            <tr>
                <td>No User Found</td>
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

<div id="userDetailDiv">

</div>

<script>
    function userDetailForAdmin(userId){
        var userId = userId;
        var div = document.getElementById("userDetailDiv");
        $.ajax({
            url: "${createLink(controller: 'admin', action: 'userDetail')}",
            data: {userId: userId},
            success: function (data) {
                if(data.status=="200"){
                    $(div).html(data.template);
                    $("#userDetailModal").modal();
                } else{
                    $.notify("Not Able to Open Details ","error");
                }
            },
            error: function () {
                $.notify("Not Able to Open Details ","error");
            }
        })
    }
</script>