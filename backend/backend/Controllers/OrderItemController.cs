using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using backend.Security;

namespace backend.Controllers
{
    [RoutePrefix("api/orderitem")]
    public class OrderItemController : ApiController
    {
        private readonly IShopContext _model;

        public OrderItemController()
        {
            _model = new ShopContext();
        }

        public OrderItemController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("")]
        public IHttpActionResult Post([FromBody] OrderItem newOrderItem)
        {
            var product = _model.Products.FirstOrDefault(p => p.Id == newOrderItem.ProductId);

            if (product.StockQuantity < newOrderItem.Quantity)
            {
                return BadRequest($"Nincs elég készlet a termékből: {product.Name}");
            }

            product.StockQuantity -= newOrderItem.Quantity;

            _model.OrderItems.Add(newOrderItem);
            _model.SaveChanges();

            return Created($"api/orderitem/{newOrderItem.OrderId}/{newOrderItem.ProductId}", newOrderItem);
        }
    }
}