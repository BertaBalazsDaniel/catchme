using kezelofelulet.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.ComponentModel;
using System.Reflection;

namespace kezelofelulet
{
    /// <summary>
    /// Interaction logic for rendelesek.xaml
    /// </summary>
    /// 
    public static class EnumHelper
    {
        public static string GetEnumDescription(Enum value)
        {
            FieldInfo fi = value.GetType().GetField(value.ToString());
            if (fi != null)
            {
                var attributes = (DescriptionAttribute[])fi.GetCustomAttributes(typeof(DescriptionAttribute), false);
                if (attributes != null && attributes.Length > 0)
                    return attributes[0].Description;
            }
            return value.ToString();
        }

        public static T GetEnumValueFromDescription<T>(string description)
        {
            var type = typeof(T);
            if (!type.IsEnum) throw new InvalidOperationException();
            foreach (var field in type.GetFields())
            {
                var attribute = Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute)) as DescriptionAttribute;
                if (attribute != null)
                {
                    if (attribute.Description == description)
                        return (T)field.GetValue(null);
                }

                if (field.Name == description)
                    return (T)field.GetValue(null);
            }
            throw new ArgumentException("Nem található enum érték ezzel a leírással: " + description);
        }
    }

    public partial class rendelesek : Window
    {
        public rendelesek()
        {
            InitializeComponent();
            listviewfel();
            combokfel();
            select.IsEnabled = false;
        }
        public void listviewfel()
        {
            listView.Items.Clear();
            using (var ctx = new Context())
            {
                var items = ctx.Orders;
                foreach (var item in items)
                {
                    listView.Items.Add(new Order(Convert.ToInt32(item.Id), Convert.ToInt32(item.UserId),item.FullName, item.Email,  item.OrderStatus, item.AddressLine, item.PhoneNumber, item.OrderDate, Convert.ToInt32(item.TotalAmount), item.PaymentStatus, item.PayPalTransactionId, item.PaymentDate));
                }
            }
        }

        public void combokfel()
        {
            rendstatusz.Items.Clear();
            foreach (OrderStatuses status in Enum.GetValues(typeof(OrderStatuses)))
            {
                rendstatusz.Items.Add(EnumHelper.GetEnumDescription(status));
            }

            fizstatusz.Items.Clear();
            foreach (PaymentStatuses status in Enum.GetValues(typeof(PaymentStatuses)))
            {
                fizstatusz.Items.Add(EnumHelper.GetEnumDescription(status));
            }
        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            MainWindow ujablak = new MainWindow();
            ujablak.Show();
            this.Close();
        }

        private void listView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (listView.SelectedIndex == -1)
            {
                userBox.Text = "";
                rendstatusz.SelectedIndex = 0;
                emailbox.Text = "";
                cimBox.Text = "";
                telBox.Text = "";
                orderTimeBox.Text = "";
                amountBox.Text = "";
                rendstatusz.SelectedIndex = 0;
                transactionid.Text = "";
                del.IsEnabled = false;
                mod.IsEnabled = false;
                select.IsEnabled = false;
                userBox.IsEnabled = false;
                emailbox.IsEnabled = false;
                cimBox.IsEnabled = false;
                telBox.IsEnabled = false;
                rendstatusz.IsEnabled = false;
                rendstatusz.SelectedIndex = -1;
                fizstatusz.SelectedIndex = -1;
            }
            else
            {
                del.IsEnabled = true;
                mod.IsEnabled = true;
                select.IsEnabled = true;
                userBox.IsEnabled = true;
                emailbox.IsEnabled = true;
                cimBox.IsEnabled = true;
                telBox.IsEnabled = true;
                rendstatusz.IsEnabled = true;

                if (listView.SelectedItem is Order item)
                {
                    using (var ctx = new Context())
                    {
                        var res = ctx.Orders
                                .Where(x => x.Id == item.Id)
                                .FirstOrDefault();

                        userBox.Text = res.FullName;
                        emailbox.Text = res.Email;
                        cimBox.Text = res.AddressLine;
                        telBox.Text = res.PhoneNumber.ToString();
                        orderTimeBox.Text = res.OrderDate.ToString();
                        amountBox.Text = res.TotalAmount.ToString();
                        rendstatusz.SelectedItem = EnumHelper.GetEnumDescription(EnumHelper.GetEnumValueFromDescription<OrderStatuses>(res.OrderStatus));
                        fizstatusz.SelectedItem = EnumHelper.GetEnumDescription(EnumHelper.GetEnumValueFromDescription<PaymentStatuses>(res.PaymentStatus));
                        transactionid.Text = res.PayPalTransactionId.ToString();
                    }
                }
            }
        }

        private void select_Click(object sender, RoutedEventArgs e)
        {
            listView.SelectedIndex = -1;
            rendstatusz.SelectedIndex = -1;
            fizstatusz.SelectedIndex = -1;
        }

        private void mod_Click(object sender, RoutedEventArgs e)
        {
            if (listView.SelectedItem is Order item)
            {
                using (var ctx = new Context())
                {
                    var rendeles = ctx.Orders.FirstOrDefault(x => x.Id == item.Id);

                    if (rendeles != null)
                    {
                        try
                        {
                            rendeles.FullName = userBox.Text;
                            rendeles.Email = emailbox.Text;
                            rendeles.AddressLine = cimBox.Text;
                            rendeles.PhoneNumber = telBox.Text;
                            rendeles.OrderDate = orderTimeBox.Text;
                            rendeles.TotalAmount = int.Parse(amountBox.Text);
                            rendeles.OrderStatus = EnumHelper.GetEnumDescription(
                                EnumHelper.GetEnumValueFromDescription<OrderStatuses>(rendstatusz.SelectedItem.ToString())
                            );
                            rendeles.PaymentStatus = EnumHelper.GetEnumDescription(
                                EnumHelper.GetEnumValueFromDescription<PaymentStatuses>(fizstatusz.SelectedItem.ToString())
                            );
                            rendeles.PayPalTransactionId = transactionid.Text;
                            ctx.SaveChanges();
                        }
                        catch 
                        {
                            MessageBox.Show("Hibás email cím!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                        }
                    }
                }
            }

            listviewfel();
        }

        private void del_Click(object sender, RoutedEventArgs e)
        {
            if (listView.SelectedItem is Order item)
            {
                using (var ctx = new Context())
                {
                    var torol = ctx.Orders.FirstOrDefault(x => x.Id == item.Id);

                    var okapcsolodoRekordok = ctx.OrderItems.Where(o => o.ProductId == torol.Id);
                    ctx.OrderItems.RemoveRange(okapcsolodoRekordok);

                    ctx.Orders.Remove(torol);
                    ctx.SaveChanges();

                    MessageBox.Show("Rendelés sikeresen törölve!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                    listviewfel();
                }
            }
            listviewfel();
        }

        private void joe(object sender, TextChangedEventArgs e)
        {
            bool hasSelection = listView.SelectedIndex != -1;
            bool hasRequiredFields = !string.IsNullOrWhiteSpace(userBox.Text) && !string.IsNullOrWhiteSpace(emailbox.Text) && !string.IsNullOrWhiteSpace(telBox.Text) && !string.IsNullOrWhiteSpace(cimBox.Text) && rendstatusz.SelectedIndex != -1 && fizstatusz.SelectedIndex != -1;

            bool isModified = false;

            if (hasSelection && listView.SelectedItem is Order selectedItem)
            {
                using (var ctx = new Context())
                {
                    var original = ctx.Orders.FirstOrDefault(x => x.Id == selectedItem.Id);

                    if (original != null)
                    {
                        string currentFullName = userBox.Text.Trim();
                        string currentEmail = emailbox.Text.Trim();
                        string currentAddress = cimBox.Text.Trim();
                        string currentPhone = telBox.Text.Trim();
                        string currentOrderStatus = rendstatusz.SelectedItem?.ToString();

                        if (currentFullName != original.FullName ||
                            currentEmail != original.Email ||
                            currentAddress != original.AddressLine ||
                            currentPhone != original.PhoneNumber ||
                            currentOrderStatus != original.OrderStatus)
                        {
                            isModified = true;
                        }
                    }
                }
            }

            mod.IsEnabled = hasSelection && hasRequiredFields;
            select.IsEnabled = hasSelection;
            del.IsEnabled = hasSelection && !isModified;
        }

        private void rendstatusz_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            joe(null,null);
        }
    }
}