using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public class Category : Entity
    {
        public int? ParentId { get; set; }
        public string Name { get; set; }


        public virtual Category Parent { get; set; }
        public virtual ICollection<Category> SubCategories { get; set; }

    }
}