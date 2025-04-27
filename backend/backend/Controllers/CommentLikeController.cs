using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using backend.Security;

namespace backend.Controllers
{
    [RoutePrefix("api/commentlike")]
    public class CommentLikeController : ApiController
    {
        private readonly IShopContext _model;

        public CommentLikeController()
        {
            _model = new ShopContext();
        }

        public CommentLikeController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("")]
        public IHttpActionResult Post([FromBody] CommentLike newVote)
        {
            var existingVote = _model.CommentLikes.FirstOrDefault(cv => cv.UserId == newVote.UserId && cv.CommentId == newVote.CommentId);
            var comment = _model.Comments.FirstOrDefault(c => c.Id == newVote.CommentId);

            if (comment == null)
            {
                return NotFound();
            }

            if (existingVote != null)
            {
                if (existingVote.LikeType != newVote.LikeType)
                {
                    if (existingVote.LikeType == "Like")
                        comment.Likes--;
                    else if (existingVote.LikeType == "DisLike")
                        comment.DisLikes--;

                    if (newVote.LikeType == "Like")
                        comment.Likes++;
                    else if (newVote.LikeType == "DisLike")
                        comment.DisLikes++;

                    existingVote.LikeType = newVote.LikeType;
                }
            }
            else
            {
                if (newVote.LikeType == "Like")
                    comment.Likes++;
                else if (newVote.LikeType == "DisLike")
                    comment.DisLikes++;

                _model.CommentLikes.Add(newVote);
            }

            _model.SaveChanges();

            return Created($"api/commentlike/{newVote.UserId}/{newVote.CommentId}", newVote);
        }

        [TokenAuthorize]
        [HttpDelete]
        [Route("{userid}/{commentid}")]
        public IHttpActionResult Delete(int userid, int commentid)
        {
            var vote = _model.CommentLikes.FirstOrDefault(cv => cv.UserId == userid && cv.CommentId == commentid);
            var comment = _model.Comments.FirstOrDefault(c => c.Id == commentid);

            if (vote.LikeType == "Like")
                comment.Likes--;
            else if (vote.LikeType == "DisLike")
                comment.DisLikes--;

            _model.CommentLikes.Remove(vote);
            _model.SaveChanges();

            return Content(HttpStatusCode.OK, new { message = "Szavazat törölve!" });
        }
    }
}