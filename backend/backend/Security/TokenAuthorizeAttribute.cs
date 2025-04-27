using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Controllers;
using backend.Models;
using System.Net;

namespace backend.Security
{
    public class TokenAuthorizeAttribute : AuthorizeAttribute
    {
        List<Roles> _roles;
        public TokenAuthorizeAttribute(string roles = null)
        {
            _roles = new List<Roles>();
            if (!string.IsNullOrEmpty(roles))
            {
                foreach (var roleName in roles.Split(','))
                {
                    if (Enum.TryParse<Roles>(roleName, out var role))
                        _roles.Add(role);
                }
            }
            else
            {
                foreach (var role in Enum.GetValues(typeof(Roles)))
                    _roles.Add((Roles)role);
            }
        }

        public override void OnAuthorization(HttpActionContext actionContext)
        {
            var authHeader = actionContext.Request.Headers.Authorization;

            if (authHeader == null || authHeader.Scheme != "Bearer" || string.IsNullOrEmpty(authHeader.Parameter))
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, new { error = "missing_or_invalid_token" });
                return;
            }

            var result = TokenManager.DecodeToken(authHeader.Parameter);

            if (result is string strResult)
            {
                if (strResult == "expired")
                {
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, new { error = "expired_token" });
                }
                else
                {
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, new { error = "invalid_token" });
                }
                return;
            }

            var user = result as User;
            if (!Enum.TryParse(user.Role, true, out Roles userType) || !_roles.Contains(userType))
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Forbidden, "Hozzáférés megtagadva");
                return;
            }
        }
    }
}