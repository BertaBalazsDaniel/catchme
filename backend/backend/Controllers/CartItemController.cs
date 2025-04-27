using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using backend.Security;

namespace backend.Controllers
{
    public class CartItemController : ApiController
    {
        private readonly IShopContext _model;

        public CartItemController()
        {
            _model = new ShopContext();
        }

        public CartItemController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("api/cartitem/{username}")]
        public IHttpActionResult GetCartByUser(string username)
        {
            var cartItems = _model.CartItems
                .Where(ci => ci.User.Username == username)
                .Include(ci => ci.Product)
                .Select(ci => new
                {
                    ProductId = ci.ProductId,
                    Quantity = ci.Quantity,
                    ProductName = ci.Product.Name,
                    ProductPrice = ci.Product.Price,
                    ImageUrl = ci.Product.ImageUrl

                })
                .ToList();

            if (!cartItems.Any())
            {
                return NotFound();
            }

            return Ok(cartItems);
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("api/cartitem")]
        public IHttpActionResult Post([FromBody] CartItem newCartItem)
        {
            var existingItem = _model.CartItems.FirstOrDefault(ci => ci.User.Id == newCartItem.UserId && ci.ProductId == newCartItem.ProductId);
            if (existingItem != null)
            {
                existingItem.Quantity += newCartItem.Quantity;
            }
            else
            {
                _model.CartItems.Add(newCartItem);
            }

            _model.SaveChanges();

            return Created($"api/cartitem/{newCartItem.UserId}/{newCartItem.ProductId}", newCartItem);
        }

        [TokenAuthorize]
        [HttpPut]
        [Route("api/cartitem/{username}/{productid}")]
        public IHttpActionResult Put(string username, int productid, [FromBody] CartItem updatedCartItem)
        {
            var cartItem = _model.CartItems.FirstOrDefault(ci => ci.User.Username == username && ci.ProductId == productid);

            cartItem.Quantity = updatedCartItem.Quantity;

            _model.SaveChanges();

            return Ok(cartItem);
        }

        [TokenAuthorize]
        [HttpDelete]
        [Route("api/cartitem/{username}/{productid}")]
        public IHttpActionResult Delete(string username, int productid)
        {
            var cartItem = _model.CartItems.FirstOrDefault(ci => ci.User.Username == username && ci.ProductId == productid);

            _model.CartItems.Remove(cartItem);
            _model.SaveChanges();

            return Content(HttpStatusCode.OK, new { message = "Sikeresen törölve!" });
        }

        [TokenAuthorize]
        [HttpDelete]
        [Route("api/cartitem/clear/{username}")]
        public IHttpActionResult ClearCart(string username)
        {
            var userCartItems = _model.CartItems.Where(ci => ci.User.Username == username).ToList();

            _model.CartItems.RemoveRange(userCartItems);
            _model.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }
    }
}