using Denver.Infra.Exceptions;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace InvoicingApi.Middleware
{
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate next;
        private readonly ILogger _logger;

        public ExceptionMiddleware(RequestDelegate next, ILoggerFactory logger)
        {
            _logger = logger.CreateLogger("ErrorHandler");
            this.next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await next(context);
            }
            catch (Exception exceptionObj)
            {
                await HandleExceptionAsync(context, exceptionObj);
            }
        }

        private Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            if (exception is ValidationException || exception is CustomException)
            {
                _logger.LogInformation("ValidationException : " + exception.Message, LogLevel.Information, exception.Data);
                string result = new ErrorDetails
                {
                    Message = $"Validation Message :  {exception.Message}",
                }.ToString();
                context.Response.ContentType = "application/json";
                context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return context.Response.WriteAsync(result.ToString());
            }            
            else
            {
                _logger.LogError(exception.Message, LogLevel.Error, new { Context = context, Exception = exception });
                string result = new ErrorDetails
                {
                    Message = "API :  Internal Server Error",
                    StatusCode = (int)HttpStatusCode.InternalServerError
                }.ToString();
                context.Response.ContentType = "application/json";
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                return context.Response.WriteAsync(result.ToString());
            }
        }
    }

    public class ErrorDetails
    {
        public int StatusCode { get; set; }
        public string Message { get; set; }

        public override string ToString()
        {
            return JsonConvert.SerializeObject(this);
        }
    }

    public class ErrorDetailsList
    {
        public int StatusCode { get; set; }
        public string Message { get; set; }
        public object MessageDetail { get; set; }

        public override string ToString()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
