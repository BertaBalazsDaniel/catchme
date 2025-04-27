using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace backend.Models
{
    public enum Roles
    {
        Adminisztrátor,
        Felhasználó,
        Moderátor
    }
    public class User : Entity
    {
        public string Username { get; set; }
        public string Email { get; set; }
        public byte[] PasswordHash { get; set; }
        public byte[] PasswordSalt { get; set; }
        public string CreatedAt { get; set; } = DateTime.Now.ToLongDateString();
        public string ProfileImage { get; set; }
        public string Bio { get; set; }
        public string Role { get; set; } = Roles.Felhasználó.ToString();
    }
}