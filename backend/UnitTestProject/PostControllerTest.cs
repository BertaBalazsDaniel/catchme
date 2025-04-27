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
    public class PostControllerTest
    {
        PostController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new PostController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task GetPostsByCategory_ShouldReturnList()
        {
            var response = await _sut.GetPostsByCategory("Catches", page: 1, limit: 2).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Hal 1"));
        }

        [TestMethod]
        public async Task GetPostById_ShouldReturnPost()
        {
            var response = await _sut.GetId(1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Hal 1"));
        }

        [TestMethod]
        public async Task GetPostById_NotFound_ShouldReturnNotFound()
        {
            var response = await _sut.GetId(999).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.NotFound, response.StatusCode);
        }

        [TestMethod]
        public async Task CreatePost_ShouldReturnCreated()
        {
            var newPost = new Post
            {
                Id = 999,
                UserId = 1,
                Content = "Test post content",
                Category = "Tips",
                ImageUrl = "test.jpg"
            };

            var response = await _sut.Post(newPost).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Test post content"));
        }

        [TestMethod]
        public async Task GetPostsByUser_ShouldReturnList()
        {
            var response = await _sut.GetPostsByUser(1,1,3).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Hal 1"));
        }

        [TestMethod]
        public async Task DeletePost_ShouldDeleteSuccessfully()
        {
            _sut.Request.Properties["UserId"] = 1;
            var response = await _sut.DeletePost(1).ExecuteAsync(new CancellationToken());

            Assert.AreEqual(HttpStatusCode.NoContent, response.StatusCode);
        }
    }
}