using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace IdentityApi.Domain.Entities
{
    public class UserRole
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        [ForeignKey(nameof(Role))]
        public int? RoleID { get; set; }
        [ForeignKey(nameof(User))]
        public int? UserID { get; set; }
        [Column(TypeName = "bit")]
        public bool IsActive { get; set; }
        public virtual Role Role { get; set; }
        public virtual User User { get; set; }
       

    }
}
