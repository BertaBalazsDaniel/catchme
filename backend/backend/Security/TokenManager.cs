using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using backend.Models;
using System.Text;

namespace backend.Security
{
    public class TokenManager
    {
        public static string GenerateToken(User user, int expireMinutes = 60)
        {
            long expiryTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + (expireMinutes * 60);
            string tokenContent = $"{user.Username}.{user.Role}.{expiryTime}";
            return Convert.ToBase64String(Encoding.UTF8.GetBytes(tokenContent));
        }

        public static object DecodeToken(string token)
        {
            try
            {
                var bytes = Convert.FromBase64String(token);
                var tokens = Encoding.UTF8.GetString(bytes).Split('.');

                if (tokens.Length < 3)
                    return "invalid_format";

                string username = tokens[0];
                string role = tokens[1];
                long expiryTime = long.Parse(tokens[2]);
                long currentTime = DateTimeOffset.Now.ToUnixTimeSeconds();

                if (currentTime > expiryTime)
                    return "expired";

                return new User
                {
                    Username = username,
                    Role = role
                };
            }
            catch
            {
                return "decode_error";
            }
        }
    }
}