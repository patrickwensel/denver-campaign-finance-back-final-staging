using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class RolesandTypesApiModel
    {
        public int RoleID { get; set; }
        public string Role { get; set; }
        public int EntityID { get; set; }
        public string EntityType { get; set; }
        public string EntityName { get; set; }
    }
}
