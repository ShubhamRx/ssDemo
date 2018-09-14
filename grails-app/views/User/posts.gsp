<html>
<head>
    <asset:stylesheet href="comman.css" />
    <asset:stylesheet href="bootstrap.min.css" />
    <asset:javascript src="jquery.min.js" />
    <asset:javascript src="bootstrap.min.js" />
    <asset:javascript src="notify.min.js" />
    <title>Posts</title>
    <meta name="layout" content="linkSharingLayout" />
</head>

<body>
<div class="col-sm-1">
    <g:render template="/templates/leftNav" />
</div>
<div class="col-sm-10" style="padding-left: 5%">
    <div class="col-sm-12" style="margin-top: 5%" id="postDiv">
        <g:render template="/templates/postTemplate" model="[user:user, posts: posts, subscribedTopics: subscribedTopics, myPost: myPost]" />
    </div>
</div>
</body>
</html>