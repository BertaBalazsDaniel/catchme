using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using backend.Controllers;
using backend.Models;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using System.Threading;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http.Results;
using Newtonsoft.Json.Linq;

namespace UnitTestProject
{
    [TestClass]
    public class ProductControllerTest
    {
        ProductController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new ProductController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task GetProducts_Paged_ShouldReturnCorrectAmount()
        {
            var response = await _sut.GetProducts(1, 3, userId: 1).ExecuteAsync(new CancellationToken());

            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);

            Assert.AreEqual(_testContext.Products.Count(), json.Value<int>("TotalCount"));
            Assert.AreEqual(1, json.Value<int>("Page"));
            Assert.AreEqual(3, json.Value<int>("Limit"));
            Assert.AreEqual(3, json["Products"].Count());
        }

        [TestMethod]
        public async Task FilterProducts_ByCategoryAndPrice_ShouldReturnResults()
        {
            var response = await _sut.GetFilteredProducts(page: 1, limit: 3, categoryId: 1, maxPrice: 11000, userId: 1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);
            Assert.IsTrue(json["Products"].Any(p => p["Name"].ToString().Contains("Bot")));
        }

        [TestMethod]
        public async Task FilterProducts_ByAttribute_ShouldReturnResults()
        {
            var response = await _sut.GetFilteredProducts(page: 1, limit: 3, attributes: "length:2m", userId: 1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);
            Assert.IsTrue(json["Products"].Any(p => p["Attributes"].ToString().Contains("2m")));
        }

        [TestMethod]
        public async Task FilterProducts_BySearchText_ShouldReturnResults()
        {
            var response = await _sut.GetFilteredProducts(page: 1, limit: 3, search: "bot", userId: 1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);
            Assert.IsTrue(json["Products"].Any(p => p["Name"].ToString().ToLower().Contains("bot")));
        }

        [TestMethod]
        public async Task GetFilterOptions_ShouldReturnCategories()
        {
            var response = await _sut.GetCategories().ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);
            Assert.IsNotNull(json["categories"]);
        }

        [TestMethod]
        public async Task GetProductByName_ShouldReturnProduct()
        {
            var response = await _sut.GetName("Bot 1", userId: 1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);
            Assert.AreEqual("Bot 1", json["Name"].ToString());
        }

        [TestMethod]
        public void GetProductByName_NotFound_ShouldReturnNotFound()
        {
            var result = _sut.GetName("NonExisting", userId: 1) as NotFoundResult;
            Assert.IsNotNull(result);
        }
    }
}