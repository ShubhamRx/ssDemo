<%@ page import="com.ssDemo.PublicController" %>
<html>
<head>
    <title>login</title>
    <asset:stylesheet href="comman.css"/>
    <asset:stylesheet href="bootstrap.min.css"/>
    <asset:javascript src="jquery.min.js"/>
    <asset:javascript src="bootstrap.min.js"/>
    <meta name="layout" content="linkSharingLayout" />

</head>
<body>
<div class="col-sm-7">
  <div class="col-sm-10 col-sm-offset-1" style="margin-top: 20%">
      <g:render template="/templates/publicTopicsTemplate" model="[topicList:topicList]"/>
  </div>
</div>

<div class="col-sm-5 " >
    <div class="col-sm-12 " id="loginSingupFormDiv" style="min-height: 70%;margin-top: 10%;border-left: 1px solid black;background-color: rgba(70,188,220,.5);">
        <g:if test="${!isSignUp}">
            <g:render template="/templates/userLogin" />
        </g:if>
        <g:else>
            <g:render template="/templates/signUpTemplate" model="[userCO: userCO]"/>
        </g:else>

    </div>

</div>

</body>
</html>