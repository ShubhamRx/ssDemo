<tr>
    <td>
        <span style="color:red" id="newPasswordError"></span>
    </td>
</tr>

<tr>
    <td>
        <input type="password" name="password" id="newPassword" class="form-control" placeholder="New Password"
               style="text-align: center;background: transparent;border: none;display: none">
    </td>
</tr>

<tr>
    <td>
        <span style="color:red" id="confirmPasswordError"></span>
    </td>
</tr>

<tr>
    <td>
        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Confirm Password"
               style="text-align: center;background: transparent;border: none;display: none">
    </td>
</tr>

<tr>
    <td>
        <span style="color:red" id="oldPasswordError"></span>
    </td>
</tr>

<tr>
    <td>
        <input type="password" name="oldpassword" id="oldPassword" class="form-control" placeholder="Old Password"
               style="text-align: center;background: transparent;border: none;display: none">
    </td>
</tr>

<tr align="center">
    <td>
        <div id="registerNewPasswordDiv" class="form-group">
            <input type="button" name="updatePassword" id="updatePassword" value="Register Password"
                   class="btn btn-primary"
                   onclick="updatePassword()" style="display: none"/>
        </div>

        <div id="cancelDiv" class="form-group">
            <input type="button" name="cancel" id="cancel" value="Skip" class="btn btn-link" onclick="skip()"
                   style="display: none">
        </div>
    </td>

</tr>

<script>
    function skip() {
        var editBtn = document.getElementById("showUpdate");
        var showPasswordBtn = document.getElementById("showUpdatePassword");
        var updatePasswordBtn = document.getElementById("updatePassword");
        var password = document.getElementById("newPassword");
        var cPassword = document.getElementById("confirmPassword");
        var oldPassword = document.getElementById("oldPassword");
        var cancelBtn = document.getElementById("cancel");
        var passwordError = document.getElementById("newPasswordError");
        var cpasswordError = document.getElementById("confirmPasswordError");
        var oldPasswordError = document.getElementById("oldPasswordError");
        $(editBtn).show();
        $(showPasswordBtn).show();
        $(updatePasswordBtn).hide();
        $(cancelBtn).hide();
        $(password).hide();
        $(cPassword).hide();
        $(oldPassword).hide();
        $(passwordError).html('');
        $(cpasswordError).html('');
        $(oldPasswordError).html('');
    }

    function updatePassword(){
        var editBtn = document.getElementById("showUpdate");
        var showPasswordBtn = document.getElementById("showUpdatePassword");
        var updatePasswordBtn = document.getElementById("updatePassword");
        var password = document.getElementById("newPassword");
        var cPassword = document.getElementById("confirmPassword");
        var oldPassword = document.getElementById("oldPassword");
        var cancelBtn = document.getElementById("cancel");
        $(editBtn).show();
        $(showPasswordBtn).show();
        $(updatePasswordBtn).hide();
        $(cancelBtn).hide();
        $(password).hide();
        $(cPassword).hide();
        $(oldPassword).hide();
        if(!password.value || !cPassword.value || !oldPassword.value){
            $.notify("Something Went Wrong","error");
        } else{
            $.ajax({
                url: "${createLink(controller: 'user', action: 'updatePassword')}",
                data: {newPassword: password.value, oldPassword: oldPassword.value},
                success: function (data) {
                    if(data.status == "200"){
                        $.notify("Password Updated Successfully","success");
                    } else{
                        $.notify("Password Could Not Updated","error");
                    }
                },
                error: function () {
                    $.notify("Error Occured","error");
                }
            })
        }
    }

    $("#confirmPassword").focusout(function () {
        var password = document.getElementById("newPassword").value;
        var cpassword = document.getElementById("confirmPassword").value;
        var error = document.getElementById("confirmPasswordError");
        if(password != cpassword){
            $(error).html("Does Not Match With Password");
            $("#updatePassword").attr('disabled',true);
        } else{
            $(error).html(" ");
            $("#updatePassword").attr('disabled',false);
        }
    })

    $("#newPassword").focusout(function () {
        var password = document.getElementById("newPassword").value;
        var error = document.getElementById("newPasswordError");
        if(/^[a-zA-Z0-9- ]*$/.test(password) == false) {
            $(error).html("Your Password contains illegal characters.");
            $("#updatePassword").attr('disabled',true);
        } else if(/^[a-zA-Z]*$/.test(password) == true) {
            $(error).html("Your Password Should Contain atleast 1 Numberic character.");
            $("#updatePassword").attr('disabled',true);
        } else if(/^[0-9]*$/.test(password) == true){
            $(error).html("Your Password Should Contain alteast 1 Alpabet character.");
            $("#updatePassword").attr('disabled',true);
        } else{
            $(error).html('');
            $("#updatePassword").attr('disabled',false);
        }
    })

    $("#oldPassword").focusout(function () {
        var oldPassword = document.getElementById("oldPassword").value;
        var error = document.getElementById("oldPasswordError");
        if(!oldPassword){
            $(error).html("Password Can Not Be Blank");
            $("#updatePassword").attr('disabled',true);
        } else{
            $(error).html("");
            $("#updatePassword").attr('disabled',false);
        }
    })
</script>