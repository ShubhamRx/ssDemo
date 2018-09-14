<%@ page import="com.ssDemo.Topic" %>
<asset:javascript src="application.js"/>
<div class="table-responsive">
    <div class="col-sm-12">
        <div class="col-sm-6 col-sm-offset-1">
            <g:link controller="user" action="myPost" class="btn btn-default">Go Back</g:link>
        </div>

        <div class="col-sm-12"><hr></div>

        <form action="${createLink(controller: 'post', action: 'editPost')}" id="editPostForm">

            <input type="hidden" name="postId" value="${post?.id}" >

            <div class="col-sm-6 col-sm-offset-3 form-group">
                <label for="editPostSubject">Topic</label>
            </div>

            <div class="col-sm-6 col-sm-offset-3 form-group">
                <g:select from="${com.ssDemo.Topic.list()}" name="topic" id="editPostTopic" class="form-control"
                          optionKey="id" optionValue="topicName" value="${post?.topic?.id}" disabled="true"/>
            </div>


            <div class="col-sm-6 col-sm-offset-3 form-group">
                <label for="editPostSubject">Subject</label>
            </div>

            <div class="col-sm-6 col-sm-offset-3 form-group">
                <span id="editPostSubjectError" style="color: red"></span>
                <input type="text" name="subject" id="editPostSubject" class="form-control" value="${post?.subject}" required>
            </div>


            <div class="col-sm-6 col-sm-offset-3 form-group">
                <label for="editPostDescription">Description</label>
            </div>

            <div class="col-sm-6 col-sm-offset-3 form-group">
                <span id="editPostDescriptionError" style="color: red"></span>
                <input type="text" name="description" id="editPostDescription" class="form-control"
                       value="${post?.description}" required>
            </div>



            %{-- <div class="col-sm-6 col-sm-offset-3 form-group">
                 <label for="editPostDocument">Document</label>
             </div>
             <div class="col-sm-6 col-sm-offset-3 form-group">
                 <input type="file" name="subject" id="editPostDocument" class="">
             </div>--}%



            <div class="col-sm-6 col-sm-offset-3 form-group">
                <label for="editPostLink">Link</label>
            </div>

            <div class="col-sm-6 col-sm-offset-3 form-group">
                <g:textArea name="link" id="editPostLink" class="form-control" value="${post?.link}"/>
            </div>


            <div class="col-sm-3 col-sm-offset-8 form-group">
                <input type="submit" name="submit" id="editPostFormSubmit" value="Update"
                       onclick="validateEditPostForm()" class="btn btn-default">
            </div>

        </form>

    </div>
</div>
