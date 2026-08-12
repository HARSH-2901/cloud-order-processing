using Microsoft.AspNetCore.Mvc;
using OrderApi.Models;
using OrderApi.Services;

namespace OrderApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly ServiceBusService _serviceBusService;

    public OrdersController(ServiceBusService serviceBusService)
    {
        _serviceBusService = serviceBusService;
    }

    [HttpPost]
    public async Task<IActionResult> CreateOrder(Order order)
    {
        order.OrderId = $"ORD-{Guid.NewGuid().ToString()[..6].ToUpper()}";

        order.Total = order.Items.Sum(
            item => item.Quantity * item.Price
        );

        order.Status = "PENDING";

        await _serviceBusService.SendOrderAsync(order);

        return Ok(order);
    }
}