using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public class Post : Entity
    {
        public int UserId { get; set; }
        public string Category { get; set; }
        public string Content { get; set; }
        public string ImageUrl { get; set; }
        public string CreatedAt { get; set; } = DateTime.UtcNow.ToLongDateString();


        public User User { get; set; }
    }
}