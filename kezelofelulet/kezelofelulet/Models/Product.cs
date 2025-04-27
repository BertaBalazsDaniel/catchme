using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace kezelofelulet.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int Price { get; set; }
        public int ? CategoryId { get; set; }
        public int StockQuantity { get; set; }
        public string ImageUrl { get; set; }
        public string Attributes { get; set; }

        public Product(int Id, string Name, string Description, int Price, int? CategoryId, int StockQuantity, string ImageUrl)
        {
            this.Id = Id;
            this.Name = Name;
            this.Description = Description;
            this.Price = Price;
            this.CategoryId = CategoryId;
            this.StockQuantity = StockQuantity;
            this.ImageUrl = ImageUrl;
        }

        public Product() { }
    }
}