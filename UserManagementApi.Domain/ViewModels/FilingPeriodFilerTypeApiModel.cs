using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace UserManagementApi.Domain.ViewModels
{
   public  class FilingPeriodFilerTypeApiModel
    {
        public int FilingPeriodFilerTypeId { get; set; }
        public int FilingPeriodId { get; set; }
        public string FilerTypeId { get; set; }
    }
}
