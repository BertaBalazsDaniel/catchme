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
    public class UserControllerTest
    {
        UserController _sut;
        TestContext _testContext;

        [TestInitialize]
        public void Setup()
        {
            _testContext = new TestContext();
            _sut = new UserController(_testContext)
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TestMethod]
        public async Task GetUser_ShouldReturnUser()
        {
            var response = await _sut.GetUser("admin").ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
            Assert.IsTrue(response.TryGetContentValue<User>(out var user));
            Assert.AreEqual("admin", user.Username);
        }

        [TestMethod]
        public async Task GetUser_NotFound_ShouldReturnNotFound()
        {
            var response = await _sut.GetUser("nonexistent").ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.NotFound, response.StatusCode);
        }

        [TestMethod]
        public async Task RegisterUser_ShouldReturnToken()
        {
            var newUser = new RegistrationRequest
            {
                Username = "newuser",
                Email = "newuser@example.com",
                Password = "password123"
            };

            var response = await _sut.Register(newUser).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        }

        [TestMethod]
        public async Task RegisterUser_Conflict_WhenUserExists()
        {
            var existing = new RegistrationRequest
            {
                Username = "admin",
                Email = "admin@horgasz.com",
                Password = "valami"
            };

            var response = await _sut.Register(existing).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Conflict, response.StatusCode);
        }

        [TestMethod]
        public async Task Login_ShouldReturnToken_WhenValid()
        {
            var login = new LoginRequest
            {
                UsernameOrEmail = "admin",
                Password = "jelszo123"
            };

            var response = await _sut.Login(login).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var token = await response.Content.ReadAsAsync<string>();
            Assert.IsFalse(string.IsNullOrWhiteSpace(token));
        }

        [TestMethod]
        public async Task Login_ShouldReturnUnauthorized_WhenWrongPassword()
        {
            var login = new LoginRequest
            {
                UsernameOrEmail = "admin",
                Password = "wrong"
            };

            var response = await _sut.Login(login).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.Unauthorized, response.StatusCode);
        }

        [TestMethod]
        public async Task ChangePassword_ShouldSucceed_WhenCorrect()
        {
            var request = new ChangePasswordRequest
            {
                CurrentPassword = "jelszo123",
                NewPassword = "newpass123",
                ConfirmNewPassword = "newpass123"
            };

            var response = await _sut.ChangePassword("admin", request).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        }

        [TestMethod]
        public async Task ChangePassword_ShouldFail_WhenPasswordsMismatch()
        {
            var request = new ChangePasswordRequest
            {
                CurrentPassword = "jelszo123",
                NewPassword = "one",
                ConfirmNewPassword = "two"
            };

            var response = await _sut.ChangePassword("admin", request).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [TestMethod]
        public async Task ChangePassword_ShouldFail_WhenIncorrectCurrentPassword()
        {
            var request = new ChangePasswordRequest
            {
                CurrentPassword = "wrong",
                NewPassword = "newpass",
                ConfirmNewPassword = "newpass"
            };

            var response = await _sut.ChangePassword("admin", request).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [TestMethod]
        public async Task UpdateUser_ShouldSucceed()
        {
            var updated = new User
            {
                Id = 1,
                Username = "admin_updated",
                Email = "admin_updated@example.com",
                Bio = "Updated bio"
            };

            var response = await _sut.Put(1, updated).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        }

        [TestMethod]
        public async Task UpdateUser_ShouldFail_WhenUsernameTaken()
        {
            var updated = new User
            {
                Id = 1,
                Username = "user1",
                Email = "admin_updated@example.com",
                Bio = "Updated bio"
            };

            var response = await _sut.Put(1, updated).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.BadRequest, response.StatusCode);
        }

        [TestMethod]
        public async Task UpdateUser_ShouldFail_WhenEmailTaken()
        {
            var updated = new User
            {
                Id = 1,
                Username = "admin_updated",
                Email = "user1@example.com",
                Bio = "Updated bio"
            };

            var response = await _sut.Put(1, updated).ExecuteAsync(new CancellationToken());
            Assert.AreEqual(HttpStatusCode.BadRequest, response.StatusCode);
        }
    }
}