-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 27, 2025 at 11:51 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bmashop`
--
DROP DATABASE IF EXISTS bmashop;
CREATE DATABASE bmashop
CHARSET utf8 COLLATE utf8_hungarian_ci;
USE bmashop;

-- --------------------------------------------------------

--
-- Table structure for table `cartitems`
--

CREATE TABLE `cartitems` (
  `UserId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL DEFAULT 1 CHECK (`Quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `cartitems`
--

INSERT INTO `cartitems` (`UserId`, `ProductId`, `Quantity`) VALUES
(3, 3, 1),
(3, 23, 1),
(3, 47, 2),
(3, 65, 1),
(3, 163, 1),
(3, 202, 1),
(3, 209, 1),
(3, 234, 3);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `Id` int(11) NOT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `Name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`Id`, `ParentId`, `Name`) VALUES
(1, NULL, 'Horgászbotok'),
(2, NULL, 'Műcsalik'),
(3, NULL, 'Orsók'),
(4, NULL, 'Csalik'),
(5, NULL, 'Zsinórok'),
(6, NULL, 'Kiegészítők'),
(7, NULL, 'Horgok'),
(8, 1, 'Feeder botok'),
(9, 1, 'Bojlis botok'),
(10, 1, 'Harcsázó botok'),
(11, 1, 'Match botok'),
(12, 2, 'Gumihal'),
(13, 2, 'Wobbler'),
(14, 2, 'Vertikális csalik, penge csalik'),
(15, 3, 'Elsőfékes feeder orsó, match orsó'),
(16, 3, 'Hátsófékes orsó'),
(17, 3, 'Elsőfékes pergető orsó'),
(18, 3, 'Nyeletőfékes orsó'),
(19, 4, 'Bojlik'),
(20, 4, 'Etetőanyag'),
(21, 4, 'Horgász magvak, magmixek'),
(22, 5, 'Dobóelőke'),
(23, 5, 'Fluorocarbon zsinór'),
(24, 5, 'Monofil zsinór'),
(25, 6, 'Ernyő, sátor'),
(26, 6, 'Szék, asztal'),
(27, 6, 'Bottartó'),
(28, 6, 'Halradar'),
(29, 6, 'Horgász Lámpák'),
(30, 6, 'Horgász dobozok'),
(31, 6, 'Kapásjelző'),
(32, 7, 'Bojlis horog'),
(33, 7, 'Rablóhalas horog'),
(34, 7, 'Feeder horog, verseny horog');

-- --------------------------------------------------------

--
-- Table structure for table `commentlikes`
--

CREATE TABLE `commentlikes` (
  `UserId` int(11) NOT NULL,
  `CommentId` int(11) NOT NULL,
  `LikeType` enum('Like','DisLike') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `commentlikes`
--

INSERT INTO `commentlikes` (`UserId`, `CommentId`, `LikeType`) VALUES
(2, 1, 'Like'),
(2, 2, 'Like'),
(2, 3, 'Like'),
(2, 4, 'Like'),
(2, 5, 'Like'),
(2, 6, 'Like'),
(2, 7, 'Like'),
(2, 8, 'Like'),
(2, 9, 'Like'),
(2, 10, 'Like'),
(2, 11, 'DisLike'),
(2, 12, 'DisLike'),
(2, 13, 'DisLike'),
(2, 14, 'DisLike'),
(2, 15, 'DisLike'),
(3, 1, 'Like'),
(3, 2, 'Like'),
(3, 3, 'Like'),
(3, 4, 'Like'),
(3, 5, 'Like'),
(3, 6, 'Like'),
(3, 7, 'Like'),
(3, 8, 'Like'),
(3, 9, 'Like'),
(3, 10, 'Like'),
(5, 1, 'Like'),
(5, 2, 'Like'),
(5, 3, 'Like'),
(5, 4, 'Like'),
(5, 5, 'DisLike'),
(5, 6, 'Like'),
(5, 7, 'Like'),
(5, 8, 'Like'),
(5, 9, 'Like'),
(5, 10, 'Like'),
(5, 11, 'DisLike'),
(5, 12, 'DisLike'),
(5, 13, 'DisLike'),
(5, 14, 'DisLike'),
(5, 15, 'DisLike'),
(7, 1, 'DisLike'),
(7, 2, 'DisLike'),
(7, 3, 'DisLike'),
(7, 4, 'DisLike'),
(7, 5, 'DisLike'),
(7, 6, 'DisLike'),
(7, 7, 'DisLike'),
(7, 8, 'DisLike'),
(7, 9, 'DisLike'),
(7, 10, 'DisLike'),
(7, 11, 'Like'),
(7, 12, 'Like'),
(7, 13, 'Like'),
(7, 14, 'Like'),
(7, 15, 'Like'),
(8, 1, 'Like'),
(8, 2, 'Like'),
(8, 3, 'Like'),
(8, 4, 'Like'),
(8, 5, 'Like'),
(8, 6, 'Like'),
(8, 7, 'DisLike'),
(8, 9, 'Like'),
(8, 10, 'Like'),
(8, 11, 'DisLike'),
(8, 12, 'DisLike'),
(8, 13, 'DisLike'),
(8, 14, 'Like'),
(8, 15, 'Like');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `Id` int(11) NOT NULL,
  `PostId` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `Content` text NOT NULL,
  `CreatedAt` varchar(19) DEFAULT date_format(current_timestamp(),'%Y-%m-%d %H:%i:%s'),
  `Likes` int(11) DEFAULT 0,
  `DisLikes` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`Id`, `PostId`, `UserId`, `Content`, `CreatedAt`, `Likes`, `DisLikes`) VALUES
(1, 59, 5, 'Gratulálok, gyönyörű hal! Igazi vad ponty, szép fogás!', '2025-04-26 18:22:46', 4, 1),
(2, 47, 5, 'Éjszakai peca legjobb része, amikor ilyen szépség szakad meg! Gratula a tükröshöz!', '2025-04-26 18:24:32', 4, 1),
(3, 1, 5, 'Nagyon szép nyurga! Gratulálok a fogáshoz, gyönyörű példány!', '2025-04-26 18:24:50', 4, 1),
(4, 63, 5, 'Ez a leírás teljesen visszaadja a hely varázsát! Minden horgász álma egy ilyen tópart!', '2025-04-26 18:25:52', 4, 1),
(5, 21, 5, 'Milyen idilli kép! A természet és a horgászat tökéletes harmóniában.', '2025-04-26 18:26:12', 3, 2),
(6, 63, 2, 'Gyönyörű környezet, itt tényleg nem csak a halak miatt érdemes horgászni! Nyugalom szigete.', '2025-04-26 18:27:09', 4, 1),
(7, 59, 2, '16 kg? Húha, szép munka! Látszik, hogy jó helyet választottál a nádasnál.', '2025-04-26 18:27:38', 3, 2),
(8, 47, 2, 'Szép éjjeli fogás, remek példány!', '2025-04-26 18:28:16', 3, 1),
(9, 21, 3, 'Az ilyen helyekért érdemes hajnalban kelni! Csodás nyugalom árad a képből!', '2025-04-26 18:29:08', 4, 1),
(10, 1, 3, 'Ez aztán a sportos nyurga! Látszik, hogy erős és egészséges hal volt!', '2025-04-26 18:29:36', 4, 1),
(11, 59, 7, 'Ezt a helyi halastóból is foghattad volna, semmi különös...', '2025-04-26 18:31:46', 1, 3),
(12, 47, 7, '10 kiló? Hát nem egy rekord, ilyenekből Dunát lehet rekeszteni…', '2025-04-26 18:32:52', 1, 3),
(13, 1, 7, '10 kiló alatti halat manapság már inkább visszaengednek fotó nélkül...', '2025-04-26 18:33:16', 1, 3),
(14, 63, 7, 'Még jó, hogy a táj szép, mert a halfogásra úgy tűnik, nem lehet számítani...', '2025-04-26 18:33:30', 2, 2),
(15, 21, 7, 'Kár, hogy több a hattyú, mint a kapás... inkább állatkertet néznék...', '2025-04-26 18:37:25', 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `UserId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`UserId`, `ProductId`) VALUES
(2, 36),
(2, 84),
(2, 189),
(2, 197),
(2, 213),
(3, 1),
(3, 4),
(3, 8),
(3, 113),
(3, 163),
(3, 170),
(3, 204),
(3, 234);

-- --------------------------------------------------------

--
-- Table structure for table `orderitems`
--

CREATE TABLE `orderitems` (
  `OrderId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL CHECK (`Quantity` > 0),
  `Price` int(11) NOT NULL CHECK (`Price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `orderitems`
--

INSERT INTO `orderitems` (`OrderId`, `ProductId`, `Quantity`, `Price`) VALUES
(1, 2, 1, 99390),
(1, 13, 1, 27990),
(1, 29, 1, 174990),
(1, 97, 3, 1690),
(1, 98, 3, 1690),
(1, 189, 1, 3990),
(1, 204, 2, 390);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `Id` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `FullName` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL CHECK (`Email` regexp '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'),
  `OrderStatus` enum('Függőben','Teljesítve','Törölve','Feldolgozás alatt') DEFAULT 'Függőben',
  `AddressLine` varchar(255) NOT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `OrderDate` varchar(19) DEFAULT date_format(current_timestamp(),'%Y-%m-%d %H:%i:%s'),
  `TotalAmount` int(11) NOT NULL CHECK (`TotalAmount` >= 0),
  `PaymentStatus` enum('Függőben','Fizetve','Sikertelen','Visszatérítve') DEFAULT 'Függőben',
  `PayPalTransactionId` varchar(255) DEFAULT NULL,
  `PaymentDate` varchar(19) DEFAULT date_format(current_timestamp(),'%Y-%m-%d %H:%i:%s')
) ;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`Id`, `UserId`, `FullName`, `Email`, `OrderStatus`, `AddressLine`, `PhoneNumber`, `OrderDate`, `TotalAmount`, `PaymentStatus`, `PayPalTransactionId`, `PaymentDate`) VALUES
(1, 2, 'Szandi Viktória', 'szandi7@gmail.com', 'Függőben', 'HU, 9600 Sárvár, Kazinczy Ferenc 11', '+36301234567', '2025-04-26 18:52:37', 317280, 'Fizetve', '3G666999NC902824R', '2025-04-26 18:52:37');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `Id` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `Category` enum('Fogások','Tippek','Horgászhelyek') NOT NULL,
  `Content` text NOT NULL,
  `ImageUrl` varchar(255) DEFAULT NULL,
  `CreatedAt` varchar(19) DEFAULT date_format(current_timestamp(),'%Y-%m-%d %H:%i:%s')
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`Id`, `UserId`, `Category`, `Content`, `ImageUrl`, `CreatedAt`) VALUES
(1, 2, 'Fogások', '9.2kg-os nyurga ponty a Farkincás tavon.', 'resources/community/image_001.jpg', '2025-04-06 10:59:24'),
(2, 2, 'Fogások', '8.6kg-os ponty a Farkincás tavon.', 'resources/community/image_002.jpg', '2025-02-28 12:59:22'),
(3, 2, 'Fogások', '9.4kg-os ponty a Farkincás tavon.', 'resources/community/image_003.jpg', '2025-03-22 01:09:27'),
(4, 2, 'Fogások', '10.2kg-os ponty a Farkincás tavon.', 'resources/community/image_004.jpg', '2025-03-29 03:00:15'),
(5, 2, 'Fogások', '10kg-os ponty a Farkincás tavon.', 'resources/community/image_005.jpg', '2025-02-20 12:02:10'),
(7, 2, 'Fogások', '11.3kg-os ponty a Farkincás tavon.', 'resources/community/image_006.jpg', '2025-03-30 18:34:41'),
(8, 2, 'Fogások', 'Csodaszép ponty a Farkincás tavon.', 'resources/community/image_007.jpg', '2025-04-05 10:28:32'),
(9, 2, 'Fogások', '17.3kg-os ponty az Ölbői horgásztavon.', 'resources/community/image_008.jpg', '2025-02-06 08:09:05'),
(10, 2, 'Fogások', '18.17kg-os ponty az Ölbői horgásztavon.', 'resources/community/image_009.jpg', '2025-03-31 21:07:17'),
(11, 2, 'Fogások', '18.17kg-os pontyom a Püspökmolnári tavon.', 'resources/community/image_010.jpg', '2025-03-03 06:05:37'),
(12, 2, 'Fogások', '36 órás túránk legnagyobb hala, ami egyben az új egyéni rekordom is. A párom által készített scopex bojlira érkezett ez a 19,65 kg-os gyönyörűség.', 'resources/community/image_011.jpg', '2025-02-23 13:21:31'),
(13, 2, 'Fogások', 'Imádok pecázni. Miután bedobod a botot, nem tudod, mi van a másik végén. A saját fantáziád van a vízfelszín alatt. 5kg-os ponty a Farkincás tavon.', 'resources/community/image_012.jpg', '2025-02-27 10:34:03'),
(14, 2, 'Fogások', '17kg-os ponty a Farkincás tavon.', 'resources/community/image_013.jpg', '2025-03-04 14:42:14'),
(15, 2, 'Fogások', '19kg-os tükrös ponty a Farkincás tavon.', 'resources/community/image_014.jpg', '2025-03-14 08:09:22'),
(16, 2, 'Fogások', 'Zalacsányi tavas túránk első hala egy 15,64 kg-os tükrös ponty.', 'resources/community/image_015.jpg', '2025-03-24 04:48:19'),
(17, 2, 'Fogások', 'Jónak ígérkezik ez a túra, sikerült megfognom életem első amurját is (11.2kg).', 'resources/community/image_016.jpg', '2025-04-01 06:38:34'),
(18, 2, 'Fogások', 'Sikerült megfognom életem első 20+ os pontyát is, 23.20 kg.', 'resources/community/image_017.jpg', '2025-03-24 08:27:24'),
(19, 2, 'Fogások', 'Túránk első nagyobb hala. Szerintetek mennyi a pontos súlya?', 'resources/community/image_018.jpg', '2025-03-24 20:45:01'),
(20, 2, 'Fogások', '13kg-os amur a Farkincás tavon.', 'resources/community/image_019.jpg', '2025-03-11 12:32:33'),
(21, 2, 'Horgászhelyek', 'Farkincás tó - ahol a nyugalom és a kapások kéz a kézben járnak. Gyönyörű környezet, tiszta víz, és ha szerencséd van, még egy hattyú is benéz!', 'resources/community/image_020.jpg', '2025-03-29 23:40:20'),
(22, 2, 'Horgászhelyek', 'Ölbői horgásztó - ha igazán komoly felszereléssel készülsz, itt van értelme! Hatalmas pontyok, rendezett stégek és nyugodt vízfelület várja a horgászokat. Tökéletes választás egy eredményes pecához!', 'resources/community/image_021.jpg', '2025-03-04 01:23:32'),
(23, 2, 'Horgászhelyek', 'Zalacsányi horgásztó - ha a horgászatot a nyugalommal és panorámával szeretnéd összekötni, ez a hely kihagyhatatlan! Erdőölelte part, tiszta víz és pazar környezet vár, ráadásul a nagytestű pontyok is otthon érzik itt magukat.', 'resources/community/image_022.jpg', '2025-03-02 02:11:01'),
(24, 2, 'Horgászhelyek', 'Zalacsányi horgásztó - a hajnali köd és a nap első sugarai különleges élményt adnak minden pecásnak. Itt nem csak a pontyok húznak nagyot, hanem a lelked is megpihen.', 'resources/community/image_023.jpg', '2025-02-25 01:45:33'),
(25, 2, 'Horgászhelyek', 'Bene-hegyi tó - a nyugalom szigete a hegyek ölelésében. Tökéletes választás, ha nemcsak a halakra, hanem a kikapcsolódásra is vágysz. Itt a kapás is jobban esik!', 'resources/community/image_024.heic', '2025-03-21 14:53:37'),
(26, 3, 'Fogások', '17kg-os nyári torpedó a Farkincás tavon.', 'resources/community/image_024.jpg', '2025-03-08 09:37:34'),
(27, 3, 'Fogások', '18kg-os szürke reggeli meglepetés!', 'resources/community/image_025.jpg', '2025-04-05 20:20:49'),
(28, 3, 'Fogások', '9kg-os mintás tükrös – minden pikkelye külön történet!', 'resources/community/image_026.jpg', '2025-02-23 00:03:41'),
(29, 3, 'Fogások', '16kg-os klasszikus pikkelyes, igazi gyönyörűség!', 'resources/community/image_027.jpg', '2025-02-10 12:17:59'),
(30, 3, 'Fogások', '17kg-os tükrös a naplementében! Erőteljes, vastag hátú harcos - ponty, amilyenről álmodsz.', 'resources/community/image_028.jpg', '2025-03-17 00:02:13'),
(31, 3, 'Fogások', '10kg-os pikkelyes a sűrűből!', 'resources/community/image_029.jpg', '2025-02-01 04:18:04'),
(32, 3, 'Fogások', '15kg-os éjjeli kapás a nádasból!', 'resources/community/image_030.jpg', '2025-03-09 04:46:50'),
(33, 3, 'Fogások', '13kg-os pikkelyes egy szélcsendes, nyugodt napon!', 'resources/community/image_031.jpg', '2025-02-18 09:16:43'),
(34, 3, 'Fogások', '14kg-os fénylő tükrös a parton!', 'resources/community/image_032.jpg', '2025-03-09 12:55:45'),
(35, 3, 'Fogások', '19kg-os éjjeli tank a parton!', 'resources/community/image_033.jpg', '2025-02-03 06:40:08'),
(36, 3, 'Fogások', '13.7kg-os nyurga amur a zöldből!', 'resources/community/image_034.jpg', '2025-02-22 05:34:25'),
(37, 3, 'Fogások', 'asd12kg-os boldogság a stégről az Ölbői horgásztavon.', 'resources/community/image_035.jpg', '2025-03-16 02:37:31'),
(38, 3, 'Fogások', '19kg-os napfényharcos a szákban a Zalacsányi horgásztavon.', 'resources/community/image_036.jpg', '2025-02-19 10:18:41'),
(39, 3, 'Fogások', '14kg-os tükrös egy varázslatos reggelen a Zalacsányi horgásztavon.', 'resources/community/image_037.jpg', '2025-03-20 16:37:30'),
(40, 3, 'Fogások', '21kg-os éjjeli óriás tükrös a matracon!', 'resources/community/image_038.jpg', '2025-03-25 19:41:33'),
(41, 3, 'Fogások', '22kg-os brutál pikkelyes a Farkincás tavon!', 'resources/community/image_039.jpg', '2025-02-21 02:36:13'),
(42, 3, 'Fogások', '20kg-os tükrös az éjszaka leple alatt!', 'resources/community/image_040.jpg', '2025-02-10 17:09:00'),
(43, 3, 'Fogások', '18kg-os tükrös a korai órákból! Napfény, nyugalom és egy igazi bajnok.', 'resources/community/image_041.jpg', '2025-02-21 08:52:40'),
(44, 3, 'Fogások', '17kg-os aranyhal naplementében!', 'resources/community/image_042.jpg', '2025-03-30 03:08:30'),
(45, 3, 'Fogások', '16kg-os reggeli meglepetés a ködből!', 'resources/community/image_043.jpg', '2025-02-15 18:13:06'),
(46, 3, 'Fogások', '13kg-os tükrös a napsütésben!', 'resources/community/image_044.jpg', '2025-04-01 13:45:08'),
(47, 3, 'Fogások', '10kg-os tükrös az éjszaka csendjéből a Farkincás tavon.', 'resources/community/image_045.jpg', '2025-04-07 10:47:53'),
(48, 3, 'Fogások', '19kg-os tükrös a nap utolsó fényeiben!', 'resources/community/image_046.jpg', '2025-03-08 11:30:02'),
(49, 3, 'Fogások', '14kg-os aranygolyó az éjszakában!', 'resources/community/image_047.jpg', '2025-04-06 20:06:55'),
(50, 3, 'Fogások', '11kg-os amur a sűrűből!', 'resources/community/image_048.jpg', '2025-03-16 23:16:15'),
(51, 3, 'Fogások', '12kg-os különlegesség a partról! Nem csak szép, de emlékezetes fogás is a Farkincás tavon.', 'resources/community/image_049.jpg', '2025-03-07 22:10:45'),
(52, 3, 'Fogások', '21kg-os bivaly a Farkincás tavon.', 'resources/community/image_050.jpg', '2025-03-13 10:01:11'),
(53, 3, 'Fogások', '18kg-os tömör gyönyör a sűrűből!', 'resources/community/image_051.jpg', '2025-02-27 13:13:59'),
(54, 3, 'Fogások', '15kg-os éjjeli bajnok a nádasból!', 'resources/community/image_052.jpg', '2025-02-08 01:51:02'),
(55, 3, 'Fogások', '13kg-os klasszikus szépség a Farkincás tavon.', 'resources/community/image_053.jpg', '2025-02-01 03:02:38'),
(56, 3, 'Fogások', '18kg-os tiszta erő és szépség! Csodás ponty a Zalacsányi horgásztavon.', 'resources/community/image_054.jpg', '2025-03-16 02:56:40'),
(57, 3, 'Fogások', 'Éj leple alatt érkezett ez a 15.5kg-os amur harcos!', 'resources/community/image_055.jpg', '2025-03-12 17:08:30'),
(58, 3, 'Fogások', 'Éjjeli riasztás, 12kg-os tükrös ponty a Zalacsányi horgásztavon', 'resources/community/image_056.jpg', '2025-02-28 03:06:29'),
(59, 3, 'Fogások', 'Napsütés, nádas, és egy hibátlan ponty! 16kg-os ponty.', 'resources/community/image_057.jpg', '2025-04-08 13:51:48'),
(60, 3, 'Fogások', '17kg-os ponty a szákban!', 'resources/community/image_058.jpg', '2025-03-09 09:58:08'),
(61, 3, 'Fogások', '20kg-os ponty a Zalacsányi horgásztavon.', 'resources/community/image_059.jpg', '2025-02-14 09:53:38'),
(62, 3, 'Horgászhelyek', 'Farkincás tó - ahol a part menti nád susogása és a hajnal nyugalma együtt garantálják a tökéletes horgászatot! Akár etetőhajóval, akár hagyományos módszerrel, itt minden adott egy felejthetetlen pecához!', 'resources/community/image_060.jpg', '2025-02-28 23:32:03'),
(63, 3, 'Horgászhelyek', ' Zalacsányi Horgásztó - ha igazán nyugodt, természetközeli horgászatra vágysz! Az erdő ölelésében megbújó vízfelület és a csendes part garantálja, hogy minden kapás igazi élmény legyen. Ide nem csak a halak, de a lelked is visszavágyik!', 'resources/community/image_061.jpg', '2025-04-08 09:58:01'),
(64, 3, 'Horgászhelyek', 'Farkincás tó - ahol a peca és technika kéz a kézben jár! A nyugodt környezet, a gondosan elhelyezett botok és az etetőhajó garantálják, hogy ne csak a halak, de a horgászélmények is nagyok legyenek!', 'resources/community/image_062.jpg', '2025-02-05 20:54:34'),
(65, 3, 'Horgászhelyek', 'Zalacsányi horgásztó - ahol a reggelek nem csak szépek, de eredményesek is! Tiszta víz, friss levegő, és esély egy szép példányra minden dobásnál. Ha peca és feltöltődés is kell, Zalacsányban a helyed!', 'resources/community/image_063.jpg', '2025-03-06 13:24:16');

-- --------------------------------------------------------

--
-- Table structure for table `productreviews`
--

CREATE TABLE `productreviews` (
  `ProductId` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `Rating` int(11) NOT NULL CHECK (`Rating` between 1 and 5),
  `ReviewText` text DEFAULT NULL,
  `CreatedAt` varchar(19) DEFAULT date_format(current_timestamp(),'%Y-%m-%d %H:%i:%s')
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `Id` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  `Price` int(11) NOT NULL CHECK (`Price` >= 0),
  `CategoryId` int(11) DEFAULT NULL,
  `StockQuantity` int(11) DEFAULT 0 CHECK (`StockQuantity` >= 0),
  `ImageUrl` varchar(255) DEFAULT NULL,
  `Attributes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`Attributes`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`Id`, `Name`, `Description`, `Price`, `CategoryId`, `StockQuantity`, `ImageUrl`, `Attributes`) VALUES
(1, 'BY DÖME TEAM FEEDER GOLD SERIE 330UL 15-40GR', 'A család legrövidebb, legfinomabb tagja kifejezetten a rövid távú keszeg- és pontyhorgászatokhoz fejlesztve!', 82990, 8, 15, 'resources/products/by-döme-team-feeder-gold-serie-330ul-15-40gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-12 Power Carbon\",\"Gyűrűk anyaga\":\"titán-króm\",\"Gyűrűk száma\":\"14\",\"Nyélborítás\":\"Parafa+EVA\",\"Súly\":\"185 g\",\"Hossz\":\"3,3 méter\",\"Típus\":\"keszeg,ponty\"}'),
(2, 'BY DÖME TEAM FEEDER GOLD SERIE 390MH 40-80GR', 'A botcsalád finom pontyhorgászathoz fejlesztett tagja. Iszonyatosan jó method pálca közepes távolságokra!', 99390, 8, 18, 'resources/products/by-döme-team-feeder-gold-serie-390mh-40-80gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-12 Power Carbon\",\"Gyűrűk anyaga\":\"titán-króm\",\"Gyűrűk száma\":\"15\",\"Nyélborítás\":\"Parafa+EVA\",\"Súly\":\"220 g\",\"Hossz\":\"3,9 méter\",\"Típus\":\"ponty\"}'),
(3, 'BY DÖME TEAM FEEDER GOLD SERIE 420H 50-100GR', 'A botcsalád finom pontyhorgászathoz fejlesztett távdobó tagja. Iszonyatosan jó method pálca nagytávolságú horgászatokhoz!', 99990, 8, 10, 'resources/products/by-döme-team-feeder-gold-serie-420h-50-100gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-12 Power Carbon\",\"Gyűrűk anyaga\":\"titán-króm\",\"Gyűrűk száma\":\"16\",\"Nyélborítás\":\"Parafa+EVA\",\"Súly\":\"225 g\",\"Hossz\":\"32 méter\",\"Típus\":\"ponty\"}'),
(4, 'BY DÖME TEAM FEEDER POWER FIGHTER 360H 30-100GR', 'A leggyakrabban használt méret, amely négy különböző erősségi változatban kerül forgalomba. Ezek között található közepesen erős, erős, extra erős, valamint az extra-extra erős változat is. Maximális dobótávolság: 60-70 méter.', 27990, 8, 17, 'resources/products/by-döme-team-feeder-power-fighter-360h-30-100gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-8 Power Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"14\",\"Nyélborítás\":\"Eva+Parafa\",\"Súly\":\"275 g\",\"Hossz\":\"3,6 méter\",\"Típus\":\"ponty, kárász\"}'),
(5, 'BY DÖME TEAM FEEDER POWER FIGHTER FEEDER 360XH 40-130GR', 'A leggyakrabban használt méret, amely négy különböző erősségi változatban kerül forgalomba. Ezek között található közepesen erős, erős, extra erős, valamint az extra-extra erős változat is. Maximális dobótávolság: 60-70 méter.', 28990, 8, 28, 'resources/products/by-döme-team-feeder-power-fighter-feeder-360xh-40-130gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-8 Power Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"14\",\"Nyélborítás\":\"Eva+Parafa\",\"Súly\":\"280 g\",\"Szállítási hossz\":\"3,6 méter\",\"Típus\":\"ponty, amur\"}'),
(6, 'BY DÖME TEAM FEEDER POWER FIGHTER BOAT FEEDER 300H 40-130GR', 'A \"boat\" névre keresztelt feederek ideálisak a csónakos álló- és folyóvízi, valamint a nem túl széles tavakon vagy csatornákon való horgászatokhoz, ahol a maximális dobótávolság 40-50 méter.', 25990, 8, 35, 'resources/products/by-döme-team-feeder-power-fighter-boat-feeder-300h-40-130gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-8 Power Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"12\",\"Nyélborítás\":\"Eva+Parafa\",\"Súly\":\"210 g\",\"Hossz\":\"3 méter\",\"Típus\":\"ponty, kárász\"}'),
(7, 'BY DÖME TEAM FEEDER POWER FIGHTER BOAT FEEDER 270H 40-120GR', 'A \"boat\" névre keresztelt feederek ideálisak a csónakos álló- és folyóvízi, valamint a nem túl széles tavakon vagy csatornákon való horgászatokhoz, ahol a maximális dobótávolság 40-50 méter.', 23990, 8, 22, 'resources/products/by-döme-team-feeder-power-fighter-boat-feeder-270h-40-120gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-8 Power Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"11\",\"Nyélborítás\":\"Eva+Parafa\",\"Súly\":\"196 g\",\"Hossz\":\"2,7 méter\",\"Típus\":\"keszeg, kárász\"}'),
(8, 'BY DÖME TEAM FEEDER POWER FIGHTER BOAT FEEDER 270XH 50-170GR', 'A \"boat\" névre keresztelt feederek ideálisak a csónakos álló- és folyóvízi, valamint a nem túl széles tavakon vagy csatornákon való horgászatokhoz, ahol a maximális dobótávolság 40-50 méter.', 25990, 8, 13, 'resources/products/by-döme-team-feeder-power-fighter-boat-feeder-270xh-50-170gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-8 Power Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"11\",\"Nyélborítás\":\"Eva+Parafa\",\"Súly\":\"207 g\",\"Hossz\":\"2,7 méter\",\"Típus\":\"ponty, amur\"}'),
(9, 'BY DÖME TEAM FEEDER POWER FIGHTER BOAT FEEDER 300XH 50-180GR', 'A \"boat\" névre keresztelt feederek ideálisak a csónakos álló- és folyóvízi, valamint a nem túl széles tavakon vagy csatornákon való horgászatokhoz, ahol a maximális dobótávolság 40-50 méter.', 27990, 8, 18, 'resources/products/by-döme-team-feeder-power-fighter-boat-feeder-300xh-50-180gr-bmashop.png', '{\"Bottest anyaga\":\"IMT-8 Power Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"12\",\"Nyélborítás\":\"Eva+Parafa\",\"Súly\":\"225 g\",\"Hossz\":\"3 méter\",\"Típus\":\"ponty, amur\"}'),
(10, 'AVID CARP EXODUS PRO 3,6M 3.25LB', 'Az Exodus termékcsalád kiemelkedő teljesítményéről, kiváló minőségéről és kivételes ár-érték arányáról híres. A legújabb technológiai fejlesztések lehetővé tették a könnyű, mégis erős karbon blank kialakítását, amely tökéletesen alkalmas nagy távolságok elérésére és nagytestű pontyok kifárasztására.', 23500, 9, 12, 'resources/products/avid-carp-exodus-pro-36m-325lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"400 g\",\"Hossz\":\"3,6 méter\",\"Típus\":\"ponty\"}'),
(11, 'AVID CARP EXODUS PRO 3,0M 3.00LB', 'Az Exodus botcsalád rövidebb változata, amely kiváló választás a kisebb tavakra vagy akadós vizekre. Kiemelkedő minőségű High Modulus Carbon anyagból készült, amely biztosítja az erőt és a tartósságot a nagy halak kifárasztásához.', 21990, 9, 38, 'resources/products/avid-carp-exodus-pro-30m-300lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"380 g\",\"Hossz\":\"3,0 méter\",\"Típus\":\"ponty\"}'),
(12, 'AVID CARP EXODUS PRO 3,9M 3.50LB', 'Az Exodus széria leghosszabb és legerősebb változata, amely tökéletes választás nagy távolságokra történő dobásokhoz és extrém körülmények között történő pontyhorgászathoz.', 24990, 9, 10, 'resources/products/avid-carp-exodus-pro-39m-350lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"420 g\",\"Hossz\":\"3,9 méter\",\"Típus\":\"ponty\"}'),
(13, 'AVID CARP TRACTION PRO 3,6M 3.25LB', 'A Traction Pro botcsalád kiváló akcióval és erős karbon szerkezettel rendelkezik, amely ideális nagytestű pontyok fárasztásához. Kiemelkedő érzékenységet és erőt biztosít.', 27990, 9, 16, 'resources/products/avid-carp-traction-pro-36m-325lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"410 g\",\"Hossz\":\"3,6 méter\",\"Típus\":\"ponty\"}'),
(14, 'AVID CARP TRACTION PRO 3,0M 3.00LB', 'Ez a rövidebb Traction Pro modell tökéletes csónakos horgászathoz és szűkebb helyeken történő horgászathoz. Megőrzi a nagyobb modellek erősségét és érzékenységét.', 25990, 9, 25, 'resources/products/avid-carp-traction-pro-30m-300lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"390 g\",\"Hossz\":\"3,0 méter\",\"Tipus\":\"ponty\"}'),
(15, 'AVID CARP TRACTION PRO 3,9M 3.50LB', 'A leghosszabb Traction Pro bot, amely a legnagyobb dobásokhoz és a legkeményebb halakhoz lett tervezve. Extra erős blank és nagy átmérőjű gyűrűk biztosítják a hatékony használatot.', 29990, 9, 37, 'resources/products/avid-carp-traction-pro-39m-350lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"430 g\",\"Hossz\":\"3,9 méter\",\"Tipus\":\"ponty\"}'),
(16, 'AVID CARP EXODUS PRO SPOD 3,6M 4.50LB', 'A spod és marker botok kategóriájába tartozó Exodus Pro modell, amely erős karbon szerkezetének köszönhetően hatékonyan használható nagy távolságokra történő etetéshez.', 25990, 9, 19, 'resources/products/avid-carp-exodus-pro-spod-36m-450lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"450 g\",\"Hossz\":\"3,6 méter\",\"Tipus\":\"spod, marker\"}'),
(17, 'AVID CARP EXODUS PRO SPOD 3,9M 4.50LB', 'A leghosszabb Exodus Pro spod bot, amely kimagasló dobási teljesítményt és precíz irányítást biztosít nagy távolságokon.', 27990, 9, 23, 'resources/products/avid-carp-exodus-pro-spod-39m-450lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"470 g\",\"Hossz\":\"3,9 méter\",\"Tipus\":\"spod, marker\"}'),
(18, 'AVID CARP TRACTION PRO SPOD 3,6M 4.50LB', 'A Traction Pro sorozat spod botja, amelyet nagy távolságra történő etetésekhez terveztek. Extra erős blankja segít a pontos és hosszú dobások kivitelezésében.', 28990, 9, 16, 'resources/products/avid-carp-traction-pro-spod-36m-450lb-bmashop.png', '{\"Bottest anyaga\":\"High Modulus Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Osztott\",\"Súly\":\"460 g\",\"Hossz\":\"3,6 méter\",\"Tipus\":\"spod, marker\"}'),
(19, 'BALZER ADRENALIN CAT SLIMER 3,05M 150-450G', 'A Balzer IM-6 Adrenalin Cat Slimer egy szenzációs nagyhalas bot, rendkívüli erejének, átlag feletti teherbírásának köszönhetően univerzális harcsás bot, csónakos és parti horgászatra is ajánlható.', 45990, 10, 25, 'resources/products/balzer-adrenalin-cat-slimer-305m-150-450g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"7\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"455 g\",\"Hossz\":\"3,05 méter\",\"Tipus\":\"harcsa\"}'),
(20, 'BALZER ADRENALIN CAT SLIMER 4,70M 150-450G', 'A Balzer IM-6 Adrenalin Cat Slimer rövidebb változata, amely kiváló választás csónakos harcsázáshoz és nehéz terepre.', 43990, 10, 43, 'resources/products/balzer-adrenalin-cat-slimer-470m-150-450g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"7\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"435 g\",\"Hossz\":\"2,70 méter\",\"Tipus\":\"harcsa\"}'),
(21, 'BALZER ADRENALIN CAT VERTICAL 1,80M 100-300G', 'Egy különleges harcsázó bot vertikális horgászatra, amely könnyű kezelhetőségével és erős blankjával kiváló választás csónakos pergetéshez.', 39990, 10, 36, 'resources/products/balzer-adrenalin-cat-vertical-180m-100-300g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"370 g\",\"Hossz\":\"1,80 méter\",\"Tipus\":\"harcsa\"}'),
(22, 'BALZER ADRENALIN CAT VERTICAL 4,10M 100-300G', 'A hosszabb vertikális harcsázó bot a Balzer Adrenalin Cat szériából, amely nagyobb távolságok és mélyebb vizek meghorgászására is alkalmas.', 41990, 10, 15, 'resources/products/balzer-adrenalin-cat-vertical-410m-100-300g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"390 g\",\"Hossz\":\"2,10 méter\",\"Tipus\":\"harcsa\"}'),
(23, 'BALZER ADRENALIN CAT BOAT 4,40M 200-600G', 'A Balzer Adrenalin Cat Boat botja extrém harcsázási körülményekre lett tervezve, erős blankkal és nagy teherbírással.', 47990, 10, 23, 'resources/products/balzer-adrenalin-cat-boat-440m-200-600g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"485 g\",\"Hossz\":\"2,40 méter\",\"Tipus\":\"harcsa\"}'),
(24, 'BALZER ADRENALIN CAT BOAT 4,70M 200-600G', 'A hosszabb Balzer Adrenalin Cat Boat bot, amely kiváló választás mélyebb vizeken történő harcsázásra és nagyobb csalikhoz.', 49990, 10, 33, 'resources/products/balzer-adrenalin-cat-boat-470m-200-600g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"6\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"505 g\",\"Hossz\":\"2,70 méter\",\"Tipus\":\"harcsa\"}'),
(25, 'BALZER ADRENALIN CAT SPIN 4,40M 50-200G', 'Egy könnyű és erős harcsázó pergetőbot, amely ideális műcsalis horgászatra és kisebb harcsák célzott pergetésére.', 38990, 10, 26, 'resources/products/balzer-adrenalin-cat-spin-440m-50-200g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"7\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"355 g\",\"Hossz\":\"2,40 méter\",\"Tipus\":\"harcsa, pergetés\"}'),
(26, 'BALZER ADRENALIN CAT SPIN 4,70M 50-200G', 'A hosszabb változata az Adrenalin Cat Spin pergetőbotnak, amely nagyobb távolságok meghorgászására is alkalmas.', 40990, 10, 15, 'resources/products/balzer-adrenalin-cat-spin-470m-50-200g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"7\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"375 g\",\"Hossz\":\"2,70 méter\",\"Tipus\":\"harcsa, pergetés\"}'),
(27, 'BALZER ADRENALIN CAT XTREME 3,00M 250-750G', 'Az Adrenalin Cat Xtreme bot a legkeményebb harcsázási körülményekre lett tervezve, hatalmas teherbírásával és erős karbon blankjával.', 52990, 10, 23, 'resources/products/balzer-adrenalin-cat-xtreme-300m-250-750g-bmashop.png', '{\"Bottest anyaga\":\"IM-6 Carbon\",\"Gyűrűk anyaga\":\"Titánium SIC\",\"Gyűrűk száma\":\"7\",\"Nyélborítás\":\"Duplon\",\"Súly\":\"550 g\",\"Hossz\":\"3,00 méter\",\"Tipus\":\"harcsa\"}'),
(28, 'BY DÖME TF SILVER CARP FLOAT 360SXC', 'Ha valaki úszós bushorgászathoz készül, és a jelenleg elérhető talán egyik legjobb botot akarja, annak sem kell egy vagyont elköltenie!', 37990, 11, 6, 'resources/products/by-döme-tf-silver-carp-float-360sxc-bmashop.png', '{\"Bottest anyaga\":\"IM10-Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"11\",\"Nyélborítás\":\"EVA\",\"Súly\":\"278 g\",\"Hossz\":\"3,6 méter\",\"Típus\":\"harcsa\"}'),
(29, 'DAIWA AIRITY X45 MATCH 14', 'Egy prémium match bot a Daiwa-tól, amely kiváló minőségű anyagokból készült és rendkívüli teljesítményt nyújt.', 174990, 11, 12, 'resources/products/daiwa-airity-x45-match-14-bmashop.png', '{\"Bottest anyaga\":\"HVF Nano Carbon\",\"Gyűrűk anyaga\":\"LS\",\"Gyűrűk száma\":\"17\",\"Nyélborítás\":\"Parafa+EVA\",\"Súly\":\"218 g\",\"Hossz\":\"327 méter\",\"Típus\":\"keszeg\"}'),
(30, 'GURU A-CLASS PELLET WAGGLER 3,3M 3-15GR', 'Az A-Class sorozat elsősorban a hobbi horgászoknak szól és a legjobb minőséget kínálja elérhető áron.', 29990, 11, 23, 'resources/products/guru-a-class-pellet-waggler-33m-3-15gr-bmashop.png', '{\"Bottest anyaga\":\"24T Carbon\",\"Gyűrűk anyaga\":\"Titánium-oxid\",\"Gyűrűk száma\":\"14\",\"Nyélborítás\":\"Szivacs+Parafa\",\"Súly\":\"195 g\",\"Hossz\":\"3,3 méter\",\"Típus\":\"keszeg,harcsa\"}'),
(31, 'GURU A-CLASS PELLET WAGGLER 3,6M 3-15GR', 'Az A-Class sorozat egy újabb változata, amely a hosszabb botokat kedvelők számára is kiváló választás.', 31990, 11, 6, 'resources/products/guru-a-class-pellet-waggler-36m-3-15gr-bmashop.png', '{\"Bottest anyaga\":\"24T Carbon\",\"Gyűrűk anyaga\":\"Titánium-oxid\",\"Gyűrűk száma\":\"14\",\"Nyélborítás\":\"Szivacs+Parafa\",\"Súly\":\"215 g\",\"Hossz\":\"3,6 méter\",\"Típus\":\"harcsa\"}'),
(32, 'GURU A-CLASS PELLET WAGGLER 3M 3-15GR', 'Egy kompakt és könnyű pellet waggler bot, amelyet kifejezetten rövidebb dobásokhoz terveztek.', 29990, 11, 13, 'resources/products/guru-a-class-pellet-waggler-3m-3-15gr-bmashop.png', '{\"Bottest anyaga\":\"24T Carbon\",\"Gyűrűk anyaga\":\"Titánium-oxid\",\"Gyűrűk száma\":\"14\",\"Nyélborítás\":\"Szivacs+Parafa\",\"Súly\":\"150 g\",\"Hossz\":\"3 méter\",\"Típus\":\"keszeg,harcsa\"}'),
(33, 'GURU A-CLASS WAGGLER 3,9M 3-15GR', 'A legjobb minőségű hobbi horgászbotok közé tartozik, amely hosszabb kialakítással rendelkezik.', 31990, 11, 12, 'resources/products/guru-a-class-waggler-39m-3-15gr-bmashop.png', '{\"Bottest anyaga\":\"24T Carbon\",\"Gyűrűk anyaga\":\"Titánium-oxid\",\"Gyűrűk száma\":\"15\",\"Nyélborítás\":\"Szivacs+Parafa\",\"Súly\":\"180 g\",\"Hossz\":\"3,9 méter\",\"Típus\":\"harcsa\"}'),
(34, 'GURU N-GAUGE PRO PELLET WAGGLER 3,3M 1-15GR', 'A 330cm-es N-Gauge Pro Pellet Waggler az optimális hosszúság a tavi pellet waggler horgászatok többségéhez.', 55990, 11, 16, 'resources/products/guru-n-gauge-pro-pellet-waggler-33m-1-15gr-bmashop.png', '{\"Bottest anyaga\":\"Zero40 Carbon\",\"Gyűrűk anyaga\":\"LS cirkónium-kerámia\",\"Gyűrűk száma\":\"12\",\"Nyélborítás\":\"EVA+Parafa\",\"Súly\":\"165 g\",\"Hossz\":\"3,3 méter\",\"Típus\":\"balin\"}'),
(35, 'GURU N-GAUGE PRO PELLET WAGGLER 3M 1-15GR', 'Az N-Gauge Pro 10 Pellet Waggler bot rövid távú horgászatra lett tervezve, kiváló dobási tulajdonságokkal.', 51990, 11, 36, 'resources/products/guru-n-gauge-pro-pellet-waggler-3m-1-15gr-bmashop.png', '{\"Bottest anyaga\":\"Zero40 Carbon\",\"Gyűrűk anyaga\":\"LS cirkónium-kerámia\",\"Gyűrűk száma\":\"12\",\"Nyélborítás\":\"EVA+Parafa\",\"Súly\":\"155 g\",\"Hossz\":\"3 méter\",\"Típus\":\"keszeg\"}'),
(36, 'GURU N-GAUGE WAGGLER 300', 'A 10ft Pellet Waggler egy könnyű és kiegyensúlyozott bot, amelyet pellet waggler horgászatra terveztek.', 47990, 11, 26, 'resources/products/guru-n-gauge-waggler-300-bmashop.png', '{\"Bottest anyaga\":\"Carbon\",\"Gyűrűk anyaga\":\"SIC\",\"Gyűrűk száma\":\"13\",\"Nyélborítás\":\"Szivacs+Parafa\",\"Súly\":\"190 g\",\"Hossz\":\"3 méter\",\"Típus\":\"harcsa,keszeg\"}'),
(37, 'BALZER SHIRASU ZANDER SHAD 9,5CM BLUE JILL', 'A Balzer Shirasu Zander Shad egy kiváló minőségű gumihal, amely tökéletes választás süllő és más ragadozóhalak horgászatához.', 1432, 12, 45, 'resources/products/balzer-shirasu-zander-shad-95cm-blue-jill-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BALZER\"}'),
(38, 'BERKLEY POWERBAIT PWR NYMPH 2CM CHARTREUSE SILVER FLECK', 'A Berkley PowerBait PWR Nymph egy apró, de hatékony gumicsali, amely különösen ajánlott finomszerelékes horgászathoz.', 2990, 12, 29, 'resources/products/berkley-powerbait-pwr-nymph-2cm-chartreuse-silver-fleck-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(39, 'BERKLEY POWERBAIT PWR NYMPH 2CM GREEN CHART', 'A Berkley PowerBait PWR Nymph Green Chart változata élénk színével hatékonyan vonzza a ragadozóhalakat.', 2990, 12, 32, 'resources/products/berkley-powerbait-pwr-nymph-2cm-green-chart-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(40, 'BERKLEY POWERBAIT PWR NYMPH 2CM PINK SHAD', 'A rózsaszín Pink Shad színváltozat kiváló választás, ha feltűnő csalit keresel sekélyebb vizekhez.', 2990, 12, 33, 'resources/products/berkley-powerbait-pwr-nymph-2cm-pink-shad-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(41, 'BERKLEY POWERBAIT PWR NYMPH 2CM PUMPKIN CHARTREUSE', 'Ez a színkombináció ideális zavaros vízben, jól látható és csábító a ragadozók számára.', 2990, 12, 43, 'resources/products/berkley-powerbait-pwr-nymph-2cm-pumpkin-chartreuse-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(42, 'BERKLEY POWERBAIT PWR NYMPH 2CM SMOKE ORANGE', 'A Smoke Orange változat természetes és élénk színeivel univerzális választás különböző halfajokra.', 2990, 12, 23, 'resources/products/berkley-powerbait-pwr-nymph-2cm-smoke-orange-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(43, 'BERKLEY POWERBAIT PWR NYMPH 2CM YELLOW ORANGE', 'A PowerBait Yellow Orange verziója kiváló hatékonysággal működik gyenge fényviszonyok között is.', 2990, 12, 20, 'resources/products/berkley-powerbait-pwr-nymph-2cm-yellow-orange-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(44, 'BERKLEY SNEAK MINNOW 2\" BONE SHAD', 'A Berkley Sneak Minnow egy élethű megjelenésű gumihal, amely tökéletes sügér és süllő horgászatához.', 3990, 12, 19, 'resources/products/berkley-sneak-minnow-2-bone-shad-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(45, 'BERKLEY SNEAK MINNOW 2\" COTTON CANDY', 'A Sneak Minnow Cotton Candy színváltozata különösen jól teljesít tiszta vizekben, csábító rózsaszín fényével.', 3990, 12, 13, 'resources/products/berkley-sneak-minnow-2-cotton-candy-bmashop.png', '{\"Fajta\":\"Gumihal\",\"Gyártó\":\"BERKLEY\"}'),
(46, 'APIA ARGO 69 8.5gr 69mm 01 Hummer Night', 'Az APIA ARGO 69 egy kis méretű felszíni wobbler, amely tökéletes a tengeri sügér, fekete dorádó és más ragadozóhalak célzott horgászatához. Kompakt kialakítása lehetővé teszi a pontos irányítást és kiváló dobástávolságot biztosít.', 8990, 13, 16, 'resources/products/apia-argo-69-85gr-69mm-01-hummer-night-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(47, 'APIA ARGO 69 8.5gr 69mm 02 All Chart', 'Az APIA ARGO 69 egy kiváló felszíni csali, amely kompakt formájának és kiegyensúlyozott súlyának köszönhetően ideális célzott ragadozóhalas horgászatra, különösen tengerparti környezetben.', 8990, 13, 22, 'resources/products/apia-argo-69-85gr-69mm-02-all-chart-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(48, 'APIA ARGO 69 8.5gr 69mm 04 Natural Blue', 'Kis méretű, pontosan irányítható felszíni csali, amely ideális tengerparti és part menti horgászathoz. Kiemelkedő választás különböző tengeri ragadozókhoz.', 8990, 13, 21, 'resources/products/apia-argo-69-85gr-69mm-04-natural-blue-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(49, 'APIA ARGO 69 8.5gr 69mm 06 Pink Back Candy', 'Az APIA ARGO 69 Pink Back Candy színváltozatban rendkívül vonzó a ragadozó halak számára. Könnyen vezethető, megbízható wobbler változó körülmények között is.', 8990, 13, 31, 'resources/products/apia-argo-69-85gr-69mm-06-pink-back-candy-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(50, 'APIA BIT-V12 48mm 12gr 01 Bora', 'Az APIA BIT-V12 egy cink öntvény wobbler, amely tökéletesen reagál a legkisebb rántásra is. Alkalmas városi csatornák, kikötők és folyók célzott sügér horgászatához.', 5490, 13, 29, 'resources/products/apia-bit-v12-48mm-12gr-01-bora-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(51, 'APIA BIT-V12 48mm 12gr 12 UC Holly Night', 'Az APIA BIT-V12 egy érzékeny, precíz vezethetőségű csali, amely ideális a kis és közepes ragadozók megfogására városi és kikötői környezetben.', 5490, 13, 53, 'resources/products/apia-bit-v12-48mm-12gr-12-uc-holly-night-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(52, 'APIA BIT-V12 48mm 12gr 13 Blue Dust', 'Könnyű és érzékeny kialakítása révén kiváló választás olyan horgászhelyekre, ahol pontos dobásra és finom vezetésre van szükség.', 5490, 13, 25, 'resources/products/apia-bit-v12-48mm-12gr-13-blue-dust-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(53, 'APIA BIT-V12 48mm 12gr 18 Black Silver', 'A BIT-V12 tökéletes választás a városi és csatornai sügérhorgászathoz, kiválóan reagál a húzásokra és rezgésekre, erős rávágásokat generálva.', 5490, 13, 40, 'resources/products/apia-bit-v12-48mm-12gr-18-black-silver-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(54, 'APIA BIT-V26 55mm 26gr 01 Bora', 'Az APIA BIT-V26 egy nehezebb testű wobbler, amely kiválóan teljesít hosszú dobások során, gyorsan süllyed, ideális sügér és kősüllő horgászatára folyókon és tavakon.', 5490, 13, 23, 'resources/products/apia-bit-v26-55mm-26gr-01-bora-bmashop.png', '{\"Fajta\":\"Wobbler\",\"Gyártó\":\"APIA\"}'),
(55, 'BALZER ADRENALIN CAT VERTICAL STIKER - BREAM', 'A Balzer Adrenalin Cat vertikális műcsali tökéletes választás harcsa horgászatához. 12 cm hosszú, 80 g tömegű, realisztikus mozgású, három beakasztási ponttal.', 4990, 14, 22, 'resources/products/balzer-adrenalin-cat-vertical-stiker---bream-bmashop.png', '{\"Fajta\":\"Vertikális csali\",\"Gyártó\":\"BALZER\"}'),
(56, 'BALZER ADRENALIN CAT VERTICAL STIKER - SILVER BREAM', 'A Balzer Adrenalin Cat Silver Bream színű vertikális csali ideális a harcsák megfogásához. 12 cm hosszú, 80 grammos, élethű festéssel és mozgással.', 4990, 14, 31, 'resources/products/balzer-adrenalin-cat-vertical-stiker---silver-bream-bmashop.png', '{\"Fajta\":\"Vertikális csali\",\"Gyártó\":\"BALZER\"}'),
(57, 'FOX RAGE BIG EYE BLADE 17GR UV BLACK & GOLD', 'A Fox Rage Big Eye Blade pengecsali vibrációs mozgása és feltűnő UV színei kiválóan működnek ragadozóhalak ellen. 17 grammos változat, UV Black & Gold színben.', 2190, 14, 15, 'resources/products/fox-rage-big-eye-blade-17gr-uv-black-&-gold-bmashop.png', '{\"Fajta\":\"Penge csali\",\"Gyártó\":\"FOX RAGE\"}'),
(58, 'FOX RAGE BIG EYE BLADE 17GR UV BLEAK', 'A Fox Rage Big Eye Blade UV Bleak pengecsali éles mozgású, kiválóan alkalmas mélyebb vizek ragadozóira. 17 gramm, realisztikus színvilággal.', 2190, 14, 12, 'resources/products/fox-rage-big-eye-blade-17gr-uv-bleak-bmashop.png', '{\"Fajta\":\"Penge csali\",\"Gyártó\":\"FOX RAGE\"}'),
(59, 'FOX RAGE BIG EYE BLADE 17GR UV FIRETIGER', 'A Fox Rage Big Eye Blade UV Firetiger színeivel extra figyelemfelkeltő, 17 grammos pengecsali, ideális süllőre vagy csukára.', 2190, 14, 17, 'resources/products/fox-rage-big-eye-blade-17gr-uv-firetiger-bmashop.png', '{\"Fajta\":\"Penge csali\",\"Gyártó\":\"FOX RAGE\"}'),
(60, 'FOX RAGE BIG EYE BLADE 17GR UV PIKE', 'Fox Rage pengecsali 17 grammos változatban, UV Pike színben. Éles rezgésével és két horgával ideális választás ragadozóhalakra.', 2190, 14, 19, 'resources/products/fox-rage-big-eye-blade-17gr-uv-pike-bmashop.png', '{\"Fajta\":\"Penge csali\",\"Gyártó\":\"FOX RAGE\"}'),
(61, 'FOX RAGE BIG EYE BLADE 8GR UV BLACK & GOLD', 'A Fox Rage Big Eye Blade kisebb, 8 grammos változata UV Black & Gold színben. Vibráló mozgása jól vonzza az éhes ragadozókat.', 1990, 14, 22, 'resources/products/fox-rage-big-eye-blade-8gr-uv-black-&-gold-bmashop.png', '{\"Fajta\":\"Penge csali\",\"Gyártó\":\"FOX RAGE\"}'),
(62, 'FOX RAGE BIG EYE BLADE 8GR UV BLEAK', 'Kompakt pengecsali 8 grammos változatban. UV Bleak színeivel kiváló választás sügérre vagy kisebb ragadozóhalakra.', 1990, 14, 43, 'resources/products/fox-rage-big-eye-blade-8gr-uv-bleak-bmashop.png', '{\"Fajta\":\"Penge csali\",\"Gyártó\":\"FOX RAGE\"}'),
(63, 'FOX RAGE BIG EYE BLADE 8GR UV FIRETIGER', 'A Fox Rage 8 grammos pengecsalija UV Firetiger színben. Két erős horoggal szerelve, élénk színvilággal és gyors mozgással.', 1990, 14, 23, 'resources/products/fox-rage-big-eye-blade-8gr-uv-firetiger-bmashop.png', '{\"Fajta\":\"Penge csali\",\"Gyártó\":\"FOX RAGE\"}'),
(64, 'BALZER ALEGRA FEEDER 6400', 'Az Alegra Feeder 6400 egy kiváló minőségű elsőfékes orsó, könnyű grafit házzal és alumínium dobbal, 5+1 csapágyas kialakítással.', 28990, 15, 17, 'resources/products/balzer-alegra-feeder-6400-bmashop.png', '{\"Áttétel\":\"4.7:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"290 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"4000\"}'),
(65, 'BALZER ALEGRA FEEDER 6500', 'Az Alegra Feeder 6500 egy megbízható, elsőfékes horgászorsó 5+1 csapággyal, ideális feeder horgászathoz.', 29990, 15, 32, 'resources/products/balzer-alegra-feeder-6500-bmashop.png', '{\"Áttétel\":\"4.7:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"300 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"5000\"}'),
(66, 'BALZER ALEGRA FEEDER 6600', 'Az Alegra Feeder 6600 egy erős, nagy kapacitású feeder orsó, precíz működéssel és tartós szerkezettel.', 29990, 15, 23, 'resources/products/balzer-alegra-feeder-6600-bmashop.png', '{\"Áttétel\":\"4.7:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"350 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"6000\"}'),
(67, 'BALZER ALEGRA FEEDER DISTANCE', 'A Balzer Alegra Distance egy hosszútávra tervezett feeder orsó, kimagasló zsinórkapacitással és erőteljes fékrendszerrel.', 32990, 15, 13, 'resources/products/balzer-alegra-feeder-distance-bmashop.png', '{\"Áttétel\":\"4.7:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"460 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"5000\"}'),
(68, 'BALZER ALEGRA GT-II 7350', 'A Balzer Alegra GT-II 7350 egy sokoldalú pergető orsó, könnyű szerkezettel és finom futással.', 25990, 15, 37, 'resources/products/balzer-alegra-gt-ii-7350-bmashop.png', '{\"Áttétel\":\"5.2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"280 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"3500\"}'),
(69, 'BALZER ALEGRA GT-II 7450', 'A Balzer Alegra GT-II 7450 egy megbízható pergető orsó, ergonomikus kialakítással és 5+1 csapággyal.', 25990, 15, 28, 'resources/products/balzer-alegra-gt-ii-7450-bmashop.png', '{\"Áttétel\":\"4.9:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"350 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"4500\"}'),
(70, 'BY DÖME TF FINE CARP 4000', 'A Fine Carp 4000 egy kompakt és könnyű feeder orsó grafit-hibrid házzal és 7+1 csapággyal.', 29990, 15, 41, 'resources/products/by-döme-tf-fine-carp-4000-bmashop.png', '{\"Áttétel\":\"5.2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"295 g\",\"Gyártó\":\"BY DÖME\",\"Méret\":\"4000\"}'),
(71, 'BY DÖME TF FINE CARP 5000', 'A Fine Carp 5000 egy modern, erős elsőfékes orsó nagy zsinórkapacitással és sima futással.', 28990, 15, 19, 'resources/products/by-döme-tf-fine-carp-5000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"377 g\",\"Gyártó\":\"BY DÖME\",\"Méret\":\"5000\"}'),
(72, 'BY DÖME TF FINE CARP 6000', 'A Fine Carp 6000 a hosszabb dobásokhoz készült, robusztus, mégis könnyű orsó kiváló anyaghasználattal.', 29900, 15, 22, 'resources/products/by-döme-tf-fine-carp-6000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"412 g\",\"Gyártó\":\"BY DÖME\",\"Méret\":\"6000\"}'),
(73, 'NEVIS PANTERA 4000', 'A Nevis Pantera 4000 egy megbízható hátsófékes orsó alumínium dobbal és könnyű grafit-hybrid házzal.', 8990, 16, 13, 'resources/products/nevis-pantera-4000-bmashop.png', '{\"Áttétel\":\"5.2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"285 g\",\"Gyártó\":\"NEVIS\",\"Méret\":\"4000\"}'),
(74, 'NEVIS PANTERA 5000', 'A Nevis Pantera 5000 erősebb kialakítással és nagyobb zsinórkapacitással ideális választás a nagyobb halakhoz.', 9990, 16, 27, 'resources/products/nevis-pantera-5000-bmashop.png', '{\"Áttétel\":\"5.2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"360 g\",\"Gyártó\":\"NEVIS\",\"Méret\":\"5000\"}'),
(75, 'OKUMA ELECTRON 150-RD', 'Az Okuma Electron 150-RD könnyű és költséghatékony hátsófékes orsó grafit dobbal és megbízható működéssel.', 7990, 16, 9, 'resources/products/okuma-electron-150-rd-bmashop.png', '{\"Áttétel\":\"4.5:1\",\"Dob anyaga\":\"Grafit\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"314 g\",\"Gyártó\":\"OKUMA\",\"Méret\":\"5000\"}'),
(76, 'SHIMANO SAHARA 3000 SSDHHG-R', 'A Shimano Sahara 3000 SSDHHG-R prémium minőségű hátsófékes orsó kiváló Shimano alkatrészekkel és precíz működéssel.', 29990, 16, 31, 'resources/products/shimano-sahara-3000-ssdhhg-r-bmashop.png', '{\"Áttétel\":\"6.2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"XT-7\",\"Súly\":\"335 g\",\"Gyártó\":\"SHIMANO\",\"Méret\":\"3000\"}'),
(77, 'SHIMANO SAHARA 4000 DH-R', 'A Shimano Sahara 4000 DH-R egy megbízható középkategóriás hátsófékes orsó XT-7 házzal és finom futással.', 29990, 16, 25, 'resources/products/shimano-sahara-4000-dh-r-bmashop.png', '{\"Áttétel\":\"5.1:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"XT-7\",\"Súly\":\"375 g\",\"Gyártó\":\"SHIMANO\",\"Méret\":\"4000\"}'),
(78, 'SHIMANO SIENNA 4000 RE', 'A Shimano Sienna 4000 RE megerősített XT-7 házzal, könnyű szerkezettel és Super Stopper II rendszerrel van felszerelve.', 14500, 16, 18, 'resources/products/shimano-sienna-4000-re-bmashop.png', '{\"Áttétel\":\"5.1:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"XGT-7\",\"Súly\":\"365 g\",\"Gyártó\":\"SHIMANO\",\"Méret\":\"4000\"}'),
(79, 'ABU GARCIA SPIKE S 4000SH', 'A Spike S megbízható, kiváló minőségű pergető orsó széria, erős testtel és precíz futással.', 45990, 17, 22, 'resources/products/abu-garcia-spike-s-4000sh-bmashop.png', '{\"Áttétel\":\"6,2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"DuraMetal\",\"Súly\":\"266 g\",\"Gyártó\":\"ABU GARCIA\",\"Méret\":\"4000\"}'),
(80, 'BALZER ADRENALIN 6500 FD', 'Rendkívül erős, mégis könnyű orsó csendes futással, masszív felépítéssel és alumínium testtel.', 49990, 17, 22, 'resources/products/balzer-adrenalin-6500-fd-bmashop.png', '{\"Áttétel\":\"5,5:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Alumínium\",\"Súly\":\"465 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"6500\"}'),
(81, 'BALZER ALEGRA LF 6500', 'Feeder horgászathoz tervezett, megbízható orsó finom fékkel és kényelmes használattal.', 18990, 17, 29, 'resources/products/balzer-alegra-lf-6500-bmashop.png', '{\"Áttétel\":\"5,2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Carbon\",\"Súly\":\"400 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"5000\"}'),
(82, 'BALZER TACTICS CAT 5700', 'Nagyméretű, lassú áttételű feeder orsó, amely tökéletes nagyhalas horgászathoz.', 19990, 17, 22, 'resources/products/balzer-tactics-cat-5700-bmashop.png', '{\"Áttétel\":\"34:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit\",\"Súly\":\"650 g\",\"Gyártó\":\"BALZER\",\"Méret\":\"5700\"}'),
(83, 'DAIWA 15\' EXIST 3012H G', 'A Daiwa zászlóshajója, extrém sima futással és prémium Zaion testtel, Japán minőség.', 199990, 17, 26, 'resources/products/daiwa-15-exist-3012h-g-bmashop.png', '{\"Áttétel\":\"5,6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Zaion\",\"Súly\":\"235 g\",\"Gyártó\":\"DAIWA\",\"Méret\":\"3012\"}'),
(84, 'DAIWA 19 CERTATE LT 4000D-C', 'Erős, mégis könnyű pergető orsó Monocoque házzal, precíz futással és hosszú élettartammal.', 179990, 17, 6, 'resources/products/daiwa-19-certate-lt-4000d-c-bmashop.png', '{\"Áttétel\":\"5,2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Monocoque alumínium\",\"Súly\":\"285 g\",\"Gyártó\":\"DAIWA\",\"Méret\":\"4000D-C\"}'),
(85, 'DAIWA 20 EXCELER LT 2000', 'Könnyű és strapabíró pergető orsó Zaion V házzal és sima futással.', 34990, 17, 26, 'resources/products/daiwa-20-exceler-lt-2000-bmashop.png', '{\"Áttétel\":\"5,2:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Zaion V\",\"Súly\":\"185 g\",\"Gyártó\":\"DAIWA\",\"Méret\":\"2000\"}'),
(86, 'DAIWA 20 EXCELER LT 3000-C', 'Tökéletes választás pergetéshez, precíz és kiegyensúlyozott működés, Zaion V ház.', 34990, 17, 7, 'resources/products/daiwa-20-exceler-lt-3000-c-bmashop.png', '{\"Áttétel\":\"5,3:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Zaion V\",\"Súly\":\"210 g\",\"Gyártó\":\"DAIWA\",\"Méret\":\"3000-C\"}'),
(87, 'DAIWA 20 EXCELER LT 3000-CXH', 'Gyors áttételű, erős, mégis könnyű pergető orsó kiváló futással és megbízhatósággal.', 34990, 17, 22, 'resources/products/daiwa-20-exceler-lt-3000-cxh-bmashop.png', '{\"Áttétel\":\"6,3:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Zaion V\",\"Súly\":\"210 g\",\"Gyártó\":\"DAIWA\",\"Méret\":\"3000-CXH\"}'),
(88, 'BY DÖME TF CARPFIGHTER PRO 4000', 'Elegáns fekete orsó, távdobó alumínium dobbal, S-Curve zsinórfektető, dupla zsinórklipsz, precíz fék.', 17990, 18, 22, 'resources/products/by-döme-tf-carpfighter-pro-4000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"425 g\",\"Fékrendszer\":\"Elsőfék+nyeletőfék\",\"Csapágyszám\":\"4+1\"}'),
(89, 'BY DÖME TF CARPFIGHTER PRO 5000', 'Erőteljes távdobó orsó fekete dizájnnal, alumínium dob, dupla zsinórklipsz, precíz futás.', 18490, 18, 22, 'resources/products/by-döme-tf-carpfighter-pro-5000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"440 g\",\"Fékrendszer\":\"Elsőfék+nyeletőfék\",\"Csapágyszám\":\"3+1\"}'),
(90, 'BY DÖME TF CARPFIGHTER PRO 6000', 'Kiváló választás pontyozáshoz, nagy zsinórkapacitás, alumínium dob, dupla klipsz, S-Curve rendszer.', 18990, 18, 22, 'resources/products/by-döme-tf-carpfighter-pro-6000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"445 g\",\"Fékrendszer\":\"Elsőfék+nyeletőfék\",\"Csapágyszám\":\"3+1\"}'),
(91, 'BY DÖME TF MASTER CARP LCS PRO 5000', 'Továbbfejlesztett változat, hosszú élettartamú fékrendszer, karbon rotor, dupla klipsz, elegáns kivitel.', 26990, 18, 22, 'resources/products/by-döme-tf-master-carp-lcs-pro-5000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"437 g\",\"Fékrendszer\":\"Elsőfék+nyeletőfék\",\"Csapágyszám\":\"5+1\"}'),
(92, 'BY DÖME TEAM FEEDER LONG CAST LCS 5500', 'Nagy dobátmérő, extra zsinórkapacitás, tökéletes távdobáshoz, két zsinórklipsz, precíz működés.', 29900, 18, 22, 'resources/products/by-döme-team-feeder-long-cast-lcs-5500-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"590 g\",\"Fékrendszer\":\"Első+nyeletőfék\",\"Csapágyszám\":\"5+1\"}'),
(93, 'BY DÖME TEAM FEEDER PEARL CARP 5000', 'Fehér dizájn, távdobó képesség, precíz fék, két zsinórklipsz, ideális feeder horgászathoz.', 13900, 18, 22, 'resources/products/by-döme-team-feeder-pearl-carp-5000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"425 g\",\"Fékrendszer\":\"Első+nyeletőfék\",\"Csapágyszám\":\"4+1\"}'),
(94, 'BY DÖME TEAM FEEDER PEARL CARP 5500', 'Hosszabb dob, extra kapacitás, nyéltőfékes kivitel, kiváló ár-érték arány, távdobáshoz ideális.', 16490, 18, 22, 'resources/products/by-döme-team-feeder-pearl-carp-5500-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"440 g\",\"Fékrendszer\":\"Első+nyeletőfék\",\"Csapágyszám\":\"4+1\"}'),
(95, 'BY DÖME TF BIG RIVER LCS 5500', 'Erőteljes szerkezet, 7+1 csapágy, folyóvízi horgászatra, masszív ház, hosszú élettartam.', 31990, 18, 22, 'resources/products/by-döme-tf-big-river-lcs-5500-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"432 g\",\"Fékrendszer\":\"Elsőfék+nyeletőfék\",\"Csapágyszám\":\"7+1\"}'),
(96, 'BY DÖME TF BIG RIVER LCS 6000', 'Kiváló folyóvízi orsó, megerősített grafit ház, két zsinórklipsz, hosszú távú terhelhetőségre.', 33990, 18, 22, 'resources/products/by-döme-tf-big-river-lcs-6000-bmashop.png', '{\"Áttétel\":\"4.6:1\",\"Dob anyaga\":\"Alumínium\",\"Ház anyaga\":\"Grafit-hybrid\",\"Súly\":\"460 g\",\"Fékrendszer\":\"Elsőfék+nyeletőfék\",\"Csapágyszám\":\"7+1\"}'),
(97, 'CARP ZOOM GIANT PONTYOZÓ ÉS HARCSÁZÓ BOJLI 40mm VÉRES', '40 mm-es méret, vérrel dúsított ízesítés kapitális pontyok és harcsák horgászatához.', 1690, 19, 37, 'resources/products/carp-zoom-giant-pontyozó-és-harcsázó-bojli-40mm-véres-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"40mm\",\"Ízesítés\":\"véres\",\"Kiszerelés\":\"-\",\"Gyártó\":\"CARP ZOOM\"}'),
(98, 'CARP ZOOM GIANT PONTYOZÓ ÉS HARCSÁZÓ BOJLI 40mm MÁJAS', '40 mm-es bojli májas ízesítéssel, ideális nagy pontyokhoz és harcsákhoz.', 1690, 19, 23, 'resources/products/carp-zoom-giant-pontyozó-és-harcsázó-bojli-40mm-májas-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"40mm\",\"Ízesítés\":\"májas\",\"Kiszerelés\":\"-\",\"Gyártó\":\"CARP ZOOM\"}'),
(99, 'DYNAMITE BAITS BIG FISH PEPPERED SQUID 20MM 1KG', 'Fűszeres tintahal ízesítés, 1kg-os kiszerelésben, ideális nagytestű pontyokra.', 5590, 19, 41, 'resources/products/dynamite-baits-big-fish-peppered-squid-20mm-1kg-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"20mm\",\"Ízesítés\":\"peppered squid\",\"Kiszerelés\":\"1kg\",\"Gyártó\":\"DYNAMITE BAITS\"}'),
(100, 'DYNAMITE BAITS BOJLI HI ATTRACT SQUID & OCTOPUS 15MM 1KG', 'Kiváló prémium csali tintahal és polip kombinációval, gyors oldódású, 1kg-os kiszerelés.', 5590, 19, 19, 'resources/products/dynamite-baits-bojli-hi-attract-squid-&-octopus-15mm-1kg-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"15mm\",\"Ízesítés\":\"squid & octopus\",\"Kiszerelés\":\"1kg\",\"Gyártó\":\"DYNAMITE BAITS\"}'),
(101, 'DYNAMITE BAITS BOJLI HOT FISH & GLM 20mm 1kg', 'Fűszeres halas ízesítés kagylókivonattal (GLM), hatékony pontycsali egész évben.', 5590, 19, 32, 'resources/products/dynamite-baits-bojli-hot-fish-&-glm-20mm-1kg-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"20mm\",\"Ízesítés\":\"hot fish & GLM\",\"Kiszerelés\":\"1kg\",\"Gyártó\":\"DYNAMITE BAITS\"}'),
(102, 'DYNAMITE BAITS BOJLI MARINE HALIBUT 20MM 1KG', 'Tengeri halas bojli, prémium összetevőkkel, olajos halak ízvilágával, 1kg-os kiszerelés.', 5590, 19, 43, 'resources/products/dynamite-baits-bojli-marine-halibut-20mm-1kg-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"20mm\",\"Ízesítés\":\"marine halibut\",\"Kiszerelés\":\"1kg\",\"Gyártó\":\"DYNAMITE BAITS\"}'),
(103, 'DYNAMITE BAITS BOJLI MONSTER TIGERNUT 20MM 1KG', 'Tigrismogyoró-alapú bojli természetes édes aromával, ideális pontyhorgászathoz.', 6490, 19, 28, 'resources/products/dynamite-baits-bojli-monster-tigernut-20mm-1kg-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"20mm\",\"Ízesítés\":\"monster tigernut\",\"Kiszerelés\":\"1kg\",\"Gyártó\":\"DYNAMITE BAITS\"}'),
(104, 'DYNAMITE BAITS BOJLI SPICY SHRIMP & PRAWN 15MM 1KG', 'Vörösrák és garnéla kivonattal készült hallisztes bojli, magas minőség, jó emészthetőség.', 5490, 19, 15, 'resources/products/dynamite-baits-bojli-spicy-shrimp-&-prawn-15mm-1kg-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"15mm\",\"Ízesítés\":\"spicy shrimp & prawn\",\"Kiszerelés\":\"1kg\",\"Gyártó\":\"DYNAMITE BAITS\"}'),
(105, 'DYNAMITE BAITS BOJLI SPICY SHRIMP & PRAWN 20MM 1KG', 'Hi-Attract bojli, fűszeres rák ízesítés, gyorsan kifejti hatását, ideális nagy pontyokra.', 5490, 19, 47, 'resources/products/dynamite-baits-bojli-spicy-shrimp-&-prawn-20mm-1kg-bmashop.png', '{\"Típus\":\"bojli\",\"Méret\":\"20mm\",\"Ízesítés\":\"spicy shrimp & prawn\",\"Kiszerelés\":\"1kg\",\"Gyártó\":\"DYNAMITE BAITS\"}'),
(106, 'BENZAR MIX CONCOURSE METHOD MIX CSILI-KOLBÁSZ 800GR', 'Chilis-kolbászos method etetőanyag, 800g-os kiszerelés, kiváló beltartalommal és oldódással.', 2590, 20, 37, 'resources/products/benzar-mix-concourse-method-mix-csili-kolbász-800gr-bmashop.png', '{\"Ízesítés\":\"Chili-kolbász\",\"Kiszerelés\":\"800g\"}'),
(107, 'BENZAR MIX CONCOURSE METHOD MIX MÁJ 800GR', 'Májas method etetőanyag 800g-os kiszerelésben, prémium alapanyagokkal és figyelemfelkeltő színekkel.', 2590, 20, 21, 'resources/products/benzar-mix-concourse-method-mix-máj-800gr-bmashop.png', '{\"Ízesítés\":\"Máj\",\"Kiszerelés\":\"800g\"}'),
(108, 'BOGYÓKA BIGYÓ - EPER', 'Busa eper tabletta, lassan oldódó, nagy aromatartalmú és hosszú hatású etetőanyag.', 1590, 20, 43, 'resources/products/bogyóka-bigyó---eper-bmashop.png', '{\"Ízesítés\":\"Eper\",\"Kiszerelés\":\"Tabletta\"}'),
(109, 'BOGYÓKA BIGYÓ - MÉZESKALÁCS', 'Mézeskalács ízű busa tabletta, lassan oldódó, prémium etetőanyag.', 1590, 20, 33, 'resources/products/bogyóka-bigyó---mézeskalács-bmashop.png', '{\"Ízesítés\":\"Mézeskalács\",\"Kiszerelés\":\"Tabletta\"}'),
(110, 'BOGYÓKA BIGYÓ - TEJSZÍNES', 'Tejszínes busa tabletta, prémium kivitel, lassú oldódás és hosszan tartó hatás.', 1590, 20, 19, 'resources/products/bogyóka-bigyó---tejszínes-bmashop.png', '{\"Ízesítés\":\"Tejszínes\",\"Kiszerelés\":\"Tabletta\"}'),
(111, 'BOGYÓKA BIGYÓ - VANÍLIA', 'Vaníliás busa tabletta, lassan oldódó, aromadús etetőanyag.', 1590, 20, 50, 'resources/products/bogyóka-bigyó---vanília-bmashop.png', '{\"Ízesítés\":\"Vanília\",\"Kiszerelés\":\"Tabletta\"}'),
(112, 'BOGYÓKA PRÉMIUM BUSÁZÓ MIX 3KG MÁLNA-EPER', 'Málnás-epres busázó etetőanyag 3kg-os kiszerelésben, prémium összetevőkkel.', 3990, 20, 28, 'resources/products/bogyóka-prémium-busázó-mix-3kg-málna-eper-bmashop.png', '{\"Ízesítés\":\"Málna-eper\",\"Kiszerelés\":\"3kg\"}'),
(113, 'BOGYÓKA PRÉMIUM BUSÁZÓ MIX 3KG MÉZESKALÁCS', 'Mézeskalácsos busázó mix 3kg-os kiszerelésben, intenzív aroma és kiváló oldódás.', 3990, 20, 17, 'resources/products/bogyóka-prémium-busázó-mix-3kg-mézeskalács-bmashop.png', '{\"Ízesítés\":\"Mézeskalács\",\"Kiszerelés\":\"3kg\"}'),
(114, 'BOGYÓKA PRÉMIUM BUSÁZÓ MIX 3KG VANÍLIA', 'Vaníliás 3kg-os busázó etetőanyag, prémium kivitel és megbízható csalogatóerő.', 3990, 20, 40, 'resources/products/bogyóka-prémium-busázó-mix-3kg-vanília-bmashop.png', '{\"Ízesítés\":\"Vanília\",\"Kiszerelés\":\"3kg\"}'),
(115, 'CARP ZOOM CSILLAGFÜRT AMUROZÁSHOZ NATÚR 125G 220ML', 'Fehérjetartalmának és tápértékének köszönhetően kedvelt és sikeres horgászcsali.', 1390, 21, 73, 'resources/products/carp-zoom-csillagfürt-amurozáshoz-natúr-125g-220ml-bmashop.png', '{\"Kiszerelés\":\"125 g / 220 ml\",\"Gyártó\":\"CARP ZOOM\"}'),
(116, 'CARP ZOOM KUKORICA XXL AMUR', 'A pontyok és amurok kedvelt csemegéje hajszál vagy szilikon előkén kínálva.', 1390, 21, 21, 'resources/products/carp-zoom-kukorica-xxl-amur-bmashop.png', '{\"Kiszerelés\":\"125 g\",\"Gyártó\":\"CARP ZOOM\"}'),
(117, 'CARP ZOOM LUPIN FŐZÖTT 125GR', 'Magas fehérjetartalmának és tápértékének köszönhetően kedvelt és sikeres horgászcsali.', 1390, 21, 33, 'resources/products/carp-zoom-lupin-főzött-125gr-bmashop.png', '{\"Kiszerelés\":\"125 g\",\"Gyártó\":\"CARP ZOOM\"}'),
(118, 'CARP ZOOM PREMIUM MAIZE 125G FOKHAGYMA', 'Fokhagymás aromájával kiváló ponty-, keszeg-, kárász- és amurcsali.', 1390, 21, 57, 'resources/products/carp-zoom-premium-maize-125g-fokhagyma-bmashop.png', '{\"Kiszerelés\":\"125 g\",\"Gyártó\":\"CARP ZOOM\"}'),
(119, 'CARP ZOOM SWEET ANGLERS MAIZE 125GR EPER', 'Különleges aromájában érlelődő kukoricaszemek, kiváló ponty-, keszeg-, kárász- és amurcsali.', 990, 21, 49, 'resources/products/carp-zoom-sweet-anglers-maize-125gr-eper-bmashop.png', '{\"Kiszerelés\":\"125 g\",\"Gyártó\":\"CARP ZOOM\"}'),
(120, 'CARP ZOOM SWEET ANGLERS MAIZE 125GR MÉZ', 'Különleges aromájában érlelődő kukoricaszemek, kiváló ponty-, keszeg-, kárász- és amurcsali.', 990, 21, 65, 'resources/products/carp-zoom-sweet-anglers-maize-125gr-méz-bmashop.png', '{\"Kiszerelés\":\"125 g\",\"Gyártó\":\"CARP ZOOM\"}'),
(121, 'CARP ZOOM SWEET ANGLERS MAIZE 125GR SZILVA', 'Különleges aromájában érlelődő kukoricaszemek, kiváló ponty-, keszeg-, kárász- és amurcsali.', 990, 21, 23, 'resources/products/carp-zoom-sweet-anglers-maize-125gr-szilva-bmashop.png', '{\"Kiszerelés\":\"125 g\",\"Gyártó\":\"CARP ZOOM\"}'),
(122, 'CARP ZOOM SWEET ANGLERS MAIZE 125GR VANÍLIA', 'Különleges aromájában érlelődő kukoricaszemek, kiváló ponty-, keszeg-, kárász- és amurcsali.', 990, 21, 30, 'resources/products/carp-zoom-sweet-anglers-maize-125gr-vanília-bmashop.png', '{\"Kiszerelés\":\"125 g\",\"Gyártó\":\"CARP ZOOM\"}'),
(123, 'CARP ZOOM TURBO SEED PLUS 1KG 7X MIX', 'A halak által legjobban kedvelt magvak és keverékek praktikus kiszerelésben.', 2190, 21, 81, 'resources/products/carp-zoom-turbo-seed-plus-1kg-7x-mix-bmashop.png', '{\"Kiszerelés\":\"1 kg\",\"Gyártó\":\"CARP ZOOM\"}'),
(124, 'AVID CARP OUTLINE CAMO TAPERED LEADER 0,28MM-0,57MM 3x15M', 'Erős és kopásálló zsinórkialakítás nagy dobásokhoz, gyorsan süllyedő tulajdonsággal.', 1990, 22, 28, 'resources/products/avid-carp-outline-camo-tapered-leader-028mm-057mm-3x15m-bmashop.png', '{\"Kiszerelés\":\"3x15 m / dob\",\"Gyártó\":\"AVID CARP\"}'),
(125, 'AVID CARP OUTLINE CAMO TAPERED LEADER 0,33MM-0,57MM 3x15M', 'Erős és kopásálló zsinórkialakítás nagy dobásokhoz, gyorsan süllyedő tulajdonsággal.', 1990, 22, 42, 'resources/products/avid-carp-outline-camo-tapered-leader-033mm-057mm-3x15m-bmashop.png', '{\"Kiszerelés\":\"3x15 m / dob\",\"Gyártó\":\"AVID CARP\"}'),
(126, 'AVID CARP OUTLINE CAMO TAPERED LEADER 0,37MM-0,57MM 3x15M', 'Erős és kopásálló zsinórkialakítás nagy dobásokhoz, gyorsan süllyedő tulajdonsággal.', 1990, 22, 35, 'resources/products/avid-carp-outline-camo-tapered-leader-037mm-057mm-3x15m-bmashop.png', '{\"Kiszerelés\":\"3x15 m / dob\",\"Gyártó\":\"AVID CARP\"}'),
(127, 'BALZER TAPER TIPS 0,28-0,58 mm', 'Kiváló vastagodó távdobó előtétzsinór, mely 15 méteren fokozatosan vastagszik.', 4390, 22, 30, 'resources/products/balzer-taper-tips-0,28-0,58-mm-bmashop.png', '{\"Kiszerelés\":\"5x15 m / tekercs\",\"Gyártó\":\"BALZER\"}'),
(128, 'BY DÖME TEAM FEEDER TAPERED LINE 0,18-0,25MM', 'Kiváló minőségű, alacsony nyúlású, könnyen köthető zsinór kopolimer alapanyagból, nagy szakítószilárdsággal.', 2690, 22, 51, 'resources/products/by-döme-team-feeder-tapered-line-0,18-0,25mm-bmashop.png', '{\"Kiszerelés\":\"5x15 m / dob\",\"Gyártó\":\"BY DÖME\"}'),
(129, 'BY DÖME TEAM FEEDER TAPERED LINE 0,195-0,28MM', 'Kiváló minőségű, alacsony nyúlású, könnyen köthető zsinór kopolimer alapanyagból, nagy szakítószilárdsággal.', 2690, 22, 40, 'resources/products/by-döme-team-feeder-tapered-line-0,195-0,28mm-bmashop.png', '{\"Kiszerelés\":\"5x15 m / dob\",\"Gyártó\":\"BY DÖME\"}'),
(130, 'BY DÖME TEAM FEEDER TAPERED LINE 0,20-0,31MM', 'Kiváló minőségű, alacsony nyúlású, könnyen köthető zsinór kopolimer alapanyagból, nagy szakítószilárdsággal.', 2690, 22, 47, 'resources/products/by-döme-team-feeder-tapered-line-0,20-0,31mm-bmashop.png', '{\"Kiszerelés\":\"5x15 m / dob\",\"Gyártó\":\"BY DÖME\"}'),
(131, 'CARP EXPERT FLUOROCARBON SHOCK LEADER 0.20MM-0.55MM', 'Magas kopásállóságú, „láthatatlan” fluorocarbon előkezsinór nagy igénybevételhez.', 3190, 22, 18, 'resources/products/carp-expert-fluorocarbon-shock-leader-020mm-055mm-bmashop.png', '{\"Kiszerelés\":\"5x15 m / dob\",\"Gyártó\":\"CARP EXPERT\"}'),
(132, 'CARP EXPERT FLUOROCARBON SHOCK LEADER 0.25MM-0.55MM', 'Magas kopásállóságú, „láthatatlan” fluorocarbon előkezsinór nagy igénybevételhez.', 3190, 22, 33, 'resources/products/carp-expert-fluorocarbon-shock-leader-025mm-055mm-bmashop.png', '{\"Kiszerelés\":\"5x15 m / dob\",\"Gyártó\":\"CARP EXPERT\"}'),
(133, 'CARP EXPERT FLUOROCARBON SHOCK LEADER 0.30MM-0.55MM', 'Magas kopásállóságú, „láthatatlan” fluorocarbon előkezsinór nagy igénybevételhez.', 3190, 22, 21, 'resources/products/carp-expert-fluorocarbon-shock-leader-030mm-055mm-bmashop.png', '{\"Kiszerelés\":\"5x15 m / dob\",\"Gyártó\":\"CARP EXPERT\"}'),
(134, 'BALZER SHIRASU FLUOROCARBON 25M 0,25 MM', 'Nagy tisztaságú fluorocarbon zsinór kiváló kopásállósággal és alacsony fénytöréssel.', 3790, 23, 26, 'resources/products/balzer-shirasu-fluorocarbon-25m-025-mm-bmashop.png', '{\"Kiszerelés\":\"25 m / 0,25 mm\",\"Gyártó\":\"BALZER\"}');
INSERT INTO `products` (`Id`, `Name`, `Description`, `Price`, `CategoryId`, `StockQuantity`, `ImageUrl`, `Attributes`) VALUES
(135, 'BALZER SHIRASU FLUOROCARBON 25M 0,35 MM', 'Erős fluorocarbon zsinór akadós pályákra, megbízható teljesítménnyel.', 4990, 23, 48, 'resources/products/balzer-shirasu-fluorocarbon-25m-035-mm-bmashop.png', '{\"Kiszerelés\":\"25 m / 0,35 mm\",\"Gyártó\":\"BALZER\"}'),
(136, 'BALZER SHIRASU FLUOROCARBON 25M 0,40 MM', 'Professzionális előkezsinór, láthatatlan a víz alatt, gyorsan süllyed.', 5490, 23, 48, 'resources/products/balzer-shirasu-fluorocarbon-25m-040-mm-bmashop.png', '{\"Kiszerelés\":\"25 m / 0,40 mm\",\"Gyártó\":\"BALZER\"}'),
(137, 'BALZER SHIRASU FLUOROCARBON 25M 0,50 MM', 'Erős, láthatatlan zsinór nagytestű halak horgászatához.', 6390, 23, 31, 'resources/products/balzer-shirasu-fluorocarbon-25m-050-mm-bmashop.png', '{\"Kiszerelés\":\"25 m / 0,50 mm\",\"Gyártó\":\"BALZER\"}'),
(138, 'BALZER SHIRASU FLUOROCARBON 15M 0,60 MM', 'Extra vastag fluorocarbon rövidebb kiszerelésben, extrém terhelésre.', 6290, 23, 13, 'resources/products/balzer-shirasu-fluorocarbon-15m-060-mm-bmashop.png', '{\"Kiszerelés\":\"15 m / 0,60 mm\",\"Gyártó\":\"BALZER\"}'),
(139, 'BALZER SHIRASU FLUOROCARBON 10M 0,70 MM', 'Maximális terhelésű, rövid fluorocarbon zsinór nagyhalas horgászathoz.', 6190, 23, 15, 'resources/products/balzer-shirasu-fluorocarbon-10m-070-mm-bmashop.png', '{\"Kiszerelés\":\"10 m / 0,70 mm\",\"Gyártó\":\"BALZER\"}'),
(140, 'BERKLEY TRILENE FLUOROCARBON 0.18MM 50M', 'Puha, alacsony láthatóságú fluorocarbon zsinór érzékeny horgászathoz.', 3790, 23, 16, 'resources/products/berkley-trilene-fluorocarbon-018mm-50m-bmashop.png', '{\"Kiszerelés\":\"50 m / 0,18 mm\",\"Gyártó\":\"BERKLEY\"}'),
(141, 'BERKLEY TRILENE FLUOROCARBON 0.20MM 50M', 'Univerzális fluorocarbon előkezsinór magas kopásállósággal.', 3790, 23, 22, 'resources/products/berkley-trilene-fluorocarbon-020mm-50m-bmashop.png', '{\"Kiszerelés\":\"50 m / 0,20 mm\",\"Gyártó\":\"BERKLEY\"}'),
(142, 'BERKLEY TRILENE FLUOROCARBON 0.22MM 50M', 'Megbízható fluorocarbon zsinór általános használatra és előkéhez.', 3790, 23, 29, 'resources/products/berkley-trilene-fluorocarbon-022mm-50m-bmashop.png', '{\"Kiszerelés\":\"50 m / 0,22 mm\",\"Gyártó\":\"BERKLEY\"}'),
(143, 'AVID CARP OUTLINE CAMO REEL LINE 1000M 0,28MM', 'Zöld színű, alacsony láthatóságú camo dobózsinór extra dobásokhoz.', 6490, 24, 93, 'resources/products/avid-carp-outline-camo-reel-line-1000m-028mm-bmashop.png', '{\"Kiszerelés\":\"1000 m\",\"Gyártó\":\"AVID CARP\"}'),
(144, 'BERKLEY TRILENE BIG GAME 0.254MM 1000M', 'Erős és kopásálló monofil zsinór távoli dobásokhoz, alacsony nyúlással.', 5290, 24, 20, 'resources/products/berkley-trilene-big-game-0254mm-1000m-bmashop.png', '{\"Kiszerelés\":\"1000 m\",\"Gyártó\":\"BERKLEY\"}'),
(145, 'BERKLEY TRILENE BIG GAME 0.28MM 1000M', 'Megbízható, erős horgászzsinór, távoli dobásokra fejlesztve.', 5290, 24, 78, 'resources/products/berkley-trilene-big-game-028mm-1000m-bmashop.png', '{\"Kiszerelés\":\"1000 m\",\"Gyártó\":\"BERKLEY\"}'),
(146, 'BERKLEY TRILENE BIG GAME 0.29MM 1000M', 'Tartós, sokoldalú monofil zsinór nagy halakhoz.', 5990, 24, 43, 'resources/products/berkley-trilene-big-game-029mm-1000m-bmashop.png', '{\"Kiszerelés\":\"1000 m\",\"Gyártó\":\"BERKLEY\"}'),
(147, 'BERKLEY TRILENE BIG GAME 0.3450MM 1000M', 'Kiváló kopásállóságú zsinór, ideális akadós terepre.', 5990, 24, 29, 'resources/products/berkley-trilene-big-game-03450mm-1000m-bmashop.png', '{\"Kiszerelés\":\"1000 m\",\"Gyártó\":\"BERKLEY\"}'),
(148, 'BERKLEY TRILENE BIG GAME 0.61MM 600M', 'Erős és vastag zsinór kapitális halakhoz, nagy teherbírással.', 9290, 24, 57, 'resources/products/berkley-trilene-big-game-061mm-600m-bmashop.png', '{\"Kiszerelés\":\"600 m\",\"Gyártó\":\"BERKLEY\"}'),
(149, 'BERKLEY TRILENE BIG GAME 0.71MM 600M', 'Nagy átmérőjű, strapabíró monofil zsinór extrém körülményekhez.', 9290, 24, 19, 'resources/products/berkley-trilene-big-game-071mm-600m-bmashop.png', '{\"Kiszerelés\":\"600 m\",\"Gyártó\":\"BERKLEY\"}'),
(150, 'BERKLEY TRILENE BIG GAME 100LB 0.89MM 600M CLEAR', 'Extra vastag, nagy teherbírású monofil zsinór kapitális halakhoz.', 9990, 24, 25, 'resources/products/berkley-trilene-big-game-100lb-089mm-600m-clear-bmashop.png', '{\"Kiszerelés\":\"600 m\",\"Gyártó\":\"BERKLEY\"}'),
(151, 'BERKLEY TRILENE XL 0.16MM 270M', 'Lágy, jól kezelhető, alacsony nyúlású zsinór pontyozáshoz.', 3490, 24, 75, 'resources/products/berkley-trilene-xl-016mm-270m-bmashop.png', '{\"Kiszerelés\":\"270 m\",\"Gyártó\":\"BERKLEY\"}'),
(152, 'AVID CARP DOUBLE DECKER BIVVY ORGANISER', 'Kétszintes sátorasztal, vízálló tálcákkal és tároló zsebekkel.', 44990, 25, 100, 'resources/products/avid-carp-double-decker-bivvy-organiser-bmashop.png', '{\"Méret\":\"55 x 35 x 20 cm\",\"Gyártó\":\"AVID CARP\"}'),
(153, 'CARP SPIRIT ARMA SKIN EVEREST 1 MAN BIVVY', 'Erős szerkezetű sátor kiváló vízállósággal és nagy belső térrel.', 79990, 25, 30, 'resources/products/carp-spirit-arma-skin-everest-1-man-bivvy-bmashop.png', '{\"Méret\":\"1 személyes sátor\",\"Gyártó\":\"CARP SPIRIT\"}'),
(154, 'CARP SPIRIT BLAX BIVVY 1 MAN', 'Könnyen összeszerelhető, kompakt sátor erős vázszerkezettel.', 49990, 25, 69, 'resources/products/carp-spirit-blax-bivvy-1-man-bmashop.png', '{\"Méret\":\"1 személyes sátor\",\"Gyártó\":\"CARP SPIRIT\"}'),
(155, 'CARP SPIRIT BLAX BIVVY 1 MAN - WINTER SKIN', 'Téli borítás extra védelemmel hideg és csapadék ellen.', 19990, 25, 33, 'resources/products/carp-spirit-blax-bivvy-1-man---winter-skin-bmashop.png', '{\"Méret\":\"Téli borítás\",\"Gyártó\":\"CARP SPIRIT\"}'),
(156, 'CARP ZOOM BIVVY SÁTOR LESZÚRÓ KÉSZLET 7x200mm 10db', 'Stabil sátorrögzítő készlet 10 darabos kiszerelésben, praktikus tokban.', 3490, 25, 69, 'resources/products/carp-zoom-bivvy-sátor-leszúró-készlet-7x200mm-10db-bmashop.png', '{\"Méret\":\"7x200 mm\",\"Gyártó\":\"CARP ZOOM\"}'),
(157, 'CARP ZOOM DÖNTHETŐ FEJŰ HORGÁSZERNYŐ 220CM', 'Dönthető fejű horgászernyő UV védelemmel, erős vázzal.', 10990, 25, 86, 'resources/products/carp-zoom-dönthető-fejű-horgászernyő-220cm-bmashop.png', '{\"Méret\":\"220 cm\",\"Gyártó\":\"CARP ZOOM\"}'),
(158, 'CARP ZOOM ERNYŐTARTÓ LESZÚRÓS', 'Fém ernyőtartó leszúró, csavaros rögzítéssel, bármilyen talajhoz.', 1990, 25, 34, 'resources/products/carp-zoom-ernyőtartó-leszúrós-bmashop.png', '{\"Méret\":\"22 x 30 cm\",\"Gyártó\":\"CARP ZOOM\"}'),
(159, 'CARP ZOOM ERNYŐTARTÓ MENETES 40 cm', 'Menetes kialakítású ernyőtartó leszúró acélból.', 2790, 25, 16, 'resources/products/carp-zoom-ernyőtartó-menetes-40-cm-bmashop.png', '{\"Méret\":\"40 cm\",\"Gyártó\":\"CARP ZOOM\"}'),
(160, 'CARP ZOOM EXPEDITION BROLLY RENDSZERŰ ERNYŐ 240', 'Félsátorrá alakítható, vízálló brolly ernyő oldalponyvával.', 34990, 25, 72, 'resources/products/carp-zoom-expedition-brolly-rendszerű-ernyő-240-bmashop.png', '{\"Méret\":\"240 x 150 x 140 cm\",\"Gyártó\":\"CARP ZOOM\"}'),
(161, 'AVID CARP DOUBLE DECKER BIVVY TABLE', 'Dupla szintes horgász asztal, állítható lábakkal és kompakt tárolással', 39990, 26, 27, 'resources/products/avid-carp-double-decker-bivvy-table-bmashop.png', '{\"Méret\":\"55 x 35 cm\",\"Gyártó\":\"AVID CARP\"}'),
(162, 'AVID COMPACT SESSION TABLE', 'Kompakt, összecsukható horgász asztal kerek kialakítással', 26500, 26, 42, 'resources/products/avid-compact-session-table-bmashop.png', '{\"Méret\":\"63 x 72 x 72 cm\",\"Gyártó\":\"AVID CARP\"}'),
(163, 'CARP ACADEMY BIG BOSS FOTEL', 'Erős vázzal, párnázott ülőfelülettel és dönthető háttámlával rendelkező komfortos horgász fotel', 59990, 26, 35, 'resources/products/carp-academy-big-boss-fotel-bmashop.png', '{\"Méret\":\"60 x 55 x 75 cm\",\"Gyártó\":\"CARP ACADEMY\"}'),
(164, 'CARP ACADEMY DELUXXE CAMOU FOTEL', 'Magastámlás, teleszkópos lábú, ergonomikus horgász fotel', 39990, 26, 21, 'resources/products/carp-academy-deluxxe-camou-fotel-bmashop.png', '{\"Méret\":\"55 x 45 x 75 cm\",\"Gyártó\":\"CARP ACADEMY\"}'),
(165, 'CARP ACADEMY GIANT CAMOU FOTEL', 'Extra méretű, teleszkópos lábú fotel prémium anyagokból és kényelmes párnázással', 49990, 26, 33, 'resources/products/carp-academy-giant-camou-fotel-bmashop.png', '{\"Méret\":\"52 x 52 x 65 cm\",\"Gyártó\":\"CARP ACADEMY\"}'),
(166, 'CARP ACADEMY GRIZZLY PRO FOTEL', 'Stabil vázas, párnázott horgász fotel nagy teherbírással', 44990, 26, 18, 'resources/products/carp-academy-grizzly-pro-fotel-bmashop.png', '{\"Méret\":\"55 x 45 x 75 cm\",\"Gyártó\":\"CARP ACADEMY\"}'),
(167, 'CARP ACADEMY LUXXUS CAMO FOTEL', 'Könnyű és stabil horgász fotel karfával, teleszkópos lábakkal', 29900, 26, 26, 'resources/products/carp-academy-luxxus-camo-fotel-bmashop.png', '{\"Méret\":\"50 x 45 x 60 cm\",\"Gyártó\":\"CARP ACADEMY\"}'),
(168, 'CARP ACADEMY QUATTRO CAMO FOTEL', 'Kényelmes kialakítású, teleszkópos lábú horgász fotel', 33900, 26, 31, 'resources/products/carp-academy-quattro-camo-fotel-bmashop.png', '{\"Méret\":\"48 x 40 x 60 cm\",\"Gyártó\":\"CARP ACADEMY\"}'),
(169, 'CARP ACADEMY MOONCHAIR FOTEL', 'Kör alakú, masszív vázas karfás horgász szék, ideális kempingezéshez is', 37990, 26, 39, 'resources/products/carp-academy-moonchair-fotel-bmashop.png', '{\"Méret\":\"100 x 100 cm\",\"Gyártó\":\"CARP ACADEMY\"}'),
(170, 'ALUFLOKK BOTTARTÓ FEJ AF15', 'Masszív, speciális bevonatú bottartó fej, maximális védelemmel.', 2490, 27, 48, 'resources/products/aluflokk-bottartó-fej-af15-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(171, 'ALUFLOKK BOTTARTÓ FEJ AF16', 'Strapabíró, alumíniumból készült bottartó fej különleges bevonattal.', 2490, 27, 35, 'resources/products/aluflokk-bottartó-fej-af16-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(172, 'ALUFLOKK BOTTARTÓFEJ AF1', 'Tartós bottartó fej, kiváló minőségű öntéstechnológiával gyártva.', 2490, 27, 47, 'resources/products/aluflokk-bottartófej-af1-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(173, 'ALUFLOKK BOTTARTÓFEJ AF1 TRIKOLOR', 'Masszív trikolor bottartó fej, különleges kialakításban.', 3490, 27, 30, 'resources/products/aluflokk-bottartófej-af1-trikolor-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(174, 'ALUFLOKK BOTTARTÓFEJ AF10', 'Egyszerű, mégis strapabíró bottartó fej horgászathoz.', 2490, 27, 48, 'resources/products/aluflokk-bottartófej-af10-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(175, 'ALUFLOKK BOTTARTÓFEJ AF10 MAGENTA', 'Stílusos magenta bottartó fej, hölgy horgászoknak is ideális.', 2490, 27, 40, 'resources/products/aluflokk-bottartófej-af10-magenta-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(176, 'ALUFLOKK BOTTARTÓFEJ AF11', 'Különleges hosszított bottartó fej stabil tartással.', 6490, 27, 43, 'resources/products/aluflokk-bottartófej-af11-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(177, 'ALUFLOKK BOTTARTÓFEJ AF11 TRIKOLOR', 'Professzionális verseny bottartó fej trikolor színben.', 8490, 27, 27, 'resources/products/aluflokk-bottartófej-af11-trikolor-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(178, 'ALUFLOKK BOTTARTÓFEJ AF1 MAGENTA', 'Feeder botvillához készült bottartó fej pink színben.', 2490, 27, 21, 'resources/products/aluflokk-bottartófej-af1-magenta-bmashop.png', '{\"Gyártó\":\"ALUFLOKK\"}'),
(179, 'BERKLEY BALL MOUNTING SYSTEM & FISH FINDER HOLDER L', 'Stabil rögzítő rendszer nagyméretű halradarhoz, nagy gömbcsuklóval és zárható talppal.', 20990, 28, 9, 'resources/products/berkley-ball-mounting-system-&-fish-finder-holder-l-bmashop.png', '{\"Méret\":\"40 mm\",\"Gyártó\":\"BERKLEY\"}'),
(180, 'CARP ZOOM RADARFEJTARTÓ ÁLLVÁNY', 'Szonár vertikális tengelyének stabil rögzítése, radar kijelzőjének valós adatainak megjelenítéséhez.', 10990, 28, 11, 'resources/products/carp-zoom-radarfejtartó-állvány-bmashop.png', '{\"Méret\":\"82 cm\",\"Gyártó\":\"CARP ZOOM\"}'),
(181, 'DEEPER CHIRP+2 LIMITED EDITION ARTIC GREY', 'CHIRP+2 halradar nagy pontossággal, három frekvenciás érzékeléssel, kiemelkedő GPS-szel.', 139990, 28, 27, 'resources/products/deeper-chirp2-limited-edition-artic-grey-bmashop.png', '{\"Méret\":\"6.5 cm\",\"Gyártó\":\"DEEPER\"}'),
(182, 'DEEPER OKOSTELEFON RÖGZÍTŐ', 'Biztonságos szilikon állvány okostelefon rögzítéséhez, bármilyen típusú bottartóra.', 7190, 28, 16, 'resources/products/deeper-okostelefon-rögzítő-bmashop.png', '{\"Méret\":\"Univerzális\",\"Gyártó\":\"DEEPER\"}'),
(183, 'DEEPER QUEST TABLET & REMOTE CONTROLLER HOLDER', 'Tablet és távirányító tartó ergonomikus kialakítással, kompatibilis Deeper eszközökkel.', 39990, 28, 5, 'resources/products/deeper-quest-tablet-&-remote-controller-holder-bmashop.png', '{\"Méret\":\"Tablet-kompatibilis\",\"Gyártó\":\"DEEPER\"}'),
(184, 'DEEPER SMART FLEXY ARM 2.0', 'Rugalmas, univerzális kar csónakos halradar rögzítéséhez, 79 cm-es hosszal.', 28990, 28, 13, 'resources/products/deeper-smart-flexy-arm-20-bmashop.png', '{\"Méret\":\"max 79 cm\",\"Gyártó\":\"DEEPER\"}'),
(185, 'DEEPER SMART SONAR HOLDER FOR BAIT BOAT', 'Etetőhajóra rögzíthető tartó Deeper szonárokhoz, alumínium szár és mágneses rögzítés.', 18990, 28, 21, 'resources/products/deeper-smart-sonar-holder-for-bait-boat-bmashop.png', '{\"Méret\":\"26 cm × 10 cm\",\"Gyártó\":\"DEEPER\"}'),
(186, 'DEEPER SMART SONAR PRO', 'Wi-Fi kapcsolattal működő halradar, 80 m hatótávval és beépített GPS-szel.', 84990, 28, 17, 'resources/products/deeper-smart-sonar-pro-bmashop.png', '{\"Méret\":\"Ø 6.5 cm\",\"Gyártó\":\"DEEPER\"}'),
(187, 'DEEPER SMART SONAR PRO+ 2', '3 sugárfrekvenciás GPS-es halradar, 100 m hatótáv, hosszú akkumulátor-üzemidő.', 124990, 28, 27, 'resources/products/deeper-smart-sonar-pro-2-bmashop.png', '{\"Méret\":\"Ø 6.5 cm\",\"Gyártó\":\"DEEPER\"}'),
(188, 'BALZER ADRENALIN CAT LÁMPÁS', 'Kézi lámpa, amely akár nagyobb távolságra is világítható. Kampóval bárhová felakasztható.', 5790, 29, 9, 'resources/products/balzer-adrenalin-cat-lámpás-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(189, 'CARP ACADEMY FEJLÁMPA', 'Könnyű, praktikus fejlámpa 3 világítási fokozattal, éjszakai horgászatra.', 3990, 29, 30, 'resources/products/carp-academy-fejlámpa-bmashop.png', '{\"Gyártó\":\"CARP ACADEMY\"}'),
(190, 'CARP ACADEMY ION LED FEJLÁMPA', 'LED és COB kombinált fejlámpa újratölthető akkuval, állítható fényerővel.', 5590, 29, 5, 'resources/products/carp-academy-ion-led-fejlámpa-bmashop.png', '{\"Gyártó\":\"CARP ACADEMY\"}'),
(191, 'CARP ACADEMY WR AKKUS FEJLÁMPA', 'Beépített akkus LED fejlámpa, több világítási fokozattal és piros fény móddal.', 4490, 29, 13, 'resources/products/carp-academy-wr-akkus-fejlámpa-bmashop.png', '{\"Gyártó\":\"CARP ACADEMY\"}'),
(192, 'CARP ZOOM COB LED KEMPINGLÁMPA', 'COB LED-es kempinglámpa, hosszabb élettartamú, energiatakarékos világítással.', 7690, 29, 28, 'resources/products/carp-zoom-cob-led-kempinglámpa-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(193, 'CARP ZOOM COB LED SÁTORLÁMPA', 'Modern sátorlámpa COB LED-del, hosszú üzemidő, kempingezéshez és horgászathoz.', 4990, 29, 29, 'resources/products/carp-zoom-cob-led-sátorlámpa-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(194, 'CARP ZOOM COB LEDES KULCSTARTÓ', 'COB LED világítású kulcstartó, kompakt méretű, extra erős fényt biztosít.', 990, 29, 23, 'resources/products/carp-zoom-cob-ledes-kulcstartó-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(195, 'CARP ZOOM COMET TÖLTHETŐ KEMPINGLÁMPA', 'USB-ről tölthető LED lámpa, három világítási fokozattal, kampóval és akasztóval.', 11990, 29, 13, 'resources/products/carp-zoom-comet-tölthető-kempinglámpa-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(196, 'CARP ZOOM DIMMABLE SÁTORLÁMPA', 'Állítható fényerejű sátorlámpa, hosszú üzemidő, többféle világítási mód.', 4490, 29, 22, 'resources/products/carp-zoom-dimmable-sátorlámpa-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(197, 'BY DÖME TF SZERELÉKES DOBOZ SZETT', 'Rendszerezett horgászathoz ideális szett, 3 dobozzal a horgok, kapcsok, kiegészítők tárolásához.', 8490, 30, 33, 'resources/products/by-döme-tf-szerelékes-doboz-szett-bmashop.png', '{\"Gyártó\":\"BY DÖME\"}'),
(198, 'CARP ACADEMY BOX SZETT KÖZEPES', 'Közepes méretű szerelékes doboz 7 részes kivitelben, különálló tároló egységekkel.', 5690, 30, 38, 'resources/products/carp-academy-box-szett-közepes-bmashop.png', '{\"Gyártó\":\"CARP ACADEMY\"}'),
(199, 'CARP ACADEMY BOX SZETT NAGY', 'Nagy méretű doboz, 8 részes szett kisebb tárolókkal és előkétartóval.', 10490, 30, 48, 'resources/products/carp-academy-box-szett-nagy-bmashop.png', '{\"Gyártó\":\"CARP ACADEMY\"}'),
(200, 'CARP SPIRIT WATERPROOF BOX', 'Strapabíró, zárható vízálló doboz tömítőgyűrűvel, belső tálcával és fogantyúval.', 26500, 30, 25, 'resources/products/carp-spirit-waterproof-box-bmashop.png', '{\"Gyártó\":\"CARP SPIRIT\"}'),
(201, 'CARP ZOOMM 3 FAKKOS DOBOZ', '3 rekeszes műanyag szerelékes doboz univerzális felhasználásra.', 390, 30, 40, 'resources/products/carp-zoomm-3-fakkos-doboz-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(202, 'CARP ZOOM 4 FAKKOS DOBOZ', '4 rekeszes, praktikus és tartós műanyag horgászdoboz.', 390, 30, 42, 'resources/products/carp-zoom-4-fakkos-doboz-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(203, 'CARP ZOOM 5 IN 1 SZERELÉKES DOBOZ', '5 az 1-ben doboz szett különálló rekeszekkel és átlátszó fedéllel.', 3490, 30, 33, 'resources/products/carp-zoom-5-in-1-szerelékes-doboz-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(204, 'CARP ZOOM 8 FAKKOS DOBOZ', '8 fakkos kompakt horgászdoboz, strapabíró műanyagból.', 390, 30, 37, 'resources/products/carp-zoom-8-fakkos-doboz-bmashop.png', '{\"Gyártó\":\"CARP ZOOM\"}'),
(205, 'Balzer Harcsás Csörgős Kapásjelző', 'Extra hangos csörgős kapásjelző, szilikonbevonattal a blank védelméért. Világítópatron is elhelyezhető.', 2790, 31, 38, 'resources/products/balzer-harcsás-csörgős-kapásjelző-bmashop.png', '{\"Vízálló\":\"nem\",\"Gyártó\":\"BALZER\"}'),
(206, 'By Döme Team Feeder Elektromos Feeder Kapásjelző', 'Feedereseknek készült, két hangszín, hátul LED világítás, 3 db AAA elemmel működik.', 6490, 31, 15, 'resources/products/by-döme-team-feeder-elektromos-feeder-kapásjelző-bmashop.png', '{\"Vízálló\":\"igen\",\"Gyártó\":\"BY DÖME\"}'),
(207, 'By Döme Team Feeder Elektromos Kapásjelző Szett 2+1', 'Elektromos szett 150 méteres hatótávval. Állítható hangerő, érzékenység, éjszakai fény.', 38990, 31, 13, 'resources/products/by-döme-team-feeder-elektromos-kapásjelző-szett-21-bmashop.png', '{\"Vízálló\":\"igen\",\"Gyártó\":\"BY DÖME\"}'),
(208, 'By Döme Tornado Feeder Elektromos Kapásjelző', 'Kompakt feeder kapásjelző automatikus éjszakai fénnyel. Hangszín, érzékenység állítható.', 6990, 31, 10, 'resources/products/by-döme-tornado-feeder-elektromos-kapásjelző-bmashop.png', '{\"Vízálló\":\"igen\",\"Gyártó\":\"BY DÖME\"}'),
(209, 'By Döme Tornado Feeder Elektromos Kapásjelző Szett 2+1', 'Tornado szett feeder horgászoknak, automatikus fényérzékeléssel és kompakt vevőegységgel.', 39900, 31, 10, 'resources/products/by-döme-tornado-feeder-elektromos-kapásjelző-szett-21-bmashop.png', '{\"Vízálló\":\"igen\",\"Gyártó\":\"BY DÖME\"}'),
(210, 'Carp Academy Basic Swinger Összes', 'Swinger állítható súllyal és zsinórklipsszel. Több színben elérhető.', 1190, 31, 18, 'resources/products/carp-academy-basic-swinger-összes-bmashop.png', '{\"Vízálló\":\"nem\",\"Gyártó\":\"CARP ACADEMY\"}'),
(211, 'Carp Academy Detect Jelző', 'Modern LED-es kapásjelző állítható hangerővel és érzékenységgel, vízálló kivitel.', 4590, 31, 13, 'resources/products/carp-academy-detect-jelző-bmashop.png', '{\"Vízálló\":\"igen\",\"Gyártó\":\"CARP ACADEMY\"}'),
(212, 'Carp Academy Detect WS 2+1', 'Professzionális szett 250 m hatótávval, energiatakarékos LED-ekkel.', 35990, 31, 27, 'resources/products/carp-academy-detect-ws-21-bmashop.png', '{\"Vízálló\":\"igen\",\"Gyártó\":\"CARP ACADEMY\"}'),
(213, 'FOX Carp Hooks Curve Shank 2', 'Középkedvelt horog, ívelt szárral és mikro szakállal.', 1590, 32, 38, 'resources/products/fox-carp-hooks-curve-shank-2-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(214, 'FOX Carp Hooks Curve Shank 4', 'Középkedvelt horog, ívelt szárral és mikro szakállal.', 1590, 32, 15, 'resources/products/fox-carp-hooks-curve-shank-4-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(215, 'FOX Carp Hooks Curve Shank 6', 'Középkedvelt horog, ívelt szárral és mikro szakállal.', 1590, 32, 44, 'resources/products/fox-carp-hooks-curve-shank-6-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(216, 'FOX Carp Hooks Curve Shank Short 2', 'Rövid szárú horog ívelt formával, mikro szakállal.', 1590, 32, 40, 'resources/products/fox-carp-hooks-curve-shank-short-2-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(217, 'FOX Carp Hooks Curve Shank Short 4', 'Rövid szárú horog ívelt formával, mikro szakállal.', 1590, 32, 87, 'resources/products/fox-carp-hooks-curve-shank-short-4-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(218, 'FOX Carp Hooks Curve Shank Short 6', 'Rövid szárú horog ívelt formával, mikro szakállal.', 1590, 32, 66, 'resources/products/fox-carp-hooks-curve-shank-short-6-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(219, 'FOX Carp Hooks Wide Gape 2', 'Erős és széles öblű horog extra heggyel.', 1590, 32, 73, 'resources/products/fox-carp-hooks-wide-gape-2-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(220, 'FOX Carp Hooks Wide Gape 4', 'Erős és széles öblű horog extra heggyel.', 1590, 32, 34, 'resources/products/fox-carp-hooks-wide-gape-4-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(221, 'FOX Carp Hooks Wide Gape 6', 'Erős és széles öblű horog extra heggyel.', 1590, 32, 13, 'resources/products/fox-carp-hooks-wide-gape-6-bmashop.png', '{\"Gyártó\":\"FOX\"}'),
(222, 'Balzer Adrenalin Cat Hármas Horog 1/0', 'Erős hármashorog harcsa horgászathoz, kiváló akadással.', 3890, 33, 61, 'resources/products/balzer-adrenalin-cat-hármas-horog-10-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(223, 'Balzer Adrenalin Cat Hármas Horog 2/0', 'Erős hármashorog harcsa horgászathoz, kiváló akadással.', 4590, 33, 69, 'resources/products/balzer-adrenalin-cat-hármas-horog-20-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(224, 'Balzer Adrenalin Cat Hármas Horog 3/0', 'Erős hármashorog harcsa horgászathoz, kiváló akadással.', 5290, 33, 17, 'resources/products/balzer-adrenalin-cat-hármas-horog-30-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(225, 'Balzer Adrenalin Cat Horog 4/0', 'Erős egyágú horog nagy harcsákhoz, extrém körülményekhez.', 1690, 33, 85, 'resources/products/balzer-adrenalin-cat-horog-40-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(226, 'Balzer Adrenalin Cat Horog 6/0', 'Erős egyágú horog nagy harcsákhoz, extrém körülményekhez.', 2290, 33, 69, 'resources/products/balzer-adrenalin-cat-horog-60-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(227, 'Balzer Adrenalin Catfish Hook 3/0', 'Ezüst színű, vastag húsú egyágú horog harcsára.', 3490, 33, 80, 'resources/products/balzer-adrenalin-catfish-hook-30-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(228, 'Balzer Adrenalin Catfish Hook 4/0', 'Ezüst színű, vastag húsú egyágú horog harcsára.', 3990, 33, 60, 'resources/products/balzer-adrenalin-catfish-hook-40-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(229, 'Balzer Adrenalin Catfish Hook 5/0', 'Ezüst színű, vastag húsú egyágú horog harcsára.', 4490, 33, 19, 'resources/products/balzer-adrenalin-catfish-hook-50-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(230, 'Balzer Előkötött Horog Zander 80 0,22mm 4', 'Egyenes hegyű süllőző horog, előkötve.', 990, 33, 53, 'resources/products/balzer-előkötött-horog-zander-80-0,22mm-4-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(231, 'Balzer Előkötött Horog Zander 80 0,25mm 2', 'Egyenes hegyű süllőző horog, előkötve.', 990, 33, 34, 'resources/products/balzer-előkötött-horog-zander-80-0,25mm-2-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(232, 'Balzer Előkötött Horog Zander 80 0,28mm 1', 'Egyenes hegyű süllőző horog, előkötve.', 990, 33, 24, 'resources/products/balzer-előkötött-horog-zander-80-0,28mm-1-bmashop.png', '{\"Gyártó\":\"BALZER\"}'),
(233, 'Gamakatsu A1 Team Feeder Circle Power 6', 'Kerekített horog feederhorgászathoz, visszatartott formával.', 1190, 34, 46, 'resources/products/gamakatsu-a1-team-feeder-circle-power-6-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(234, 'Gamakatsu A1 Team Feeder Circle Power 8', 'Kerekített horog feederhorgászathoz, visszatartott formával.', 1190, 34, 66, 'resources/products/gamakatsu-a1-team-feeder-circle-power-8-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(235, 'Gamakatsu A1 Team Feeder Circle Power 10', 'Kerekített horog feederhorgászathoz, visszatartott formával.', 1190, 34, 53, 'resources/products/gamakatsu-a1-team-feeder-circle-power-10-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(236, 'Gamakatsu A1 Team Feeder Circle Power 12', 'Kerekített horog feederhorgászathoz, visszatartott formával.', 1190, 34, 55, 'resources/products/gamakatsu-a1-team-feeder-circle-power-12-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(237, 'Gamakatsu A1 Team Feeder Carp Feeder 6', 'Feeder típusú horog, rövid szárral, éles heggyel, különösen pontyhorgászatra ajánlott.', 1590, 34, 43, 'resources/products/gamakatsu-a1-team-feeder-carp-feeder-6-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(238, 'Gamakatsu A1 Team Feeder Carp Feeder 8', 'Feeder típusú horog, rövid szárral, éles heggyel, különösen pontyhorgászatra ajánlott.', 1490, 34, 95, 'resources/products/gamakatsu-a1-team-feeder-carp-feeder-8-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(239, 'Gamakatsu A1 Team Feeder Carp Feeder 10', 'Feeder típusú horog, rövid szárral, éles heggyel, különösen pontyhorgászatra ajánlott.', 1390, 34, 88, 'resources/products/gamakatsu-a1-team-feeder-carp-feeder-10-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(240, 'Gamakatsu A1 Team Feeder Carp Feeder 12', 'Feeder típusú horog, rövid szárral, éles heggyel, különösen pontyhorgászatra ajánlott.', 1390, 34, 17, 'resources/products/gamakatsu-a1-team-feeder-carp-feeder-12-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}'),
(241, 'Gamakatsu A1 Team Feeder Carp Feeder 14', 'Feeder típusú horog, rövid szárral, éles heggyel, különösen pontyhorgászatra ajánlott.', 1390, 34, 85, 'resources/products/gamakatsu-a1-team-feeder-carp-feeder-14-bmashop.png', '{\"Gyártó\":\"Gamakatsu\"}');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `Id` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `PasswordHash` blob NOT NULL,
  `PasswordSalt` blob NOT NULL,
  `CreatedAt` varchar(19) DEFAULT date_format(current_timestamp(),'%Y-%m-%d'),
  `ProfileImage` varchar(255) DEFAULT NULL,
  `Bio` text DEFAULT NULL,
  `Role` enum('Adminisztrátor','Felhasználó','Moderátor') DEFAULT 'Felhasználó'
) ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`Id`, `Username`, `Email`, `PasswordHash`, `PasswordSalt`, `CreatedAt`, `ProfileImage`, `Bio`, `Role`) VALUES
(1, 'admin', 'admin@bmashop.com', 0xc66e62e6a9f4086e794dadaeebdce5fdde0216e739007b40a542aac636c3cb28a3d605edf8805c4a84f789c2b63ab5196c28a52ea8af5a8967c8c40115351074, 0x57f9747b93b196954649df119a2efebd135b3443f4e580d090c69394574c3c8228bf4f104f0a739dcdd878b8cbe9b5b9cde01517baad708b9af9826fda44beadf22c0d1a5e37cbe2090f7c404bf337638391574002a6f2dcf1e2c341e9b7448623a4663589eaa7cbbe98d924b1857701b4328524153f2b6c4c8482d979b87985, '2025-02-01 07:24:13', 'resources/users/user.svg', 'Adminisztrátor a horgászbolt számára.', 'Adminisztrátor'),
(2, 'pecas_viki', 'szandi7@gmail.com', 0xa57f2d8ea1feba18dd24ccf0cb787fbca7123b2957c9efe450784f277fd1d80c70e779ac85772c99f705480715f46cddc90b94b5a5776bc62ffdbb107ec0d7e1, 0xdee0b6e00015f466d0c3f73187c57c2a1c3865d0f26b4cd3363f97596d08bb0d15305fc4d2937cf7bfae3acd0fb932c9dd5c8ec54490964bddc22f5dad2a95815813be7ea837d000462732acbe9797b76486c0807231799eed9a4670deb4e7d587c748bcb107779dba44c56179d82ac929feea29d7f916e1c1a5ea5baf785a3e, '2025-02-01 07:54:36', 'resources/users/pecas_viki.jpg', 'Fishing\nZéti 22.11.27.', 'Felhasználó'),
(3, 'pecas_bence', 'horvath7@gmail.com', 0x7916f23d88dc9c8cf12404aefbb710586f3d22360c80429bcf07113b4b7436d713db806a7907b218729c93b469eb7f18b489bc7c80709dc662cbf943ec939f93, 0x48fe3ef4e537a3f3989406ac8fd16bed863c23ad1357e3aefffa77f9d7a3a6b2b4f67bc3f9192b5c8b6bec8697174166f8ee972577a478d00ddf9d753dbbbe226ca0cea5f7446bac5360917cc4fa78a67f08dadd306ad5462e02746775e8dffbbbf9cd2938e5aae577d55bdc6735e12d4b0f4e53230e7c4f133f5fb11fb8ad49, '2025-02-01 07:55:14', 'resources/users/pecas_bence.jpg', 'Fishing\nHope Bait\nHungary', 'Felhasználó'),
(4, 'moderator', 'moderator@bmashop.com', 0x30a73cfc36c6393a70f8574517c49a8a2689a8082c9c30d7c040ea917074935a0741e6351095f6417a06b3deebfc85f9dc9629502f5458e3be3577ffb0fa8682, 0x85747f28ef1f11612e164d26959e812ff4e6f54af3237eda614ca2654bcd48b2f45f5cd30f58b0a2731450e5a246f6cb3602e200705db08613728ea2acea004547ab88ddce6f8f7d717ad5ce2d60ff42b30a58312d65a223246f3a2ac1bbe3d2b1adaea8b31f777ef6e1b386509ce89f046dae272a650db046a51f4c76a7c2b1, '2025-02-01 07:56:25', 'resources/users/user.svg', '', 'Moderátor'),
(5, 'pecas_balazs', 'bbalazsdaniel@gmail.com', 0x56fff63770350686cb034f0ec70df011f3307ff9fdfde645c78d9d0d7bdb9f5ab5363f2e4a2d5a353788509e6fbf1a008e615ae54ae792473de337417c8a763c, 0xbc6bf3e10b3c4d01294c7f6796266f19fd76850c89223cbdba5514f92a925208555462fd592a907aaf88c8ed4c3913f8e588bb9d9bc26c826bcacd3de96d3c5b7aa22dee19f1a66265e356f137d7fddd8d4656e8cebbf5be4eadb4c37e6a795c7a5cdcb2d498fb0700589aff70c240b1399aac344df5d850c336337d6219e78d, '2025-02-01 05:57:03', 'resources/users/user.svg', '', 'Felhasználó'),
(7, 'pecas_adam', 'padam@gmail.com', 0xc432c227d00e58f387ff42ea659751a1738eb63a77abb0af847be21720b877f6a98d147312127c18cdfccef94b193bd9598f85d7b58aea73dfcccf2f46256572, 0xf41998d5e7ef195f61b06f1eb8916b9bb2be972c79d4772c6f30fadd1c3d90a187a948e1fa890cc49afa1df3c95fff5ac32978bcab3955ccbeeb485d29236fe6340139f98bd9ccfe72ccc591aeaf5676af31a2a4b74480d8284466a2ef9e4faec108de40cbbd3538a06b8990d65dd9a9e0d8dee4743f36c0bd7197634a1543d3, '2025-02-01 05:58:08', 'resources/users/user.svg', '', 'Felhasználó'),
(8, 'pecas_marci', 'hmarcell@gmail.com', 0x4afc5d222dc3322fd2ed5ba5a246abe72d921328317e978194d8f23d185c09104f2ec988cde99f40da91b14e89cb2f24835e8bf41c63e10ad153358c78cd948e, 0x5d960a414b6d88985bdb3f134d71da922795fb600abda0eb5d831c6ab3e2f871306a215621c8a791036f805092858d24bcaebb259f16f16737c08760c6499e3eb43dae11985f0f2e146f8a205d7e878f6d37a968203fe7ed0388588756e1c30d86a90a15383e2ee88ecc9ce11ef1fc2e00f94d3843908624adc136e72af33c02, '2025-02-01 05:58:50', 'resources/users/user.svg', '', 'Felhasználó');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cartitems`
--
ALTER TABLE `cartitems`
  ADD PRIMARY KEY (`UserId`,`ProductId`),
  ADD KEY `ProductId` (`ProductId`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Name` (`Name`),
  ADD KEY `ParentId` (`ParentId`);

--
-- Indexes for table `commentlikes`
--
ALTER TABLE `commentlikes`
  ADD PRIMARY KEY (`UserId`,`CommentId`),
  ADD KEY `CommentId` (`CommentId`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `PostId` (`PostId`),
  ADD KEY `UserId` (`UserId`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`UserId`,`ProductId`),
  ADD KEY `ProductId` (`ProductId`);

--
-- Indexes for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD PRIMARY KEY (`OrderId`,`ProductId`),
  ADD KEY `ProductId` (`ProductId`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `PayPalTransactionId` (`PayPalTransactionId`),
  ADD KEY `UserId` (`UserId`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `UserId` (`UserId`);

--
-- Indexes for table `productreviews`
--
ALTER TABLE `productreviews`
  ADD PRIMARY KEY (`ProductId`,`UserId`),
  ADD KEY `UserId` (`UserId`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `CategoryId` (`CategoryId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=242;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cartitems`
--
ALTER TABLE `cartitems`
  ADD CONSTRAINT `cartitems_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`),
  ADD CONSTRAINT `cartitems_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `products` (`Id`);

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`ParentId`) REFERENCES `categories` (`Id`) ON DELETE SET NULL;

--
-- Constraints for table `commentlikes`
--
ALTER TABLE `commentlikes`
  ADD CONSTRAINT `commentlikes_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`),
  ADD CONSTRAINT `commentlikes_ibfk_2` FOREIGN KEY (`CommentId`) REFERENCES `comments` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`PostId`) REFERENCES `posts` (`Id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`);

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`),
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `products` (`Id`);

--
-- Constraints for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD CONSTRAINT `orderitems_ibfk_1` FOREIGN KEY (`OrderId`) REFERENCES `orders` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orderitems_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `products` (`Id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`);

--
-- Constraints for table `productreviews`
--
ALTER TABLE `productreviews`
  ADD CONSTRAINT `productreviews_ibfk_1` FOREIGN KEY (`ProductId`) REFERENCES `products` (`Id`),
  ADD CONSTRAINT `productreviews_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`CategoryId`) REFERENCES `categories` (`Id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
