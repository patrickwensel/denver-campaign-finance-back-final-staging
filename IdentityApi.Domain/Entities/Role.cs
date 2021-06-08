using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace IdentityApi.Domain.Entities
{
    public class Role
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        [Required]
        [Column(TypeName = "nvarchar(100)")]
        public String Type { get; set; }
        public int? CreatedBy { get; set; }

        [DataType(DataType.DateTime), DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}")]
        public DateTime? InsDateTime { get; set; }

        [Column(TypeName = "bit")]
        public bool IsActive { get; set; }
        public ICollection<UserRole> UserRoles { get; set; }

    }
}
