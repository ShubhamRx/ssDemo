<%@ page import="com.ssDemo.Enums" %>
<asset:javascript src="bootstrap.min.js" />
<sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">

    <div class="col-sm-5" style="padding-top: 3%">
        <label style="font-size: medium" class="pull-right"><g:link controller="user" action="dashboard" style="color: white;text-decoration:none">Welcome ${user.firstName}</g:link></label>
    </div>

    <div class="col-sm-1" id="notificationTemplateDiv" style="padding-top:3%; border-left: 1px solid gray ">
        <g:render template="/templates/notificationTemplate" model="[user: user]"/>

    </div>

    <div class="col-sm-6 pull-right">
        <a href="${createLink(controller: 'logout', action: 'index')}" class="a">
            <i class="fas fa-sign-out-alt"></i>
            <label style="font-size: medium">Logout</label>
        </a>
    </div>

</sec:ifAnyGranted>