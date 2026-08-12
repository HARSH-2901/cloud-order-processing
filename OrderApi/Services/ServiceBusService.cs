using System.Text.Json;
using Azure.Messaging.ServiceBus;
using OrderApi.Models;

namespace OrderApi.Services;

public class ServiceBusService
{
    private readonly ServiceBusClient _client;
    private readonly ServiceBusSender _sender;

    public ServiceBusService(IConfiguration configuration)
    {
        var connectionString =
            configuration["ServiceBusConnectionString"]
            ?? throw new InvalidOperationException(
                "Service Bus connection string is not configured."
            );

        _client = new ServiceBusClient(connectionString);
        _sender = _client.CreateSender("orders");
    }

    public async Task SendOrderAsync(Order order)
    {
        var json = JsonSerializer.Serialize(order);

        var message = new ServiceBusMessage(json)
        {
            ContentType = "application/json",
            Subject = "NewOrder"
        };

        await _sender.SendMessageAsync(message);
    }
}