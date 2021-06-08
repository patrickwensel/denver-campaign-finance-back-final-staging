using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LookUpResponseApiModel
    {
        public string LookUpTypeCode { get; set; }
        public string LookUpTypeId { get; set; }
        public string LookUpName { get; set; }
        public string LookUpDesc { get; set; }
        public int LookUpOrder { get; set; }
    }
}
