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
    public class CommentLikeControllerTest
    {
        CommentLikeController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new CommentLikeController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task CreateLike_ShouldReturnCreated()
        {
            var like = new CommentLike
            {
                UserId = 1,
                CommentId = 2,
                LikeType = "DisLike"
            };

            var response = await _sut.Post(like).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("DisLike"));
        }

        [TestMethod]
        public async Task UpdateLike_ShouldSwitchType()
        {
            var like = new CommentLike
            {
                UserId = 1,
                CommentId = 1,
                LikeType = "DisLike"
            };

            var response = await _sut.Post(like).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("DisLike"));
        }

        [TestMethod]
        public async Task DeleteLike_ShouldReturnOk()
        {
            var response = await _sut.Delete(1, 1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        }
    }
}