using Microsoft.AspNetCore.DataProtection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InvoicingApi.Configurations
{
    public class AppSettings
    {
        public Secret Secret { get; set; }
        public SftpSettings SftpSettings { get; set; }
        public StartUpSettings StartUpSettings { get; set; }
        public EmailSettings EmailSettings { get; set; }
    }

    public class EmailSettings
    {
        public string SmtpPort { get; set; }
        public string SmtpServer { get; set; }
        public string SmtpUserName { get; set; }
        public string SmtpPassword { get; set; }
        public string AdminEmails { get; set; }
        public string SMTPCCEmail { get; set; }
        public string CCEmails { get; set; }
        public string BccEmails { get; set; }
        public string UILink { get; set; }
    }

    public class StartUpSettings
    {
        public string SwaggerUrl { get; set; }
    }

    public class SftpSettings
    {
        public string HostName { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public int Port { get; set; }
        public string MBMCSourcePath { get; set; }
        public string MBMCDestinationPath { get; set; }
    }
    public class Secret
    {
        public string SecretKey { get; set; }
    }
}
