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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace kezelofelulet
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            rendelesek ujablak = new rendelesek();
            ujablak.Show();
            this.Close();
        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            termekek ujablak = new termekek();
            ujablak.Show();
            this.Close();
        }

        private void button2_Click(object sender, RoutedEventArgs e)
        {
            kategoriak ujablak = new kategoriak();
            ujablak.Show();
            this.Close();
        }
    }
}