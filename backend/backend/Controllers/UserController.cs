using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using backend.UserManager;
using backend.Security;
using System.Net.Http.Headers;

namespace backend.Controllers
{
    public class LoginRequest
    {
        public string UsernameOrEmail { get; set; }
        public string Password { get; set; }
    }
    public class RegistrationRequest
    {
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }

    public class ChangePasswordRequest
    {
        public string CurrentPassword { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmNewPassword { get; set; }
    }
    public class UserController : ApiController
    {
        private readonly IShopContext _model;

        public UserController()
        {
            _model = new ShopContext();
        }

        public UserController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("api/user/{username}")]
        public IHttpActionResult GetUser(string username)
        {
            var user = _model.Users.FirstOrDefault(u => u.Username == username);

            if (user == null)
            {
                return Content(HttpStatusCode.NotFound,"Nem található a felhasználó!");
            }

            return Ok(user);
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("api/user/me")]
        public IHttpActionResult GetCurrentUser()
        {
            try
            {
                var authHeader = Request.Headers.Authorization;

                var user = (User)TokenManager.DecodeToken(authHeader.Parameter);
                if (user == null)
                {
                    return Unauthorized();
                }

                var dbUser = _model.Users
                    .Where(u => u.Username == user.Username)
                    .Select(u => new
                    {
                        Id = u.Id,
                        Username = u.Username,
                        Email = u.Email,
                        ProfileImage = u.ProfileImage,
                        Bio = u.Bio,
                        Role = u.Role,
                        CreatedAt = u.CreatedAt
                    })
                    .FirstOrDefault();

                if (dbUser == null)
                {
                    return NotFound();
                }

                return Ok(dbUser);
            }
            catch
            {
                return BadRequest();
            }
        }

        [TokenAuthorize]
        [HttpPut]
        [Route("api/user/{userid}")]
        public IHttpActionResult Put(int userid, [FromBody] User updatedUser)
        {
            var existingUser = _model.Users.FirstOrDefault(u => u.Id == userid);
            if (existingUser == null)
            {
                return NotFound();
            }

            if (_model.Users.Any(u => u.Email == updatedUser.Email && u.Id != userid))
            {
                return Content(HttpStatusCode.BadRequest, new { success = false, message = "Ez az email cím már foglalt." });
            }

            if (_model.Users.Any(u => u.Username == updatedUser.Username && u.Id != userid))
            {
                return Content(HttpStatusCode.BadRequest, new { success = false, message = "Ez a felhasználónév már foglalt." });
            }   

            existingUser.Email = updatedUser.Email;
            existingUser.Bio = updatedUser.Bio;
            existingUser.Username = updatedUser.Username;

            _model.SaveChanges();

            return Ok(new { success = true, user = existingUser });
        }

        [HttpPost]
        [Route("api/user/login")]
        public IHttpActionResult Login([FromBody] LoginRequest loginRequest)
        {
            var user = _model.Users.FirstOrDefault(u => u.Username == loginRequest.UsernameOrEmail || u.Email == loginRequest.UsernameOrEmail);
            if (user == null)
            {
                return NotFound();
            }

            if (!PasswordManager.VerifyPasswordHash(loginRequest.Password, user.PasswordHash, user.PasswordSalt))
            {
                return Unauthorized();
            }

            return Ok(TokenManager.GenerateToken(user));
        }


        [HttpPost]
        [Route("api/user/register")]
        public IHttpActionResult Register([FromBody] RegistrationRequest newUser)
        {
            var existingUser = _model.Users.FirstOrDefault(u => u.Username == newUser.Username || u.Email == newUser.Email);
            if (existingUser != null)
            {
                return Conflict();
            }

            PasswordManager.CreatePasswordHash(newUser.Password, out byte[] passwordHash, out byte[] passwordSalt);

            var user = new User
            {
                Username = newUser.Username,
                Email = newUser.Email,
                PasswordHash = passwordHash,
                PasswordSalt = passwordSalt,
                CreatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                Role = Roles.Felhasználó.ToString(),
                ProfileImage = "resources/users/user.svg",
                Bio = ""
            };

            _model.Users.Add(user);
            _model.SaveChanges();

            return Ok(TokenManager.GenerateToken(user));
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("api/user/{username}/changepassword")]
        public IHttpActionResult ChangePassword(string username, [FromBody] ChangePasswordRequest request)
        {
            if (request.NewPassword != request.ConfirmNewPassword)
            {
                return Content(HttpStatusCode.BadRequest, new { success = false, message = "Az új jelszavak nem egyeznek meg." });
            }

            var user = _model.Users.FirstOrDefault(u => u.Username == username);

            if (!PasswordManager.VerifyPasswordHash(request.CurrentPassword, user.PasswordHash, user.PasswordSalt))
            {
                return Content(HttpStatusCode.BadRequest, new { success = false, message = "A jelenlegi jelszó nem megfelelő." });
            }

            PasswordManager.CreatePasswordHash(request.NewPassword, out byte[] newHash, out byte[] newSalt);
            user.PasswordHash = newHash;
            user.PasswordSalt = newSalt;

            _model.SaveChanges();
            return Ok(new { success = true, message = "Jelszó sikeresen módosítva." });
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("api/user/refreshtoken")]
        public IHttpActionResult RefreshToken()
        {
            try
            {
                var authHeader = Request.Headers.Authorization;
                if (authHeader == null || authHeader.Scheme != "Bearer" || string.IsNullOrEmpty(authHeader.Parameter)) 
                { 
                    return Unauthorized(); 
                }

                var user = (User)TokenManager.DecodeToken(authHeader.Parameter);
                if (user == null)
                {
                    return Unauthorized();
                }

                string newToken = TokenManager.GenerateToken(user);
                return Ok(new { token = newToken });
            }
            catch
            {
                return BadRequest();
            }
        }
    }
}