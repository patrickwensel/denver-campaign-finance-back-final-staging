using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistSignatureApiModel
    {
      
        public int LobbyistId { get; set; }
        [Required]
        [StringLength(150)]
        public string SignFirstName { get; set; }
        [Required]
        [StringLength(150)]
        public string SignLastName { get; set; }
        [Required]
        [StringLength(250)]
        public string SignEmail { get; set; }
        [Required]
        public string SignImageURL { get; set; }
    }
}
