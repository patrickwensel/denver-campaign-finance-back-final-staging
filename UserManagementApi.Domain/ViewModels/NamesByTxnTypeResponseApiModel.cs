using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class NamesByTxnTypeResponseApiModel
    {
        public int ContactId { get; set; }
        public string Fullname { get; set; }
        public int FilerId { get; set; }
    }
}
