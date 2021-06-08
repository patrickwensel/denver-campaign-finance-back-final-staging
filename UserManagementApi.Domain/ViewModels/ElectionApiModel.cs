using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class ElectionApiModel
    {
        public int Id { get; set; }
        public DateTime? ElectionDate { get; set; }
        public string Name { get; set; }
    }
}
