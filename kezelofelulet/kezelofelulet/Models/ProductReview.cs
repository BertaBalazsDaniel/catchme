using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace kezelofelulet.Models
{
    public class ProductReview
    {
        [Key]
        public int ProductId { get; set; }
        public int UserId { get; set; }
        public int Rating { get; set; }
        public string ReviewText { get; set; }
        public string CreatedAt { get; set; }
    }
}
