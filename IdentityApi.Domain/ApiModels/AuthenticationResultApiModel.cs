using System;
using System.Collections.Generic;
using System.Text;

namespace IdentityApi.Domain.ApiModels
{
    public class AuthenticationResultApiModel
    {
        public AuthenticationResultApiModel()        {
            ErrorMessage = new List<string>();
        }

        public string Token { get; set; }

        public string RefreshToken { get; set; }

        public bool Success { get; set; }

        public List<string> ErrorMessage { get; set; }
    }
}
