using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace kezelofelulet.Models
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

    public class Order
    {
        public int Id { get; set; }
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

        public Order(int Id, int UserId,string FullName, string Email, string OrderStatus, string AddressLine, string PhoneNumber, string OrderDate, int TotalAmount, string PaymentStatus, string PayPalTransactionId, string PaymentDate)
        {
            this.Id = Id;
            this.UserId = UserId;
            this.FullName = FullName;
            this.Email = Email;
            this.OrderStatus = OrderStatus;
            this.AddressLine = AddressLine;
            this.PhoneNumber = PhoneNumber;
            this.OrderDate = OrderDate;
            this.TotalAmount = TotalAmount;
            this.PaymentStatus = PaymentStatus;
            this.PayPalTransactionId = PayPalTransactionId;
            this.PaymentDate = PaymentDate;
        }

        public Order() { }
    }
}