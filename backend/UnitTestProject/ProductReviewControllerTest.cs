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
    public class ProductReviewControllerTest
    {
        ProductReviewController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new ProductReviewController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task CreateReview_ShouldReturnCreated()
        {
            var review = new ProductReview
            {
                ProductId = 1,
                UserId = 3,
                Rating = 4,
                ReviewText = "Really liked it!",
                CreatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            var response = await _sut.Post(review).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Really liked it!"));
        }

        [TestMethod]
        public async Task UpdateReview_ShouldReturnUpdated()
        {
            var updated = new ProductReview
            {
                ProductId = 1,
                UserId = 2,
                Rating = 2,
                ReviewText = "Updated review content",
                CreatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };

            var response = await _sut.Post(updated).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Updated review content"));
        }

        [TestMethod]
        public async Task GetReviewsByProduct_ShouldReturnList()
        {
            var response = await _sut.GetPagedByProduct("Bot 1", 1, 2).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);

            Assert.IsNotNull(json["Reviews"]);
            Assert.IsNotNull(json["TotalCount"]);
            Assert.IsTrue((int)json["TotalCount"] >= json["Reviews"].Count());
        }
    }
}