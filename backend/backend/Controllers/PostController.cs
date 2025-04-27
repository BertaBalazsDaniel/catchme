using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using System;
using backend.Security;
using System.IO;

namespace backend.Controllers
{
    [RoutePrefix("api/post")]
    public class PostController : ApiController
    {
        private readonly IShopContext _model;

        public PostController()
        {
            _model = new ShopContext();
        }

        public PostController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("category/{category}")]
        public IHttpActionResult GetPostsByCategory(string category, int page, int limit)
        {
            var posts = _model.Posts
                .Include(p => p.User)
                .Where(p => p.Category == category)
                .Select(p => new
                {
                    Id = p.Id,
                    UserId = p.UserId,
                    UserName = p.User.Username,
                    ProfileImage = p.User.ProfileImage,
                    Category = p.Category,
                    Content = p.Content,
                    ImageUrl = p.ImageUrl,
                    CreatedAt = p.CreatedAt,
                    CommentCount = _model.Comments.Count(c => c.PostId == p.Id)
                });

            int totalCount = posts.Count();

            var pagedPosts = posts
                .OrderByDescending(p => p.CreatedAt)
                .Skip((page - 1) * limit)
                .Take(limit)
                .ToList();

            return Ok(new
            {
                TotalCount = totalCount,
                Page = page,
                Limit = limit,
                Posts = pagedPosts
            });
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("{id}")]
        public IHttpActionResult GetId(int id)
        {
            var post = _model.Posts
                .Include(p => p.User)
                .Select(p => new
                {
                    Id = p.Id,
                    UserId = p.UserId,
                    UserName = p.User.Username,
                    ProfileImage = p.User.ProfileImage,
                    Category = p.Category,
                    Content = p.Content,
                    ImageUrl = p.ImageUrl,
                    CreatedAt = p.CreatedAt
                })
                .FirstOrDefault(p => p.Id == id);

            if (post == null)
            {
                return NotFound();
            }

            return Ok(post);
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("")]
        public IHttpActionResult Post([FromBody] Post newPost)
        {
            newPost.CreatedAt = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss");

            _model.Posts.Add(newPost);
            _model.SaveChanges();

            return Created($"api/post/{newPost.Id}", newPost);
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("user/{userId}")]
        public IHttpActionResult GetPostsByUser(int userId, int page, int limit)
        {
            var posts = _model.Posts
                .Where(p => p.UserId == userId)
                .Select(p => new
                {
                    Id = p.Id,
                    UserId = p.UserId,
                    UserName = p.User.Username,
                    ProfileImage = p.User.ProfileImage,
                    Category = p.Category,
                    Content = p.Content,
                    ImageUrl = p.ImageUrl,
                    CreatedAt = p.CreatedAt,
                    CommentCount = _model.Comments.Count(c => c.PostId == p.Id)
                });

            int totalCount = posts.Count();

            var pagedPosts = posts
                .OrderByDescending(p => p.CreatedAt)
                .Skip((page - 1) * limit)
                .Take(limit)
                .ToList();

            return Ok(new
            {
                TotalCount = totalCount,
                Page = page,
                Limit = limit,
                Posts = pagedPosts
            });
        }

        [TokenAuthorize]
        [HttpDelete]
        [Route("{id}")]
        public IHttpActionResult DeletePost(int id)
        {
            var post = _model.Posts.FirstOrDefault(p => p.Id == id);

            if (!string.IsNullOrEmpty(post.ImageUrl))
            {
                try
                {
                    string relativePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, @"..\..\frontend\html", post.ImageUrl);
                    string fullPath = Path.GetFullPath(relativePath);

                    if (File.Exists(fullPath))
                    {
                        File.Delete(fullPath);
                    }
                }
                catch
                {
                    
                }
            }

            _model.Posts.Remove(post);
            _model.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }
    }
}