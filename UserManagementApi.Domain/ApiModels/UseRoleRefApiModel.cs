using System;
using System.Collections.Generic;
using System.Text;
using UserManagementApi.Domain.Entities;

namespace UserManagementApi.Domain.ApiModels
{
    public class UseRoleRefApiModel : CommonInfo
    {
        public int UserRoleRefId { get; set; }
        public int UserId { get; set; }
        public string RoleType { get; set; }
        public int RoleId { get; set; }
        public int RefID { get; set; }
        public int RelationshipId { get; set; }
    }
}
