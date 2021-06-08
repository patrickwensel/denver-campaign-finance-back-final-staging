using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.Infra
{
    public class RefreshToken
    {      
        public int Id { get; set; }

        public string Token { get; set; }

        public string JwtId { get; set; }

        public DateTime CreatedDate { get; set; }

        public DateTime ExpiredDate { get; set; }

        public bool IsUsed { get; set; }

        public bool Invalidated { get; set; }

        public string UserId { get; set; }
    }
}
