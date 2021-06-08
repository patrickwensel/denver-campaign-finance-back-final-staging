using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public  class GetAdminUsers
    {
        public int ContactID { get; set; }
        public int FilerID { get; set; }
        public int UserID { get; set; }
        public string UserName { get; set; }
        public string FilerName { get; set; }
        public string FilerType { get; set; }
        public string UserRole { get; set; }
        public string Status { get; set; }
        public DateTime? LastActiveStartDate { get; set; }
        public DateTime? LastActiveEnddate { get; set; }
        public DateTime? CreatedStartDate { get; set; }
        public DateTime? CreatedEnddate { get; set; }
    }
}
