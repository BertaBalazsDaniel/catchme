using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace kezelofelulet.Models
{
    public class Favorite
    {
        [Key]
        public int UserId { get; set; }
        public int ProductId { get; set; }
    }
}