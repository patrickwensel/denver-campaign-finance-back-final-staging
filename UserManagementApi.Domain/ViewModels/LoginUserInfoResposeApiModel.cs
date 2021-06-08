using System;
using System.Collections.Generic;
using System.Text;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.ApiModels
{
    public class LoginUserInfoResposeApiModel
    {
        public bool IsAuthenticated { get; set; } 
        public string Message { get; set; }
        public string UserId { get; set; }
        public string ContactId { get; set; }
        public string EmailId { get; set; }
        public int TypeId { get; set; }
        public string UserType { get; set; }
        public string PWD { get; set; }
        public string SaltKey { get; set; }
        public List<RolesandTypesApiModel> RolesandTypes { get; set; }
    }
}
