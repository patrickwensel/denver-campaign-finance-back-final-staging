using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.Infra.Constants
{
    public static class Constants
    {
        public const string CorsPolicyName = "defaultCORS";
        public const string ResetPage = "reset-password";
        public const string EmailSubject = "FORGOT PASSWORD - Request";
        public const string ForgotMessage = "Please find the rest password link below. Please click and set your new password </br> </br> <a href='{0}' target='_blank'>Click to rest your password</a> </br> </br> Thanks";
        public const string LOB_EMP = "LOB-EMP";
        public const string LOB_SUB = "LOB-SUB";
        public const string LOB_CLI = "LOB-CLI";
        public const string LOB_REL = "LOB-REL";
        public const string USER_CANDIDATE = "USER-CAN";
        public const string USER_LOBBYIST = "USER-LOB";
        public const string USER_IEF = "USER-IEF";
        public const string STATUS_APPROVED = "Approved";
        public const string STATUS_REJECTED = "Rejected";
        public const string CommitteeApprovedOrDeniedEmailSubject = "Committee Account {0}";
        public const string CommitteeApprovedOrDeniedMessage = "Hi {0}, We just wanted to let you know your committee account has been {1}. Thanks";
        public const string LobbyistApprovedOrDeniedEmailSubject = "Lobbyist Account {0}";
        public const string LobbyistApprovedOrDeniedMessage = "Hi {0}, We just wanted to let you know your lobbyist account has been {1}. Thanks";
        public const string CreateAccountSubject = "Your {0} Account is created";
        public const string CreateAccountMessage = "Hi {0}, We just wanted to let you know your {1} account has been successfully. Thanks";
    }

    public static class ValidationMessage
    {
        public const string InvalidInput = "Invalid Input";

        public const string InvalidUser = "Invalid User";

        public const string MatchPassword = "Password dosen't match";

        public const string MisMatchPassword = "Old Password and New Password cannot be same";

        public const string PasswordValidation = "EmailID already exists.Please validate the data entered and try again";

        public const string Email = "Please enter the email ID";

        public const string InvalidEmail = "Invalid Email ID";

        public const string ConfirmPassword = "Please confirm the Password entered";

        public const string Details = "Please enter the details to proceed further";

        public const string DetailedPassword = "The Entered Password should have at least 1 upper case, At least 1 lower case, At least 1 numeric letter, At least 1 special character and no spaces";


    }
}
