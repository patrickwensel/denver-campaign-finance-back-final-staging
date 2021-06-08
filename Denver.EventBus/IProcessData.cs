using Denver.EventBus.EventPayLoads;
using System.Threading.Tasks;

namespace Denver.EventBus
{
    public interface IProcessData
    {
        Task Process(UserRegisteredPayLoad myPayload);
    }
}
