using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public enum VoteTypes
    {
        Like,
        Dislike
    }
    public class CommentLike
    {
        public int UserId { get; set; }
        public int CommentId { get; set; }
        public string LikeType { get; set; }


        public User User { get; set; }
        public Comment Comment { get; set; }
    }
}