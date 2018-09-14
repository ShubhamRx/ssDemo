<form action="${createLink(controller: 'signUp', action: 'userSignUp')}" method="post" enctype="multipart/form-data">
    <g:set var="max" value="${grailsApplication.config.getProperty('grails.controllers.upload.maxFileSize')}"/>
    <div class="col-sm-10 col-sm-offset-1"
         style="margin-top: 8%;background-color: rgba(70,184,218,.5);font-weight: bold;overflow-y: scroll;">

        <div class="col-sm-4 col-sm-offset-4 form-group" style="margin-top: 2%;">
            <label class="label" style="font-weight: bold;font-size: x-large;">Signup</label>
        </div>

        <div class="col-sm-12 form-group">
            <g:hasErrors bean="${userCO}" field="firstName">
                <span class="col-sm-12" style="color:red"><g:message
                        error="${renderErrors(bean: userCO, field: 'firstName')}"/></span>
            </g:hasErrors>
            <input type="text" name="firstName" id="firstName" class="form-control" value="${userCO?.firstName}"
                   placeholder="First Name">
        </div>

        <div class="col-sm-12 form-group">
            <g:hasErrors bean="${userCO}" field="lastName">
                <span class="col-sm-12" style="color:red"><g:message
                        error="${renderErrors(bean: userCO, field: 'lastName')}"/></span>
            </g:hasErrors>
            <input type="text" name="lastName" id="lastName" class="form-control" value="${userCO?.lastName}"
                   placeholder="Last Name">
        </div>

        <div class="col-sm-12 form-group">
            <g:hasErrors bean="${userCO}" field="email">
                <span class="col-sm-12" style="color:red"><g:message
                        error="${renderErrors(bean: userCO, field: 'email')}"/></span>
            </g:hasErrors>
            <div class="col-sm-12" style="color: red" id="emailMsg"></div>
            <input type="text" name="email" id="email" class="form-control" value="${userCO?.email}"
                   placeholder="Email">
        </div>

        <div class="col-sm-12 form-group">
            <g:hasErrors bean="${userCO}" field="username">
                <span class="col-sm-12" style="color:red"><g:message
                        error="${renderErrors(bean: userCO, field: 'username')}"/></span>
            </g:hasErrors>
            <input type="text" name="username" id="username" class="form-control" value="${userCO?.username}"
                   placeholder="@ User Name">
        </div>

        <div class="col-sm-12 form-group">
            <g:hasErrors bean="${userCO}" field="password">
                <span class="col-sm-12" style="color:red"><g:message
                        error="${renderErrors(bean: userCO, field: 'password')}"/></span>
            </g:hasErrors>
            <div class="col-sm-12" style="color:red" id="passwordMsg"></div>
            <input type="password" name="password" id="password" class="form-control" value="${userCO?.password}"
                   placeholder="Password">
        </div>

        <div class="col-sm-12 form-group">
            <div class="col-sm-12" style="color:red" id="cPasswordMsg"></div>
            <input type="password" name="confirmPassword" id="confirmPassword" class="form-control"
                   placeholder="Confirm Password">
        </div>

        <div class="col-sm-12 form-group">
            <div class="col-sm-12" style="color:red" id="photoMsg"></div>
            <input type="file" name="photo" id="photo" class="form-control" placeholder="Photo">
        </div>

        <div class="col-sm-12 form-group">
            <input type="submit" name="signUpBtn" id="signUpBtn" value="Register" class="btn btn-default form-control " onclick="return checkSize()">
        </div>

        <div class="col-sm-6 form-group">
            <input type="button" name="openLogInBtn" id="openLogInBtn" value="login"
                   class="btn btn-default form-control" onclick="openLogInForm()">
        </div>

    </div>
</form>


<script>
    function openLogInForm() {
        var div = document.getElementById("loginSingupFormDiv");
        var url = "${createLink(controller: 'loginAjax',action: 'openLogInForm')}"
        $.ajax({
            url: url,
            success: function (data) {
                $(div).html("");
                $(div).html(data.template);
            },
            error: function (data) {

            }
        })
    }

    function checkSize() {
        var element = document.getElementById("photo");
        var size = element.files[0].size;
        var error = document.getElementById("photoMsg");
        if(size > ${max}){

            $(error).html("The Size Of File Should Be Less Than "+${max}/(1000*1000)+" mb");
            return false;
        } else{
            $(error).html(" ");
            return true;
        }
    }

    $("#confirmPassword").focusout(function () {
        var password = document.getElementById("password").value;
        var cpassword = document.getElementById("confirmPassword").value;
        var error = document.getElementById("cPasswordMsg");
        if(password != cpassword){
            $(error).html("Does Not Match With Password");
            $("#signUpBtn").attr('disabled',true);
        } else{
            $(error).html(" ");
            $("#signUpBtn").attr('disabled',false);
        }
    })

    $("#password").focusout(function () {
        var password = document.getElementById("password").value;
        var error = document.getElementById("passwordMsg");
        if(/^[a-zA-Z0-9- ]*$/.test(password) == false) {
            $(error).html("Your Password contains illegal characters.");
            $("#signUpBtn").attr('disabled',true);
        } else if(/^[a-zA-Z]*$/.test(password) == true) {
            $(error).html("Your Password Should Contain atleast 1 Numberic character.");
            $("#signUpBtn").attr('disabled',true);
        } else if(/^[0-9]*$/.test(password) == true){
            $(error).html("Your Password Should Contain alteast 1 Alpabet character.");
            $("#signUpBtn").attr('disabled',true);
        } else{
            $(error).html('');
            $("#signUpBtn").attr('disabled',false);
        }
    })

    $("#email").focusout(function () {
        var email = document.getElementById("email").value;
        var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
        var error= document.getElementById("emailMsg");
        if(email_regex.test(email)==false) {
            $(error).html("Your Email Id is Not Valid");
            $("#signUpBtn").attr('disabled', true);
        } else{
            $(error).html("");
            $("#signUpBtn").attr('disabled',false);
        }
    })
</script>