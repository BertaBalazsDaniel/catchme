using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace kezelofelulet.Models
{
    public class Category
    {
        public int Id { get; set; }
        public int? ParentId { get; set; }
        public string Name { get; set; }

        public Category(int Id, int? ParentId, string Name)
        {
            this.Id = Id;
            this.ParentId = ParentId;
            this.Name = Name;
        }

        public Category() { }
    }
}