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
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.IO;

namespace kezelofelulet
{
    /// <summary>
    /// Interaction logic for termekek.xaml
    /// </summary>
    /// 
    public partial class termekek : Window
    {
        private char[] tiltottKarakterek = { '"', '\'', '_', ':', ';', '?', '!', '*', '/', '.', '+', '\\', '<', '>', '#', '|', ',', '–', '—', ' ' };
        private string imageSaveDirectory = null;
        private Dictionary<string, string> tempAttrib = new Dictionary<string, string>();
        private Dictionary<string, int> kategoriak = new Dictionary<string, int>();

        public void combofel()
        {
            kategoria.Items.Clear();
            kategoriak.Clear();

            using (var ctx = new Context())
            {
                var parentIds = ctx.Categories
                                   .Where(c => c.ParentId != null)
                                   .Select(c => c.ParentId)
                                   .Distinct()
                                   .ToList();

                var leafCategories = ctx.Categories
                                        .Where(c => c.ParentId != null && !parentIds.Contains(c.Id))
                                        .ToList();

                foreach (var item in leafCategories)
                {
                    kategoria.Items.Add(item.Name);
                    kategoriak[item.Name] = item.Id;
                }
            }
        }

        private string SzurNevet(string nev)
        {
            nev = nev.Replace("–", "-").Replace("—", "-");

            foreach (char c in tiltottKarakterek)
            {
                if (c != ' ')
                {
                    nev = nev.Replace(c.ToString(), "");
                }
                else if (c == '–' || c == '—')
                {
                    nev = nev.Replace(c.ToString(), "-");
                }
                else
                {
                    nev = nev.Replace(c.ToString(), "-");
                }
            }

            return nev;
        }

        public void listviewfel()
        {
            listView.Items.Clear();
            using (var ctx = new Context())
            {
                var items = ctx.Products;
                foreach (var item in items)
                {
                    listView.Items.Add(new Product(item.Id, item.Name, item.Description, Convert.ToInt32(item.Price), item.CategoryId, Convert.ToInt32(item.StockQuantity), item.ImageUrl));
                }
            }
        }

        public termekek()
        {
            InitializeComponent();

            if (File.Exists("imagesavepath.txt"))
            {
                string savedPath = File.ReadAllText("imagesavepath.txt");
                if (Directory.Exists(savedPath))
                {
                    imageSaveDirectory = savedPath;
                    mappa.Text = $"Aktuális képmentési hely: {imageSaveDirectory}";
                }
                else
                {
                    imageSaveDirectory = null;
                    mappa.Text = "Aktuális képmentési hely: -";
                }
            }
            else
            {
                imageSaveDirectory = null;
                mappa.Text = "Aktuális képmentési hely: -";
            }
            listviewfel();
            combofel();
            select.IsEnabled = false;
        }
        private void button_Click(object sender, RoutedEventArgs e)
        {
            MainWindow ujablak = new MainWindow();
            ujablak.Show();
            this.Close();
        }

        private void listView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (imageSaveDirectory == null)
            {
                listView.SelectedIndex = -1;
                if (listView.SelectedIndex == -1)
                {
                    MessageBox.Show("Először válasszd ki a képek mentési helyét!", "Figyelmeztetés", MessageBoxButton.OK, MessageBoxImage.Warning);
                }
                return;
            }

            if (listView.SelectedIndex == -1)
            {
                nevBox.Text = "";
                leirasBox.Text = "";
                arBox.Text = "";
                kategoria.SelectedIndex = -1;
                dbBox.Text = "";
                del.IsEnabled = false;
                mod.IsEnabled = false;
                select.IsEnabled = false;
                addimage.IsEnabled = false;
                attribLista.Items.Clear();
                tempAttrib.Clear();
            }
            else
            {
                add.IsEnabled = false;
                del.IsEnabled = true;
                mod.IsEnabled = true;
                addimage.IsEnabled = true;

                if (listView.SelectedItem is Product item)
                {
                    using (var ctx = new Context())
                    {
                        var res = ctx.Products.FirstOrDefault(x => x.Name == item.Name);

                        nevBox.Text = res.Name;
                        leirasBox.Text = res.Description;
                        arBox.Text = res.Price.ToString();

                        string kategoriaNev = kategoriak.FirstOrDefault(x => x.Value == res.CategoryId).Key;
                        if (!string.IsNullOrEmpty(kategoriaNev))
                        {
                            kategoria.SelectedItem = kategoriaNev;
                        }
                        else
                        {
                            kategoria.SelectedIndex = -1;
                        }

                        dbBox.Text = res.StockQuantity.ToString();
                        select.IsEnabled = true;
                        attribLista.Items.Clear();
                        tempAttrib.Clear();

                        string imagePath = SearchImagePath(res.Name);

                        if (!string.IsNullOrEmpty(imageSaveDirectory) && imagePath != null)
                        {
                            BitmapImage bitmap = new BitmapImage();
                            using (FileStream stream = new FileStream(imagePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                            {
                                bitmap.BeginInit();
                                bitmap.CacheOption = BitmapCacheOption.OnLoad;
                                bitmap.StreamSource = stream;
                                bitmap.EndInit();
                            }
                            productimage.Source = bitmap;
                            noimage.Text = "";
                        }
                        else if (string.IsNullOrEmpty(imageSaveDirectory))
                        {
                            productimage.Source = null;
                            noimage.Text = "Nincs beállítva mentési mappa.";
                        }
                        else
                        {
                            productimage.Source = null;
                            noimage.Text = "Nincsen kép rendelve a termékhez!";
                        }

                        if (!string.IsNullOrEmpty(res.Attributes))
                        {
                            try
                            {
                                var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(res.Attributes);
                                foreach (var kv in dict)
                                {
                                    tempAttrib[kv.Key] = kv.Value;
                                    attribLista.Items.Add($"{kv.Key}: {kv.Value}");
                                }
                            }
                            catch
                            {
                                
                            }
                        }
                    }
                }
            }
        }

        private void add_Click(object sender, RoutedEventArgs e)
        {
            using (var ctx = new Context())
            {
                bool nevLetezik = ctx.Products.Any(x => x.Name == nevBox.Text.Trim());
                if (nevLetezik)
                {
                    MessageBox.Show("Ez a terméknév már létezik!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (!int.TryParse(arBox.Text, out int price) || price < 0)
                {
                    MessageBox.Show("Hibás vagy negatív ár!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (!int.TryParse(dbBox.Text, out int stockQuantity) || stockQuantity < 0)
                {
                    MessageBox.Show("Hibás vagy negatív darabszám!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (tempAttrib.Count == 0)
                {
                    MessageBox.Show("Legalább egy attribútumot meg kell adni!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                string imagePath = SearchImagePath(nevBox.Text);
                if (imagePath == null)
                {
                    MessageBox.Show("Nincs kép rendelve a termékhez!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                string fileName = Path.GetFileName(imagePath);
                string relativePath = "resources/products/" + fileName;

                var ujTermek = new Product
                {
                    Name = nevBox.Text.Replace("—", "-").Replace("–", "-"),
                    Description = leirasBox.Text,
                    Price = price,
                    CategoryId = kategoriak[kategoria.SelectedItem.ToString()],
                    StockQuantity = stockQuantity,
                    ImageUrl = relativePath,
                    Attributes = JsonConvert.SerializeObject(tempAttrib)
                };

                ctx.Products.Add(ujTermek);
                ctx.SaveChanges();
            }

            nevBox.Text = "";
            leirasBox.Text = "";
            arBox.Text = "";
            kategoria.SelectedIndex = -1;
            dbBox.Text = "";
            productimage.Source = null;
            attribLista.Items.Clear();
            MessageBox.Show("Termék sikeresen hozzáadva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
            listviewfel();
        }

        private void mod_Click(object sender, RoutedEventArgs e)
        {
            if (listView.SelectedItem is Product item)
            {
                using (var ctx = new Context())
                {
                    var termek = ctx.Products.FirstOrDefault(x => x.Id == item.Id);

                    if (termek != null)
                    {
                        string ujNev = nevBox.Text.Trim();

                        bool nevLetezik = ctx.Products.Any(x => x.Name == ujNev && x.Id != item.Id);
                        if (nevLetezik)
                        {
                            MessageBox.Show("Ez a terméknév már létezik!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                            return;
                        }

                        termek.Name = ujNev;
                        termek.Description = leirasBox.Text;

                        if (!int.TryParse(arBox.Text, out int price))
                        {
                            MessageBox.Show("Hibás ár érték!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                            return;
                        }
                        if (price < 0)
                        {
                            MessageBox.Show("Az ár nem lehet negatív!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                            return;
                        }

                        if (!int.TryParse(dbBox.Text, out int stockQuantity))
                        {
                            MessageBox.Show("Hibás darabszám érték!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                            return;
                        }
                        if (stockQuantity < 0)
                        {
                            MessageBox.Show("A darabszám nem lehet negatív!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                            return;
                        }

                        termek.Price = price;
                        termek.StockQuantity = stockQuantity;
                        termek.CategoryId = kategoriak[kategoria.SelectedItem.ToString()];
                        termek.Attributes = JsonConvert.SerializeObject(tempAttrib);

                        string imagePath = SearchImagePath(termek.Name);

                        if (imagePath != null)
                        {
                            string extension = Path.GetExtension(imagePath);
                            string baseName = SzurNevet(termek.Name).ToLower() + "-bmashop";
                            termek.ImageUrl = "resources/products/" + baseName + extension;
                        }

                        ctx.SaveChanges();
                        MessageBox.Show("Termék sikeresen módosítva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                    }
                    else
                    {
                        MessageBox.Show("Nem található a kiválasztott termék!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }

                listviewfel();
                productimage.Source = null;
                noimage.Text = "";
            }
            else
            {
                MessageBox.Show("Nincs kiválasztva termék!", "Figyelmeztetés", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        private void del_Click(object sender, RoutedEventArgs e)
        {
            using (var ctx = new Context())
            {
                var torol = ctx.Products
                               .FirstOrDefault(x => x.Name == nevBox.Text);

                if (torol != null)
                {
                    var fkapcsolodoRekordok = ctx.Favorites.Where(f => f.ProductId == torol.Id);
                    ctx.Favorites.RemoveRange(fkapcsolodoRekordok);

                    var ckapcsolodoRekordok = ctx.CartItems.Where(c => c.ProductId == torol.Id);
                    ctx.CartItems.RemoveRange(ckapcsolodoRekordok);

                    var okapcsolodoRekordok = ctx.OrderItems.Where(o => o.ProductId == torol.Id);
                    ctx.OrderItems.RemoveRange(okapcsolodoRekordok);

                    var pkapcsolodoRekordok = ctx.ProductReviews.Where(p => p.ProductId == torol.Id);
                    ctx.ProductReviews.RemoveRange(pkapcsolodoRekordok);

                    ctx.Products.Remove(torol);
                    ctx.SaveChanges();

                    MessageBox.Show("Termék sikeresen törölve!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                {
                    MessageBox.Show("A termék nem található!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            listviewfel();
        }

        private void select_Click(object sender, RoutedEventArgs e)
        {
            listView.SelectedIndex = -1;
            add.IsEnabled = false;
            productimage.Source = null;
        }

        private void joe(object sender, TextChangedEventArgs e)
        {
            bool hasSelection = listView.SelectedIndex != -1;
            bool hasRequiredFields = !string.IsNullOrWhiteSpace(nevBox.Text) && !string.IsNullOrWhiteSpace(leirasBox.Text) && !string.IsNullOrWhiteSpace(arBox.Text) && kategoria.SelectedIndex != -1 && !string.IsNullOrWhiteSpace(dbBox.Text);

            bool isModified = false;

            if (hasSelection && listView.SelectedItem is Product selectedItem)
            {
                using (var ctx = new Context())
                {
                    var original = ctx.Products.FirstOrDefault(x => x.Id == selectedItem.Id);

                    if (original != null)
                    {
                        string currentName = nevBox.Text.Trim();
                        string currentDesc = leirasBox.Text.Trim();
                        string currentPrice = arBox.Text.Trim();
                        string currentDb = dbBox.Text.Trim();
                        string currentCategory = kategoria.SelectedItem?.ToString();
                        string originalCategory = kategoriak.FirstOrDefault(x => x.Value == original.CategoryId).Key;

                        if (currentName != original.Name ||
                            currentDesc != original.Description ||
                            currentPrice != original.Price.ToString() ||
                            currentDb != original.StockQuantity.ToString() ||
                            currentCategory != originalCategory)
                        {
                            isModified = true;
                        }
                    }
                }
            }

            add.IsEnabled = !hasSelection && hasRequiredFields;
            mod.IsEnabled = hasSelection && hasRequiredFields;
            select.IsEnabled = hasSelection && imageSaveDirectory != null;
            del.IsEnabled = hasSelection && !isModified;

            if (tempAttrib.Count == 0 || SearchImagePath(nevBox.Text) == null)
            {
                add.IsEnabled = false;
            }
        }


        private void attribLista_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (attribLista.SelectedIndex != -1)
            {
                attrdel.IsEnabled = true;
                attrselect.IsEnabled = true;
                attrmod.IsEnabled = true;
                attradd.IsEnabled = false;
                string selected = attribLista.SelectedItem.ToString();
                var split = selected.Split(':');

                if (split.Length >= 2)
                {
                    tulNevBox.Text = split[0].Trim();
                    tulErtBox.Text = string.Join(":", split.Skip(1)).Trim();
                }
            }
            else
            {
                tulNevBox.Clear();
                tulErtBox.Clear();
                attrjoe(null, null);
            }
        }
        private void addAttribute_Click(object sender, RoutedEventArgs e)
        {
            string key = tulNevBox.Text.Trim();
            string value = tulErtBox.Text.Trim();

            if (!string.IsNullOrWhiteSpace(key) && !string.IsNullOrWhiteSpace(value))
            {
                tempAttrib[key] = value;
                attribLista.Items.Add($"{key}: {value}");
                tulNevBox.Clear();
                tulErtBox.Clear();
            }
            attrjoe(null, null);
        }
        private void removeAttribute_Click(object sender, RoutedEventArgs e)
        {
            if (attribLista.SelectedItem != null)
            {
                string selected = attribLista.SelectedItem.ToString();
                string key = selected.Split(':')[0].Trim();
                tempAttrib.Remove(key);
                attribLista.Items.Remove(selected);
            }
            attrjoe(null, null);
        }

        private void saveAttribute_Click(object sender, RoutedEventArgs e)
        {
            string key = tulNevBox.Text.Trim();
            string value = tulErtBox.Text.Trim();

            if (!string.IsNullOrWhiteSpace(key) && !string.IsNullOrWhiteSpace(value))
            {
                tempAttrib[key] = value;

                var itemsToRemove = attribLista.Items
                    .Cast<string>()
                    .Where(item => item.Split(':')[0].Trim() == key)
                    .ToList();

                foreach (var item in itemsToRemove)
                {
                    attribLista.Items.Remove(item);
                }

                attribLista.Items.Add($"{key}: {value}");

                tulNevBox.Clear();
                tulErtBox.Clear();
            }
        }

        private void removeAttributeSelection_Click(object sender, RoutedEventArgs e)
        {
            attribLista.SelectedIndex = -1;
            attradd.IsEnabled = false;
        }
        private void attrjoe(object sender, TextChangedEventArgs e)
        {
            if (attribLista.SelectedIndex == -1 && tulErtBox.Text != "" && tulNevBox.Text != "" )
            {
                attradd.IsEnabled = true;
                attrmod.IsEnabled = false;
                attrdel.IsEnabled = false;
                attrselect.IsEnabled = false;
            }
            else
            {
                if (attribLista.SelectedIndex != -1 && tulErtBox.Text != "" && tulNevBox.Text != "")
                {
                    attradd.IsEnabled = false;
                    attrmod.IsEnabled = true;
                    attrdel.IsEnabled = true;
                    attrselect.IsEnabled = true;
                }
                else
                {
                    attradd.IsEnabled = false;
                    attrmod.IsEnabled = false;
                    attrdel.IsEnabled = false;
                    attrselect.IsEnabled = false;
                }
            }
        }
        private void UploadImage_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrEmpty(imageSaveDirectory) || !Directory.Exists(imageSaveDirectory))
            {
                MessageBox.Show("Nincs kiválasztva képek mentési mappa, ezért nem tölthető fel kép!", "Figyelmeztetés", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var openFileDialog = new Microsoft.Win32.OpenFileDialog
            {
                Filter = "Képek (*.png;*.jpg;*.jpeg)|*.png;*.jpg;*.jpeg"
            };

            if (openFileDialog.ShowDialog() == true)
            {
                string selectedPath = openFileDialog.FileName;

                string extension = Path.GetExtension(selectedPath).ToLower();
                string customFileName = SzurNevet(nevBox.Text).ToLower() + "-bmashop" + extension;

                string targetPath = Path.Combine(imageSaveDirectory, customFileName);

                try
                {
                    File.Copy(selectedPath, targetPath, overwrite: true);

                    BitmapImage bitmap = new BitmapImage();
                    using (FileStream stream = new FileStream(targetPath, FileMode.Open, FileAccess.Read))
                    {
                        bitmap.BeginInit();
                        bitmap.CacheOption = BitmapCacheOption.OnLoad;
                        bitmap.StreamSource = stream;
                        bitmap.EndInit();
                    }

                    productimage.Source = bitmap;
                    noimage.Text = "";
                    joe(null, null);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Hiba történt a kép feltöltésekor: " + ex.Message, "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void ChooseImageFolder_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new System.Windows.Forms.FolderBrowserDialog();

            if (dialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                imageSaveDirectory = dialog.SelectedPath;
                File.WriteAllText("imagesavepath.txt", imageSaveDirectory);
                MessageBox.Show("Képek mentési mappája beállítva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                mappa.Text = $"Aktuális képmentési hely: {imageSaveDirectory}";
            }
        }

        private string SearchImagePath(string name)
        {
            string baseName = SzurNevet(name).ToLower() + "-bmashop";
            string[] extensions = { ".png", ".jpg", ".jpeg" };

            return extensions
                .Select(ext => Path.Combine(imageSaveDirectory, baseName + ext))
                .FirstOrDefault(File.Exists);
        }

        private void kategoria_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            joe(null, null);
        }
    }
}