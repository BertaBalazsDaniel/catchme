using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public class Product : Entity
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public int Price { get; set; }
        public int? CategoryId { get; set; }
        public int StockQuantity { get; set; } = 0;
        public string ImageUrl { get; set; }
        public string Attributes { get; set; }


        public Category Category { get; set; }
        public ICollection<ProductReview> ProductReview { get; set; }
    }

}