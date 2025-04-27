using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using backend.Controllers;
using backend.Models;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using System.Threading;
using System.Net;
using System.Data.Entity;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http.Results;
using Newtonsoft.Json.Linq;

namespace UnitTestProject
{
    [TestClass]
    public class CartItemControllerTest
    {
        CartItemController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new CartItemController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task AddCartItem_ShouldReturnCreated()
        {
            var item = new CartItem
            {
                UserId = 1,
                ProductId = 3,
                Quantity = 2
            };

            var response = await _sut.Post(item).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("\"ProductId\":3"));
        }

        [TestMethod]
        public async Task UpdateCartItem_ShouldReturnOk()
        {
            var updated = new CartItem { Quantity = 7 };

            var response = await _sut.Put("admin", 1, updated).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("\"Quantity\":7"));
        }

        [TestMethod]
        public async Task DeleteCartItem_ShouldReturnNoContent()
        {
            var response = await _sut.Delete("admin", 1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        }

        [TestMethod]
        public async Task GetCartByUser_ShouldReturnOk()
        {
            var response = await _sut.GetCartByUser("admin").ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("ProductName"));
        }

        [TestMethod]
        public async Task GetCartByUser_Empty_ShouldReturnNotFound()
        {
            var response = await _sut.GetCartByUser("nonexistent").ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.NotFound, response.StatusCode);
        }

        [TestMethod]
        public async Task ClearCart_ShouldReturnNoContent()
        {
            var response = await _sut.ClearCart("admin").ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.NoContent, response.StatusCode);
        }
    }
}