using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class FilerApiModel
    {
        public int FilerID { get; set; }
        public string EntityType { get; set; }
        public int CategoryID { get; set; }
    }
}
