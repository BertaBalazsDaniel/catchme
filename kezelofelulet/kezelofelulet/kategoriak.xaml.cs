using kezelofelulet.Models;
using System;
using System.Collections.Generic;
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

namespace kezelofelulet
{
    /// <summary>
    /// Interaction logic for kategoriak.xaml
    /// </summary>
    /// 
    public partial class kategoriak : Window
    {
        public kategoriak()
        {
            InitializeComponent();
            listviewfel();
            combofel();
            fokategoriak.SelectedIndex = 0;
            select.IsEnabled = false;
            del.IsEnabled = false;
        }
        public void listviewfel()
        {
            listView.Items.Clear();
            using (var ctx = new Context())
            {
                var items = ctx.Categories;
                foreach (var item in items)
                {
                    listView.Items.Add(new Category(item.Id,item.ParentId,item.Name));
                }
            }
        }
        public void combofel()
        {
            fokategoriak.Items.Clear();
            fokategoriak.Items.Add("Ez egy főkategória");
            using (var ctx=new Context())
            {
                var res = ctx.Categories.Where(x => x.ParentId == null).ToList();
                foreach (var item in res)
                {
                    fokategoriak.Items.Add(item.Name);
                }
            }
        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            MainWindow ujablak = new MainWindow();
            ujablak.Show();
            this.Close();
        }

        private void select_Click(object sender, RoutedEventArgs e)
        {
            listView.SelectedIndex = -1;
            select.IsEnabled = false;
            joe();
        }

        private void mod_Click(object sender, RoutedEventArgs e)
        {
            if (listView.SelectedItem is Category item)
            {
                using (var ctx = new Context())
                {
                    var kategoria = ctx.Categories.FirstOrDefault(x => x.Id == item.Id);
                    var katid = ctx.Categories.FirstOrDefault(x => x.Name == fokategoriak.SelectedItem.ToString());
                    string ujNev = nevBox.Text.Trim();
                    bool nevLetezik = ctx.Categories.Any(x => x.Name == ujNev && x.Id != kategoria.Id);

                    if (nevLetezik)
                    {
                        MessageBox.Show("Ez a név már létezik egy másik kategóriánál!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                        nevBox.Text = "";
                        fokategoriak.SelectedIndex = 0;
                        listviewfel();
                        return;
                    }

                    if (fokategoriak.SelectedIndex == 0)
                    {
                        kategoria.ParentId = null;
                    }
                    else
                    {
                        if (katid != null && katid.Id != kategoria.Id)
                        {
                            kategoria.ParentId = katid.Id;
                        }
                        else
                        {
                            MessageBox.Show("Nem lehet saját magának az alkategóriája!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                            return;
                        }
                    }

                    kategoria.Name = ujNev;
                    ctx.SaveChanges();
                    MessageBox.Show("Kategória sikeresen módosítva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                }
            }

            nevBox.Text = "";
            fokategoriak.SelectedIndex = 0;
            listView.Items.Clear();
            listviewfel();
            combofel();
            listView.SelectedIndex = -1;
            joe();
        }



        private void add_Click(object sender, RoutedEventArgs e)
        {
            int id = 0;
            using (var ctx = new Context())
            {
                var items = ctx.Categories;
                foreach (var item in items)
                {
                    id = item.Id + 1;
                }
            }

            using (var ctx = new Context())
            {
                string ujNev = nevBox.Text.Trim();

                if (ctx.Categories.Any(x => x.Name == ujNev))
                {
                    MessageBox.Show("Ez a kategória már létezik!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    nevBox.Text = "";
                    fokategoriak.SelectedIndex = 0;
                }
                else
                {
                    if (fokategoriak.SelectedIndex == 0)
                    {
                        var ujKategoria = new Category
                        {
                            Id = id,
                            Name = ujNev,
                            ParentId = null
                        };

                        ctx.Categories.Add(ujKategoria);
                        ctx.SaveChanges();
                    }
                    else
                    {
                        var katid = ctx.Categories
                            .FirstOrDefault(x => x.Name == fokategoriak.SelectedItem.ToString());

                        var ujKategoria = new Category
                        {
                            Id = id,
                            Name = ujNev,
                            ParentId = katid.Id
                        };

                        ctx.Categories.Add(ujKategoria);
                        ctx.SaveChanges();
                    }
                }

                nevBox.Text = "";
                fokategoriak.SelectedIndex = 0;
            }

            listviewfel();
            combofel();
            joe();
        }

        private void del_Click(object sender, RoutedEventArgs e)
        {
            using (var ctx = new Context())
            {
                var torol = ctx.Categories.FirstOrDefault(x => x.Name == nevBox.Text);

                var tkapcsolodoRekordok = ctx.Products.Where(p => p.CategoryId == torol.Id).ToList();

                foreach (var item in tkapcsolodoRekordok)
                {
                    var fkapcsolodoRekordok = ctx.Favorites.Where(f => f.ProductId == item.Id);
                    ctx.Favorites.RemoveRange(fkapcsolodoRekordok);

                    var ckapcsolodoRekordok = ctx.CartItems.Where(c => c.ProductId == item.Id);
                    ctx.CartItems.RemoveRange(ckapcsolodoRekordok);

                    var okapcsolodoRekordok = ctx.OrderItems.Where(o => o.ProductId == item.Id);
                    ctx.OrderItems.RemoveRange(okapcsolodoRekordok);

                    var pkapcsolodoRekordok = ctx.ProductReviews.Where(p => p.ProductId == item.Id);
                    ctx.ProductReviews.RemoveRange(pkapcsolodoRekordok);
                }
                    
                ctx.Products.RemoveRange(tkapcsolodoRekordok);

                ctx.Categories.Remove(torol);
                ctx.SaveChanges();
                nevBox.Text = "";
                fokategoriak.SelectedIndex = 0;

                MessageBox.Show("Kategória sikeresen törölve!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
            }

            listView.Items.Clear();
            listviewfel();
            combofel();

        }

        private void listView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (listView.SelectedIndex == -1)
            {
               
                add.IsEnabled = true;
                del.IsEnabled = false;
                mod.IsEnabled = false;
                nevBox.Text = "";
                fokategoriak.SelectedIndex = 0;
            }
            else
            {
                add.IsEnabled = false;
                del.IsEnabled = true;
                mod.IsEnabled = true;
                select.IsEnabled = true;
                if (listView.SelectedItem is Category item)
                {
                    using (var ctx = new Context())
                    {
                        var res = ctx.Categories.Where(x => x.Name == item.Name).FirstOrDefault();

                        var katnev = ctx.Categories.Where(x => x.Id == item.ParentId).FirstOrDefault();

                        nevBox.Text = res.Name;

                        if (res.ParentId==null)
                        {
                            fokategoriak.SelectedIndex = 0;
                        }
                        else
                        {
                            fokategoriak.SelectedItem = katnev.Name;
                        }
                    }
                }
            }
            joe();
        }
        private void joe()
        {
            bool hasSelection = listView.SelectedIndex != -1;
            bool hasText = !string.IsNullOrWhiteSpace(nevBox.Text);
            bool hasParentSelected = fokategoriak.SelectedIndex != -1;

            bool isModified = false;

            if (hasSelection && listView.SelectedItem is Category selectedItem)
            {
                using (var ctx = new Context())
                {
                    var original = ctx.Categories.FirstOrDefault(x => x.Id == selectedItem.Id);

                    if (original != null)
                    {
                        string currentNev = nevBox.Text.Trim();
                        string originalNev = original.Name;
                        string currentParentNev = fokategoriak.SelectedItem?.ToString();
                        string originalParentNev = original.ParentId == null ? "Ez egy főkategória" : ctx.Categories.FirstOrDefault(x => x.Id == original.ParentId)?.Name;

                        if (currentNev != originalNev || currentParentNev != originalParentNev)
                        {
                            isModified = true;
                        }
                    }
                }
            }

            if (hasSelection)
            {
                select.IsEnabled = true;
                mod.IsEnabled = hasText && hasParentSelected;
                del.IsEnabled = !isModified;
            }
            else
            {
                add.IsEnabled = hasText && hasParentSelected;
                select.IsEnabled = false;
                mod.IsEnabled = false;
                del.IsEnabled = false;
            }
        }

        private void nevBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            joe();
        }

        private void fokategoriak_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            joe();
        }
    }
}