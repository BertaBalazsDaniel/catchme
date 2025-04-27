using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using System;
using backend.Security;

namespace backend.Controllers
{
    public class CommentController : ApiController
    {
        private readonly IShopContext _model;

        public CommentController()
        {
            _model = new ShopContext();
        }

        public CommentController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("api/comment")]
        public IHttpActionResult Post([FromBody] Comment newComment)
        {
            newComment.CreatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            _model.Comments.Add(newComment);
            _model.SaveChanges();

            return Created($"api/comment/{newComment.Id}", newComment);
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("api/comment/{postid}/{userid}")]
        public IHttpActionResult GetCommentsByPost(int postid, int userid, int page, int limit)
        {
            var comments = _model.Comments
                .Where(c => c.PostId == postid)
                .Select(c => new
                {
                    Id = c.Id,
                    Content = c.Content,
                    CreatedAt = c.CreatedAt,
                    UserId = c.UserId,
                    User = new { c.User.Username, c.User.ProfileImage },
                    Likes = _model.CommentLikes.Count(v => v.CommentId == c.Id && v.LikeType == "Like"),
                    DisLikes = _model.CommentLikes.Count(v => v.CommentId == c.Id && v.LikeType == "DisLike"),
                    UserLike = _model.CommentLikes
                                    .Where(v => v.CommentId == c.Id && v.UserId == userid)
                                    .Select(v => v.LikeType)
                                    .FirstOrDefault()
                });

            var totalCount = comments.Count();

            var pagedComments = comments
                .OrderByDescending(c => c.Likes)
                .Skip((page - 1) * limit)
                .Take(limit)
                .ToList();

            return Ok(new
            {
                TotalCount = totalCount,
                Page = page,
                Limit = limit,
                Comments = pagedComments
            });
        }

        [TokenAuthorize]
        [HttpPut]
        [Route("{id}/like")]
        public IHttpActionResult LikeComment(int id)
        {
            var comment = _model.Comments.FirstOrDefault(c => c.Id == id);

            comment.Likes++;
            _model.SaveChanges();

            return Ok(comment);
        }

        [TokenAuthorize]
        [HttpPut]
        [Route("{id}/dislike")]
        public IHttpActionResult DisLikeComment(int id)
        {
            var comment = _model.Comments.FirstOrDefault(c => c.Id == id);

            comment.DisLikes++;
            _model.SaveChanges();

            return Ok(comment);
        }
    }
}