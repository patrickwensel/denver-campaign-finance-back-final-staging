using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class RefreshTokenApiModel
    {
        public string Token { get; set; }

        public string RefreshToken { get; set; }
    }
}
