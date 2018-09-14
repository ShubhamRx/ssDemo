<%@ page import="CommandObjects.TopicCO" %>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
<div class="leftNav">

    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">
        <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
            <a href="${createLink(controller:'user',action:'dashboard')}" class="a">
                <i class="fas fa-tachometer-alt"></i>
                <label style="font-size: medium">Dashboard</label>
            </a>
        </div>
    </sec:ifAnyGranted>

    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">
    <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
        <a onclick="openCreateTopicModal()" class="a">
            <i class="far fa-plus-square" style=""></i>
            <label style="font-size: medium">Create Topic</label>
        </a>
    </div>
    </sec:ifAnyGranted>

    <sec:ifAllGranted roles="ROLE_ADMIN">
        <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
            <a href="${createLink(controller:'admin',action:'listUser')}" class="a">
                <i class="fas fa-users" style=""></i>
                <label style="font-size: medium">Users</label>
            </a>
        </div>
    </sec:ifAllGranted>

    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">
        <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
            <a href="${createLink(controller:'user',action:'allTopic')}" class="a">
                <i class="fas fa-book"></i>
                <label style="font-size: medium">Topics</label>
            </a>
        </div>
    </sec:ifAnyGranted>

    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">
        <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
            <a href="${createLink(controller:'user',action:'myTopic')}" class="a">
                <i class="fas fa-book-reader"></i>
                <label style="font-size: medium">My Topics</label>
            </a>
        </div>
    </sec:ifAnyGranted>

    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">
        <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
            <a href="${createLink(controller:'user',action:'profile')}" class="a">
                <i class="far fa-user-circle"></i>
                <label style="font-size: medium">Profile</label>
            </a>
        </div>
    </sec:ifAnyGranted>

    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">
        <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
            <a href="${createLink(controller:'topic',action:'showPost')}" class="a">
                <i class="fas fa-file-signature"></i>
                <label style="font-size: medium">Posts</label>
            </a>
        </div>
    </sec:ifAnyGranted>

    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">
        <div class="col-sm-12 " style="overflow-wrap: break-word;margin-top: 15%">
            <a href="${createLink(controller:'user',action:'myPost')}" class="a">
                <i class="fas fa-box-open"></i>
                <label style="font-size: medium">My Posts</label>
            </a>
        </div>
    </sec:ifAnyGranted>

</div>

<div id="createTopicModalDiv">
    <g:render template="/templates/createTopicModalTemplate" model="[user:user, topicCO: new CommandObjects.TopicCO()]" />
</div>
<script>
    function openCreateTopicModal(){
        $("#createTopicModal").modal();
    }
</script>