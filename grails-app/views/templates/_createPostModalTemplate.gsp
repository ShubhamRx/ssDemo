<div class="modal fade" id="createPostModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">



            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Create Post</h4>
            </div>

            <div class="modal-body">
                <form action="${createLink(controller:'user', action: 'createPost')}" id="createPostForm" enctype="multipart/form-data" method="post">
                    <div class="form-group">
                        <label for="topic">Topic</label>
                        <span id="topicError" style="color: red"></span>
                        <g:select name="topic" from="${subscribedTopics}" id="topic" noSelection="['':'Select Topic To Post on']" class="form-control" optionValue="topicName" optionKey="id"/>
                    </div>

                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <span id="subjectError" style="color: red"></span>
                        <input type="text" id="subject" name="subject" class="form-control" placeholder="Enter Subject"/>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <span id="descriptionError" style="color: red"></span>
                        <input type="text" id="description" name="description" class="form-control" placeholder="Enter Description"/>
                    </div>

                    <div class="form-group">
                        <label for="document">Document</label>
                        <input type="file" id="document" name="document" class="form-control" accept="application/pdf" />
                    </div>

                    <div class="form-group">
                        <label for="link">Link</label>
                        <g:textArea name="link" id="link" class="form-control" placeholder="Paste Link" />
                    </div>

                    <input type="hidden" name="userID" id="userID" value="${user?.id}" />

                    <div class="form-group" align="right">
                        <input type="button" name="submitPost" id="submitPost" value="Post" class="btn btn-default" onclick="post()" />
                        <input type="reset" name="reset" id="reset" value="Reset" class="btn btn-default" />
                    </div>
                </form>
            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>



        </div>
    </div>
</div>

<script>
    function post() {
        var topic = document.getElementById("topic").value;
        var subject = document.getElementById("subject").value;
        var description = document.getElementById("description").value;
        if(validateForm(topic,subject,description)){
            var form = document.getElementById("createPostForm");
            $(form).submit();
        }
    }

    function validateForm(topic,subject,description) {
        var topic= topic;
        var subject = subject;
        var description = description;
        var flag = true;
        if(!topic){
            $("#topicError").html("Please Choose Topic");
            flag = false;
        } else{
            $("#topicError").html(" ");
        }
        if(!subject){
            $("#subjectError").html("Please Enter Subject");
            flag = false;
        } else{
            $("#subjectError").html(" ");
        }
        if(!description){
            $("#descriptionError").html("Please Enter description");
            flag = false;
        } else{
            $("#descriptionError").html(" ");
        }
        return flag;
    }
</script>