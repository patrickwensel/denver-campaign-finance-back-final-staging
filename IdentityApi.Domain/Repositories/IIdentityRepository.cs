using IdentityApi.Domain.ApiModels;
using IdentityApi.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace IdentityApi.Domain.Repositories
{
    public interface IIdentityRepository : IDisposable
    {
        Task<User> CheckLoginAsync(LoginApiModel NewLogin, CancellationToken ct = new CancellationToken());
    }
}
