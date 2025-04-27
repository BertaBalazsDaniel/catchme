using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public class ProductReview
    {
        public int ProductId { get; set; }
        public int UserId { get; set; }
        public int Rating { get; set; }
        public string ReviewText { get; set; }
        public string CreatedAt { get; set; } = DateTime.Now.ToLongDateString();


        public virtual User User { get; set; }
        public virtual Product Product { get; set; }
    }

}