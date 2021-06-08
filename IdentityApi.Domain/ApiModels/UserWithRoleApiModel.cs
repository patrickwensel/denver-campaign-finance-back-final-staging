using System;
using System.Collections.Generic;
using System.Text;

namespace IdentityApi.Domain.ApiModels
{
    public class UserWithRoleApiModel
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public Guid Identifier { get; set; }
        public string Role { get; set; }

    }
}
