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
    public class CommentControllerTest
    {
        CommentController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new CommentController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task CreateComment_ShouldReturnCreated()
        {
            var comment = new Comment
            {
                PostId = 1,
                UserId = 2,
                Content = "Test comment content"
            };

            var response = await _sut.Post(comment).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("Test comment content"));
        }

        [TestMethod]
        public async Task GetCommentsByPost_ShouldReturnComments()
        {
            var response = await _sut.GetCommentsByPost(postid: 1, userid: 1, page: 1, limit: 5).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);

            Assert.IsTrue(json["Comments"] != null);
            Assert.IsTrue(json["Comments"].HasValues);
        }

        [TestMethod]
        public async Task GetCommentsByPost_Empty_ShouldReturnEmptyList()
        {
            var response = await _sut.GetCommentsByPost(postid: 999, userid: 1, page: 1, limit: 5).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            var json = JObject.Parse(content);

            Assert.IsTrue(json["Comments"] != null);
            Assert.AreEqual(0, json["Comments"].Count());
        }

        [TestMethod]
        public async Task LikeComment_ShouldIncrementLikes()
        {
            var response = await _sut.LikeComment(1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("\"Likes\":"));
        }

        [TestMethod]
        public async Task DislikeComment_ShouldIncrementDislikes()
        {
            var response = await _sut.DisLikeComment(1).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var content = await response.Content.ReadAsStringAsync();
            Assert.IsTrue(content.Contains("\"DisLikes\":"));
        }
    }
}