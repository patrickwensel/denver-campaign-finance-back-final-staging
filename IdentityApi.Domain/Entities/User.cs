using Denver.Infra.Converters;
using IdentityApi.Domain.ApiModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace IdentityApi.Domain.Entities
{
    public class User : IConvertModel<User, LoginApiModel>
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        [Column(TypeName = "nvarchar(100)")]
        public string Username { get; set; }

        [Required]
        [StringLength(100)]
        [Column(TypeName = "nvarchar(100)")]
        public string Password { get; set; }
        [StringLength(50)]
        [Column(TypeName = "nvarchar(100)")]
        public string Email { get; set; }
        [Column(TypeName = "bit")]
        public bool? IsSendAdminPayrollUploadEmail { get; set; }

        [Required]
        [StringLength(100)]
        [Column(TypeName = "nvarchar(100)")]
        public string FirstName { get; set; }


        [StringLength(50)]
        [Column(TypeName = "nvarchar(100)")]
        public string LastName { get; set; }

        [StringLength(15)]
        [Column(TypeName = "varchar(15)")]
        public string Phone { get; set; }

        public int? CreatedBy { get; set; }
        [DataType(DataType.DateTime), DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}")]

        public bool IsActive { get; set; }
        public Guid Identifier { get; set; }
        [Column(TypeName = "nvarchar(max)")]
        public string Salt { get; set; }

        public ICollection<UserRole> UserRoles { get; set; }

        public LoginApiModel Convert() => new LoginApiModel
        {
            UserName = Username,
            Password = Password
        };

    }
}
