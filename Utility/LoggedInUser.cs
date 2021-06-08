using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.Infra
{
    public class LoggedInUser
    {
        public string UserId { get; set; }

        public string ContactId { get; set; }

        public string Email { get; set; }

        public string UserType { get; set; }
    }

    public class LoggedInUserInfo
    {    
        public string Email { get; set; }
    }
}
