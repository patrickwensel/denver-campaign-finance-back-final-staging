using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class UserModel
    {
        public int ContactInformationId { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }

    }
}
