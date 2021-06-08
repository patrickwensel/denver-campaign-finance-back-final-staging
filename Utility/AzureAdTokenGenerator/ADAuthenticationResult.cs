using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.Infra
{
    public class ADAuthenticationResult
    {
        public string UserId { get; set; }

        public bool IsAutehnticated { get; set; }

        public string Message { get; set; }

        public AuthenticationResult Result { get; set; }

    }
}
