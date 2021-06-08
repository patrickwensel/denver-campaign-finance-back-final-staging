using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.Infra.Converters
{
    public interface IConvertModel<TSource, TTarget>
    {
        TTarget Convert();       
    }
}
