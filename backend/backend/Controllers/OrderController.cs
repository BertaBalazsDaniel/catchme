using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using System;
using backend.Security;

namespace backend.Controllers
{
    [RoutePrefix("api/order")]
    public class OrderController : ApiController
    {
        private readonly IShopContext _model;

        public OrderController()
        {
            _model = new ShopContext();
        }

        public OrderController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("{id}")]
        public IHttpActionResult Get(int id)
        {
            var order = _model.Orders
                .Include(o => o.OrderItems.Select(oi => oi.Product))
                .Select(o => new
                {
                    Id = o.Id,
                    UserId = o.UserId,
                    OrderStatus = o.OrderStatus,
                    AddressLine = o.AddressLine,
                    PhoneNumber = o.PhoneNumber,
                    Email = o.Email,
                    FullName = o.FullName,
                    OrderDate = o.OrderDate,
                    TotalAmount = o.TotalAmount,
                    PaymentStatus = o.PaymentStatus,
                    PayPalTransactionId = o.PayPalTransactionId,
                    PaymentDate = o.PaymentDate,
                    Products = o.OrderItems.Select(oi => new
                    {
                        oi.Product.Id,
                        oi.Product.Name,
                        oi.Product.Price
                    }).ToList()
                })
                .FirstOrDefault(o => o.Id == id);

            if (order == null)
            {
                return NotFound();
            }

            return Ok(order);
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("")]
        public IHttpActionResult Post([FromBody] Order newOrder)
        {
            if (newOrder == null)
            {
                return BadRequest("Order értéke null.");
            }

            if (string.IsNullOrWhiteSpace(newOrder.OrderStatus))
            {
                newOrder.OrderStatus = OrderStatuses.Függőben.ToString();
            }

            if (string.IsNullOrWhiteSpace(newOrder.PaymentStatus))
            {
                newOrder.PaymentStatus = PaymentStatuses.Fizetve.ToString();
            }

            newOrder.OrderDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            newOrder.PaymentDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            _model.Orders.Add(newOrder);
            _model.SaveChanges();

            return Created($"api/order/{newOrder.Id}", newOrder);
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("user/{userId}")]
        public IHttpActionResult GetOrdersByUser(int userId)
        {
            var orders = _model.Orders
                .Where(o => o.UserId == userId)
                .Select(o => new
                {
                    Id = o.Id,
                    UserId = o.UserId,
                    OrderStatus = o.OrderStatus,
                    AddressLine = o.AddressLine,
                    PhoneNumber = o.PhoneNumber,
                    Email = o.Email,
                    FullName = o.FullName,
                    OrderDate = o.OrderDate,
                    TotalAmount = o.TotalAmount,
                    PaymentStatus = o.PaymentStatus,
                    PayPalTransactionId = o.PayPalTransactionId,
                    PaymentDate = o.PaymentDate,
                    Products = o.OrderItems.Select(oi => new
                    {
                        oi.Product.Id,
                        oi.Product.Name,
                        oi.Product.Price,
                        oi.Quantity
                    }).ToList()
                })
                .ToList();

            if (!orders.Any())
            {
                return NotFound();
            }

            return Ok(orders);
        }
    }
}