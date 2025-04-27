using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using backend.Models;
using System.Data.Entity;
using backend.Security;
using System;

namespace backend.Controllers
{
    [RoutePrefix("api/product")]
    public class ProductController : ApiController
    {
        private readonly IShopContext _model;

        public ProductController()
        {
            _model = new ShopContext();
        }

        public ProductController(IShopContext model)
        {
            _model = model;
        }

        [TokenAuthorize()]
        [HttpGet]
        [Route("")]
        public IHttpActionResult GetProducts(int page, int limit, int? userId = null)
        {
            var products = _model.Products
                .Include(p => p.Category)
                .Select(p => new
                {
                    Id = p.Id,
                    Name = p.Name,
                    Description = p.Description,
                    Price = p.Price,
                    CategoryId = p.CategoryId,
                    StockQuantity = p.StockQuantity,
                    ImageUrl = p.ImageUrl,
                    Attributes = p.Attributes
                });

            int totalProducts = products.Count();

            var favorites = _model.Favorites.Where(f => f.UserId == userId.Value).Select(f => f.ProductId).ToList();

            var pagedProducts = products
                .OrderBy(p => p.Id)
                .Skip((page - 1) * limit)
                .Take(limit)
                .ToList()
                .Select(p => new {
                    Id = p.Id,
                    Name = p.Name,
                    Description = p.Description,
                    Price = p.Price,
                    CategoryId = p.CategoryId,
                    StockQuantity = p.StockQuantity,
                    ImageUrl = p.ImageUrl,
                    Attributes = p.Attributes,
                    Saved = favorites.Contains(p.Id)
                }).ToList();

            return Ok(new
            {
                TotalCount = totalProducts,
                Page = page,
                Limit = limit,
                Products = pagedProducts
            });
        }

        [TokenAuthorize()]
        [HttpGet]
        [Route("filter")]
        public IHttpActionResult GetFilteredProducts(int page, int limit, int? categoryId = null, decimal? maxPrice = null, string attributes = null, string search = null, string sortBy = null, string sortOrder = "asc", int? userId = null)
        {
            var products = _model.Products.Include(p => p.Category).AsQueryable();

            if (categoryId.HasValue)
                products = products.Where(p => p.CategoryId == categoryId.Value);

            if (maxPrice.HasValue)
                products = products.Where(p => p.Price <= maxPrice.Value);

            if (!string.IsNullOrEmpty(search))
                products = products.Where(p => p.Name.ToLower().Contains(search.ToLower()));

            if (!string.IsNullOrEmpty(sortBy))
            {
                bool descending = sortOrder.ToLower() == "desc";
                switch (sortBy.ToLower())
                {
                    case "name":
                        products = descending ? products.OrderByDescending(p => p.Name) : products.OrderBy(p => p.Name);
                        break;
                    case "price":
                        products = descending ? products.OrderByDescending(p => p.Price) : products.OrderBy(p => p.Price);
                        break;
                    default:
                        products = products.OrderBy(p => p.Id);
                        break;
                }
            }

            var productsList = products.ToList();

            if (!string.IsNullOrEmpty(attributes))
            {
                var attributePairs = attributes.Split(',');
                foreach (var pair in attributePairs)
                {
                    var keyValue = pair.Split(':');
                    if (keyValue.Length == 2)
                    {
                        var key = keyValue[0].Trim();
                        var value = keyValue[1].Trim();

                        if (decimal.TryParse(value.Replace(',', '.'), System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal numericFilter))
                        {
                            productsList = productsList.Where(p =>
                            {
                                if (string.IsNullOrEmpty(p.Attributes)) return false;
                                try
                                {
                                    var attr = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(p.Attributes);

                                    var match = attr.FirstOrDefault(kv => kv.Key.Trim().Equals(key, StringComparison.OrdinalIgnoreCase));
                                    if (string.IsNullOrEmpty(match.Key)) return false;

                                    var raw = match.Value;
                                    var numOnly = raw.Split(' ')[0].Replace(',', '.');

                                    if (decimal.TryParse(numOnly, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal attrNumber))
                                    {
                                        return attrNumber <= numericFilter;
                                    }
                                }
                                catch { }
                                return false;
                            }).ToList();
                        }
                        else
                        {
                            productsList = productsList.Where(p =>
                            {
                                if (string.IsNullOrEmpty(p.Attributes)) return false;
                                try
                                {
                                    var attr = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(p.Attributes);
                                    return attr.Any(kv =>
                                        kv.Key.Trim().Equals(key, StringComparison.OrdinalIgnoreCase) &&
                                        kv.Value.Trim().Equals(value, StringComparison.OrdinalIgnoreCase));
                                }
                                catch { }
                                return false;
                            }).ToList();
                        }
                    }
                }
            }

            int totalProducts = productsList.Count();
            var favorites = _model.Favorites.Where(f => f.UserId == userId.Value).Select(f => f.ProductId).ToList();

            var pagedProducts = productsList
                .Skip((page - 1) * limit)
                .Take(limit)
                .Select(p => new
                {
                    Id = p.Id,
                    Name = p.Name,
                    Description = p.Description,
                    Price = p.Price,
                    CategoryId = p.CategoryId,
                    StockQuantity = p.StockQuantity,
                    ImageUrl = p.ImageUrl,
                    Attributes = p.Attributes,
                    Saved = favorites.Contains(p.Id)
                })
                .ToList();

            return Ok(new
            {
                TotalCount = totalProducts,
                Page = page,
                Limit = limit,
                Products = pagedProducts
            });
        }

        [TokenAuthorize()]
        [HttpGet]
        [Route("filters")]
        public IHttpActionResult GetCategories()
        {
            var allCategories = _model.Categories.ToList();
            var allProducts = _model.Products.ToList();

            var rootCategories = allCategories
                .Where(c => c.ParentId == null)
                .Select(parent => BuildCategoryTree(parent, allCategories, allProducts))
                .ToList();

            return Ok(new { categories = rootCategories });
        }

        private object BuildCategoryTree(Category parent, List<Category> allCategories, List<Product> allProducts)
        {
            var subcategories = allCategories
                .Where(sub => sub.ParentId == parent.Id)
                .Select(sub => BuildCategoryTree(sub, allCategories, allProducts))
                .ToList();

            var productsInCategory = allProducts.Where(p => p.CategoryId == parent.Id).ToList();

            var attributes = productsInCategory
                .Where(p => !string.IsNullOrEmpty(p.Attributes))
                .SelectMany(p => Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(p.Attributes))
                .GroupBy(attr => attr.Key)
                .ToDictionary(
                    g => g.Key,
                    g => g.Select(x => x.Value).Distinct().ToList()
                );

            var minPrice = productsInCategory.Any() ? productsInCategory.Min(p => p.Price) : 0;
            var maxPrice = productsInCategory.Any() ? productsInCategory.Max(p => p.Price) : 0;

            return new
            {
                Id = parent.Id,
                Name = parent.Name,
                SubCategories = subcategories,
                Attributes = attributes,
                MinPrice = minPrice,
                MaxPrice = maxPrice
            };
        }

        [TokenAuthorize]
        [HttpGet]
        [Route("byname")]
        public IHttpActionResult GetName([FromUri] string name, int? userId)
        {
            var product = _model.Products
                .Include(p => p.Category)
                .FirstOrDefault(p => p.Name == name);

            if (product == null)
            {
                return NotFound();
            }

            return Ok(new
            {
                Id = product.Id,
                Name = product.Name,
                Description = product.Description,
                Price = product.Price,
                CategoryId = product.CategoryId,
                StockQuantity = product.StockQuantity,
                ImageUrl = product.ImageUrl,
                Attributes = product.Attributes,
                Saved = _model.Favorites.Any(f => f.UserId == userId.Value && f.ProductId == product.Id)
            });
        }
    }
}