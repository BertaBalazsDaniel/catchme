using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public class Comment : Entity
    {
        public int PostId { get; set; }
        public int UserId { get; set; }
        public string Content { get; set; }
        public string CreatedAt { get; set; } = DateTime.UtcNow.ToLongDateString();
        public int Likes { get; set; } = 0;
        public int DisLikes { get; set; } = 0;


        public User User { get; set; }
    }
}