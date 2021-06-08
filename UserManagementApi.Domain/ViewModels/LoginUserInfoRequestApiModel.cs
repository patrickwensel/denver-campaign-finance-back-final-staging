using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class LoginUserInfoRequestApiModel
    {
        public string EmailId { get; set; }
        public string Password { get; set; }
    }
}
