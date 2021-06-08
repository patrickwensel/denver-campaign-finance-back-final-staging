using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace Denver.Infra.Common
{
    public class SendEmail
    {
        public static async Task<bool> SendMail(string smtpServer, int smtpPort,
            string fromMailID, string toMailID, string password, string ccMailID, string bccMailID, string subject, string bobyMessage, string filePath = null)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(fromMailID);
                mail.To.Add(toMailID);
                //CreatOptionForm = string.Concat(CreatOptionForm.Select(x => Char.IsUpper(x) ? " " + x : x.ToString()));

                mail.Subject = subject;
                mail.Body = bobyMessage;
                mail.IsBodyHtml = true;


                mail.CC.Add(ccMailID);

                //SmtpClient SmtpServer = new SmtpClient("smtp.prism-medical.com");
                SmtpClient SmtpServer = new SmtpClient(smtpServer);
                SmtpServer.EnableSsl = true;
                SmtpServer.UseDefaultCredentials = false;
                SmtpServer.Credentials = new System.Net.NetworkCredential(fromMailID, password);
                SmtpServer.Port = smtpPort;

                SmtpServer.Send(mail);

                return true;

            }
            catch (Exception ex)
            {
                return false;

            }
        }

    }
}
