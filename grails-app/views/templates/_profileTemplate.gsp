<div class="table-responsive">
    <table align="center" class="">
        <tr class="">
            <td class="">
                <g:if test="${user?.photo}">
                    <g:img dir="images" file="${user?.UID}.jpg" height="150px" width="180px"
                           style="border-radius: 50%"/>
                </g:if>
                <g:else>
                    <g:img dir="images" file="default.jpg" height="150px" width="180px" style="border-radius: 50%"/>
                </g:else>
            </td>
        </tr>
    </table>
    <table align="center" style="margin-top: 3%;width: 20%">
        <tr>
            <td align="center">
                <label for="firstName" style="text-align: center">First Name</label>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red" id="firstNameError"></span>
            </td>
        </tr>
        <tr>
            <td><input type="text" name="firstName" id="firstName" class="form-control" value="${user?.firstName}"
                       style="text-align: center;background: transparent;border: none"
                       disabled></td>
        </tr>
        <tr>
            <td align="center">
                <label for="lastName" style="text-align: center">Last Name</label>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red" id="lastNameError"></span>
            </td>
        </tr>

        <tr>
            <td><input type="text" name="lastName" id="lastName" class="form-control" value="${user?.lastName}"
                       style="text-align: center;background: transparent;border: none" disabled></td>
        </tr>
        <tr>
            <td align="center">
                <label for="username" style="text-align: center">User Name</label>
            </td>
        </tr>

        <tr>
            <td><input type="text" name="username" id="username" class="form-control" value="${user?.username}"
                       style="text-align: center;background: transparent;border: none" disabled></td>
        </tr>
        <tr>
            <td align="center">
                <label for="email" style="text-align: center">Email</label>
            </td>
        </tr>

        <tr>
            <td><input type="text" name="email" id="email" class="form-control" value="${user?.email}"
                       style="text-align: center;background: transparent;border: none" disabled></td>
        </tr>


        <div id="updatePasswordDiv">
            <g:render template="/templates/updatePasswordTemplate"/>
        </div>


        <tr><td align="center">
            <div id="showUpdateDiv" class="form-group">
                <input type="button" name="showUpdate" id="showUpdate" value="Edit" class="btn btn-primary"
                       onclick="enableUpdate()"></div>

            <div id="updateDiv" class="form-group">
                <input type="button" name="updateBtn" id="updateBtn" value="Update" class="btn btn-primary"
                       style="display: none" onclick="disableUpdate(${user?.id})"></div>

            <div id="showUpdatePasswordDiv" class="form-group">
                <input type="button" name="showUpdatePassword" id="showUpdatePassword" value="Update Password"
                       class="btn btn-link"
                       onclick="enableUpdatePassword()"/>
            </div>

        </td></tr>
    </table>

</div>

<script>
    function enableUpdate() {
        var updateDiv = document.getElementById("updateBtn");
        var editDiv = document.getElementById("showUpdateDiv");
        var firstName = document.getElementById("firstName");
        var lastName = document.getElementById("lastName");
        var updatePasswordBtn = document.getElementById("showUpdatePassword");
        $(editDiv).hide();
        $(updatePasswordBtn).hide();
        $(updateDiv).show();
        $(firstName).removeAttr("disabled");
        $(lastName).removeAttr("disabled");
    }

    function disableUpdate(userId) {
        var userId = userId;
        var updateDiv = document.getElementById("updateBtn");
        var editDiv = document.getElementById("showUpdateDiv");
        var firstName = document.getElementById("firstName");
        var lastName = document.getElementById("lastName");
        var profileDiv = document.getElementById("profileDiv");
        var firstNameError = document.getElementById("firstNameError");
        var lastNameError = document.getElementById("lastNameError");
        if (firstName.value && lastName.value) {
            $(updateDiv).hide();
            $(editDiv).show();
            $(firstName).attr("disabled", "disabled");
            $(lastName).attr("disabled", "disabled");
            $.ajax({
                url: "${createLink(controller: 'user',action: 'updateProfile')}",
                data: {userId: userId, firstName: firstName.value, lastName: lastName.value},
                success: function (data) {
                    $(profileDiv).html(data.template);
                    $.notify("Profile Updated", "success");
                },
                error: function () {
                    $.notify("Error in Updating", "error");
                }

            })
        } else {
            if (!firstName.value) {
                $(firstNameError).html("First Name Can Not Be Empty");
            } else {
                $(firstNameError).html("");
            }
            if (!lastName.value) {
                $(lastNameError).html("Last Name Can Not Be Empty");

            } else {
                $(lastNameError).html("");
            }
        }

    }

    function enableUpdatePassword() {
        var editBtn = document.getElementById("showUpdate");
        var showPasswordBtn = document.getElementById("showUpdatePassword");
        var updatePasswordBtn = document.getElementById("updatePassword");
        var password = document.getElementById("newPassword");
        var cPassword = document.getElementById("confirmPassword");
        var oldPassword = document.getElementById("oldPassword");
        var cancelBtn = document.getElementById("cancel");
        $(editBtn).hide();
        $(showPasswordBtn).hide();
        $(updatePasswordBtn).show();
        $(cancelBtn).show();
        $(password).show();
        $(cPassword).show();
        $(oldPassword).show();
    }

</script>