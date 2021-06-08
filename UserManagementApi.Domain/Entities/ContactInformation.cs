using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;
using Denver.Infra.Converters;

namespace UserManagementApi.Domain.Entities
{
    public class ContactInformation
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public string ContactinformationId { get; set; }

        [Required]
        [StringLength(100)]
        [Column(TypeName = "nvarchar(100)")]
        public string FirstName { get; set; }


        [StringLength(50)]
        [Column(TypeName = "nvarchar(100)")]
        public string LastName { get; set; }

        [StringLength(500)]
        [Column(TypeName = "nvarchar(1000)")]
        public string MailingAddress1 { get; set; }

        [StringLength(500)]
        [Column(TypeName = "nvarchar(1000)")]
        public string MailingAddress2 { get; set; }

        [StringLength(50)]
        [Column(TypeName = "nvarchar(100)")]
        public string State { get; set; }

        [StringLength(50)]
        [Column(TypeName = "nvarchar(100)")]
        public string City { get; set; }

        [StringLength(50)]
        [Column(TypeName = "nvarchar(100)")]
        public string ZipCode { get; set; }

        [StringLength(15)]
        [Column(TypeName = "varchar(15)")]
        public string Phone { get; set; }

        public int? CreatedBy { get; set; }
        [DataType(DataType.DateTime), DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}")]

        public int? ModifiedBy { get; set; }
        [DataType(DataType.DateTime), DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}")]

        public bool IsActive { get; set; }

        public bool IsDeleted { get; set; }
    }
}
