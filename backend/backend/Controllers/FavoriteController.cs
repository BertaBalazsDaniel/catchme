using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using backend.Security;

namespace backend.Controllers
{
    [RoutePrefix("api/favorite")]
    public class FavoriteController : ApiController
    {
        private readonly IShopContext _model;

        public FavoriteController()
        {
            _model = new ShopContext();
        }

        public FavoriteController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("{userId}")]
        public IHttpActionResult GetFavoritesByUser(int userId)
        {
            var favorites = _model.Favorites
                .Include(f => f.Product)
                .Where(f => f.UserId == userId)
                .Select(f => new
                {
                    ProductId = f.ProductId,
                    Product = new
                    {
                        f.Product.Id,
                        f.Product.Name,
                        f.Product.Price,
                        f.Product.ImageUrl
                    }
                })
                .ToList();

            return Ok(favorites);
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("count/{userId}")]
        public IHttpActionResult GetFavoriteCount(int userId)
        {
            int count = _model.Favorites.Count(f => f.UserId == userId);
            return Ok(new { count });
        }

        [TokenAuthorize]
        [HttpPost]
        [Route("toggle")]
        public IHttpActionResult ToggleFavorite([FromBody] Favorite favorite)
        {
            var existingFavorite = _model.Favorites
                .FirstOrDefault(f => f.UserId == favorite.UserId && f.ProductId == favorite.ProductId);

            if (existingFavorite != null)
            {
                _model.Favorites.Remove(existingFavorite);
                _model.SaveChanges();
                return Ok(new { message = "Kedvenc eltávolítva." });
            }
            else
            {
                _model.Favorites.Add(favorite);
                _model.SaveChanges();
                return Ok(new { message = "Kedvenc hozzáadva."});
            }
        }
    }
}