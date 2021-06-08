using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class GetFeesResposneApiModel
    {
        public int feeid { get; set; }
        public string name { get; set; }
        public decimal amount { get; set; }
        public DateTime duedate { get; set; }
        public DateTime invoice_date { get; set; }
        public string filername { get; set; }
        public string type_id { get; set; }
    }
}
