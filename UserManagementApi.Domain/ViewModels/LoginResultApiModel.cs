using System;
using System.Collections.Generic;
using System.Text;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.ApiModels
{
    public class LoginResultApiModel
    {
        public LoginResultApiModel()
        {
            ErrorMessage = new List<string>();
        }

        public bool Success { get; set; }

        public string Token { get; set; }

        public string RefreshToken { get; set; }

        public bool IsAuthenticated { get; set; }

        public List<RolesandTypesApiModel> RolesandTypes { get; set; }

        public List<string> ErrorMessage { get; set; }
    }
}
