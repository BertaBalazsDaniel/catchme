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
    public class FavoriteControllerTest
    {
        FavoriteController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new FavoriteController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task GetFavoritesByUser_ShouldReturnFavorites()
        {
            var response = await _sut.GetFavoritesByUser(1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("ProductId"));
        }

        [TestMethod]
        public async Task ToggleFavorite_AddNew_ShouldReturnAdded()
        {
            var favorite = new Favorite
            {
                UserId = 1,
                ProductId = 2
            };

            var response = await _sut.ToggleFavorite(favorite).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("hozzáadva"));
        }

        [TestMethod]
        public async Task ToggleFavorite_RemoveExisting_ShouldReturnRemoved()
        {
            var favorite = new Favorite
            {
                UserId = 1,
                ProductId = 1
            };

            var response = await _sut.ToggleFavorite(favorite).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("eltávolítva"));
        }

        [TestMethod]
        public async Task GetFavoriteCount_ShouldReturnCorrectCount()
        {
            var response = await _sut.GetFavoriteCount(1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("\"count\":"));
        }
    }

}