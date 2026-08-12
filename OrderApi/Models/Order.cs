namespace OrderApi.Models;

public class Order
{
    public string OrderId { get; set; } = string.Empty;

    public string CustomerId { get; set; } = string.Empty;

    public List<OrderItem> Items { get; set; } = new();

    public decimal Total { get; set; }

    public string Status { get; set; } = "PENDING";
}

public class OrderItem
{
    public string ProductId { get; set; } = string.Empty;

    public int Quantity { get; set; }

    public decimal Price { get; set; }
}