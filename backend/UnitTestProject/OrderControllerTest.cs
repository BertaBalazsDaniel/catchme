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
    public class OrderControllerTest
    {
        OrderController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new OrderController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task GetOrderById_ShouldReturnOrder()
        {
            var response = await _sut.Get(1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Completed"));
        }

        [TestMethod]
        public async Task GetOrderById_NotFound_ShouldReturnNotFound()
        {
            var response = await _sut.Get(9999).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.NotFound, response.StatusCode);
        }

        [TestMethod]
        public async Task CreateOrder_ShouldReturnCreated()
        {
            var order = new Order
            {
                Id = 999,
                UserId = 1,
                AddressLine = "Test address",
                PhoneNumber = "+36301234567",
                TotalAmount = 5000,
                PaymentStatus = "Pending",
                PayPalTransactionId = "TXNTEST",
                OrderStatus = "Pending",
                PaymentDate = "2025-03-22"
            };

            var response = await _sut.Post(order).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Test address"));
        }

        [TestMethod]
        public async Task CreateOrder_NullInput_ShouldReturnBadRequest()
        {
            var response = await _sut.Post(null).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [TestMethod]
        public async Task GetOrdersByUser_ShouldReturnList()
        {
            var response = await _sut.GetOrdersByUser(1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("TXN001"));
        }

        [TestMethod]
        public async Task GetOrdersByUser_Empty_ShouldReturnNotFound()
        {
            var response = await _sut.GetOrdersByUser(9999).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.NotFound, response.StatusCode);
        }
    }
}