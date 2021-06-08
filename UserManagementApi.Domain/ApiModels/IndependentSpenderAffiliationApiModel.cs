using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class IndependentSpenderAffiliationApiModel
    {
        public int UserID { get; set; }
        public string Notes { get; set; }
        public IEnumerable<IndependentSpenderAffiliation> IndependentSpenderids { get; set; }
    }
}
