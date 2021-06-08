using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public  class AddUserPaymentApiModel
    {

        public   string EmailId { get; set; }
        public int Entity_id { get; set; }
        public string Entity_Type { get; set; }

    }
}
