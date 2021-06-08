using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class UserInfoResposeApiModel
    {
        public int UserId { get; set; }
        public string FName { get; set; }
        public string LName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string cityName { get; set; }
        public string StateCode { get; set; }
        public string Zip { get; set; }
        public string PhoneNo { get; set; }
        public string EmailId { get; set; }
        public string UserType { get; set; }
    }
}
