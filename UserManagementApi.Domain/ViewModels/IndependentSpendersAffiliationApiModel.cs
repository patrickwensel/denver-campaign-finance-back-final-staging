using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class IndependentSpendersAffiliationApiModel
    {
        public int ContactID { get; set; }
        public string Notes { get; set; }
        public IEnumerable<IndependentSpenderAffiliationDetailApiModel> IndependentSpenderIds { get; set; }
    }
}
