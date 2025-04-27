using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public class Favorite
    {
        public int UserId { get; set; }
        public int ProductId { get; set; }


        public User User { get; set; }
        public Product Product { get; set; }
    }
}