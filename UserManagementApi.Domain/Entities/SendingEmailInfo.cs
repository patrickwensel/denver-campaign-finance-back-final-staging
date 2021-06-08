using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities
{
    public class SendingEmailInfo
    {
        public string FromEmail { get; set; }
        public string SMTPServer { get; set; }
        public int SMTPPort { get; set; }
        public string Password { get; set; }
        public string ToEmail { get; set; }
        public string CcEmail { get; set; }
        public string BccEmail { get; set; }
        public string Subject { get; set; }
        public string BodyMessage { get; set; }
        public string BodyTemplate { get; set; }
        public bool IsBodyHtml { get; set; }
        public bool EnableSsl { get; set; }
       
    }
}
