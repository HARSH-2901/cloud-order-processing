using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace OrderProcessor;

public class OrderFunction
{
    private readonly ILogger<OrderFunction> _logger;

    public OrderFunction(ILoggerFactory loggerFactory)
    {
        _logger = loggerFactory.CreateLogger<OrderFunction>();
    }

    [Function("ProcessOrder")]
    public void Run(
        [ServiceBusTrigger(
            "orders",
            Connection = "ServiceBusConnectionString"
        )] string message)
    {
        _logger.LogInformation(
            "Received order message: {Message}",
            message
        );

        _logger.LogInformation(
            "Order processed successfully."
        );
    }
}