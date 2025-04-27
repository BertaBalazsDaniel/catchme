using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace kezelofelulet.Models
{

    public enum Roles
    {
        Admin,
        User,
        Moderator
    }
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string PasswordSalt { get; set; }
        public string CreatedAt { get; set; } = DateTime.UtcNow.ToLongDateString();
        public string ProfileImage { get; set; }
        public string Bio { get; set; }
        public string Role { get; set; } = Roles.Admin.ToString();
    }
}
