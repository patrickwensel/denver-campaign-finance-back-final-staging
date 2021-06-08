using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LoanApiModel
    {
        public int contact_id { get; set; }
        public string entity_type { get; set; }
        public int entity_id { get; set; }
        public string Lendertype { get; set; }
        public string firstname { get; set; }
        public string lastname { get; set; }
        public string employee { get; set; }
        public string occupation { get; set; }
        public int voterId { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public int zip { get; set; }
        public string loanType { get; set; }
        public DateTime date_loan { get; set; }
        public int amount { get; set; }
        public string name_of_guarantor_or_endorser { get; set; }
        public int Amount_Guaranteed { get; set; }
        public string interest_teams { get; set; }
        public DateTime duedate { get; set; }
        public string contact_Type { get; set; }

        public bool contactupdatedflag { get; set; }
        public int loanId { get; set; }
        public IEnumerable<SubTransactionApiModel> subtransactions { get; set; }
    }
}
