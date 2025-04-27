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
    public class OrderItemControllerTest
    {
        OrderItemController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new OrderItemController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task CreateOrderItem_ShouldReturnCreated()
        {
            var item = new OrderItem
            {
                OrderId = 1,
                ProductId = 2,
                Quantity = 3,
                Price = 12345
            };

            var response = await _sut.Post(item).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("ProductId"));
        }
    }
}