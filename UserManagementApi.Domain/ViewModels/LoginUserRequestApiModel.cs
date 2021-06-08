using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public class LoginUserRequestApiModel
    {
        public string EmailId { get; set; }
        public string Password { get; set; }
    }
}
