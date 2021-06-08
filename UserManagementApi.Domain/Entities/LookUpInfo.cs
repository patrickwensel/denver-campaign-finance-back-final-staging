using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities.LookUp
{
   public class LookUpInfo : CommonInfo
    {
        public string LookUpType { get; set; }
        public string LookUpTypeId { get; set; }
        public string LookUpName { get; set; }
        public string LookUpDesc { get; set; }
        public int SequenceNo { get; set; }
    }

}
