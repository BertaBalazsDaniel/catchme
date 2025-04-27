using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using Newtonsoft.Json;
using System.Configuration;

namespace backend.Models
{
    public class ShopContext : DbContext, IShopContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<ProductReview> ProductReviews { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }
        public DbSet<Post> Posts { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<CommentLike> CommentLikes { get; set; }
        public DbSet<Favorite> Favorites { get; set; }
        public DbSet<CartItem> CartItems { get; set; }

        public ShopContext() : base("name=ShopConnection") { }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<CommentLike>()
                .HasKey(cv => new { cv.UserId, cv.CommentId });

            modelBuilder.Entity<Favorite>()
                .HasKey(f => new { f.UserId, f.ProductId });

            modelBuilder.Entity<CartItem>()
                .HasKey(c => new { c.ProductId, c.UserId });

            modelBuilder.Entity<OrderItem>()
                .HasKey(o => new { o.ProductId, o.OrderId });

            modelBuilder.Entity<ProductReview>()
                .HasKey(p => new { p.ProductId, p.UserId });

            modelBuilder.Entity<Category>()
               .HasMany(c => c.SubCategories)
               .WithOptional()
               .HasForeignKey(c => c.ParentId);

            base.OnModelCreating(modelBuilder);
        }
    }
}