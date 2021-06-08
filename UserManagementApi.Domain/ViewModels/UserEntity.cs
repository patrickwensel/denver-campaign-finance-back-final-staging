using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class UserEntity
    {
        public int ContactId { get; set; }
        public string EntityName { get; set; }
        public string EntityType { get; set; }
    }
}
