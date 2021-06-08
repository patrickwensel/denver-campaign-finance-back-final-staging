using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class SendCommitteNoteRequestApiModel
    {
        public int Id { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
    }
}
