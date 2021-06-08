using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.Infra
{
    public class JwtTokenSettings
    {
        public string Secret { get; set; }
        public TimeSpan TokenLifeTime { get; set; }
    }
}
