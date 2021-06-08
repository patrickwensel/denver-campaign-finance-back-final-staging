using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class ContactUserAccountApiModel
    {
        public ContactApiModel ContactDetail { get; set; }
        public UserAccountApiModel UserAccountDetails { get; set; }
    }
}
