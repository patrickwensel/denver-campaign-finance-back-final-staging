using Denver.DataAccess;
using Microsoft.Extensions.Configuration;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.LookUp;
using UserManagementApi.Domain.ApiModels.State;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.DataCore.Repositories
{
    public class CommonRepository : ICommonRepository
    {
        private DBManager dataContext;
        public CommonRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
        }
        public async Task<IEnumerable<LookUpListResponseApiModel>> GetLookUps(string LookUpType)
        {
            IDbDataParameter[] param = new[]{
                  dataContext.CreateParameter(DbType.String,"LookType", 100, LookUpType, ParameterDirection.InputOutput)
            };
            var dtLookUps = dataContext.GetDataTable(@"SELECT * FROM get_lookups(:LookType)", commandType: CommandType.Text, param);

            IEnumerable<LookUpListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<LookUpListResponseApiModel>(dtLookUps);
            return resposeDt;
        }
        public async Task<IEnumerable<StatesListResponseApiModel>> GetStateList()
        {
            var dtStates = dataContext.GetDataTable(@"SELECT * FROM get_statelist()", commandType: CommandType.Text);

            IEnumerable<StatesListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<StatesListResponseApiModel>(dtStates);
            return resposeDt;
        }

        public async Task<bool> SendMail(EmailReq emailInfo)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(emailInfo.FromEmail);

                string[] ToEmails = emailInfo.ToEmail.Split(",");

                foreach (string email in ToEmails)
                {
                    mail.To.Add(email);
                }
                mail.Subject = emailInfo.Subject;
                mail.Body = emailInfo.BodyMessage;
                mail.IsBodyHtml = true;
                if (emailInfo.CcEmail != null)
                {
                    string[] CcEmails = emailInfo.CcEmail.Split(",");

                    foreach (string email in CcEmails)
                    {
                        mail.CC.Add(email);
                    }
                }

                if (emailInfo.BccEmail != null)
                {
                    string[] BCcEmails = emailInfo.BccEmail.Split(",");

                    foreach (string email in BCcEmails)
                    {
                        mail.Bcc.Add(email);
                    }
                }

                SmtpClient SmtpServer = new SmtpClient(emailInfo.SMTPServer);
                SmtpServer.EnableSsl = true;
                SmtpServer.UseDefaultCredentials = false;
                SmtpServer.Credentials = new System.Net.NetworkCredential(emailInfo.FromEmail, emailInfo.Password);
                SmtpServer.Port = emailInfo.SMTPPort;

                SmtpServer.Send(mail);

                return true;

            }
            catch (Exception ex)
            {
                return false;

            }
        }

        public async Task<IEnumerable<StatusResponseApiModel>> GetStatus(StatusRequestApiModel statusRequest)
        {
            IDbDataParameter[] param = new[]{
                dataContext.CreateParameter(DbType.String,"sType", 100, statusRequest.StatusType, ParameterDirection.InputOutput)
            };
            var dtStatus = dataContext.GetDataTable(@"SELECT * FROM public.get_status(:sType)", commandType: CommandType.Text, param);

            IEnumerable<StatusResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<StatusResponseApiModel>(dtStatus);
            return resposeDt;
        }
       
    }
}
