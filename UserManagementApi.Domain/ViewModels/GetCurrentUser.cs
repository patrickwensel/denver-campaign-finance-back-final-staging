using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class GetCurrentUser
    {
        public int ContactID { get; set; }
        public int FilerID { get; set; }
        public int UserID { get; set; }
        public string UserRole { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Permissions { get; set; }
        public string status { get; set; }

    }
}
