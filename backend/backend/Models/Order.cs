using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace backend.Models
{
    public enum OrderStatuses
    {
        Függőben,
        Teljesítve,
        Törölve,
        [EnumMember(Value = "Feldolgozás alatt")]
        FeldolgozasAlatt,
    }

    public enum PaymentStatuses
    {
        Függőben,
        Fizetve,
        Sikertelen,
        Visszatérítve
    }

    public class Order : Entity
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string OrderStatus { get; set; } = OrderStatuses.Függőben.ToString();
        public string AddressLine { get; set; }
        public string PhoneNumber { get; set; }
        public string OrderDate { get; set; } = DateTime.Now.ToLongDateString();
        public int TotalAmount { get; set; }
        public string PaymentStatus { get; set; } = PaymentStatuses.Függőben.ToString();
        public string PayPalTransactionId { get; set; }
        public string PaymentDate { get; set; } = DateTime.Now.ToLongDateString();


        [JsonIgnore]
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public IEnumerable<Product> OrderProductItems => OrderItems.Select(oi => oi.Product);

    }
}