using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using backend.Models;
using backend.UserManager;


namespace UnitTestProject
{
    public class TestContext : IShopContext
    {
        FakeDbSet<User> _users;
        FakeDbSet<Product> _products;
        FakeDbSet<ProductReview> _productreviews;
        FakeDbSet<Post> _posts;
        FakeDbSet<OrderItem> _orderitems;
        FakeDbSet<Order> _orders;
        FakeDbSet<Favorite> _favorites;
        FakeDbSet<CommentLike> _commentlikes;
        FakeDbSet<Comment> _comments;
        FakeDbSet<Category> _categories;
        FakeDbSet<CartItem> _cartitems;

        public TestContext()
        {
            byte[] hash, salt;
            PasswordManager.CreatePasswordHash("jelszo123", out hash, out salt);

            _users = new FakeDbSet<User>(new List<User>
            {
                new User { Id = 1, Username = "admin", Email = "admin@horgasz.com", PasswordHash = hash, PasswordSalt = salt, CreatedAt = "2025-02-04 10:18:40", ProfileImage = "resources/users/user.svg", Bio = "Adminisztrátor.", Role = Roles.Adminisztrátor.ToString() },
                new User { Id = 2, Username = "user1", Email = "user1@example.com", PasswordHash = hash, PasswordSalt = salt, CreatedAt = "2025-02-04 10:18:41", ProfileImage = "resources/users/user.svg", Bio = "Felhasználó 1.", Role = Roles.Felhasználó.ToString() },
                new User { Id = 3, Username = "user2", Email = "user2@example.com", PasswordHash = hash, PasswordSalt = salt, CreatedAt = "2025-02-04 10:18:42", ProfileImage = "resources/users/user.svg", Bio = "Felhasználó 2.", Role = Roles.Felhasználó.ToString() },
                new User { Id = 4, Username = "mod1", Email = "mod1@example.com", PasswordHash = hash, PasswordSalt = salt, CreatedAt = "2025-02-04 10:18:43", ProfileImage = "resources/users/user.svg", Bio = "Moderátor.", Role = Roles.Moderátor.ToString() },
                new User { Id = 5, Username = "user3", Email = "user3@example.com", PasswordHash = hash, PasswordSalt = salt, CreatedAt = "2025-02-04 10:18:44", ProfileImage = "resources/users/user.svg", Bio = "Felhasználó 3.", Role = Roles.Felhasználó.ToString() }
            });

            _categories = new FakeDbSet<Category>(new List<Category>
            {
                new Category { Id = 1, Name = "Botok" },
                new Category { Id = 2, Name = "Orsók"},
                new Category { Id = 3, Name = "Csalik" },
                new Category { Id = 4, Name = "Kiegészítők" },
                new Category { Id = 5, Name = "Ruházat" },
                new Category { Id = 6, Name = "Alkategória Teszt", ParentId = 1 }
            });

            _products = new FakeDbSet<Product>(new List<Product>
            {
                new Product { Id = 1, Name = "Bot 1", Description = "Bot leírás 1", Price = 10000, CategoryId = 1, StockQuantity = 10, ImageUrl = "img1.jpg", Attributes = "{\"length\":\"2m\"}" },
                new Product { Id = 2, Name = "Bot 2", Description = "Bot leírás 2", Price = 12000, CategoryId = 1, StockQuantity = 5, ImageUrl = "img2.jpg", Attributes = "{\"length\":\"2.5m\"}" },
                new Product { Id = 3, Name = "Orsó 1", Description = "Orsó leírás", Price = 8000, CategoryId = 2, StockQuantity = 15, ImageUrl = "img3.jpg", Attributes = "{\"ratio\":\"5.1:1\"}" },
                new Product { Id = 4, Name = "Csali", Description = "Csali leírás", Price = 2000, CategoryId = 3, StockQuantity = 50, ImageUrl = "img4.jpg", Attributes = "{\"type\":\"élő\"}" },
                new Product { Id = 5, Name = "Kabát", Description = "Meleg kabát", Price = 15000, CategoryId = 5, StockQuantity = 8, ImageUrl = "img5.jpg", Attributes = "{\"size\":\"L\"}" }
            });

            _productreviews = new FakeDbSet<ProductReview>(new List<ProductReview>
            {
                new ProductReview { ProductId = 1, UserId = 2, Rating = 5, ReviewText = "Nagyon jó!", CreatedAt = "2025-02-04 11:00:00" },
                new ProductReview { ProductId = 2, UserId = 3, Rating = 4, ReviewText = "Elmegy.", CreatedAt = "2025-02-04 11:01:00" },
                new ProductReview { ProductId = 3, UserId = 4, Rating = 5, ReviewText = "Remek orsó!", CreatedAt = "2025-02-04 11:02:00" },
                new ProductReview { ProductId = 4, UserId = 5, Rating = 3, ReviewText = "Átlagos.", CreatedAt = "2025-02-04 11:03:00" },
                new ProductReview { ProductId = 5, UserId = 1, Rating = 4, ReviewText = "Hasznos ruházat.", CreatedAt = "2025-02-04 11:04:00" }
            });

            _orders = new FakeDbSet<Order>(new List<Order>
            {
                new Order { Id = 1, UserId = 1, OrderStatus = "Completed", AddressLine = "Cím 1", PhoneNumber = "+361234567", TotalAmount = 10000, PaymentStatus = "Paid", PayPalTransactionId = "TXN001", OrderDate = "2025-02-04", PaymentDate = "2025-02-04" },
                new Order { Id = 2, UserId = 2, OrderStatus = "Pending", AddressLine = "Cím 2", PhoneNumber = "+361234568", TotalAmount = 20000, PaymentStatus = "Pending", PayPalTransactionId = "TXN002", OrderDate = "2025-02-04", PaymentDate = "2025-02-04" },
                new Order { Id = 3, UserId = 3, OrderStatus = "Shipped", AddressLine = "Cím 3", PhoneNumber = "+361234569", TotalAmount = 15000, PaymentStatus = "Paid", PayPalTransactionId = "TXN003", OrderDate = "2025-02-04", PaymentDate = "2025-02-04" },
                new Order { Id = 4, UserId = 4, OrderStatus = "Completed", AddressLine = "Cím 4", PhoneNumber = "+361234570", TotalAmount = 18000, PaymentStatus = "Paid", PayPalTransactionId = "TXN004", OrderDate = "2025-02-04", PaymentDate = "2025-02-04" },
                new Order { Id = 5, UserId = 5, OrderStatus = "Cancelled", AddressLine = "Cím 5", PhoneNumber = "+361234571", TotalAmount = 5000, PaymentStatus = "Refunded", PayPalTransactionId = "TXN005", OrderDate = "2025-02-04", PaymentDate = "2025-02-04" }
            });

            _orderitems = new FakeDbSet<OrderItem>(new List<OrderItem>
            {
                new OrderItem { OrderId = 1, ProductId = 1, Quantity = 1, Price = 10000 },
                new OrderItem { OrderId = 2, ProductId = 2, Quantity = 1, Price = 12000 },
                new OrderItem { OrderId = 3, ProductId = 3, Quantity = 2, Price = 16000 },
                new OrderItem { OrderId = 4, ProductId = 4, Quantity = 3, Price = 6000 },
                new OrderItem { OrderId = 5, ProductId = 5, Quantity = 1, Price = 15000 }
            });

            _posts = new FakeDbSet<Post>(new List<Post>
            {
                new Post { Id = 1, UserId = 1, Category = "Catches", Content = "Hal 1", CreatedAt = "2025-02-04" },
                new Post { Id = 2, UserId = 2, Category = "Tips", Content = "Tartalom 2", CreatedAt = "2025-02-04" },
                new Post { Id = 3, UserId = 3, Category = "Fishing Spots", Content = "Leírás 3", CreatedAt = "2025-02-04" },
                new Post { Id = 4, UserId = 4, Category = "Catches", Content = "Hal 4", CreatedAt = "2025-02-04" },
                new Post { Id = 5, UserId = 5, Category = "Tips", Content = "Tartalom 5", CreatedAt = "2025-02-04" }
            });

            _comments = new FakeDbSet<Comment>(new List<Comment>
            {
                new Comment { Id = 1, PostId = 1, UserId = 2, Content = "Szép!", CreatedAt = "2025-02-04", Likes = 10, DisLikes = 1 },
                new Comment { Id = 2, PostId = 2, UserId = 3, Content = "Köszi!", CreatedAt = "2025-02-04", Likes = 5, DisLikes = 0 },
                new Comment { Id = 3, PostId = 3, UserId = 4, Content = "Remek!", CreatedAt = "2025-02-04", Likes = 7, DisLikes = 2 },
                new Comment { Id = 4, PostId = 4, UserId = 5, Content = "Tetszik!", CreatedAt = "2025-02-04", Likes = 8, DisLikes = 0 },
                new Comment { Id = 5, PostId = 5, UserId = 1, Content = "Jó tanács!", CreatedAt = "2025-02-04", Likes = 6, DisLikes = 0 }
            });

            _commentlikes = new FakeDbSet<CommentLike>(new List<CommentLike>
            {
                new CommentLike { UserId = 1, CommentId = 1, LikeType = "upvote" },
                new CommentLike { UserId = 2, CommentId = 2, LikeType = "upvote" },
                new CommentLike { UserId = 3, CommentId = 3, LikeType = "upvote" },
                new CommentLike { UserId = 4, CommentId = 4, LikeType = "upvote" },
                new CommentLike { UserId = 5, CommentId = 5, LikeType = "upvote" }
            });

            _favorites = new FakeDbSet<Favorite>(new List<Favorite>
            {
                new Favorite { UserId = 1, ProductId = 1 },
                new Favorite { UserId = 2, ProductId = 2 },
                new Favorite { UserId = 3, ProductId = 3 },
                new Favorite { UserId = 4, ProductId = 4 },
                new Favorite { UserId = 5, ProductId = 5 }
            });

            _cartitems = new FakeDbSet<CartItem>(new List<CartItem>
            {
                new CartItem { UserId = 1, ProductId = 1, Quantity = 1 },
                new CartItem { UserId = 2, ProductId = 2, Quantity = 2 },
                new CartItem { UserId = 3, ProductId = 3, Quantity = 1 },
                new CartItem { UserId = 4, ProductId = 4, Quantity = 3 },
                new CartItem { UserId = 5, ProductId = 5, Quantity = 1 }
            });


            foreach (var post in _posts)
            {
                post.User = _users.FirstOrDefault(u => u.Id == post.UserId);
            }

            foreach (var item in _orderitems)
            {
                item.Product = _products.FirstOrDefault(p => p.Id == item.ProductId);
            }

            foreach (var order in _orders)
            {
                order.OrderItems = _orderitems.Where(oi => oi.OrderId == order.Id).ToList();
            }

            foreach (var comment in _comments)
            {
                comment.User = _users.FirstOrDefault(u => u.Id == comment.UserId);
            }

            foreach (var category in _categories)
            {
                category.SubCategories = _categories.Where(c => c.ParentId == category.Id).ToList();
            }

            foreach (var cartItem in _cartitems)
            {
                cartItem.User = _users.FirstOrDefault(u => u.Id == cartItem.UserId);
                cartItem.Product = _products.FirstOrDefault(p => p.Id == cartItem.ProductId);
            }

            foreach (var review in _productreviews)
            {
                review.User = _users.FirstOrDefault(u => u.Id == review.UserId);
                review.Product = _products.FirstOrDefault(p => p.Id == review.ProductId);
            }

            foreach (var fav in _favorites)
            {
                fav.Product = _products.FirstOrDefault(p => p.Id == fav.ProductId);
            }
        }

        public DbSet<User> Users
        {
            get => _users; 
            set => _users = new FakeDbSet<User>(value);
        }

        public DbSet<Product> Products
        {
            get => _products;
            set => _products = new FakeDbSet<Product>(value);
        }

        public DbSet<ProductReview> ProductReviews
        {
            get => _productreviews;
            set => _productreviews = new FakeDbSet<ProductReview>(value);
        }
        public DbSet<Post> Posts
        {
            get => _posts;
            set => _posts = new FakeDbSet<Post>(value);
        }
        public DbSet<OrderItem> OrderItems
        {
            get => _orderitems;
            set => _orderitems = new FakeDbSet<OrderItem>(value);
        }
        public DbSet<Order> Orders
        {
            get => _orders;
            set => _orders = new FakeDbSet<Order>(value);
        }
        public DbSet<Favorite> Favorites
        {
            get => _favorites;
            set => _favorites = new FakeDbSet<Favorite>(value);
        }
        public DbSet<CommentLike> CommentLikes
        {
            get => _commentlikes;
            set => _commentlikes = new FakeDbSet<CommentLike>(value);
        }
        public DbSet<Comment> Comments
        {
            get => _comments;
            set => _comments = new FakeDbSet<Comment>(value);
        }
        public DbSet<Category> Categories
        {
            get => _categories;
            set => _categories = new FakeDbSet<Category>(value);
        }
        public DbSet<CartItem> CartItems
        {
            get => _cartitems;
            set => _cartitems = new FakeDbSet<CartItem>(value);
        }

        public int SaveChanges()
        {
            return 0;
        }
    }
}