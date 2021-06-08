using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.EventBus.EventPayLoads
{
    public class UserRegisteredPayLoad
    {
        public int UserId { get; set; }

        public string Email { get; set; }
    }
}
