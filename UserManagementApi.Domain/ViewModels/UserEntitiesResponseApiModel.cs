using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class UserEntitiesResponseApiModel
    {
        public IEnumerable<UserEntity> Lobbyists { get; set; }
        public IEnumerable<UserEntity> Committees { get; set; }
        public IEnumerable<UserEntity> IndependentExp { get; set; }
        public IEnumerable<UserEntity> CoveredOfficials { get; set; }

    }
}
