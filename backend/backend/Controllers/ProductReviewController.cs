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
    public class ProductReviewController : ApiController
    {
        private readonly IShopContext _model;

        public ProductReviewController()
        {
            _model = new ShopContext();
        }

        public ProductReviewController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("api/productreview/byname")]
        public IHttpActionResult GetPagedByProduct([FromUri] string productName, int page = 1, int limit = 5)
        {
            var query = _model.ProductReviews
                .Include(r => r.User)
                .Where(pr => pr.Product.Name == productName)
                .OrderByDescending(pr => pr.CreatedAt);

            var totalCount = query.Count();

            var paged = query
                .Skip((page - 1) * limit)
                .Take(limit)
                .Select(pr => new {
                    Rating = pr.Rating,
                    ReviewText = pr.ReviewText,
                    CreatedAt = pr.CreatedAt,
                    UserName = pr.User.Username
                })
                .ToList();

            return Ok(new
            {
                TotalCount = totalCount,
                Page = page,
                Limit = limit,
                Reviews = paged
            });
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("api/productreview")]
        public IHttpActionResult Post([FromBody] ProductReview newReview)
        {
            var existingReview = _model.ProductReviews.FirstOrDefault(r => r.ProductId == newReview.ProductId && r.UserId == newReview.UserId);
            if (existingReview != null)
            {
                existingReview.Rating = newReview.Rating;
                existingReview.ReviewText = newReview.ReviewText;
                existingReview.CreatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
            else
            {
                newReview.CreatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                _model.ProductReviews.Add(newReview);
            }

            _model.SaveChanges();

            return Created($"api/productreview/{newReview.UserId}/{newReview.ProductId}", newReview);
        }
    }
}