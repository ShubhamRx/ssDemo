<div class="modal fade" id="editTopicModal" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">



            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Edit Topic</h4>
            </div>

            <div class="modal-body">
                <form action="${createLink(controller:'user', action: 'editTopic')}" id="editTopicForm">
                    <div class=" form-group">
                        <label class="control-label" for="editTopicName">Topic Name</label>
                        <div id="editTopicNameError">
                            <span style="color:red"></span>
                        </div>
                        <input type="text" name="topicName" id="editTopicName" class="form-control"
                               placeholder="Enter Topic Name" value="${topicCO?.topicName}">
                    </div>

                    <div class=" form-group">
                        <label class="control-label" for="editVisibility">Visibility</label>
                        <div id="editVisibilityError">
                            <span style="color:red"></span>
                        </div>
                        <g:select from="${com.ssDemo.Enums.Visibility}" name="visibility" id="editVisibility"
                                  noSelection="['': 'Select Visibility']" class="form-control" value="${topicCO?.visibility}"/>
                    </div>

                    <input type="hidden" name="topicId" id="editTopicId" />

                    <input type="hidden" name="createdBy" id="editCreatedBy" value="${user?.id}" />

                    <div class="form-group col-sm-offset-9" >
                        <input type="button" name="topicSubmitBtn" id="editTopicSubmitBtn" value="Update" class="btn btn-default" onclick="editTopic()">
                        <input type="reset" value="reset" class="btn btn-default">
                    </div>

                </form>
            </div>


            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>



        </div>
    </div>
</div>

<script>
    function editTopic() {
        var topicName = document.getElementById("editTopicName").value;
        var visibility = document.getElementById("editVisibility").value;
        if(validateValues(topicName,visibility)){
            var form = document.getElementById("editTopicForm");
            $(form).submit();
        }
    }

    function validateValues(topicName,visibility) {
        var topicName = topicName;
        var visibility = visibility;
        var flag = true;
        if(!topicName){
            $("#editTopicNameError").children().html("Please Enter Topic Name");
            flag = false;
        } else{
            $("#editTopicNameError").children().html(" ");
        }
        if(!visibility){
            $("#editVisibilityError").children().html("Please Enter Visibility");
            flag = false;
        } else{
            $("#editVisibilityError").children().html(" ");
        }
        return flag;
    }
</script>