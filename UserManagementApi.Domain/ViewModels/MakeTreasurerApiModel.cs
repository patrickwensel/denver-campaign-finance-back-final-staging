using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class MakeTreasurerApiModel
    {
        public int ContactID { get; set; }   
        public int UserID { get; set; }  
        public string Status { get; set; }
        public int EntityId { get; set; }
        public string EntityType { get; set; }
        public int EmailMsgID { get; set; }
    }
}
