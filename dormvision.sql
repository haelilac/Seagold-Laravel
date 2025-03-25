-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2025 at 01:32 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.3.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dormvision`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `facebook_profile` varchar(255) DEFAULT NULL,
  `contact_number` varchar(255) NOT NULL,
  `occupation` varchar(255) DEFAULT NULL,
  `check_in_date` datetime NOT NULL,
  `duration` int(11) NOT NULL,
  `reservation_details` text DEFAULT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `id_type` enum('Postal ID','UMID','National ID','Passport','Driver''s License','Philhealth ID','School ID','Voter''s ID/ Voter''s Certification','PRC ID') NOT NULL,
  `valid_id` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `set_price` decimal(10,2) DEFAULT NULL,
  `house_number` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `barangay` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `zip_code` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`id`, `last_name`, `first_name`, `middle_name`, `birthdate`, `email`, `facebook_profile`, `contact_number`, `occupation`, `check_in_date`, `duration`, `reservation_details`, `unit_id`, `id_type`, `valid_id`, `status`, `created_at`, `updated_at`, `set_price`, `house_number`, `street`, `barangay`, `city`, `province`, `zip_code`) VALUES
(27, '', '', NULL, NULL, 'friskysoda1001@gmail.com', NULL, '099999999', 'Student', '2025-01-04 19:00:00', 10, 'CF-3', NULL, 'Postal ID', 'uploads/valid_ids/GCv6Mwmp1QGRAtVm9rHQYLSH4UahFlbaGTB9KArY.png', 'Accepted', '2024-12-13 02:41:47', '2024-12-13 02:42:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(28, '', '', NULL, NULL, 'hernandezkc.tenant@gmail.com', NULL, '09288723266', 'Student', '2025-01-06 07:00:00', 3, 'DAC-1', NULL, 'Postal ID', 'uploads/valid_ids/IUBx0oFREqljfjgfyxjZlRMF108oYrKKABOmnKjp.jpg', 'Accepted', '2024-12-20 07:21:59', '2024-12-20 07:26:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(56, 'Bolok', 'Shana', 'Tasico', '2002-07-02', 'bolokshana.tenant@gmail.com', 'https://www.facebook.com/elalala1012/', '9517764536', 'Student', '2025-03-28 15:00:00', 2, 'CF-4', 5, 'Postal ID', 'uploads/valid_ids/JYe89pTY5XNIOJQlJ83cqPqqhia86xjzD4QOLA7k.jpg', 'Accepted', '2025-03-20 07:35:23', '2025-03-20 07:53:19', 4000.00, '166', 'Libis', 'Rosario', 'Rodriguez', 'Rizal', '1860');

-- --------------------------------------------------------

--
-- Table structure for table `booked_tour`
--

CREATE TABLE `booked_tour` (
  `id` int(11) NOT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `num_visitors` int(11) NOT NULL,
  `date_booked` date DEFAULT NULL,
  `time_slot` varchar(255) NOT NULL,
  `status` varchar(50) DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booked_tour`
--

INSERT INTO `booked_tour` (`id`, `user_email`, `name`, `phone_number`, `num_visitors`, `date_booked`, `time_slot`, `status`) VALUES
(10, 'hernandezkc.tenant@gmail.com', 'KC', '09288723266', 7, '2025-01-01', '10:00 AM', 'Pending'),
(12, 'katermita.tenant@gmail.com', 'katss', '09288723266', 1, '2025-01-01', '02:00 PM', 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `date`, `title`, `description`, `created_at`, `updated_at`) VALUES
(5, '2025-01-05', 'Test 3', 'ccccccccccccccccccccc', '2024-12-26 07:57:28', '2024-12-26 07:57:28');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `emoji_rating` enum('in-love','happy','neutral','sad','angry') NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `user_email`, `emoji_rating`, `comment`, `created_at`, `updated_at`) VALUES
(1, NULL, 'happy', 'Keri na', '2025-01-04 19:13:20', '2025-01-04 19:13:20'),
(2, NULL, 'in-love', 'Cute', '2025-01-04 19:22:34', '2025-01-04 19:22:34');

-- --------------------------------------------------------

--
-- Table structure for table `gallery`
--

CREATE TABLE `gallery` (
  `id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gallery`
--

INSERT INTO `gallery` (`id`, `image_path`, `title`, `description`, `category`, `created_at`, `updated_at`) VALUES
(2, 'gallery/Nh92OQk4tumCCQmb4PkXdZhgtISkLsyI0rJ1uFxe.png', NULL, NULL, 'HALLWAY', '2025-01-04 06:13:01', '2025-01-04 06:13:01');

-- --------------------------------------------------------

--
-- Table structure for table `guest_user`
--

CREATE TABLE `guest_user` (
  `user_email` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `visit_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `guest_user`
--

INSERT INTO `guest_user` (`user_email`, `name`, `date_of_birth`, `gender`, `password`, `visit_count`) VALUES
('bolokshana.tenant@gmail.com', 'Shana Bolok', NULL, NULL, '$2y$12$bZPiMn9hE4Hlba3KPsYIduRbHMUn2P13X1t1pzAsWxNa8EiXOLaWu', 3),
('friskysoda1001@gmail.com', 'Shana Bolokk', '2002-07-11', 'Female', '$2y$12$IEIQ5ZAsGYGpK/zUmhl2NeYqzApfRN7gqIvcAvj3u4uqAPYNcbSb2', 0),
('girondudut92@gmail.com', 'Jiro Giron', '2008-02-06', 'Male', '$2y$12$z6PdJO31LPJSM7qKKMSKketEUxbQjogS7S0ZFKAiSVdYP2DoRSu0.', 0),
('hernandezkc.tenant@gmail.com', NULL, NULL, NULL, '', 5),
('katermita.tenant@gmail.com', 'Kat Ermitaaaa', '2002-02-02', 'Female', '$2y$12$OhdKk2Ed7XOloSGwKY3lVOSf4Hwi/devn/vQVWzwM/LPD6VmK2d1G', 2),
('shanacarmellabolok@gmail.com', 'Shanaaaa', '2002-07-05', 'Female', '$2y$12$Vn0GMMtzuzKl4eOzkOyC3.BvJDefXnXNhUcjrmtEpTdSM40XMlnfC', 1);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_requests`
--

CREATE TABLE `maintenance_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `description` text NOT NULL,
  `status` enum('pending','in_progress','completed','canceled','rejected','scheduled') DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `schedule` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `maintenance_requests`
--

INSERT INTO `maintenance_requests` (`id`, `user_id`, `description`, `status`, `file_path`, `created_at`, `updated_at`, `schedule`) VALUES
(6, 7, 'Test sa image', 'pending', NULL, '2024-12-14 03:07:22', '2024-12-14 03:07:22', NULL),
(7, 7, 'Ulit test sa image if papasok sa database', 'completed', NULL, '2024-12-14 03:28:56', '2024-12-14 23:17:51', NULL),
(9, 7, 'Di ko na alammmm', 'pending', NULL, '2024-12-14 05:48:45', '2024-12-14 05:48:45', NULL),
(14, 7, 'axzxsaxaxx', 'pending', NULL, '2024-12-14 05:53:18', '2024-12-14 05:53:18', NULL),
(15, 7, 'mmmmmmmmmmmmmmmmmmmm', 'pending', NULL, '2024-12-14 05:53:48', '2024-12-14 05:53:48', NULL),
(17, 27, 'Hiiii', 'scheduled', NULL, '2024-12-14 23:30:41', '2024-12-14 23:59:06', NULL),
(18, 27, 'test schedulea', 'scheduled', NULL, '2024-12-15 00:04:57', '2024-12-15 00:05:42', NULL),
(19, 27, 'bbbbbbbbbbbbbbbbb', 'scheduled', NULL, '2024-12-15 00:17:58', '2024-12-15 00:18:51', NULL),
(21, 27, 'ddddddddddddddddd', 'scheduled', NULL, '2024-12-15 00:31:45', '2024-12-15 00:45:24', '2024-12-15 17:45:00'),
(22, 27, 'eeeeeeeeeeeeeeeeeee', 'scheduled', NULL, '2024-12-15 00:55:19', '2024-12-15 21:30:04', '2024-12-21 13:29:00'),
(23, 27, 'Test Maintenance Request', 'pending', NULL, '2024-12-16 02:51:38', '2024-12-16 02:51:38', NULL),
(24, 27, 'ffffffffffffffffffff', 'pending', NULL, '2024-12-16 03:27:52', '2024-12-16 03:27:52', NULL),
(25, 27, 'ggggggggggggggg', 'pending', NULL, '2024-12-16 03:38:36', '2024-12-16 03:38:36', NULL),
(28, 27, 'Eto na talaga', 'scheduled', 'maintenance_uploads/ioVNaKxFX6YExWrCKMYbbbcUFldxwKLzNKqezFoh.png', '2024-12-16 03:43:55', '2024-12-16 04:40:11', '2024-12-30 20:40:00');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_11_06_064927_create_personal_access_tokens_table', 1),
(5, '2024_11_06_065820_add_role_to_users_table', 1),
(6, '2024_11_06_083615_add_is_admin_to_users_table', 1),
(7, '2024_11_06_090735_add_role_to_users_table', 1),
(8, '2014_10_12_000000_create_users_table', 1),
(9, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(10, '2019_08_19_000000_create_failed_jobs_table', 1),
(11, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(12, '2024_11_12_153343_add_role_to_users_table', 2),
(13, '2024_11_12_153833_add_role_to_users_table', 2),
(14, '2024_11_28_112633_create_applications_table', 2),
(15, '2024_11_28_145349_add_email_and_valid_id_to_applications_table', 3),
(16, '2024_11_28_151029_add_email_and_valid_id_to_applications_table', 4),
(17, '2024_12_02_053838_create_units_table', 5),
(19, '2024_12_11_052335_create_maintenance_requests_table', 6),
(20, '2024_12_11_090748_add_unit_id_to_users_table', 7),
(21, '2024_12_11_134146_add_unit_code_and_role_to_users_table', 8),
(24, '2024_12_11_142945_add_unit_id_to_applications_table', 9);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `created_at`, `updated_at`) VALUES
(1, 27, 'Payment Reminder', 'Your payment is due on 2025-02-04. Please pay promptly to avoid penalties.', '', 0, '2024-12-16 20:27:06', '2024-12-16 20:27:06'),
(2, 27, 'Payment Reminder', 'Your payment is due on 2025-02-04. Please pay promptly to avoid penalties.', '', 0, '2024-12-16 20:46:39', '2024-12-16 20:46:39'),
(3, 27, 'Payment Reminder', 'Your payment is due on 2025-02-04. Please pay promptly to avoid penalties.', '', 0, '2024-12-16 21:07:57', '2024-12-16 21:07:57'),
(4, 27, 'Payment Reminder', 'Your payment is due on 2025-02-04. Please pay promptly to avoid penalties.', '', 0, '2024-12-16 21:17:29', '2024-12-16 21:17:29'),
(5, 27, 'Payment Reminder', 'Your payment is due on 2025-02-04. Please pay promptly to avoid penalties.', '', 0, '2024-12-16 21:22:19', '2024-12-16 21:22:19'),
(6, 27, 'Payment Reminder', 'Your payment is due on 2025-02-04. Please pay promptly to avoid penalties.', '', 0, '2024-12-16 21:25:35', '2024-12-16 21:25:35'),
(7, 27, 'Payment Reminder', 'Your payment is due on 2025-02-04. Please pay promptly to avoid penalties.', '', 0, '2024-12-16 21:36:21', '2024-12-16 21:36:21'),
(8, 27, 'Payment Reminder', 'Your payment is due on 2024-12-25. Submit before the due date!', '', 0, '2024-12-21 23:36:02', '2024-12-21 23:36:02'),
(9, 28, 'Payment Reminder', 'Your payment is due on 2024-12-25. Submit before the due date!', '', 0, '2024-12-21 23:36:08', '2024-12-21 23:36:08'),
(12, 27, 'Upcoming Payment Reminder', 'Your payment is due on 2024-12-25. Submit it before the due date!', '', 0, '2024-12-21 23:45:25', '2024-12-21 23:45:25'),
(13, 28, 'Upcoming Payment Reminder', 'Your payment is due on 2024-12-25. Submit it before the due date!', '', 0, '2024-12-21 23:45:30', '2024-12-21 23:45:30'),
(17, 7, 'New Tour Booking', 'A new booking has been made by KC for 2025-01-01 at 10:00 AM.', '', 0, '2025-01-02 17:51:48', '2025-01-02 17:51:48'),
(19, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-03 05:56:07', '2025-01-03 05:56:07'),
(20, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-03 06:07:22', '2025-01-03 06:07:22'),
(21, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-03 06:16:22', '2025-01-03 06:16:22'),
(22, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-03 07:36:12', '2025-01-03 07:36:12'),
(23, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-03 07:55:46', '2025-01-03 07:55:46'),
(25, 7, 'New Tour Booking', 'A new booking has been made by KC for 2025-01-01 at 03:00 PM.', '', 0, '2025-01-05 09:11:20', '2025-01-05 09:11:20'),
(26, 7, 'New Tour Booking', 'A new booking has been made by katss for 2025-01-01 at 02:00 PM.', '', 0, '2025-01-05 09:51:40', '2025-01-05 09:51:40'),
(27, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-06 04:37:43', '2025-01-06 04:37:43'),
(28, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-06 04:37:50', '2025-01-06 04:37:50'),
(29, 7, 'New Maintenance Request', 'New maintenance request from Shana Bolok (Unit: FAC-2).', '', 0, '2025-01-06 04:37:51', '2025-01-06 04:37:51');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_type` varchar(50) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `receipt_path` varchar(255) DEFAULT NULL,
  `status` enum('pending','confirmed','partially paid','rejected') NOT NULL DEFAULT 'pending',
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `receipt` varchar(255) DEFAULT NULL,
  `payment_period` date NOT NULL,
  `remaining_balance` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 4, 'auth_token', 'd0b7dc7f997bc493dc34c0477a393f8cbbe2e68c6f5eb03e9e8e1f785ba7f78a', '[\"*\"]', NULL, NULL, '2024-11-12 08:27:01', '2024-11-12 08:27:01'),
(2, 'App\\Models\\User', 5, 'auth_token', '7b17d90b3574e7d6dc877234deb54347bba7f3265292ecf035ffd34c4416def7', '[\"*\"]', NULL, NULL, '2024-11-12 08:54:38', '2024-11-12 08:54:38'),
(3, 'App\\Models\\User', 4, 'auth_token', 'a3bc1aba6f1508e2748233c68a2e554a9e816e3a9608e856c5c0f0004db8add5', '[\"*\"]', NULL, NULL, '2024-11-12 08:55:18', '2024-11-12 08:55:18'),
(4, 'App\\Models\\User', 7, 'auth_token', '2c6d9308e23760b6dfddf411b076effef0e6a3062942d37bb085b2f8ea18f1d1', '[\"*\"]', '2024-11-12 09:07:51', NULL, '2024-11-12 08:58:02', '2024-11-12 09:07:51'),
(5, 'App\\Models\\User', 5, 'auth_token', 'adbdc058ea887dfad6f4d1bb8b59b6aed619561f7d0f8c6cede6eb20c902c5bb', '[\"*\"]', '2024-11-12 09:08:36', NULL, '2024-11-12 09:08:33', '2024-11-12 09:08:36'),
(6, 'App\\Models\\User', 5, 'auth_token', '445cb5f33103e621c9fec1768968a5033fa09493bca5bc3a3cdcb56e89f0fa7c', '[\"*\"]', '2024-11-12 09:12:38', NULL, '2024-11-12 09:12:35', '2024-11-12 09:12:38'),
(7, 'App\\Models\\User', 7, 'auth_token', '8711a3426b05c9532ddffa4c11361258f46410c9e9a0fb7b93e89a1b49071686', '[\"*\"]', '2024-11-12 09:14:25', NULL, '2024-11-12 09:14:23', '2024-11-12 09:14:25'),
(8, 'App\\Models\\User', 7, 'auth_token', '25115f52d4ee3433f3d93126ae7ae4ed27da4196fa31ddeb3e0290e99815c98a', '[\"*\"]', NULL, NULL, '2024-11-12 09:19:51', '2024-11-12 09:19:51'),
(9, 'App\\Models\\User', 7, 'auth_token', '6bd7b34ead3b499107e5d2694082475cff1f8420dda2efa8fc7b27456a21827c', '[\"*\"]', NULL, NULL, '2024-11-17 05:21:51', '2024-11-17 05:21:51'),
(10, 'App\\Models\\User', 7, 'auth_token', '1594e5d91f9ad80292de363e672b00491c3bb4e1fbbb79dcc3f2e008e47f37d1', '[\"*\"]', NULL, NULL, '2024-11-17 05:21:56', '2024-11-17 05:21:56'),
(11, 'App\\Models\\User', 5, 'auth_token', '3eb3a4d71a51d3275c271d78692400a85900ed477df9fd22873d2f0b2bcdbfd7', '[\"*\"]', '2024-11-17 05:22:44', NULL, '2024-11-17 05:22:41', '2024-11-17 05:22:44'),
(12, 'App\\Models\\User', 5, 'auth_token', '05e4df5f5914f306055374f4f66ddd9d337636d51bd9c37b8dd7f3921a5b6fb1', '[\"*\"]', '2024-11-17 06:27:07', NULL, '2024-11-17 06:27:01', '2024-11-17 06:27:07'),
(13, 'App\\Models\\User', 5, 'auth_token', '9c10cff99849097643fb59c4f7c776032b3f650fc5a00c08e3314249bbb275c6', '[\"*\"]', NULL, NULL, '2024-11-17 06:27:03', '2024-11-17 06:27:03'),
(14, 'App\\Models\\User', 5, 'auth_token', '9e4fd122c9d6ff7e47d83ecdd5489d8900c6ebd7d6733908b325d94a6bd86688', '[\"*\"]', NULL, NULL, '2024-11-17 06:27:03', '2024-11-17 06:27:03'),
(15, 'App\\Models\\User', 5, 'auth_token', 'd270a4bd5827f54c08ffc9ee45b016f4a236fcd51b78fc09d191ee9e91ab3dfe', '[\"*\"]', NULL, NULL, '2024-11-17 06:27:04', '2024-11-17 06:27:04'),
(16, 'App\\Models\\User', 5, 'auth_token', 'd6d28a49bae44001a9871e93651c63da6778171a695da62f4fc1d1a757bde09f', '[\"*\"]', NULL, NULL, '2024-11-17 06:27:05', '2024-11-17 06:27:05'),
(17, 'App\\Models\\User', 7, 'auth_token', 'f9565a77abe052d5dff0c75e089cebbdb5ae1f4daffc0ead9f09782ec9f625cd', '[\"*\"]', NULL, NULL, '2024-11-17 06:27:18', '2024-11-17 06:27:18'),
(18, 'App\\Models\\User', 7, 'auth_token', '2c79ebe23d72110a1d68dec623ea4042902804b6df1882c71c35475894283c0b', '[\"*\"]', NULL, NULL, '2024-11-17 09:01:05', '2024-11-17 09:01:05'),
(19, 'App\\Models\\User', 7, 'auth_token', 'dd00477b6543a30266c1b97f8c7a84008299d7595a1a41bbe0b4f7b7412d88aa', '[\"*\"]', NULL, NULL, '2024-11-17 09:01:45', '2024-11-17 09:01:45'),
(20, 'App\\Models\\User', 7, 'auth_token', 'eb0017a727ff665b3125a76796c5d10a5864e2d5bc5a8566606664bacb23afeb', '[\"*\"]', NULL, NULL, '2024-11-17 09:01:47', '2024-11-17 09:01:47'),
(21, 'App\\Models\\User', 5, 'auth_token', '25b49e2e3da88302abb4648963927d37c5dce23d1d21cebbb2bb36630f931175', '[\"*\"]', '2024-11-17 09:05:00', NULL, '2024-11-17 09:04:55', '2024-11-17 09:05:00'),
(22, 'App\\Models\\User', 5, 'auth_token', 'd459b77323f4a606a25dafe06a3a9c30efb6e437b4c07492f5c6acc18605592e', '[\"*\"]', NULL, NULL, '2024-11-17 09:04:57', '2024-11-17 09:04:57'),
(23, 'App\\Models\\User', 5, 'auth_token', '720bcd250197a7bd0e29848b1706e06b3fa1245057de9c8a15fe3a4f3b783cc7', '[\"*\"]', '2024-11-17 09:47:16', NULL, '2024-11-17 09:47:13', '2024-11-17 09:47:16'),
(24, 'App\\Models\\User', 5, 'auth_token', 'b67406bf87ee8fb9d94beab3aef03e7519cedf4b59acda9ba7f7b199fdb7bb5c', '[\"*\"]', '2024-11-17 09:48:00', NULL, '2024-11-17 09:47:58', '2024-11-17 09:48:00'),
(25, 'App\\Models\\User', 5, 'auth_token', 'd45b9ec1f4b1ce915e3ced68d1659be159686410e8df32b2fd87eec5502c1d59', '[\"*\"]', '2024-11-17 09:48:47', NULL, '2024-11-17 09:48:43', '2024-11-17 09:48:47'),
(26, 'App\\Models\\User', 7, 'auth_token', '9609b5ee7a7f45b28d902f88f82163714ff27aca01dafca64dc51002aa301756', '[\"*\"]', NULL, NULL, '2024-11-17 09:48:53', '2024-11-17 09:48:53'),
(27, 'App\\Models\\User', 7, 'auth_token', '2f25b7133b48559d89b4e447e0d7117892f9ac3f31a359c569ea620a52496911', '[\"*\"]', NULL, NULL, '2024-11-17 10:13:37', '2024-11-17 10:13:37'),
(28, 'App\\Models\\User', 7, 'auth_token', '2a6f38da87816975aa970e71a5991a6c70f5304c0f66d9cfe654bd93c794d849', '[\"*\"]', NULL, NULL, '2024-11-17 22:46:47', '2024-11-17 22:46:47'),
(29, 'App\\Models\\User', 5, 'auth_token', 'd4d0e3c9381e72bb358fa6e2c47b68e08fd4a83b9f3d708de844ab775d782b1c', '[\"*\"]', '2024-11-17 22:47:33', NULL, '2024-11-17 22:47:28', '2024-11-17 22:47:33'),
(30, 'App\\Models\\User', 7, 'auth_token', '9e84dfeb8d59db6f102e770100ad1af5bcc65664e341f3a4650d416c731a4088', '[\"*\"]', NULL, NULL, '2024-11-17 22:51:44', '2024-11-17 22:51:44'),
(31, 'App\\Models\\User', 7, 'auth_token', '8a420aaeb747232f58177d027b489dc9e6772bb63e3efeba1f12d8e733735474', '[\"*\"]', NULL, NULL, '2024-11-17 22:51:56', '2024-11-17 22:51:56'),
(32, 'App\\Models\\User', 7, 'auth_token', '95d6d69abf0d0f3c135116d2d1ec906bf8c4aaff9b6993e89b2b6ee7649ea160', '[\"*\"]', NULL, NULL, '2024-11-17 22:53:05', '2024-11-17 22:53:05'),
(33, 'App\\Models\\User', 7, 'auth_token', '32e32cdf37529669a94a5b2e6c776b404a64bff54face12701bcc6277baae76c', '[\"*\"]', NULL, NULL, '2024-11-17 22:57:23', '2024-11-17 22:57:23'),
(34, 'App\\Models\\User', 7, 'auth_token', 'e0928f0c1c56c1610e2e64833b4e1d655a647e86f109422923cef0a9f00580fc', '[\"*\"]', NULL, NULL, '2024-11-17 22:57:30', '2024-11-17 22:57:30'),
(35, 'App\\Models\\User', 7, 'auth_token', '3337ecf94b1d51b5c10bd4ef8c09953aba8feb1ad467c170703339001d624529', '[\"*\"]', NULL, NULL, '2024-11-17 22:59:45', '2024-11-17 22:59:45'),
(36, 'App\\Models\\User', 7, 'auth_token', 'd65f611a130302842bca8fe1e1145bce84b269c6244945c4306b65ab75e9347f', '[\"*\"]', NULL, NULL, '2024-11-17 22:59:52', '2024-11-17 22:59:52'),
(37, 'App\\Models\\User', 7, 'auth_token', '3e135a9a09a9d4239b75200d488c67b232118dbe963086cff62a990b11c40d24', '[\"*\"]', NULL, NULL, '2024-11-17 23:02:58', '2024-11-17 23:02:58'),
(38, 'App\\Models\\User', 7, 'auth_token', '25e70a91f0fbeb84eb118a0cdfcaaca2de6fb0dcb47e3eb510d584e49dcbfc88', '[\"*\"]', NULL, NULL, '2024-11-17 23:09:38', '2024-11-17 23:09:38'),
(39, 'App\\Models\\User', 7, 'auth_token', '53de96dfcd912b7dda69c3af4ca51b989608bcf9331564431efbb5a20aea4d24', '[\"*\"]', NULL, NULL, '2024-11-17 23:09:41', '2024-11-17 23:09:41'),
(40, 'App\\Models\\User', 7, 'auth_token', 'e2195db79308f12ba3fdb98fe51793cd1b22b60bc8ef45ae1aebbd645f5d965e', '[\"*\"]', NULL, NULL, '2024-11-17 23:09:43', '2024-11-17 23:09:43'),
(41, 'App\\Models\\User', 7, 'auth_token', '03723d0a8346bcc636814c26f56afd7bbd1398bb3b32edf6a417dd6de866ede0', '[\"*\"]', NULL, NULL, '2024-11-17 23:09:46', '2024-11-17 23:09:46'),
(42, 'App\\Models\\User', 7, 'auth_token', 'c75471bf42d3b42cbd8d6f3b14694184a85c23454b917cb989dcc3e0eb2ed843', '[\"*\"]', NULL, NULL, '2024-11-17 23:10:29', '2024-11-17 23:10:29'),
(43, 'App\\Models\\User', 7, 'auth_token', 'baf5b3856a4efe9a6b1110d089838e04e37c44114c47a51c70b1457d1fde1a24', '[\"*\"]', NULL, NULL, '2024-11-17 23:10:32', '2024-11-17 23:10:32'),
(44, 'App\\Models\\User', 7, 'auth_token', '9fb74511390055a50af7118411305f613a6cc8f5262914fd297bf83661c7249c', '[\"*\"]', NULL, NULL, '2024-11-21 01:49:26', '2024-11-21 01:49:26'),
(45, 'App\\Models\\User', 7, 'auth_token', 'e643e4763e0e0cbc06c638cce1ea4143bc8a397cef52192cbaf796d57f723e70', '[\"*\"]', NULL, NULL, '2024-11-21 01:49:30', '2024-11-21 01:49:30'),
(46, 'App\\Models\\User', 7, 'auth_token', '0455b27386909b2357e49d3e0f2c9acb57fcbc2e84078a539f24494670e8f3a7', '[\"*\"]', NULL, NULL, '2024-11-21 01:51:58', '2024-11-21 01:51:58'),
(47, 'App\\Models\\User', 7, 'auth_token', '5c3fe0edc8d3fe408d53ded019679c1a0aac43fdd8d62a120dfd196d1196d3ce', '[\"*\"]', NULL, NULL, '2024-11-21 01:52:02', '2024-11-21 01:52:02'),
(48, 'App\\Models\\User', 7, 'auth_token', 'b34930893496273bc42977c8914bde3396e912e87095b0fd2e9b1e515f84f2a6', '[\"*\"]', NULL, NULL, '2024-11-21 01:52:03', '2024-11-21 01:52:03'),
(49, 'App\\Models\\User', 7, 'auth_token', '9fa0938675a3b5c1021853e288b9af73cc8fa1a4cd2aa7421752a377fa586dd3', '[\"*\"]', NULL, NULL, '2024-11-21 02:00:05', '2024-11-21 02:00:05'),
(50, 'App\\Models\\User', 7, 'auth_token', '599a22319c7c4815bf1cad0bb64bf53ffd684882e9496aeaea8110c79ff74199', '[\"*\"]', NULL, NULL, '2024-11-21 02:09:40', '2024-11-21 02:09:40'),
(51, 'App\\Models\\User', 7, 'auth_token', 'e6f568e7d6cd0a186eeb0dc9f1a8510f5fc629d70175536c093f5bf144d5d9ad', '[\"*\"]', NULL, NULL, '2024-11-21 02:09:44', '2024-11-21 02:09:44'),
(52, 'App\\Models\\User', 7, 'auth_token', '4d51dd6d760cf52abe94c47e0659fc34c76ef42b176564bbb7317ca691e47b28', '[\"*\"]', NULL, NULL, '2024-11-21 02:09:47', '2024-11-21 02:09:47'),
(53, 'App\\Models\\User', 7, 'auth_token', '697276e4d8327d9a84597df8632523e82e8eda82e6095f63bfcfed1674cfbe73', '[\"*\"]', NULL, NULL, '2024-11-21 02:52:19', '2024-11-21 02:52:19'),
(54, 'App\\Models\\User', 7, 'auth_token', 'c1a893e1b77120782c6833f4631640c4857acd86502b00c502933596e7b1c7c9', '[\"*\"]', NULL, NULL, '2024-11-21 02:52:23', '2024-11-21 02:52:23'),
(55, 'App\\Models\\User', 7, 'auth_token', 'd1c5d1cde41524ce2cbb56daa893cff2472380a3570c285fdf69981597ad26fd', '[\"*\"]', NULL, NULL, '2024-11-21 02:55:30', '2024-11-21 02:55:30'),
(56, 'App\\Models\\User', 7, 'auth_token', 'b43240cf6a4708897d4376558238ea88f126fe3d7f3692989660bc5d849f1a66', '[\"*\"]', NULL, NULL, '2024-11-21 02:57:13', '2024-11-21 02:57:13'),
(57, 'App\\Models\\User', 7, 'auth_token', 'ae9676fec7c14a6222cf059ff4297fe30d165fee000b586602198051759aa11d', '[\"*\"]', NULL, NULL, '2024-11-21 02:58:39', '2024-11-21 02:58:39'),
(58, 'App\\Models\\User', 7, 'auth_token', 'd54776a4215052963f2a5162b8cce7bca0af53a0f1eb9d0e5f19e0500600e5d1', '[\"*\"]', NULL, NULL, '2024-11-21 03:03:12', '2024-11-21 03:03:12'),
(59, 'App\\Models\\User', 7, 'auth_token', 'eeb5a93cec5f72418aff38c1803f12be65087af669555facd362d0ba77e7a1f4', '[\"*\"]', NULL, NULL, '2024-11-21 03:20:58', '2024-11-21 03:20:58'),
(60, 'App\\Models\\User', 7, 'auth_token', 'b5c7d9ef0b635412ef571d2a01e55ee305790b261c1447c3580f55b2394f5590', '[\"*\"]', NULL, NULL, '2024-11-21 03:21:00', '2024-11-21 03:21:00'),
(61, 'App\\Models\\User', 7, 'auth_token', 'c83c02f5e8626cddef6afc3c3ef97e823d2d4fb24070ee6effa71c2574d81855', '[\"*\"]', NULL, NULL, '2024-11-21 03:21:01', '2024-11-21 03:21:01'),
(62, 'App\\Models\\User', 7, 'auth_token', '23842313574260aabbbb542bf65276b3479004ae9151abbe1ba174de9d2c8478', '[\"*\"]', NULL, NULL, '2024-11-21 03:21:02', '2024-11-21 03:21:02'),
(63, 'App\\Models\\User', 7, 'auth_token', 'b5ac109ebcb8b95e07fd9ba6eea728ca0ba48181f4ece7bdebe0b0f1f68b7c81', '[\"*\"]', NULL, NULL, '2024-11-21 03:50:30', '2024-11-21 03:50:30'),
(64, 'App\\Models\\User', 7, 'auth_token', '519263ca1b7f20836a36947befa4a4b08e130e0e8c7a08ca88f7303180152c2e', '[\"*\"]', NULL, NULL, '2024-11-21 03:50:32', '2024-11-21 03:50:32'),
(65, 'App\\Models\\User', 7, 'auth_token', 'f6e11743209ea059ce909137b44d15c20a0ea0098906e8e5acc8b9b27107967d', '[\"*\"]', NULL, NULL, '2024-11-21 03:50:33', '2024-11-21 03:50:33'),
(66, 'App\\Models\\User', 7, 'auth_token', '273f381debed8d6fbffe88ec3c2ae6bbd74c7f760d37b7d9892a2a5e6344f105', '[\"*\"]', NULL, NULL, '2024-11-28 02:57:40', '2024-11-28 02:57:40'),
(67, 'App\\Models\\User', 7, 'auth_token', 'f292e59922c8173277fbb605d4473793b5c7f2dd31dcc6fc867383f3e13933b5', '[\"*\"]', NULL, NULL, '2024-11-28 02:57:42', '2024-11-28 02:57:42'),
(68, 'App\\Models\\User', 7, 'auth_token', '9e7c30da099a00598f1e8eb0525528fa7dee0def86976598456fe9072f83d904', '[\"*\"]', NULL, NULL, '2024-11-28 03:08:11', '2024-11-28 03:08:11'),
(69, 'App\\Models\\User', 7, 'auth_token', '7de88582d496184fbdfa89caa3776b320540cebb65e6da2a10b906337608da59', '[\"*\"]', NULL, NULL, '2024-11-28 03:18:18', '2024-11-28 03:18:18'),
(70, 'App\\Models\\User', 7, 'auth_token', 'b06c94b5b4016e3b133430e7d89f1b397c335e998f8a0011d7e3f7a90d4250e2', '[\"*\"]', NULL, NULL, '2024-11-28 03:36:11', '2024-11-28 03:36:11'),
(71, 'App\\Models\\User', 7, 'auth_token', '7e7dab3a390bb5f07c2a912b06901c6192f2e34f5b71328044f4564576cfa79b', '[\"*\"]', NULL, NULL, '2024-11-28 04:03:48', '2024-11-28 04:03:48'),
(72, 'App\\Models\\User', 7, 'auth_token', '52cf65e5b01e53307cb16645cd4b81312aedf5b02befe5bb6012e69d5505aa58', '[\"*\"]', NULL, NULL, '2024-11-28 06:33:17', '2024-11-28 06:33:17'),
(73, 'App\\Models\\User', 7, 'auth_token', '4237dd5988e966a4f629b8303a166a9df13e7384db6a064ec39ddedac5015db4', '[\"*\"]', NULL, NULL, '2024-11-28 06:39:20', '2024-11-28 06:39:20'),
(74, 'App\\Models\\User', 7, 'auth_token', '688bc22576224ed127ab7de1e4546c4649a24282f7b01db9702e065d8b1f2c30', '[\"*\"]', NULL, NULL, '2024-11-28 07:14:24', '2024-11-28 07:14:24'),
(75, 'App\\Models\\User', 7, 'auth_token', '7a9d1d69f5f2e11cf4aeac26ff42d671eb179f6eb2e5a4a535d8ab6c9998f9af', '[\"*\"]', NULL, NULL, '2024-11-28 07:30:03', '2024-11-28 07:30:03'),
(76, 'App\\Models\\User', 7, 'auth_token', '552781de3a21c13467100c126e9a5c4d554a60a53f145476e219f27771dfd7a9', '[\"*\"]', NULL, NULL, '2024-11-29 07:46:35', '2024-11-29 07:46:35'),
(77, 'App\\Models\\User', 7, 'auth_token', 'e8aa53d214615d5dc86be1577ab7c20639cb29a606ea349c10af65ff4152256b', '[\"*\"]', NULL, NULL, '2024-12-01 21:35:09', '2024-12-01 21:35:09'),
(78, 'App\\Models\\User', 7, 'auth_token', '89bc17c8a70020368b2f6b36c63b226132c620a0d4ed8e165e0789e07aae9c9a', '[\"*\"]', NULL, NULL, '2024-12-01 22:12:05', '2024-12-01 22:12:05'),
(79, 'App\\Models\\User', 7, 'auth_token', '036b14d7b079a15eb06e74c85a7190c434129fc247eda07a01c436dfe6773de6', '[\"*\"]', NULL, NULL, '2024-12-01 22:12:08', '2024-12-01 22:12:08'),
(80, 'App\\Models\\User', 7, 'auth_token', 'face848c2af0eb1c0f69c2cb17ea91292ea3f00ab548c13cdecbfe5a69689f09', '[\"*\"]', NULL, NULL, '2024-12-01 22:12:25', '2024-12-01 22:12:25'),
(81, 'App\\Models\\User', 7, 'auth_token', '3297be3dfa1afa70501461c2b25ba9b34973e8a630c693ec260af493f843985f', '[\"*\"]', NULL, NULL, '2024-12-01 22:19:31', '2024-12-01 22:19:31'),
(82, 'App\\Models\\User', 7, 'auth_token', '64f21b3c96b9433edab9286a7035741d41c62c725b18ea756f2ea44bd137289a', '[\"*\"]', NULL, NULL, '2024-12-01 22:19:32', '2024-12-01 22:19:32'),
(83, 'App\\Models\\User', 7, 'auth_token', '762fcff2af7c691ec670d25f4babd09ad059bffc2e572b76907339d15b583d4b', '[\"*\"]', NULL, NULL, '2024-12-01 22:19:47', '2024-12-01 22:19:47'),
(84, 'App\\Models\\User', 7, 'auth_token', 'e09d5e407c9145c41c3473e0a42713e01b798fbde2363382ec1b38bdb0a45cc4', '[\"*\"]', NULL, NULL, '2024-12-01 22:24:59', '2024-12-01 22:24:59'),
(85, 'App\\Models\\User', 7, 'auth_token', 'e9abfc709cf9c37e8ebf1ad46e4eb6abb08254a63a8b579c5bf7fcc8d89cd510', '[\"*\"]', NULL, NULL, '2024-12-01 22:25:01', '2024-12-01 22:25:01'),
(86, 'App\\Models\\User', 7, 'auth_token', 'cc26115b267d611fb3b5b3130430d388b5f31e9234cde205af3fbe278aa4315e', '[\"*\"]', NULL, NULL, '2024-12-01 22:25:03', '2024-12-01 22:25:03'),
(87, 'App\\Models\\User', 7, 'auth_token', '621966887753b564f10a68c6439eb4bb9033a0a6372832cfa5adaa587c14d9dd', '[\"*\"]', NULL, NULL, '2024-12-01 22:25:03', '2024-12-01 22:25:03'),
(88, 'App\\Models\\User', 7, 'auth_token', '1c330f4637a94219dabbce3da040bc8a0a94b7a4a72185aedd74f086d345df7d', '[\"*\"]', NULL, NULL, '2024-12-01 22:50:09', '2024-12-01 22:50:09'),
(89, 'App\\Models\\User', 7, 'auth_token', 'd62b5f86a82eae93355e311ac4b4e1e72d4d47ab1a83e85bc9077451cfe0b458', '[\"*\"]', NULL, NULL, '2024-12-01 22:50:10', '2024-12-01 22:50:10'),
(90, 'App\\Models\\User', 7, 'auth_token', 'a5d7daed09b4ea255bbb9c2b6956cbc9c995db2ff60662baaf69c46440b82f06', '[\"*\"]', NULL, NULL, '2024-12-01 23:09:14', '2024-12-01 23:09:14'),
(91, 'App\\Models\\User', 7, 'auth_token', 'f7f6a21ebefa699e56ed38705d0a57f0cf915fc59369f0c15ada01b97b208955', '[\"*\"]', NULL, NULL, '2024-12-01 23:09:17', '2024-12-01 23:09:17'),
(92, 'App\\Models\\User', 7, 'auth_token', 'cc430aafed82c96c7c0226121905f3d80ed7ca6fa09af913d43a55aee50a12c7', '[\"*\"]', NULL, NULL, '2024-12-01 23:28:18', '2024-12-01 23:28:18'),
(93, 'App\\Models\\User', 7, 'auth_token', '43751847e659cbb72b5a21e34d555f306c2a0c83f812a19b16c95da80667fa9b', '[\"*\"]', NULL, NULL, '2024-12-04 18:45:17', '2024-12-04 18:45:17'),
(94, 'App\\Models\\User', 8, 'auth_token', 'b37139cb243f9c6e21ec997780d221b5aad20da7d3872589cc298bd3e050633a', '[\"*\"]', '2024-12-04 19:20:22', NULL, '2024-12-04 19:02:00', '2024-12-04 19:20:22'),
(95, 'App\\Models\\User', 8, 'auth_token', '121c7577c7ae1454b15e920baa793a540763c567284cd7e2828e241aec056ce4', '[\"*\"]', '2024-12-04 19:21:27', NULL, '2024-12-04 19:21:25', '2024-12-04 19:21:27'),
(96, 'App\\Models\\User', 8, 'auth_token', 'cde2f2df0db4b336c5cca000902fa949e14072a505b26e88775d39d5e70155b5', '[\"*\"]', '2024-12-04 20:04:37', NULL, '2024-12-04 19:43:01', '2024-12-04 20:04:37'),
(97, 'App\\Models\\User', 8, 'auth_token', '8cfea55b1277f4213ec3d6b6a2e8581df0ecdd44f2869d375b2331194620f1ea', '[\"*\"]', '2024-12-04 20:19:21', NULL, '2024-12-04 20:06:44', '2024-12-04 20:19:21'),
(98, 'App\\Models\\User', 8, 'auth_token', '098d17abbed07610c60a8c37f072333583996356f65b6f24141f4c3ec1fc886d', '[\"*\"]', '2024-12-04 21:20:50', NULL, '2024-12-04 20:19:40', '2024-12-04 21:20:50'),
(99, 'App\\Models\\User', 8, 'auth_token', 'f0ed27f3ccf6a2774e8e81fdd1478a5f3fe36e4e3da7dd0ff06447d95ac6bc67', '[\"*\"]', '2024-12-04 21:43:37', NULL, '2024-12-04 21:24:03', '2024-12-04 21:43:37'),
(100, 'App\\Models\\User', 7, 'auth_token', 'a2bf18b67cbbd821ca0faf7337ccd9988754f92007bdeae71936cf336a754ddc', '[\"*\"]', NULL, NULL, '2024-12-04 21:44:30', '2024-12-04 21:44:30'),
(101, 'App\\Models\\User', 8, 'auth_token', 'b3378d108cb37571926431a1c9419309ce9f341ed86b11e5db89590851ec1569', '[\"*\"]', '2024-12-04 22:04:43', NULL, '2024-12-04 22:04:38', '2024-12-04 22:04:43'),
(102, 'App\\Models\\User', 7, 'auth_token', 'd5867934571ff86cfc01fd2659fcbce1b4c1f5833e58a67d2b0b6aa3bde666f1', '[\"*\"]', NULL, NULL, '2024-12-04 22:07:37', '2024-12-04 22:07:37'),
(103, 'App\\Models\\User', 8, 'auth_token', '47abc386c721a3370af7d7863890944c2d21750d799c4d5b85da4adaf5db560c', '[\"*\"]', '2024-12-04 22:49:40', NULL, '2024-12-04 22:12:07', '2024-12-04 22:49:40'),
(104, 'App\\Models\\User', 7, 'auth_token', '680ce752b6a648346402aa2542e511737d7c0fcf9331a0dcfe26d242a22d676c', '[\"*\"]', NULL, NULL, '2024-12-05 03:33:18', '2024-12-05 03:33:18'),
(105, 'App\\Models\\User', 7, 'auth_token', 'c6eec55aaef86cabb26f56508ac6c4c6d072e30fd90dc6a92db66bb0a3acaf90', '[\"*\"]', NULL, NULL, '2024-12-05 03:36:47', '2024-12-05 03:36:47'),
(106, 'App\\Models\\User', 8, 'auth_token', 'c7734fb4000152ae7c142c1470041e6d2681ab7fabaa92645115092c2305aa60', '[\"*\"]', '2024-12-05 03:38:47', NULL, '2024-12-05 03:37:51', '2024-12-05 03:38:47'),
(107, 'App\\Models\\User', 8, 'auth_token', 'bf95bf7182741cd359f49667f1f2c390da089956a78dde43fa8dc302770449d4', '[\"*\"]', '2024-12-10 18:35:17', NULL, '2024-12-10 17:59:07', '2024-12-10 18:35:17'),
(108, 'App\\Models\\User', 7, 'auth_token', '30eaaaa856dd4811ddd6359869501a49179490352678fb7890a9c44c2e14731d', '[\"*\"]', NULL, NULL, '2024-12-10 18:41:37', '2024-12-10 18:41:37'),
(109, 'App\\Models\\User', 8, 'auth_token', '1c7037aaf35505abd3c9c507ba8a7e224a32ba7fceb3aed8e588e10cbd0b7304', '[\"*\"]', '2024-12-10 18:54:11', NULL, '2024-12-10 18:54:06', '2024-12-10 18:54:11'),
(110, 'App\\Models\\User', 7, 'auth_token', '9e2a0e0f4b0d68b3a6e6a7018c0394656a5461c80ac46c026744beaed73a81b4', '[\"*\"]', '2024-12-10 19:30:20', NULL, '2024-12-10 19:30:10', '2024-12-10 19:30:20'),
(111, 'App\\Models\\User', 7, 'auth_token', 'cfc16560b9e4615adfb525432fb3fd48c7c1348f61b7e8b629de4afdae3e7673', '[\"*\"]', NULL, NULL, '2024-12-10 19:34:51', '2024-12-10 19:34:51'),
(112, 'App\\Models\\User', 7, 'auth_token', 'dff05863c828f5291fc68c2053711c8b8ad9bdeeebb46e266db8a6f95e8ebf40', '[\"*\"]', '2024-12-10 21:16:29', NULL, '2024-12-10 20:25:34', '2024-12-10 21:16:29'),
(113, 'App\\Models\\User', 7, 'auth_token', 'b64f9e7602eabf04b16f68b764a999cb1b65731ed9153b828e69a94d1a048345', '[\"*\"]', NULL, NULL, '2024-12-10 20:25:35', '2024-12-10 20:25:35'),
(114, 'App\\Models\\User', 7, 'auth_token', 'a4f07e61f3d990a00d06e43c1a11577d3b34018b3c22c2599a0723a1ebf4b7c9', '[\"*\"]', NULL, NULL, '2024-12-10 20:25:35', '2024-12-10 20:25:35'),
(115, 'App\\Models\\User', 7, 'auth_token', 'cf3effac23668793f1cb5a9d87141f93ecb009432c544d7761d23fa97e81c183', '[\"*\"]', NULL, NULL, '2024-12-10 21:26:21', '2024-12-10 21:26:21'),
(116, 'App\\Models\\User', 8, 'auth_token', '8431efa84a904acf4887ee07aa8fa8a0fda6368f100f263a2fb721bc4cba4afb', '[\"*\"]', '2024-12-10 21:26:36', NULL, '2024-12-10 21:26:33', '2024-12-10 21:26:36'),
(117, 'App\\Models\\User', 8, 'auth_token', 'ae224d54400b33ca5ee76749683422710f5cd3bb4f6ed4a54eff3175c2b0daac', '[\"*\"]', '2024-12-10 21:41:59', NULL, '2024-12-10 21:41:58', '2024-12-10 21:41:59'),
(118, 'App\\Models\\User', 7, 'auth_token', 'fc6a3e58f1e6efd5857c39fa060310f7e36e9e701a2ef61b873aa6078054b7c7', '[\"*\"]', '2024-12-10 22:02:32', NULL, '2024-12-10 21:42:08', '2024-12-10 22:02:32'),
(119, 'App\\Models\\User', 8, 'auth_token', '0bb9848460a55464be03a73455a0228759e2e9ad74ae4c69efbdcab2b4c7c519', '[\"*\"]', '2024-12-10 22:12:09', NULL, '2024-12-10 22:12:04', '2024-12-10 22:12:09'),
(120, 'App\\Models\\User', 8, 'auth_token', '6b7b6da537048ff2b9b86b513516008b96fab59bfce43cd6ca43aba034ad5c8a', '[\"*\"]', '2024-12-10 23:22:35', NULL, '2024-12-10 23:22:25', '2024-12-10 23:22:35'),
(121, 'App\\Models\\User', 8, 'auth_token', '05814cf1efd765b406a90ce15c7443d7310f9738a4df1b2d8e684816537553d0', '[\"*\"]', '2024-12-10 23:55:49', NULL, '2024-12-10 23:35:25', '2024-12-10 23:55:49'),
(122, 'App\\Models\\User', 7, 'auth_token', '750c59dae6b14807e696c95d08d3ab765d8292ccb1dc09c225ae2c025deba7e0', '[\"*\"]', '2024-12-11 00:07:17', NULL, '2024-12-10 23:56:19', '2024-12-11 00:07:17'),
(123, 'App\\Models\\User', 8, 'auth_token', 'a1f3e5e0f595fd4f83f00eba1251da89a28342cd249184eb62a8fb04f26803a1', '[\"*\"]', '2024-12-11 00:12:40', NULL, '2024-12-11 00:12:26', '2024-12-11 00:12:40'),
(124, 'App\\Models\\User', 7, 'auth_token', 'c69f9ed5073da0e290b3e00d242a0d9b361500fc071a26d05b3360b823ef6552', '[\"*\"]', '2024-12-11 00:14:55', NULL, '2024-12-11 00:13:09', '2024-12-11 00:14:55'),
(125, 'App\\Models\\User', 8, 'auth_token', 'beb1588ab56941c485d85631ec7b1888206675319d2a96a19ade4e05b491ca99', '[\"*\"]', '2024-12-11 00:25:39', NULL, '2024-12-11 00:25:09', '2024-12-11 00:25:39'),
(126, 'App\\Models\\User', 7, 'auth_token', 'fd6902a46ab8a91f122f0a284697cfe2504964847ac2d1ce6906285ba709ee57', '[\"*\"]', '2024-12-11 00:34:30', NULL, '2024-12-11 00:34:26', '2024-12-11 00:34:30'),
(127, 'App\\Models\\User', 7, 'auth_token', '965100f698db0668c7abe09d524d1678dc83e96511e940ce56a53844d543d4c3', '[\"*\"]', '2024-12-11 00:38:36', NULL, '2024-12-11 00:38:32', '2024-12-11 00:38:36'),
(128, 'App\\Models\\User', 8, 'auth_token', '05fe5a030c87392f9d17ee26f7880c4e33e9d55062c9b3d85021623a053140e4', '[\"*\"]', '2024-12-11 01:03:43', NULL, '2024-12-11 00:52:27', '2024-12-11 01:03:43'),
(129, 'App\\Models\\User', 7, 'auth_token', '37e0409d14085af1d25b15a2038f50334f13c87ccf4b548b633302c27f120aa6', '[\"*\"]', '2024-12-11 01:24:45', NULL, '2024-12-11 01:03:58', '2024-12-11 01:24:45'),
(130, 'App\\Models\\User', 7, 'auth_token', 'e041e6560c296513e49845e69e26354cf592c7b9b7267dcc1753e5540a616d98', '[\"*\"]', '2024-12-11 01:26:37', NULL, '2024-12-11 01:25:07', '2024-12-11 01:26:37'),
(131, 'App\\Models\\User', 8, 'auth_token', '5d19887e29bd5d7c0cd5e8e1c20535c1aa973ae066bf35e113b8c677a567004d', '[\"*\"]', '2024-12-11 01:27:04', NULL, '2024-12-11 01:27:02', '2024-12-11 01:27:04'),
(132, 'App\\Models\\User', 7, 'auth_token', 'c3614fdb81bd1f2bdcfaee46c13cca4fd9cb5189b7d769bbc65234a1d1efd660', '[\"*\"]', '2024-12-11 01:48:06', NULL, '2024-12-11 01:27:17', '2024-12-11 01:48:06'),
(133, 'App\\Models\\User', 7, 'auth_token', 'f35583da941e1a189beb97c40818db4301eef7ba267abee1a319805197a137d7', '[\"*\"]', '2024-12-11 05:55:42', NULL, '2024-12-11 05:51:27', '2024-12-11 05:55:42'),
(134, 'App\\Models\\User', 7, 'auth_token', '7ab2daadbbfbd98e68f2711b7d403366c8197ec248a5eb7bb9bde5ffda27fb69', '[\"*\"]', '2024-12-11 06:26:26', NULL, '2024-12-11 06:02:08', '2024-12-11 06:26:26'),
(135, 'App\\Models\\User', 7, 'auth_token', '07929acfbafc0ec3edee161989b22eaadb3c34b32e3dd781b3e82186fd049141', '[\"*\"]', '2024-12-11 06:41:06', NULL, '2024-12-11 06:40:59', '2024-12-11 06:41:06'),
(136, 'App\\Models\\User', 7, 'auth_token', '15e6b137af3229ca1dd1a02c4d01700c9a341012fd4b28efa4cd47c245caf2e0', '[\"*\"]', '2024-12-11 06:42:46', NULL, '2024-12-11 06:42:40', '2024-12-11 06:42:46'),
(137, 'App\\Models\\User', 7, 'auth_token', 'cf8820b891fbf193234aa7adb59361d526e76586c8255a8853c8a3a024cb2e2a', '[\"*\"]', '2024-12-11 06:52:39', NULL, '2024-12-11 06:51:02', '2024-12-11 06:52:39'),
(138, 'App\\Models\\User', 7, 'auth_token', 'f0d11f96e797e8086f2f4f54c1d7e16c1bb727d9024e5a61b27573f3c98eca40', '[\"*\"]', '2024-12-11 06:59:48', NULL, '2024-12-11 06:58:40', '2024-12-11 06:59:48'),
(139, 'App\\Models\\User', 18, 'auth_token', '5d2714e57cf4d5f3ef82d634d3d012b386c76240385c8eb702d0d4f76ce7a9c8', '[\"*\"]', '2024-12-11 07:02:03', NULL, '2024-12-11 07:01:52', '2024-12-11 07:02:03'),
(140, 'App\\Models\\User', 7, 'auth_token', '5f4416c06927dbf656e214e38807938fc68bd012b58a658cfdd13ba3f41085f2', '[\"*\"]', '2024-12-11 07:08:00', NULL, '2024-12-11 07:07:51', '2024-12-11 07:08:00'),
(141, 'App\\Models\\User', 7, 'auth_token', 'b949fd7fd514589e6c43f5775bf76073a5e45b7c4cc6f1891a4468f331384d87', '[\"*\"]', '2024-12-11 07:13:35', NULL, '2024-12-11 07:13:26', '2024-12-11 07:13:35'),
(142, 'App\\Models\\User', 8, 'auth_token', '4d53344d714bf473fbfb8d4d14fb816a185914455412d07249de93a1fd9c5a0b', '[\"*\"]', '2024-12-11 22:03:10', NULL, '2024-12-11 21:57:11', '2024-12-11 22:03:10'),
(143, 'App\\Models\\User', 8, 'auth_token', '55403078487f2ad5df6eddb7036280e5ccd1575a4ffded3c9d5e7a92330bf209', '[\"*\"]', NULL, NULL, '2024-12-11 21:57:13', '2024-12-11 21:57:13'),
(144, 'App\\Models\\User', 7, 'auth_token', '07e7835599e8f33428880c341692270197c56a66be1848d9fbfa75f5fe4a1191', '[\"*\"]', '2024-12-11 23:26:39', NULL, '2024-12-11 22:03:56', '2024-12-11 23:26:39'),
(145, 'App\\Models\\User', 8, 'auth_token', 'a8932f39ea0d696c92b9960ee5f1063c582961d2816ca3ee67998d498a5ae1d0', '[\"*\"]', '2024-12-12 00:25:55', NULL, '2024-12-11 23:29:49', '2024-12-12 00:25:55'),
(146, 'App\\Models\\User', 7, 'auth_token', '50b590c6a901137af6d999b9e427f843a6ef12e7dc9ee314c842c25ef61aa0ef', '[\"*\"]', '2024-12-12 00:29:24', NULL, '2024-12-12 00:28:23', '2024-12-12 00:29:24'),
(147, 'App\\Models\\User', 8, 'auth_token', '840a861d66b85b043313221f05b540f9ddd4cd7572267a3f839eddf306dcc766', '[\"*\"]', '2024-12-12 00:31:36', NULL, '2024-12-12 00:30:57', '2024-12-12 00:31:36'),
(148, 'App\\Models\\User', 7, 'auth_token', '7774164c6bfb234788efca0bac7888c532102dd7d8b7e78ecc43884b4e8f7c65', '[\"*\"]', '2024-12-12 01:39:08', NULL, '2024-12-12 01:10:17', '2024-12-12 01:39:08'),
(149, 'App\\Models\\User', 8, 'auth_token', 'df8309ed2dc5f2672ab094d20897e95625a20a23d7d1a3357a3cfe674227cafb', '[\"*\"]', '2024-12-12 04:44:46', NULL, '2024-12-12 01:39:44', '2024-12-12 04:44:46'),
(150, 'App\\Models\\User', 7, 'auth_token', '5cfeabef7c0f12f3a2bf0909934501457836d4c4223ec43143efbea0e10d7aaf', '[\"*\"]', '2024-12-12 05:41:10', NULL, '2024-12-12 04:47:01', '2024-12-12 05:41:10'),
(151, 'App\\Models\\User', 7, 'auth_token', '02bf90502c07acae215c6147fa4b060e63d0597dc52070b99abc898e711311a2', '[\"*\"]', '2024-12-12 06:26:08', NULL, '2024-12-12 06:26:03', '2024-12-12 06:26:08'),
(152, 'App\\Models\\User', 7, 'auth_token', '78632ac7e957b7c869124967430739d11455ca08e4b96b32b011ba7b6a417313', '[\"*\"]', '2024-12-12 06:50:43', NULL, '2024-12-12 06:42:48', '2024-12-12 06:50:43'),
(153, 'App\\Models\\User', 7, 'auth_token', '6516742ec0b473fe47f25cc63fdc4eb8597ac7ba634887d30a1372c751e23a30', '[\"*\"]', '2024-12-12 07:03:57', NULL, '2024-12-12 06:53:08', '2024-12-12 07:03:57'),
(154, 'App\\Models\\User', 7, 'auth_token', 'f1c26b893b827724e9cf6a5e257f289c106b9b33d4a2cc32ef066f3341d27fb0', '[\"*\"]', '2024-12-12 07:14:37', NULL, '2024-12-12 07:14:31', '2024-12-12 07:14:37'),
(155, 'App\\Models\\User', 7, 'auth_token', '6fb43339c6cdb5c200d1094c6e86a82028198e9aa9adee84789759fdd0c80074', '[\"*\"]', '2024-12-12 09:01:57', NULL, '2024-12-12 07:24:19', '2024-12-12 09:01:57'),
(156, 'App\\Models\\User', 7, 'auth_token', 'b2daa9ec2dde44e6731ad848d4dbfd1daa55bf63ac2fc03d02db0e19b6006987', '[\"*\"]', '2024-12-12 10:29:35', NULL, '2024-12-12 10:23:50', '2024-12-12 10:29:35'),
(157, 'App\\Models\\User', 7, 'auth_token', '72f70567cef427c7af0b903687a16403661581f28151df9d03710b7dd041a4ee', '[\"*\"]', '2024-12-12 11:42:30', NULL, '2024-12-12 11:31:34', '2024-12-12 11:42:30'),
(158, 'App\\Models\\User', 8, 'auth_token', 'c5574f324c5933104b9d52836c66baf727c3265156e01045c88b585e7228d770', '[\"*\"]', '2024-12-12 12:07:50', NULL, '2024-12-12 11:51:10', '2024-12-12 12:07:50'),
(159, 'App\\Models\\User', 7, 'auth_token', 'fe41f0179ca8fb046b92069b0eaebaac9aaa0a14db8fc8e9814885b5e50c8cf9', '[\"*\"]', '2024-12-12 12:25:00', NULL, '2024-12-12 12:17:56', '2024-12-12 12:25:00'),
(160, 'App\\Models\\User', 7, 'auth_token', 'af7df2e16de7f611b3c9230b9100dc6cd57f794e1d057ad05b2c5680549ef8b4', '[\"*\"]', '2024-12-12 18:27:01', NULL, '2024-12-12 12:26:52', '2024-12-12 18:27:01'),
(161, 'App\\Models\\User', 8, 'auth_token', 'ac025512e5684db85f244d885aa1c71e95609b560559f001b32b8c260609c939', '[\"*\"]', '2024-12-12 19:16:51', NULL, '2024-12-12 18:52:48', '2024-12-12 19:16:51'),
(162, 'App\\Models\\User', 7, 'auth_token', 'fea40bb6e719ddc34629a018fb4c765d9d6f81482634d3c0f20e54bdf59ebef1', '[\"*\"]', '2024-12-12 21:30:08', NULL, '2024-12-12 21:29:57', '2024-12-12 21:30:08'),
(163, 'App\\Models\\User', 8, 'auth_token', '5ac531d116dad27a32af3313a7c91731b6081d39360ec3fc302695aadf9bc33f', '[\"*\"]', '2024-12-12 21:30:07', NULL, '2024-12-12 21:29:58', '2024-12-12 21:30:07'),
(164, 'App\\Models\\User', 7, 'auth_token', '229df0ca2afc0bd5d40eaa19f0ab67912ec6648fd6472c18718b8e200c66ca7d', '[\"*\"]', '2024-12-12 22:21:27', NULL, '2024-12-12 21:31:03', '2024-12-12 22:21:27'),
(165, 'App\\Models\\User', 8, 'auth_token', 'dbc7c1841f63a06fcb44cc2b622da1bbed1d9b8e3bf39279f8b5a272df86bfc6', '[\"*\"]', '2024-12-12 22:44:01', NULL, '2024-12-12 22:26:26', '2024-12-12 22:44:01'),
(166, 'App\\Models\\User', 7, 'auth_token', 'a2f2a33a0c4682ab01faf6de7a144db8ee654198915021fe8aea4dfcc9225275', '[\"*\"]', '2024-12-13 02:14:55', NULL, '2024-12-12 22:48:42', '2024-12-13 02:14:55'),
(167, 'App\\Models\\User', 8, 'auth_token', '626859e58145265f69446916aa6f24b5459954d1a4997c8df01f7344eeb0db29', '[\"*\"]', '2024-12-13 02:35:42', NULL, '2024-12-13 02:35:13', '2024-12-13 02:35:42'),
(168, 'App\\Models\\User', 7, 'auth_token', 'c790df72e2de95a378a76e0e90d019e3689d2ef0cba301f4650126a6ceded697', '[\"*\"]', '2024-12-13 02:36:05', NULL, '2024-12-13 02:35:57', '2024-12-13 02:36:05'),
(169, 'App\\Models\\User', 7, 'auth_token', '7f7291d1282d336b2be342c753a4b3228d061f89a4f376388fd92e76b064c37b', '[\"*\"]', '2024-12-13 02:42:47', NULL, '2024-12-13 02:42:09', '2024-12-13 02:42:47'),
(170, 'App\\Models\\User', 27, 'auth_token', 'cddef530fe9e3681af3d0fe81352fc6d141cb1325df6de9b5acc2d7e71a3a98a', '[\"*\"]', '2024-12-13 03:06:05', NULL, '2024-12-13 02:44:20', '2024-12-13 03:06:05'),
(171, 'App\\Models\\User', 7, 'auth_token', 'deaee299110b9bddc6eeb64c6d0c648bb8ac12c3a88d47340704827f0ffa9569', '[\"*\"]', '2024-12-13 03:54:48', NULL, '2024-12-13 03:16:25', '2024-12-13 03:54:48'),
(172, 'App\\Models\\User', 7, 'auth_token', '25768010162746ad1c08a84534d959844e20246e163af8f137895b1364a2777e', '[\"*\"]', '2024-12-13 03:58:30', NULL, '2024-12-13 03:56:00', '2024-12-13 03:58:30'),
(173, 'App\\Models\\User', 7, 'auth_token', 'b7ba38946ab08398ef4af9501fca6f11588b831aa939411459b8b014c6b9b29b', '[\"*\"]', '2024-12-13 04:07:06', NULL, '2024-12-13 03:59:38', '2024-12-13 04:07:06'),
(174, 'App\\Models\\User', 7, 'auth_token', '906643b4460f06f5a1455dc7921bad135b69139075b6dc3df95b08afccd7208b', '[\"*\"]', '2024-12-13 06:05:40', NULL, '2024-12-13 06:05:30', '2024-12-13 06:05:40'),
(175, 'App\\Models\\User', 27, 'auth_token', '482bfb10a3756a0c3bff4908d7cc08a54bdb438550a81c7c3d18582eb8a4ca42', '[\"*\"]', NULL, NULL, '2024-12-13 06:08:08', '2024-12-13 06:08:08'),
(176, 'App\\Models\\User', 27, 'auth_token', 'c2f1b7eb395f0d5507545690578079bc00342cb561cadcc9dfa3f4e040ef33bd', '[\"*\"]', NULL, NULL, '2024-12-13 06:09:31', '2024-12-13 06:09:31'),
(177, 'App\\Models\\User', 27, 'auth_token', '75bf630d5455ac94b0f187971756d99736a3e2ccfdb222e6e5d33bd471e2b0bf', '[\"*\"]', NULL, NULL, '2024-12-13 06:10:20', '2024-12-13 06:10:20'),
(178, 'App\\Models\\User', 7, 'auth_token', '48cb9a5ed9430ce6d79dfcacedb2b72748e437562bbb5dfd114f3a3bc29fb778', '[\"*\"]', '2024-12-13 06:21:48', NULL, '2024-12-13 06:21:39', '2024-12-13 06:21:48'),
(179, 'App\\Models\\User', 27, 'auth_token', 'c8d116b53cf160b3362a1174a2c876166dbb26cac744a2d7e6c9132b83fb9cfd', '[\"*\"]', '2024-12-13 06:44:50', NULL, '2024-12-13 06:29:38', '2024-12-13 06:44:50'),
(180, 'App\\Models\\User', 7, 'auth_token', '3d69b000e155bf6b4ec126f360ad29dbdcfb8dfb76cc205e33bb4de83aabc267', '[\"*\"]', '2024-12-13 06:56:12', NULL, '2024-12-13 06:56:04', '2024-12-13 06:56:12'),
(181, 'App\\Models\\User', 27, 'auth_token', 'a0f8891081140a53a54d0cac37ffbfac1b12c3140efccab6d89d4839f784846a', '[\"*\"]', '2024-12-13 06:57:23', NULL, '2024-12-13 06:57:17', '2024-12-13 06:57:23'),
(182, 'App\\Models\\User', 7, 'auth_token', '6623f0f94ec60d2b0e66e1c6713bedb2ffd2cc4332c58ef57c937ea5350ac3be', '[\"*\"]', '2024-12-13 07:23:47', NULL, '2024-12-13 07:08:18', '2024-12-13 07:23:47'),
(183, 'App\\Models\\User', 7, 'auth_token', '4f037aa6050e9c4a53ec12919dc11bcf976fe9882703978ab8b9abc0af8561b2', '[\"*\"]', '2024-12-13 20:09:20', NULL, '2024-12-13 20:08:57', '2024-12-13 20:09:20'),
(184, 'App\\Models\\User', 27, 'auth_token', '0ca5999ef70f664ba1526d6aa194f1111b1d1ac08517225745309f9f99fa508f', '[\"*\"]', '2024-12-13 20:16:41', NULL, '2024-12-13 20:09:42', '2024-12-13 20:16:41'),
(185, 'App\\Models\\User', 7, 'auth_token', '99cf8cd8e263d2d5311ee68800009b33f020b702aa7ebd32ca7690855aeeda91', '[\"*\"]', '2024-12-13 21:58:58', NULL, '2024-12-13 20:39:15', '2024-12-13 21:58:58'),
(186, 'App\\Models\\User', 27, 'auth_token', '3c92c4966ccea20790abc0ea2681306bc0f65857a810b25f36895466a0dec61a', '[\"*\"]', '2024-12-13 21:59:55', NULL, '2024-12-13 21:59:48', '2024-12-13 21:59:55'),
(187, 'App\\Models\\User', 7, 'auth_token', '0e99fbb31e2e08130d4fd011f31d975bc84ca9a422517da902b287789a189951', '[\"*\"]', '2024-12-13 22:10:56', NULL, '2024-12-13 22:02:43', '2024-12-13 22:10:56'),
(188, 'App\\Models\\User', 27, 'API Token', '31875d5f4d02a29b9fc89f7078f4ec4ddcc1e6e34fe0a6d5215237c9d21fb4a9', '[\"*\"]', '2024-12-13 23:49:56', NULL, '2024-12-13 22:46:41', '2024-12-13 23:49:56'),
(189, 'App\\Models\\User', 7, 'API Token', '609f790754a64f54ee663ce041e9024dc613bfe3d25e5565247d3dbaffc90cd0', '[\"*\"]', '2024-12-14 00:03:44', NULL, '2024-12-13 23:50:14', '2024-12-14 00:03:44'),
(190, 'App\\Models\\User', 27, 'API Token', '512087c8c533e2c6633d4dd740fee044d00bacc9f69cdcc7aa4c75f33628c2ce', '[\"*\"]', '2024-12-14 00:07:14', NULL, '2024-12-14 00:06:56', '2024-12-14 00:07:14'),
(191, 'App\\Models\\User', 7, 'API Token', '675e631d22ca4594a39bd5aac73b9817affed4d3cec231472d337bc749bec7a8', '[\"*\"]', '2024-12-14 01:48:28', NULL, '2024-12-14 00:17:41', '2024-12-14 01:48:28'),
(192, 'App\\Models\\User', 7, 'API Token', '68bc61b10046970adc8e8b7a195e324f16a614fbbace3960279ca632b657d276', '[\"*\"]', NULL, NULL, '2024-12-14 01:55:20', '2024-12-14 01:55:20'),
(193, 'App\\Models\\User', 27, 'API Token', '1d96675b0aa928dd722819c268c5b26430e67dc023fa5a4cb072cb889902dd57', '[\"*\"]', '2024-12-14 02:04:27', NULL, '2024-12-14 02:04:21', '2024-12-14 02:04:27'),
(194, 'App\\Models\\User', 7, 'API Token', '68a6021fe548c8ab8e57122db3c8243410cbc7d98c84e902078f365d1b1cbf13', '[\"*\"]', '2024-12-14 03:36:27', NULL, '2024-12-14 02:23:10', '2024-12-14 03:36:27'),
(195, 'App\\Models\\User', 27, 'API Token', '2f0325f6ee988345e3fd05269b6d8a0a429f60cd518f6417f82e81877bd2b79b', '[\"*\"]', '2024-12-14 03:37:26', NULL, '2024-12-14 03:36:50', '2024-12-14 03:37:26'),
(196, 'App\\Models\\User', 7, 'API Token', 'dddec18fc3f8b19df79a74c9c04e4fb9aed0c85ed488184d206af23f0d1dbd24', '[\"*\"]', '2024-12-14 05:54:14', NULL, '2024-12-14 03:37:48', '2024-12-14 05:54:14'),
(197, 'App\\Models\\User', 27, 'API Token', '611379dcbbfee3a581ffe249648cfb26ca7bbebd0fb8ee07dd578d4fa4a321f7', '[\"*\"]', '2024-12-14 06:00:00', NULL, '2024-12-14 05:54:48', '2024-12-14 06:00:00'),
(198, 'App\\Models\\User', 7, 'API Token', '064735690991f67f972b8cdfb63499215dc2be2e9293c36784ae41872dab08f4', '[\"*\"]', '2024-12-14 20:00:04', NULL, '2024-12-14 18:59:31', '2024-12-14 20:00:04'),
(199, 'App\\Models\\User', 27, 'API Token', '8ed8b4d551b2a2486428812428d3de4b42785850fd2ee30c50f4839a59a8cebe', '[\"*\"]', '2024-12-14 21:46:25', NULL, '2024-12-14 21:46:04', '2024-12-14 21:46:25'),
(200, 'App\\Models\\User', 27, 'API Token', 'ab3b79a34ecb6a667dbc0fe16e2110303785e36ef3b805a263e914e45a7c7e63', '[\"*\"]', NULL, NULL, '2024-12-14 21:46:06', '2024-12-14 21:46:06'),
(201, 'App\\Models\\User', 7, 'API Token', '5545dde1c52e6b0c7be6f6835cac045043c795a88288c6505858a3f995b38f27', '[\"*\"]', '2024-12-14 23:12:12', NULL, '2024-12-14 21:46:41', '2024-12-14 23:12:12'),
(202, 'App\\Models\\User', 27, 'API Token', 'cc677a4ceab5572003a85c034ada9dfb8a7dc4f5b02da9c930b64bb7f97de1b3', '[\"*\"]', '2024-12-14 23:18:19', NULL, '2024-12-14 23:16:52', '2024-12-14 23:18:19'),
(203, 'App\\Models\\User', 7, 'API Token', '7573f3fbf8696185ccb535cd180caba1d8706b757a626f4706aa5efe99330b0d', '[\"*\"]', '2024-12-14 23:20:51', NULL, '2024-12-14 23:17:27', '2024-12-14 23:20:51'),
(204, 'App\\Models\\User', 27, 'API Token', 'db0960211bcc9c509a97556df9923dc5f8a75d5013e9a395485e86a0696af14b', '[\"*\"]', '2024-12-14 23:42:19', NULL, '2024-12-14 23:30:27', '2024-12-14 23:42:19'),
(205, 'App\\Models\\User', 7, 'API Token', '38a99173d7cfcee5489580b8f09aae493755232139b5de888291d27f2f117786', '[\"*\"]', '2024-12-14 23:59:06', NULL, '2024-12-14 23:43:22', '2024-12-14 23:59:06'),
(206, 'App\\Models\\User', 27, 'API Token', 'd64f9166f1968c245b6e983299cd0066e4bf598b9ed8194fbc4021e871f6fa6d', '[\"*\"]', '2024-12-15 00:04:56', NULL, '2024-12-14 23:59:45', '2024-12-15 00:04:56'),
(207, 'App\\Models\\User', 7, 'API Token', '9eae14fcb2593d9ec2213251550aa76215871d67d1d1bc99c8ddc75435bae465', '[\"*\"]', '2024-12-15 00:06:02', NULL, '2024-12-15 00:05:20', '2024-12-15 00:06:02'),
(208, 'App\\Models\\User', 27, 'API Token', '3939d9e9ab0d56f29b0ee30ab55d0304010444b0a71ccd63b596b19b411eb4f6', '[\"*\"]', '2024-12-15 00:16:25', NULL, '2024-12-15 00:06:28', '2024-12-15 00:16:25'),
(209, 'App\\Models\\User', 7, 'API Token', '49ad73baa524e82b0a38207b895bf2fad11b6ebed57fd15f47ab1cfe48a42040', '[\"*\"]', '2024-12-15 00:17:01', NULL, '2024-12-15 00:16:33', '2024-12-15 00:17:01'),
(210, 'App\\Models\\User', 27, 'API Token', '5fcf8c13b06926e909790638416abc627f46c27b0b96175662c4f8282fc5c73d', '[\"*\"]', '2024-12-15 00:17:58', NULL, '2024-12-15 00:17:47', '2024-12-15 00:17:58'),
(211, 'App\\Models\\User', 7, 'API Token', 'cb9a7b9e53b90b50b66d289e48436e122fbe9ba94edbd03a0af0a412d9713166', '[\"*\"]', '2024-12-15 00:20:49', NULL, '2024-12-15 00:18:24', '2024-12-15 00:20:49'),
(212, 'App\\Models\\User', 27, 'API Token', 'fb8371e7546f6021275147f4636508107ff0ee3c771a47af217a7e09eea6269f', '[\"*\"]', '2024-12-15 00:22:06', NULL, '2024-12-15 00:21:08', '2024-12-15 00:22:06'),
(213, 'App\\Models\\User', 7, 'API Token', '01375b06e03dc3476bfa0d235e9fb1409b98dea509f17307795bf9020337414a', '[\"*\"]', '2024-12-15 00:22:40', NULL, '2024-12-15 00:22:22', '2024-12-15 00:22:40'),
(214, 'App\\Models\\User', 27, 'API Token', 'ef09745180d6306b96c6d86a2e48b87de9a69034e1606b9e181b2d29ce52ab5d', '[\"*\"]', '2024-12-15 00:30:27', NULL, '2024-12-15 00:23:08', '2024-12-15 00:30:27'),
(215, 'App\\Models\\User', 7, 'API Token', '0962e080a45b7788d4d7ac8030c47fe963d58b88d0a573f598de47fab5197962', '[\"*\"]', '2024-12-15 00:31:03', NULL, '2024-12-15 00:30:41', '2024-12-15 00:31:03'),
(216, 'App\\Models\\User', 27, 'API Token', '7a103a541a3dbe4950dd5bc23ba4ccfb777d9507363b291401d9314eeacbd141', '[\"*\"]', '2024-12-15 00:31:45', NULL, '2024-12-15 00:31:33', '2024-12-15 00:31:45'),
(217, 'App\\Models\\User', 7, 'API Token', '132176c7dc77fb19feef04b0ce4c6408c2cefa6b1c462223fe4e75cc12d37fdb', '[\"*\"]', '2024-12-15 00:34:07', NULL, '2024-12-15 00:32:58', '2024-12-15 00:34:07'),
(218, 'App\\Models\\User', 27, 'API Token', '1dfcfe84013acfcf7bce7a3b4e032014473aa23160af820358d3afaa5bfe779f', '[\"*\"]', '2024-12-15 00:36:33', NULL, '2024-12-15 00:35:51', '2024-12-15 00:36:33'),
(219, 'App\\Models\\User', 7, 'API Token', '4ec64e7f098072c593da24ce0c6a964e18fe79d8e2303685289677a2f558486f', '[\"*\"]', '2024-12-15 00:45:33', NULL, '2024-12-15 00:43:18', '2024-12-15 00:45:33'),
(220, 'App\\Models\\User', 27, 'API Token', '763b0e493471f521c49e70313d0a55388c5c22a7922249c2187bcc825a381916', '[\"*\"]', '2024-12-15 00:55:19', NULL, '2024-12-15 00:45:52', '2024-12-15 00:55:19'),
(221, 'App\\Models\\User', 7, 'API Token', 'f91299720b1bb699eb3604790a5d75965632bed414ba7e49bd208757843b374b', '[\"*\"]', '2024-12-15 00:56:33', NULL, '2024-12-15 00:55:40', '2024-12-15 00:56:33'),
(222, 'App\\Models\\User', 27, 'API Token', '4a8ba6604668957cd1709a7b931bf653ce842cd4a69fcf9b8ef41815c88a57ba', '[\"*\"]', '2024-12-15 01:21:55', NULL, '2024-12-15 00:56:43', '2024-12-15 01:21:55'),
(223, 'App\\Models\\User', 7, 'API Token', 'be49c8e89afd308c5ca94cf6e47a72aa32bc62ed8ac6635a18e11e148d35f006', '[\"*\"]', '2024-12-15 01:22:13', NULL, '2024-12-15 01:22:00', '2024-12-15 01:22:13'),
(224, 'App\\Models\\User', 7, 'API Token', 'f33fcca4897307705953ad3896e67273c18849b25a9b03a474068e2735aa9465', '[\"*\"]', '2024-12-15 02:34:12', NULL, '2024-12-15 02:33:58', '2024-12-15 02:34:12'),
(225, 'App\\Models\\User', 27, 'API Token', 'ef292c569b49e41a5d9778c3da1350dce02f5c799c9dbde75e71cdfa0282abfa', '[\"*\"]', '2024-12-15 19:12:30', NULL, '2024-12-15 02:33:59', '2024-12-15 19:12:30'),
(226, 'App\\Models\\User', 27, 'API Token', '317f301ffffebad2271cfb67df041b13d4d9c9e08fd18c2808ea6f4b3d279c5f', '[\"*\"]', '2024-12-15 19:13:32', NULL, '2024-12-15 19:13:28', '2024-12-15 19:13:32'),
(227, 'App\\Models\\User', 7, 'API Token', 'b45750511574ba2bfe685d183244e642f387113f8093788385da79270d20d8a7', '[\"*\"]', '2024-12-15 20:56:35', NULL, '2024-12-15 19:13:54', '2024-12-15 20:56:35'),
(228, 'App\\Models\\User', 7, 'API Token', 'a0c8506171248959a32c61596655d26a751296dc8805ef7aba6f09fde5c24d70', '[\"*\"]', '2024-12-15 20:58:46', NULL, '2024-12-15 20:56:34', '2024-12-15 20:58:46'),
(229, 'App\\Models\\User', 27, 'API Token', '0f12236dcdd1887a390d7392349a8324771837eaa1bd33e1616a0304b6e8d6c8', '[\"*\"]', '2024-12-15 21:14:13', NULL, '2024-12-15 20:58:45', '2024-12-15 21:14:13'),
(230, 'App\\Models\\User', 7, 'API Token', 'ffbd30ad3623bc60c5f5b955c531c2eeba7268c79330f230d8fe8b62368a7204', '[\"*\"]', '2024-12-15 21:14:32', NULL, '2024-12-15 21:14:17', '2024-12-15 21:14:32'),
(231, 'App\\Models\\User', 27, 'API Token', 'b6e270b1f4280cea6547e70323b75d7f60301c9edfa87720d036e70c2468dcf9', '[\"*\"]', '2024-12-15 21:15:02', NULL, '2024-12-15 21:14:49', '2024-12-15 21:15:02'),
(232, 'App\\Models\\User', 7, 'API Token', '72ac5b6c774b773754a7257ae62976e0a60dfe65e80dc03f5cd7121b4f95b206', '[\"*\"]', NULL, NULL, '2024-12-15 21:20:54', '2024-12-15 21:20:54'),
(233, 'App\\Models\\User', 7, 'API Token', '8eb898cefb7f951f86b9f37765232366538cf3292bd89151174a2d60f6b48d58', '[\"*\"]', NULL, NULL, '2024-12-15 21:20:55', '2024-12-15 21:20:55'),
(234, 'App\\Models\\User', 7, 'API Token', '1f2946d04038ba321456dd59bd5a502698fbe4481c61aca7cf68a17d167a4e00', '[\"*\"]', NULL, NULL, '2024-12-15 21:20:57', '2024-12-15 21:20:57'),
(235, 'App\\Models\\User', 7, 'API Token', 'ef096f955d60c0f26b263a8a84a23194da123cdb9d801e2425b7f5a9264edce5', '[\"*\"]', NULL, NULL, '2024-12-15 21:20:58', '2024-12-15 21:20:58'),
(236, 'App\\Models\\User', 7, 'API Token', '84cb14fe4a0b5aae3121b7dd5ffd42da7ae2af26e6e0958564290d5c79a7a90e', '[\"*\"]', '2024-12-15 21:21:25', NULL, '2024-12-15 21:20:59', '2024-12-15 21:21:25'),
(237, 'App\\Models\\User', 27, 'API Token', '3571659b6d44a87b451d86778a7da0ba11f4ba2ec0ad461275566844e0895115', '[\"*\"]', NULL, NULL, '2024-12-15 21:21:37', '2024-12-15 21:21:37'),
(238, 'App\\Models\\User', 27, 'API Token', 'aea28feaac5b15c8dc93121ed101b894aa3b1378a681b086e6870da2ddab71aa', '[\"*\"]', NULL, NULL, '2024-12-15 21:21:38', '2024-12-15 21:21:38'),
(239, 'App\\Models\\User', 27, 'API Token', '6678d9fb3f11847a11fb6bd1e6372270c3ac245c309d2ab4690a810d785a4d77', '[\"*\"]', '2024-12-15 21:22:19', NULL, '2024-12-15 21:21:40', '2024-12-15 21:22:19'),
(240, 'App\\Models\\User', 27, 'API Token', '7ae2cb44c82481910be13dc36cad64ec697417ca26c7d625f3dc10f0d6c06a96', '[\"*\"]', NULL, NULL, '2024-12-15 21:21:40', '2024-12-15 21:21:40'),
(241, 'App\\Models\\User', 27, 'API Token', '730ec32d71a48ced422cc28ad7f2c51005b498ac700dc8ba87b0105d93b8dc5f', '[\"*\"]', NULL, NULL, '2024-12-15 21:21:41', '2024-12-15 21:21:41'),
(242, 'App\\Models\\User', 7, 'API Token', 'ee291289a58aa7889578580db101d38e70a22193452da2c459bb5cbab9234b6e', '[\"*\"]', '2024-12-15 21:30:16', NULL, '2024-12-15 21:29:40', '2024-12-15 21:30:16'),
(243, 'App\\Models\\User', 7, 'API Token', '6afd6e3756af730cb46fe4ce37869be6f5e65ad8c1782cf565e77b9f7b2f5c9d', '[\"*\"]', NULL, NULL, '2024-12-15 21:29:41', '2024-12-15 21:29:41'),
(244, 'App\\Models\\User', 7, 'API Token', '990701c0dd1616f9095c193ec531a2bf350bb22844866391f9b2114a06a2c81f', '[\"*\"]', NULL, NULL, '2024-12-15 21:29:42', '2024-12-15 21:29:42'),
(245, 'App\\Models\\User', 7, 'API Token', '84fdc3d7cfd79cbf97c7008b90371a138d71b0a19b273653317d9cbe655caefb', '[\"*\"]', NULL, NULL, '2024-12-15 21:29:43', '2024-12-15 21:29:43'),
(246, 'App\\Models\\User', 7, 'API Token', '5ad5b49a544eaa5925dcefe3c6e7b6c2e9ce8fc9a692ba1df6c098d27d18dc3a', '[\"*\"]', NULL, NULL, '2024-12-15 21:29:44', '2024-12-15 21:29:44'),
(247, 'App\\Models\\User', 27, 'API Token', 'f5d539f4720b98836e0c62b4b3823dbea21612ce55528bd13a002ab800056ebd', '[\"*\"]', NULL, NULL, '2024-12-15 21:30:26', '2024-12-15 21:30:26'),
(248, 'App\\Models\\User', 27, 'API Token', 'd5c9537c19e5853a2af8e84882bb1c9ace3e8ca1013542265fbba6ce5957e34d', '[\"*\"]', NULL, NULL, '2024-12-15 21:30:27', '2024-12-15 21:30:27'),
(249, 'App\\Models\\User', 27, 'API Token', 'eae7ed0423ec168a05a76b66363ea017f67da16ee873db19acc5dee4ba76d925', '[\"*\"]', NULL, NULL, '2024-12-15 21:30:29', '2024-12-15 21:30:29'),
(250, 'App\\Models\\User', 27, 'API Token', '43bb5b4082553e7217c226e39eb999190854f2c3e19514a9f781e95122d25a94', '[\"*\"]', '2024-12-15 23:42:38', NULL, '2024-12-15 21:30:30', '2024-12-15 23:42:38'),
(251, 'App\\Models\\User', 27, 'API Token', 'a41a8ba5c76081e15ea9588423193652620dae87281409f749f88a204a5df840', '[\"*\"]', NULL, NULL, '2024-12-15 21:30:31', '2024-12-15 21:30:31'),
(252, 'App\\Models\\User', 7, 'API Token', '62fe3e9b68f4683a213b0a11bed7c16e1febac773fcf930d328c5e82b776be8e', '[\"*\"]', NULL, NULL, '2024-12-16 01:54:36', '2024-12-16 01:54:36'),
(253, 'App\\Models\\User', 7, 'API Token', '1c74217cb7ddac97ee5b3109ab0d4f7f0993afae9bb0422f60debb138b3d5a09', '[\"*\"]', NULL, NULL, '2024-12-16 01:55:33', '2024-12-16 01:55:33'),
(254, 'App\\Models\\User', 7, 'API Token', 'e063e314c5cde7655c1756fd94af48fd6ba6b052aa4fc002a68c1042b7ce6bad', '[\"*\"]', NULL, NULL, '2024-12-16 01:58:07', '2024-12-16 01:58:07'),
(255, 'App\\Models\\User', 7, 'API Token', '71825e7bb74c37e8715325502cc551c55833b64aaa456b03f984fd942011f5d2', '[\"*\"]', NULL, NULL, '2024-12-16 02:08:20', '2024-12-16 02:08:20'),
(256, 'App\\Models\\User', 7, 'API Token', '434f4961706ee59ba2b2607d0e16cf614b19c30b4fe76064a42a1470301d8877', '[\"*\"]', NULL, NULL, '2024-12-16 02:10:33', '2024-12-16 02:10:33'),
(257, 'App\\Models\\User', 7, 'API Token', '768a045d71d1eddfced75769cab662d24cbcab9b1a0a822d7be96f99bf82738c', '[\"*\"]', NULL, NULL, '2024-12-16 02:11:27', '2024-12-16 02:11:27'),
(258, 'App\\Models\\User', 7, 'API Token', '0873a957fc0e99f6f5485f1ca22fa4364ce7b7eade11a3c66f085508059836a1', '[\"*\"]', NULL, NULL, '2024-12-16 02:17:07', '2024-12-16 02:17:07'),
(259, 'App\\Models\\User', 7, 'API Token', 'b6911799876fcdba9e740847846a957b5d73fd0b7f7505747f0d1bc7cb8d1a45', '[\"*\"]', NULL, NULL, '2024-12-16 02:23:18', '2024-12-16 02:23:18'),
(260, 'App\\Models\\User', 7, 'API Token', '81fce575826e7e916f1347e6e1d73fa68cdafa0c11fe4889133005c9c6e431aa', '[\"*\"]', NULL, NULL, '2024-12-16 02:25:04', '2024-12-16 02:25:04'),
(261, 'App\\Models\\User', 7, 'API Token', '1e3b503d78aacc4cb5be48bd6aebacd317cbc41b4b73149b01bc066242b84a53', '[\"*\"]', '2024-12-16 02:27:46', NULL, '2024-12-16 02:27:27', '2024-12-16 02:27:46'),
(262, 'App\\Models\\User', 27, 'API Token', '22aae9904b3a64e0fe35b707fd2158a024f6a8e00f0f05b4c40f03dc217ad7fb', '[\"*\"]', '2024-12-16 03:17:52', NULL, '2024-12-16 02:27:55', '2024-12-16 03:17:52'),
(263, 'App\\Models\\User', 7, 'API Token', '1d3845a6e311d1c2e1c92d9047748c1e38fa7f2063229a84cf66d8cc8c3fe808', '[\"*\"]', '2024-12-16 02:43:39', NULL, '2024-12-16 02:37:01', '2024-12-16 02:43:39'),
(264, 'App\\Models\\User', 27, 'API Token', 'e567708ce840be3b5b573000f6f90dd40ea7ebf65b97606876035e173c978b20', '[\"*\"]', '2025-01-02 10:23:07', NULL, '2024-12-16 02:46:10', '2025-01-02 10:23:07');
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(265, 'App\\Models\\User', 7, 'API Token', '4f2a98930f5d829328c88f8399135fc7cbd5644ce8994c10d2ab96da06ed6d0f', '[\"*\"]', '2024-12-16 03:18:11', NULL, '2024-12-16 03:17:57', '2024-12-16 03:18:11'),
(266, 'App\\Models\\User', 27, 'API Token', 'd55d639d791412b93bdf91a971c5706d923d2ad12af97d7ce72ebdb83efdc8f2', '[\"*\"]', NULL, NULL, '2024-12-16 03:18:11', '2024-12-16 03:18:11'),
(267, 'App\\Models\\User', 27, 'API Token', '7da296651719718510196863fcf05255b3f5cbdffa2943c211b17ad9a2664841', '[\"*\"]', '2024-12-16 03:28:13', NULL, '2024-12-16 03:18:22', '2024-12-16 03:28:13'),
(268, 'App\\Models\\User', 7, 'API Token', 'fff59d4b66b8dcc3334cebb5cb896c6945b191cab9f50e34ff2b3b8c02e38036', '[\"*\"]', '2024-12-16 03:38:03', NULL, '2024-12-16 03:28:17', '2024-12-16 03:38:03'),
(269, 'App\\Models\\User', 27, 'API Token', '0a4b8a04ba48f4ea9f3253dd7b74eb928995321413ca00a012cbc0309a27bb96', '[\"*\"]', '2024-12-16 03:43:55', NULL, '2024-12-16 03:38:11', '2024-12-16 03:43:55'),
(270, 'App\\Models\\User', 7, 'API Token', '7cdb20456064be005c93ae2a2941095dd46a9be0cfdd320086606bdf83d0cfed', '[\"*\"]', '2024-12-16 03:45:41', NULL, '2024-12-16 03:44:05', '2024-12-16 03:45:41'),
(271, 'App\\Models\\User', 27, 'API Token', '949bcfd91f230f4caaf3bb8ec137d9cede35cc1ee3648ecdfe91ca8f2dc7e16a', '[\"*\"]', '2024-12-16 03:49:34', NULL, '2024-12-16 03:45:54', '2024-12-16 03:49:34'),
(272, 'App\\Models\\User', 7, 'API Token', '5c3fe7b2dbd3dff23cef3c6c0bb8cfb0bf0d720ec03cd2190bf00e4b7faf2b92', '[\"*\"]', '2024-12-16 03:50:10', NULL, '2024-12-16 03:49:39', '2024-12-16 03:50:10'),
(273, 'App\\Models\\User', 27, 'API Token', 'f3da39cd1f2f3d3f77f12aa24716abfe9df907800891c3255c063e1ce25fb412', '[\"*\"]', '2024-12-16 04:28:05', NULL, '2024-12-16 03:50:24', '2024-12-16 04:28:05'),
(274, 'App\\Models\\User', 7, 'API Token', 'e0bc0a098e15bd05179ef77493c12a8aa1d7b5b72876f953dbcfcfe6c51fadbb', '[\"*\"]', '2024-12-16 04:38:51', NULL, '2024-12-16 04:28:11', '2024-12-16 04:38:51'),
(275, 'App\\Models\\User', 27, 'API Token', 'c67228b91dd371619da0e871856cb10db25d53a2ab53b4977462c7fae614af9a', '[\"*\"]', '2024-12-16 04:39:07', NULL, '2024-12-16 04:39:01', '2024-12-16 04:39:07'),
(276, 'App\\Models\\User', 7, 'API Token', '0ccbdabd186511584603cb823ae3844b4d782d31226d27a0b45cf49d116a27a0', '[\"*\"]', '2024-12-16 04:40:35', NULL, '2024-12-16 04:39:17', '2024-12-16 04:40:35'),
(277, 'App\\Models\\User', 27, 'API Token', 'de8209a914978f53daf4f93ca5f2cd1ada55da8f63dad695d7f8969ca28f6bbd', '[\"*\"]', '2024-12-16 04:47:09', NULL, '2024-12-16 04:41:10', '2024-12-16 04:47:09'),
(278, 'App\\Models\\User', 7, 'API Token', 'c5b3400deec670b1e376f167e57b07f2ffe0969454c63fe381c1ffa61d2ec6b7', '[\"*\"]', '2024-12-16 05:15:00', NULL, '2024-12-16 04:47:17', '2024-12-16 05:15:00'),
(279, 'App\\Models\\User', 27, 'API Token', 'fb84cd7a421bc5286dd93bf45d6212254ef0eecb6a1af7e4ba232d53229e9cb1', '[\"*\"]', '2024-12-16 05:16:21', NULL, '2024-12-16 05:15:14', '2024-12-16 05:16:21'),
(280, 'App\\Models\\User', 7, 'API Token', 'f0949361db95ba8f2c8a8a5aa99769b1f4ded04da63a0e8849b483c68333e85b', '[\"*\"]', '2024-12-16 05:28:18', NULL, '2024-12-16 05:16:30', '2024-12-16 05:28:18'),
(281, 'App\\Models\\User', 7, 'API Token', 'ce3a297becca9c5c1c5a51c08b216e43f015d4662b4d14fcd256165c5a7b836a', '[\"*\"]', '2024-12-16 05:30:42', NULL, '2024-12-16 05:28:26', '2024-12-16 05:30:42'),
(282, 'App\\Models\\User', 27, 'API Token', 'f2b89d90028ffa4be085de85b0226d0774b23eb1d3f696870f78d2e84ed16408', '[\"*\"]', '2024-12-16 05:38:46', NULL, '2024-12-16 05:30:52', '2024-12-16 05:38:46'),
(283, 'App\\Models\\User', 7, 'API Token', 'b033dceb86ef8a16af9334615fae7109d215945c2694bce2b225dfca83fd50d1', '[\"*\"]', '2024-12-16 05:39:39', NULL, '2024-12-16 05:38:51', '2024-12-16 05:39:39'),
(284, 'App\\Models\\User', 27, 'API Token', 'f3ec9e3579eadbb16890d2629ba633c569c71dcf2735588d43159ccf06fd10a6', '[\"*\"]', '2024-12-16 05:45:14', NULL, '2024-12-16 05:40:00', '2024-12-16 05:45:14'),
(285, 'App\\Models\\User', 7, 'API Token', '5bfeb58ee1d09658c12e490ceca70d34adc6206e36fe9a73241d057c7d879a25', '[\"*\"]', '2024-12-16 05:58:00', NULL, '2024-12-16 05:45:18', '2024-12-16 05:58:00'),
(286, 'App\\Models\\User', 7, 'API Token', '4a5d3218e48cccc7d22bda384a4650d0960e7edef626245e42ebeb8e03e6548e', '[\"*\"]', NULL, NULL, '2024-12-16 05:58:06', '2024-12-16 05:58:06'),
(287, 'App\\Models\\User', 27, 'API Token', '2a9bf19054f703b9d1810dea17e044197eab10b07659d52ec8a4e64c0c3dcbee', '[\"*\"]', '2024-12-16 06:46:41', NULL, '2024-12-16 05:58:25', '2024-12-16 06:46:41'),
(288, 'App\\Models\\User', 7, 'API Token', 'a4a8fcfd15d0cda84f2c9671822974f5fe18292569a365a96400427e167a6843', '[\"*\"]', '2024-12-16 07:06:34', NULL, '2024-12-16 06:46:47', '2024-12-16 07:06:34'),
(289, 'App\\Models\\User', 27, 'API Token', '6a9d24969901b119efc4dcfd02c2ee5321aa38a5a36965a1caee4b6d8b54fb67', '[\"*\"]', '2024-12-16 07:20:22', NULL, '2024-12-16 07:06:44', '2024-12-16 07:20:22'),
(290, 'App\\Models\\User', 7, 'API Token', '486bffd31a1b6dd6f9b9d22fef8387f6a4afb6ecad63f75454f85e0f5b657875', '[\"*\"]', '2024-12-16 07:23:20', NULL, '2024-12-16 07:23:01', '2024-12-16 07:23:20'),
(291, 'App\\Models\\User', 27, 'API Token', 'a9bbc8701f8351c405457ed4834fda9445dfe27ac43be9ea375d0d066a9002c4', '[\"*\"]', '2024-12-16 07:29:27', NULL, '2024-12-16 07:23:26', '2024-12-16 07:29:27'),
(292, 'App\\Models\\User', 7, 'API Token', '28222c60640e545cca2d57c9af2d11b4b12ba513085866dee5d050feaacd3a2b', '[\"*\"]', '2024-12-16 07:30:42', NULL, '2024-12-16 07:29:31', '2024-12-16 07:30:42'),
(293, 'App\\Models\\User', 27, 'API Token', '6ecc614a571ce44a1f845637b6ee001ff47dba91cfce8e5041f468c6b849c215', '[\"*\"]', '2024-12-16 07:40:28', NULL, '2024-12-16 07:30:49', '2024-12-16 07:40:28'),
(294, 'App\\Models\\User', 7, 'API Token', '74a02dec45b3bfa1b3c7965354267226965a59545bae8f51d435993986a202ff', '[\"*\"]', '2024-12-16 07:40:49', NULL, '2024-12-16 07:40:33', '2024-12-16 07:40:49'),
(295, 'App\\Models\\User', 27, 'API Token', 'a09bc49b27230bfe2ee6dd77f2ee44321e3bcd8e90b6edcdaa3361df35b0f3bf', '[\"*\"]', '2024-12-16 07:40:56', NULL, '2024-12-16 07:40:45', '2024-12-16 07:40:56'),
(296, 'App\\Models\\User', 7, 'API Token', 'be514f93d8050c1efb2b57dc55c950eaa8df646b3b2f19c890f477821d5bbfd1', '[\"*\"]', '2024-12-16 08:11:59', NULL, '2024-12-16 08:02:24', '2024-12-16 08:11:59'),
(297, 'App\\Models\\User', 27, 'API Token', '0e76cee39d7e385406d4522a2f237074c748499de0a25dfb67cc5f52ce8a3fd1', '[\"*\"]', '2024-12-16 08:15:02', NULL, '2024-12-16 08:12:12', '2024-12-16 08:15:02'),
(298, 'App\\Models\\User', 7, 'API Token', 'af0ef54089d1e6b67a0a77202391fa959088212f513403b64d788e87e3b864fc', '[\"*\"]', '2024-12-16 17:42:57', NULL, '2024-12-16 17:42:42', '2024-12-16 17:42:57'),
(299, 'App\\Models\\User', 27, 'API Token', '616422fb708438c93db317be103be5d4a5d3a363e9f1132f60019cec82269fde', '[\"*\"]', '2024-12-16 18:30:02', NULL, '2024-12-16 17:43:02', '2024-12-16 18:30:02'),
(300, 'App\\Models\\User', 7, 'API Token', '198aeb1ec6e46ee4cba1656832cb226061bd555c8af746abd23a5b2bca6b2aa1', '[\"*\"]', '2024-12-16 18:30:22', NULL, '2024-12-16 18:30:05', '2024-12-16 18:30:22'),
(301, 'App\\Models\\User', 27, 'API Token', '857394f51262f63b1f3f1ad55f7fb7ccf90117cbc9c33aa401d8ca6135024b08', '[\"*\"]', '2024-12-16 18:55:07', NULL, '2024-12-16 18:30:19', '2024-12-16 18:55:07'),
(302, 'App\\Models\\User', 7, 'API Token', '47fcae205307bcb532b1c6f0ac52ed876f4cf4c7257b3804d50f8964fef63c53', '[\"*\"]', '2024-12-16 20:16:10', NULL, '2024-12-16 18:55:12', '2024-12-16 20:16:10'),
(303, 'App\\Models\\User', 27, 'API Token', '0c41a6a3a5d9c4a78ecd2a772762ae109a3a74fb0de43d724c02f7a7b8e675f6', '[\"*\"]', '2024-12-16 20:26:23', NULL, '2024-12-16 20:16:15', '2024-12-16 20:26:23'),
(304, 'App\\Models\\User', 7, 'API Token', '80781707a9c4e7ead0993ab84f9054f4a8c5d296b09d78e8f73c478ffe071560', '[\"*\"]', '2024-12-16 20:26:44', NULL, '2024-12-16 20:26:30', '2024-12-16 20:26:44'),
(305, 'App\\Models\\User', 27, 'API Token', 'c1c64ee761d9952d7ae30d3bcfb6506e7f41c584391c7d176437c4805db154cf', '[\"*\"]', '2024-12-16 22:05:01', NULL, '2024-12-16 20:26:47', '2024-12-16 22:05:01'),
(306, 'App\\Models\\User', 7, 'API Token', '22b2b12fa6ae339f8836b5550d2a3846e4f1eaa41c7cad4bf379dbb6d9bf2dd6', '[\"*\"]', '2024-12-16 22:14:09', NULL, '2024-12-16 22:05:06', '2024-12-16 22:14:09'),
(307, 'App\\Models\\User', 27, 'API Token', 'ff8d3c38b771c4c011a00ea794c3078665424414f9b0b5bee48e4dc4db70adda', '[\"*\"]', '2024-12-17 00:03:32', NULL, '2024-12-16 22:14:28', '2024-12-17 00:03:32'),
(308, 'App\\Models\\User', 27, 'API Token', '78237d83a8f325afd1e81d264cdf69b1906b6b1d5e11baf2f4798159ab5b199f', '[\"*\"]', '2024-12-17 00:36:17', NULL, '2024-12-17 00:03:40', '2024-12-17 00:36:17'),
(309, 'App\\Models\\User', 7, 'API Token', 'ddc6f4c04598107239bac1d14d85af8c0410c776f20c069088850536e6863039', '[\"*\"]', '2024-12-18 20:09:49', NULL, '2024-12-18 20:09:36', '2024-12-18 20:09:49'),
(310, 'App\\Models\\User', 27, 'API Token', 'af382ccdedb5ecedab9fba0874e55480030aedbe47c7b062da4fd08a34e19ff6', '[\"*\"]', '2024-12-18 21:47:19', NULL, '2024-12-18 20:10:09', '2024-12-18 21:47:19'),
(311, 'App\\Models\\User', 27, 'API Token', '10ea3402011a1fdc5e39b3d8a5d28981e997e3a2a9127a4e4a9ae57eaebe084f', '[\"*\"]', '2024-12-18 21:47:51', NULL, '2024-12-18 21:47:46', '2024-12-18 21:47:51'),
(312, 'App\\Models\\User', 27, 'API Token', 'ec7ba905af490cdf0adb495e007c51dd928d5bbdc900f9c9c0471461a8e30816', '[\"*\"]', '2024-12-18 22:50:16', NULL, '2024-12-18 21:53:59', '2024-12-18 22:50:16'),
(313, 'App\\Models\\User', 27, 'API Token', '0b06015f45460045d64f5f8bf5ed4e54782020f5601083ab7114394eeb17d84b', '[\"*\"]', '2024-12-19 01:52:20', NULL, '2024-12-18 22:50:24', '2024-12-19 01:52:20'),
(314, 'App\\Models\\User', 7, 'API Token', 'ee241e90855b03788217fba097aec1808ced04de1faf8c44b0e8c162125160ed', '[\"*\"]', '2024-12-19 03:13:32', NULL, '2024-12-19 03:11:46', '2024-12-19 03:13:32'),
(315, 'App\\Models\\User', 27, 'API Token', 'd0f410fe526a4f44302d305d81c7611eab502da11be3c02d494728ed93975a36', '[\"*\"]', '2024-12-19 03:46:55', NULL, '2024-12-19 03:13:39', '2024-12-19 03:46:55'),
(316, 'App\\Models\\User', 7, 'API Token', 'b9e49bc92ca107c843f580f5c87f77c749ba7bb41890fa4eee7d782b226ca572', '[\"*\"]', '2024-12-19 17:50:03', NULL, '2024-12-19 17:49:32', '2024-12-19 17:50:03'),
(317, 'App\\Models\\User', 27, 'API Token', '46c8efd31392da2f79ac74004b785b1927df8666e379b1cec7b4314e6de8bb32', '[\"*\"]', '2024-12-19 18:55:20', NULL, '2024-12-19 17:49:59', '2024-12-19 18:55:20'),
(318, 'App\\Models\\User', 7, 'API Token', '0e76e2e4e466b65458000c771f06a7fdbf761a7b470f22cc01e319b027500cd2', '[\"*\"]', '2024-12-19 19:53:19', NULL, '2024-12-19 18:55:32', '2024-12-19 19:53:19'),
(319, 'App\\Models\\User', 27, 'API Token', 'a19f05d8eb5de8ac1082649297fc098eef0ca327365e9db13a4e975630eaeb10', '[\"*\"]', '2024-12-19 21:51:22', NULL, '2024-12-19 19:53:27', '2024-12-19 21:51:22'),
(320, 'App\\Models\\User', 7, 'API Token', '58e22136da6f766f885e7be1b453d2d4596bfff2911198147390ee54b82ed770', '[\"*\"]', '2024-12-19 22:29:01', NULL, '2024-12-19 21:51:29', '2024-12-19 22:29:01'),
(321, 'App\\Models\\User', 27, 'API Token', '826b02b118ea3ac7144aa3ecbc68cbce5faf45a58a1b0cba219befc118f2e12d', '[\"*\"]', '2024-12-19 22:50:38', NULL, '2024-12-19 22:29:13', '2024-12-19 22:50:38'),
(322, 'App\\Models\\User', 27, 'API Token', '00dc72c6795ce568484efd3cacb98e68eb800e995c4ca76d1acd36e2b44b9adc', '[\"*\"]', '2024-12-19 23:32:17', NULL, '2024-12-19 22:52:38', '2024-12-19 23:32:17'),
(323, 'App\\Models\\User', 7, 'API Token', 'cf02567559adbd2abc69a4d7540ff65522263461e8363108e6196ce7efa29b68', '[\"*\"]', '2024-12-19 23:34:55', NULL, '2024-12-19 23:32:21', '2024-12-19 23:34:55'),
(324, 'App\\Models\\User', 27, 'API Token', '46b71315c954fb6f13566c9a33d004dcb51a10f73f5ffe69c45bc962a8a0aa5d', '[\"*\"]', '2024-12-20 00:00:29', NULL, '2024-12-19 23:35:04', '2024-12-20 00:00:29'),
(325, 'App\\Models\\User', 7, 'API Token', '335b69daeee984041b5357da891518a92c005d4a990b852934cf571e51150645', '[\"*\"]', '2024-12-20 00:22:09', NULL, '2024-12-20 00:00:33', '2024-12-20 00:22:09'),
(326, 'App\\Models\\User', 27, 'API Token', '816e2f48fc00cd4e4f43f56aedc6fcb5d5e8c99612b438b1d2697814198f2c24', '[\"*\"]', '2024-12-20 00:23:17', NULL, '2024-12-20 00:22:15', '2024-12-20 00:23:17'),
(327, 'App\\Models\\User', 7, 'API Token', '9b9bb6b0fb3129812a2a3995ecb3c87d51fb777825b65e058d5478babe5a7ea0', '[\"*\"]', '2024-12-20 00:27:43', NULL, '2024-12-20 00:23:22', '2024-12-20 00:27:43'),
(328, 'App\\Models\\User', 27, 'API Token', '5186605eb359a45302976cc2633fb732b334bc0433dd01327b415bec1e0ba772', '[\"*\"]', '2024-12-20 00:30:12', NULL, '2024-12-20 00:27:50', '2024-12-20 00:30:12'),
(329, 'App\\Models\\User', 7, 'API Token', '6aec3828a732cc064c1e272e08e5559972c0707fed6da3f3cc7c344c47d3c993', '[\"*\"]', '2024-12-20 01:46:36', NULL, '2024-12-20 00:30:21', '2024-12-20 01:46:36'),
(330, 'App\\Models\\User', 27, 'API Token', '673e0c469bf644b06beb276fdd182fe87e77365b4a9e85b424cf75373a207057', '[\"*\"]', '2024-12-20 02:02:50', NULL, '2024-12-20 01:46:56', '2024-12-20 02:02:50'),
(331, 'App\\Models\\User', 7, 'API Token', '35c628274089161f3033b8c194df7b91d7a191173d8c66e18020f35322cfbc33', '[\"*\"]', '2024-12-20 02:13:11', NULL, '2024-12-20 02:02:55', '2024-12-20 02:13:11'),
(332, 'App\\Models\\User', 27, 'API Token', '8cc905367c10d3fb08fffbab71f4b5e333927ef3740dcd42ebe6959d3818f66a', '[\"*\"]', '2024-12-20 02:45:28', NULL, '2024-12-20 02:13:18', '2024-12-20 02:45:28'),
(333, 'App\\Models\\User', 7, 'API Token', '45db56f469b329e7c2e2fdb3f930ff736ccdf63ef9ef75bab6a3b969b384db66', '[\"*\"]', '2024-12-20 02:54:07', NULL, '2024-12-20 02:45:32', '2024-12-20 02:54:07'),
(334, 'App\\Models\\User', 7, 'API Token', '748c5b85919cbaffe1af8ef274a0ab17ff0746e15c3c2805b1981afbc9a4c98b', '[\"*\"]', '2024-12-20 06:51:59', NULL, '2024-12-20 02:56:52', '2024-12-20 06:51:59'),
(335, 'App\\Models\\User', 7, 'API Token', '732a840bd1d7c6fe806203c73973955938052a1f5e2ae90330b82a0600cc11ff', '[\"*\"]', NULL, NULL, '2024-12-20 06:55:18', '2024-12-20 06:55:18'),
(336, 'App\\Models\\User', 7, 'API Token', '8a375c314259f8bb815e8d83dc499b4325b98e7699b22a1b1228e08e4ac74f0f', '[\"*\"]', '2024-12-20 07:44:26', NULL, '2024-12-20 07:26:24', '2024-12-20 07:44:26'),
(337, 'App\\Models\\User', 27, 'API Token', 'd7b762503d60d040092cd4b29ed11a974f2bc70d479cbed7403071d6a7fccad6', '[\"*\"]', '2024-12-20 08:33:18', NULL, '2024-12-20 07:47:41', '2024-12-20 08:33:18'),
(338, 'App\\Models\\User', 7, 'API Token', 'fd742f66e5f05eee82d10d1f364d1d1cb0a479a809465774f7cd98cca32076c0', '[\"*\"]', '2024-12-20 08:34:02', NULL, '2024-12-20 08:33:23', '2024-12-20 08:34:02'),
(339, 'App\\Models\\User', 27, 'API Token', '635f6acc2c676936a6a46ea323861cc20518a6840df60cebcc244ff01e4b9fb8', '[\"*\"]', '2024-12-20 08:37:13', NULL, '2024-12-20 08:34:09', '2024-12-20 08:37:13'),
(340, 'App\\Models\\User', 7, 'API Token', 'f973e700dd3c5d4583e21d1e4a04b073341b09b48bccbef26124e188fd7e4347', '[\"*\"]', '2024-12-20 08:37:42', NULL, '2024-12-20 08:37:18', '2024-12-20 08:37:42'),
(341, 'App\\Models\\User', 27, 'API Token', '13c52e046fe707a211c0770008a23c4834f91a63d31a10cdab6a1c46fc4ae2a3', '[\"*\"]', '2024-12-20 09:06:42', NULL, '2024-12-20 08:37:48', '2024-12-20 09:06:42'),
(342, 'App\\Models\\User', 7, 'API Token', '6f1ddc0517b8086fe862f753c4211be8d00e28e77d4ca3cb5f338a409bace86a', '[\"*\"]', '2024-12-20 10:29:21', NULL, '2024-12-20 09:06:47', '2024-12-20 10:29:21'),
(343, 'App\\Models\\User', 7, 'API Token', '26a717db9039742ac870624ad941f9303f528c531ec25043872ed45591299ebb', '[\"*\"]', '2024-12-20 11:06:43', NULL, '2024-12-20 10:38:01', '2024-12-20 11:06:43'),
(344, 'App\\Models\\User', 27, 'API Token', '9b8e8975f52d4147bbb070eb2e9655c450f43f76fec2d26675f7cc244f8a3b75', '[\"*\"]', '2024-12-20 11:08:01', NULL, '2024-12-20 11:07:09', '2024-12-20 11:08:01'),
(345, 'App\\Models\\User', 7, 'API Token', '6cb47ca8e058e139c73459aa5553f177b4a53f79ca3f3201f1c223e216b75db0', '[\"*\"]', '2024-12-20 11:31:56', NULL, '2024-12-20 11:08:06', '2024-12-20 11:31:56'),
(346, 'App\\Models\\User', 27, 'API Token', '3ca37176a058c812e7f7fce42199f78848483002610a15936ccc85870f061f50', '[\"*\"]', '2024-12-20 11:32:31', NULL, '2024-12-20 11:32:03', '2024-12-20 11:32:31'),
(347, 'App\\Models\\User', 7, 'API Token', '2063586072fb2d02b061996aff56abed1e596bae615c484ecba721543bf24a2d', '[\"*\"]', '2024-12-20 17:48:28', NULL, '2024-12-20 11:32:35', '2024-12-20 17:48:28'),
(348, 'App\\Models\\User', 7, 'API Token', 'a7f51af601b2e0d8751e334ef52480ab232564171f8ad1158bf046bcb96c8555', '[\"*\"]', '2024-12-20 17:49:00', NULL, '2024-12-20 17:48:32', '2024-12-20 17:49:00'),
(349, 'App\\Models\\User', 27, 'API Token', '180c763301ae3cdf05efb59a8564da8e0a9339b37390c4522ac6af78619de9c4', '[\"*\"]', '2024-12-20 18:03:30', NULL, '2024-12-20 17:49:15', '2024-12-20 18:03:30'),
(350, 'App\\Models\\User', 7, 'API Token', '499d255e042f8fc097901c2a1812c95a5f8f3026dba2b00fac5ca7a04266510a', '[\"*\"]', '2024-12-20 21:35:42', NULL, '2024-12-20 18:03:30', '2024-12-20 21:35:42'),
(351, 'App\\Models\\User', 7, 'API Token', '44bbd77970388a29f6459a4827cf637cfba89fc7312978b0fe4dab6712bb7296', '[\"*\"]', '2024-12-20 21:54:21', NULL, '2024-12-20 21:42:17', '2024-12-20 21:54:21'),
(352, 'App\\Models\\User', 7, 'API Token', '7000a59d4ad7630905cd7db564afcb93a46e6fbbfc4ac0373d98c929c3cc7ca2', '[\"*\"]', NULL, NULL, '2024-12-20 21:54:26', '2024-12-20 21:54:26'),
(353, 'App\\Models\\User', 7, 'API Token', '66f158b982c0b8b1b412849be3ca44be21782fd6df1730ba83d94cad0f30a1f6', '[\"*\"]', '2024-12-20 22:14:29', NULL, '2024-12-20 21:58:01', '2024-12-20 22:14:29'),
(354, 'App\\Models\\User', 7, 'API Token', 'e9a7d553f61fdce61f294cfba9925e922c0332989b76510fe687747dcad02e66', '[\"*\"]', NULL, NULL, '2024-12-20 22:14:32', '2024-12-20 22:14:32'),
(355, 'App\\Models\\User', 27, 'API Token', 'bbdbeccd746a9b975f6b4de06ed4044c7526ff810a677af4b81fddb2ca1892fb', '[\"*\"]', '2024-12-21 01:41:20', NULL, '2024-12-20 22:53:46', '2024-12-21 01:41:20'),
(356, 'App\\Models\\User', 27, 'API Token', '62240f86379c233f1e840b8a76fe0902ce99be03db026d5609d2f290946b7138', '[\"*\"]', '2024-12-21 02:03:19', NULL, '2024-12-21 01:51:42', '2024-12-21 02:03:19'),
(357, 'App\\Models\\User', 7, 'API Token', '9095c1eea3df7a63afb27da85d71255043892540581f39e4179ed1fc38cc2bfc', '[\"*\"]', '2024-12-21 02:18:53', NULL, '2024-12-21 02:03:26', '2024-12-21 02:18:53'),
(358, 'App\\Models\\User', 27, 'API Token', '8838bf099416ba95ab5465307c9ef83415018a7ef235700000e5c62237204e85', '[\"*\"]', '2024-12-21 02:26:48', NULL, '2024-12-21 02:18:59', '2024-12-21 02:26:48'),
(359, 'App\\Models\\User', 27, 'API Token', 'a6ec382167959ce90473437e98f634104da56bcd05127a43ae183f61ea68cb27', '[\"*\"]', '2024-12-21 02:48:17', NULL, '2024-12-21 02:27:47', '2024-12-21 02:48:17'),
(360, 'App\\Models\\User', 7, 'API Token', '9530c5d59e46282e7bc6e8b1a5f4c8e49fac0aa7727cefe3bde0233a8285f70b', '[\"*\"]', '2024-12-21 02:55:42', NULL, '2024-12-21 02:48:21', '2024-12-21 02:55:42'),
(361, 'App\\Models\\User', 27, 'API Token', '15849c9d004a98c127e64a0b8122e2796f9c1b47c4ef5d8a0c17c9e32eaa9fe1', '[\"*\"]', '2024-12-21 02:58:33', NULL, '2024-12-21 02:55:51', '2024-12-21 02:58:33'),
(362, 'App\\Models\\User', 7, 'API Token', 'caea635bdda2991393255b88ca691140c99c547704207bf909b76ba4670292d9', '[\"*\"]', '2024-12-21 03:12:08', NULL, '2024-12-21 02:58:40', '2024-12-21 03:12:08'),
(363, 'App\\Models\\User', 27, 'API Token', 'ac80bc62c0b1e5656159bccbf506b16d6f290d66c82a41a975394928a7669090', '[\"*\"]', '2024-12-21 22:06:22', NULL, '2024-12-21 03:12:10', '2024-12-21 22:06:22'),
(364, 'App\\Models\\User', 27, 'API Token', '64451e4aab679fafba80143882d45bdf329f4c7c6aaf059527770f6ef6d8a979', '[\"*\"]', '2024-12-21 22:07:26', NULL, '2024-12-21 22:07:08', '2024-12-21 22:07:26'),
(365, 'App\\Models\\User', 7, 'API Token', 'ee33cf1d873f6e4fd5a1b9cc24faf61aa1e94a680b1613b6b5aa89a9e7053f07', '[\"*\"]', '2024-12-21 22:07:45', NULL, '2024-12-21 22:07:16', '2024-12-21 22:07:45'),
(366, 'App\\Models\\User', 27, 'API Token', 'cbc8e4c26a6cdf532ab83dc6fdd0fbb2fe3c6b085fce05d5e792e33b69ae583d', '[\"*\"]', '2024-12-22 00:46:37', NULL, '2024-12-21 22:22:58', '2024-12-22 00:46:37'),
(367, 'App\\Models\\User', 7, 'API Token', '65d8fc47128b21dadfa7d1c6e74841e24b6e3a3d192120b340fea2c3cb55e35b', '[\"*\"]', '2024-12-25 00:38:02', NULL, '2024-12-25 00:37:27', '2024-12-25 00:38:02'),
(368, 'App\\Models\\User', 27, 'API Token', '0581c3d23d8c63678299745f0f860cb85886a0303038226337da9d5d7f0a2023', '[\"*\"]', '2024-12-25 00:43:04', NULL, '2024-12-25 00:37:46', '2024-12-25 00:43:04'),
(369, 'App\\Models\\User', 27, 'API Token', 'a054db9daa6e94be63a2ef960da81906e9eb9a5deba0414412419b81b7bc954f', '[\"*\"]', '2024-12-25 00:52:13', NULL, '2024-12-25 00:44:01', '2024-12-25 00:52:13'),
(370, 'App\\Models\\User', 27, 'API Token', '20ece9b20af5ed7418e4b926fd3395c68eccc5bf3faadcdf4647a2a166a65cd5', '[\"*\"]', '2024-12-25 19:13:04', NULL, '2024-12-25 19:12:51', '2024-12-25 19:13:04'),
(371, 'App\\Models\\User', 27, 'API Token', '61d6da2c214f19c25c59098014a056ee87c3d3e9a1532d60ead8cf1433a08dee', '[\"*\"]', NULL, NULL, '2024-12-25 19:12:52', '2024-12-25 19:12:52'),
(372, 'App\\Models\\User', 7, 'API Token', '81b902b4fc679d98be3add8a0d18685c476c904bdf328718bd12bc206a124715', '[\"*\"]', '2024-12-25 22:46:44', NULL, '2024-12-25 19:13:04', '2024-12-25 22:46:44'),
(373, 'App\\Models\\User', 27, 'API Token', '8e0473f66a63eff5760fee7ddfa1289b1c382c6e5139b6492a650aea143623be', '[\"*\"]', '2024-12-25 23:15:25', NULL, '2024-12-25 22:46:54', '2024-12-25 23:15:25'),
(374, 'App\\Models\\User', 7, 'API Token', '3f4acf88ecb0e9ebb28c926ed73f394971856c7d86756894793b5f5ea44545d0', '[\"*\"]', '2024-12-25 23:34:29', NULL, '2024-12-25 23:15:34', '2024-12-25 23:34:29'),
(375, 'App\\Models\\User', 27, 'API Token', 'ce82ae8dc5897dfe65dd2e8c9e161d8e76a20859a4f6bc1f6cc3179a59a775ed', '[\"*\"]', '2024-12-25 23:36:14', NULL, '2024-12-25 23:34:36', '2024-12-25 23:36:14'),
(376, 'App\\Models\\User', 7, 'API Token', '82449abc25ec62766c21d9441c332ba39f7e2330f2ed6c5365b603500738ff4c', '[\"*\"]', '2024-12-25 23:37:22', NULL, '2024-12-25 23:36:20', '2024-12-25 23:37:22'),
(377, 'App\\Models\\User', 27, 'API Token', '6b5a0d3cd5e3ed5206915a02a7cd9987049df797dd6e6705c15bfdfeac1f0bbd', '[\"*\"]', '2024-12-26 07:56:35', NULL, '2024-12-25 23:37:26', '2024-12-26 07:56:35'),
(378, 'App\\Models\\User', 7, 'API Token', '91a0df20520c9f7d13758317a0e3c61cccb34e5183327a090f86141560c907a0', '[\"*\"]', '2024-12-26 07:57:47', NULL, '2024-12-26 07:56:38', '2024-12-26 07:57:47'),
(379, 'App\\Models\\User', 27, 'API Token', 'f11563d3491c5af7ad279246c16009c0cf4c26182e51caf707cbdf63946477a2', '[\"*\"]', '2024-12-26 09:32:19', NULL, '2024-12-26 07:57:53', '2024-12-26 09:32:19'),
(380, 'App\\Models\\User', 7, 'API Token', '1c36a3f924a2da970393eec2553218525ea83dfcf87014748cafbbe1dd3b834f', '[\"*\"]', '2024-12-29 07:25:35', NULL, '2024-12-26 09:34:00', '2024-12-29 07:25:35'),
(381, 'App\\Models\\User', 7, 'API Token', 'a9e4f66986bb9dbf7e6188ae11e8df27793a71e07ccb98693bc1488198b7fb4c', '[\"*\"]', '2024-12-29 07:26:32', NULL, '2024-12-29 07:26:20', '2024-12-29 07:26:32'),
(382, 'App\\Models\\User', 7, 'API Token', 'b232d727baedf2f4b2ee2f225ad488affbf5e971f0983bea061a4e0ce450e4b2', '[\"*\"]', '2025-01-01 02:37:43', NULL, '2024-12-31 01:42:28', '2025-01-01 02:37:43'),
(383, 'App\\Models\\User', 7, 'API Token', '3bd54152ffcbeae3ad0c0f249fe44eae3234b607fd3d5c25c619e933dc03abc6', '[\"*\"]', NULL, NULL, '2024-12-31 01:42:32', '2024-12-31 01:42:32'),
(384, 'App\\Models\\User', 7, 'API Token', '22eef6e2dc8f91a2249a2d6f179af424f74728a356b809e8af5a5a310078db82', '[\"*\"]', '2025-01-01 02:38:06', NULL, '2025-01-01 02:37:51', '2025-01-01 02:38:06'),
(385, 'App\\Models\\User', 7, 'API Token', '3d987263f33c4596280f85b5149d5b7a75119d1b9e0aa83919d7dd8dfceb1678', '[\"*\"]', '2025-01-01 03:27:16', NULL, '2025-01-01 02:38:32', '2025-01-01 03:27:16'),
(386, 'App\\Models\\User', 7, 'API Token', 'fbc716897f081e53e3eaa10ddd5f622648848e04af7aa78d3643d9ed48db3c50', '[\"*\"]', '2025-01-01 03:43:10', NULL, '2025-01-01 03:27:30', '2025-01-01 03:43:10'),
(387, 'App\\Models\\User', 7, 'API Token', 'd9592acb23d7c57b5d2076a6db95df596cd16c4c50d6f540b2d965810451162e', '[\"*\"]', '2025-01-01 04:00:47', NULL, '2025-01-01 04:00:38', '2025-01-01 04:00:47'),
(388, 'App\\Models\\User', 7, 'API Token', '1aecd7890601272d7913b52b2b6a79aa2175e6bfaf7acd7fd322eb85b85af08b', '[\"*\"]', '2025-01-01 04:01:16', NULL, '2025-01-01 04:00:53', '2025-01-01 04:01:16'),
(389, 'App\\Models\\User', 27, 'API Token', '8baadcea4ce17d6bfca97e85d165701970df808e4bf876ca92f03ce2dd11dee8', '[\"*\"]', '2025-01-01 09:51:53', NULL, '2025-01-01 04:32:09', '2025-01-01 09:51:53'),
(390, 'App\\Models\\User', 30, 'GoogleLogin', '05bba202fcd36e89a85138d497ac7f6773040c3c23eb65f20c1381d6121b2add', '[\"*\"]', '2025-01-02 07:07:57', NULL, '2025-01-02 06:40:23', '2025-01-02 07:07:57'),
(391, 'App\\Models\\User', 30, 'GoogleLogin', '1eb7f3885787faf78a906c9f96ba2d870a08867ef42fe3d71db8f98046f19195', '[\"*\"]', NULL, NULL, '2025-01-02 07:47:12', '2025-01-02 07:47:12'),
(392, 'App\\Models\\User', 30, 'GoogleLogin', '940c96130555ca4718e3dd8b0e0826961247b76bc617bb272cb21b92c25be6e7', '[\"*\"]', NULL, NULL, '2025-01-02 07:55:42', '2025-01-02 07:55:42'),
(393, 'App\\Models\\User', 30, 'GoogleLogin', 'bb946ab788f8e7361d603cf186d440d8aac65658c8a5f05c628cad4bdba410d6', '[\"*\"]', NULL, NULL, '2025-01-02 07:56:33', '2025-01-02 07:56:33'),
(394, 'App\\Models\\User', 30, 'GoogleLogin', 'ed418ae30d817cc17dfc7ba81e9a4f914cb4f20a6098988f2625f913b0647e29', '[\"*\"]', NULL, NULL, '2025-01-02 08:03:55', '2025-01-02 08:03:55'),
(395, 'App\\Models\\User', 30, 'GoogleLogin', 'b85e14d8c4ba6f994764113d5b88ada7fcdfc0104bee081cbf91af3043361a0c', '[\"*\"]', NULL, NULL, '2025-01-02 08:09:50', '2025-01-02 08:09:50'),
(396, 'App\\Models\\User', 30, 'GoogleLogin', '7d3408334a75459d7ed674219d0de01254a3deb54d66dec5b269652245229546', '[\"*\"]', '2025-01-02 08:12:00', NULL, '2025-01-02 08:11:33', '2025-01-02 08:12:00'),
(397, 'App\\Models\\User', 7, 'API Token', 'aa285ac940f444c000c0672e39598b02fb9fe580c49d37c669a535a72cfddc7b', '[\"*\"]', '2025-01-02 08:19:40', NULL, '2025-01-02 08:19:18', '2025-01-02 08:19:40'),
(398, 'App\\Models\\User', 7, 'API Token', '2f38a01ca0a8ce409f7fb4431eef123bb9dbab1a830e26590538f026931f70f9', '[\"*\"]', '2025-01-02 08:20:14', NULL, '2025-01-02 08:19:52', '2025-01-02 08:20:14'),
(399, 'App\\Models\\User', 7, 'API Token', '18d18e0768b540f5d4c12a3bf6364b3d2af29333e66a718be13a6b97b756b3b5', '[\"*\"]', '2025-01-02 08:27:14', NULL, '2025-01-02 08:26:52', '2025-01-02 08:27:14'),
(400, 'App\\Models\\User', 7, 'API Token', 'a353bbd9beaf8e3a7bbb95bb1f81f1aedfa24a024904ae6ece733e654a0f306b', '[\"*\"]', '2025-01-02 08:31:49', NULL, '2025-01-02 08:31:25', '2025-01-02 08:31:49'),
(401, 'App\\Models\\User', 7, 'API Token', 'fd1ba672f25dcd07f5b279d9eddd0f12be030145d2b3205f6fa32fc7da6afe88', '[\"*\"]', '2025-01-02 08:33:38', NULL, '2025-01-02 08:33:15', '2025-01-02 08:33:38'),
(402, 'App\\Models\\User', 7, 'API Token', 'dc0ba29a25f2ba0374c97670365b860b64cc8dca363640f3fef61e3bc23468a1', '[\"*\"]', '2025-01-02 08:40:53', NULL, '2025-01-02 08:40:28', '2025-01-02 08:40:53'),
(403, 'App\\Models\\User', 27, 'API Token', '0146ee187a916d8b5d7659d5502bb61173b946dcf8127514efd8ceaceb161255', '[\"*\"]', '2025-01-02 08:41:37', NULL, '2025-01-02 08:41:23', '2025-01-02 08:41:37'),
(404, 'App\\Models\\User', 7, 'API Token', '7773bb191ea9f0fc0bea588b040fb730a4768b90adeb40d09215d6503097122b', '[\"*\"]', '2025-01-02 08:45:27', NULL, '2025-01-02 08:45:04', '2025-01-02 08:45:27'),
(405, 'App\\Models\\User', 29, 'GoogleLogin', '7ad47158d44b51372486dd9edf8b2b16fef380e6a39e408ff94b96089a375f55', '[\"*\"]', NULL, NULL, '2025-01-02 09:04:11', '2025-01-02 09:04:11'),
(406, 'App\\Models\\User', 30, 'GoogleLogin', 'e4e9a6b110e0a3a59780a5183b43105cfd23887ad098139186ab1990e7e607ee', '[\"*\"]', NULL, NULL, '2025-01-02 09:04:55', '2025-01-02 09:04:55'),
(407, 'App\\Models\\User', 7, 'API Token', '72b76dd9758a7bdf709d7ae4da17b9fdac124b6d33e432f07b7e807bbf5b92c7', '[\"*\"]', '2025-01-02 09:09:14', NULL, '2025-01-02 09:08:52', '2025-01-02 09:09:14'),
(408, 'App\\Models\\User', 7, 'API Token', 'eb9809cbcc0aa231d399ea954f2b7d993ef6138b074e1b5d03d259c100ef6ea0', '[\"admin-tenant\"]', '2025-01-02 09:25:46', NULL, '2025-01-02 09:25:25', '2025-01-02 09:25:46'),
(409, 'App\\Models\\User', 7, 'API Token', '63ab81ce6b68f26c7616aa2c32a2a6ba0836e1aa8b35d4333c8ae4414695a21c', '[\"admin-tenant\"]', '2025-01-02 09:36:58', NULL, '2025-01-02 09:36:36', '2025-01-02 09:36:58'),
(410, 'App\\Models\\User', 29, 'GoogleLogin', '9208180b9dc95009c7d2bf78b0bb475d62c2e55ff7066b7f00ec724e4d0dd913', '[\"*\"]', '2025-01-02 09:53:28', NULL, '2025-01-02 09:38:09', '2025-01-02 09:53:28'),
(411, 'App\\Models\\User', 29, 'GoogleLogin', 'a8884b63bb3818c0ff0ad859615714d96c8b5e9bc2fca72613fc18b5e6d9735b', '[\"*\"]', '2025-01-02 11:02:13', NULL, '2025-01-02 09:53:39', '2025-01-02 11:02:13'),
(412, 'App\\Models\\User', 7, 'API Token', '3528a809757fd2c7f4ead20380f0742abedb8b4ec996e4cc14cc7f4aeeae6fd4', '[\"admin-tenant\"]', '2025-01-02 11:02:49', NULL, '2025-01-02 11:02:25', '2025-01-02 11:02:49'),
(413, 'App\\Models\\User', 27, 'API Token', '99156b8a1fcb208231be3a6b845b2402ed13c2b6c720198e2d17b238267166de', '[\"admin-tenant\"]', '2025-01-02 11:08:02', NULL, '2025-01-02 11:06:53', '2025-01-02 11:08:02'),
(414, 'App\\Models\\User', 28, 'GoogleLogin', '9b60a2d6ebcd18b7e189af0d495d0297e625a3dc55584b5c2fa11d6e32580d5c', '[\"*\"]', '2025-01-02 11:25:34', NULL, '2025-01-02 11:08:34', '2025-01-02 11:25:34'),
(415, 'App\\Models\\User', 28, 'GoogleLogin', 'af1dcd6b484c531f40f3c2f68c430007e4056edbc801052586b2a4b655ad4ebd', '[\"*\"]', '2025-01-02 11:56:44', NULL, '2025-01-02 11:27:39', '2025-01-02 11:56:44'),
(416, 'App\\Models\\User', 7, 'API Token', 'eaa3b3171b578e5201df2406225e22bf95563662e999271ecbe70a4f9c0cdf31', '[\"admin-tenant\"]', '2025-01-02 14:35:51', NULL, '2025-01-02 12:39:19', '2025-01-02 14:35:51'),
(417, 'App\\Models\\User', 27, 'GoogleLogin', 'cb8bbd3fe3e34828195291c20306b387cd88f1df3d13c7994f753719f5718eee', '[\"*\"]', '2025-01-02 14:53:15', NULL, '2025-01-02 14:36:11', '2025-01-02 14:53:15'),
(418, 'App\\Models\\User', 7, 'API Token', '101b91ab3c9fcb9044373919202d6299fe68bbd00b0935dd69d84feadf78458e', '[\"admin-tenant\"]', '2025-01-02 14:58:43', NULL, '2025-01-02 14:58:18', '2025-01-02 14:58:43'),
(419, 'App\\Models\\User', 27, 'GoogleLogin', '7e597e151fa8fdd122e7ba293c3c44d2344ef52f2aef7e778f7c75e0d9b06a31', '[\"*\"]', NULL, NULL, '2025-01-02 14:59:42', '2025-01-02 14:59:42'),
(420, 'App\\Models\\User', 7, 'API Token', '8fe5ed908035426d09777777f775104633e83fca5ee0cc035e6fb1d91d0d867a', '[\"admin-tenant\"]', '2025-01-02 17:51:02', NULL, '2025-01-02 17:50:36', '2025-01-02 17:51:02'),
(421, 'App\\Models\\User', 28, 'GoogleLogin', 'bec2c7eefcfd573485fd4d669048280c03dbdf2d14296751d067ee3450ebe59d', '[\"*\"]', '2025-01-02 17:51:48', NULL, '2025-01-02 17:51:27', '2025-01-02 17:51:48'),
(422, 'App\\Models\\User', 7, 'API Token', '7c1417e9fcf8f3f5d722bab1912ff637a2ebcb2b9092a1412c1e3456724ad3a9', '[\"admin-tenant\"]', '2025-01-02 17:52:48', NULL, '2025-01-02 17:52:24', '2025-01-02 17:52:48'),
(423, 'App\\Models\\User', 29, 'GoogleLogin', '057c5bffde19a09d70c796812c5fac49122938e0bcd13ae8b283c776fd291992', '[\"*\"]', NULL, NULL, '2025-01-02 17:53:50', '2025-01-02 17:53:50'),
(424, 'App\\Models\\User', 7, 'API Token', '1319537a61c410fd901a9049b0eb487f3d07a51cbc155e552615dbfe4cf57ade', '[\"admin-tenant\"]', '2025-01-02 17:58:49', NULL, '2025-01-02 17:58:24', '2025-01-02 17:58:49'),
(425, 'App\\Models\\User', 7, 'API Token', 'ed5b612625dc373c14c4e850c2f847219b31665f3932b0f0463b3bda62990bef', '[\"admin-tenant\"]', '2025-01-02 18:55:48', NULL, '2025-01-02 18:29:35', '2025-01-02 18:55:48'),
(426, 'App\\Models\\User', 7, 'API Token', 'eb4aae223550e7189ad26dd8b8d0d00a2e1ac21384eced3d80ff84751f0ee454', '[\"admin-tenant\"]', '2025-01-02 19:14:02', NULL, '2025-01-02 19:08:44', '2025-01-02 19:14:02'),
(427, 'App\\Models\\User', 7, 'API Token', '465b83a70aa5ac5539bc40c66b8be9883f80ea339e4797b478300b0167c1d06e', '[\"admin-tenant\"]', '2025-01-02 19:32:01', NULL, '2025-01-02 19:31:39', '2025-01-02 19:32:01'),
(428, 'App\\Models\\User', 7, 'API Token', '46285481631118e0d9a4775552177ebc45d559b508c57a0f7ca858d106d3ee85', '[\"admin-tenant\"]', '2025-01-02 19:54:10', NULL, '2025-01-02 19:53:40', '2025-01-02 19:54:10'),
(429, 'App\\Models\\User', 27, 'API Token', 'e7592934368b4a57b4150e8e08036631095ebf30260bba9d44451496fcf40375', '[\"admin-tenant\"]', '2025-01-02 19:54:22', NULL, '2025-01-02 19:54:06', '2025-01-02 19:54:22'),
(430, 'App\\Models\\User', 27, 'API Token', '5aac6cdb39b1faaf27c515cb4d58ff320a45837e50a73c716a74d076cc7cacc5', '[\"admin-tenant\"]', NULL, NULL, '2025-01-02 19:54:07', '2025-01-02 19:54:07'),
(431, 'App\\Models\\User', 27, 'API Token', 'db9b1e4dd5adc0cd3488d5b80eab7e8e91505f965e877bfba792094aaeddbbd1', '[\"admin-tenant\"]', '2025-01-03 04:19:05', NULL, '2025-01-02 19:54:37', '2025-01-03 04:19:05'),
(432, 'App\\Models\\User', 27, 'API Token', '0bb7a9e60c2fa6dfa3ca99e6a62e2b47815d6f778b81436869011546ac095f6a', '[\"admin-tenant\"]', '2025-01-03 04:26:53', NULL, '2025-01-03 04:19:30', '2025-01-03 04:26:53'),
(433, 'App\\Models\\User', 27, 'API Token', '1a90f689828a4efa1b2e708c54bf70c8586f98fbcc5c63d9d0d85d1e5c421024', '[\"admin-tenant\"]', '2025-01-03 04:31:25', NULL, '2025-01-03 04:27:07', '2025-01-03 04:31:25'),
(434, 'App\\Models\\User', 27, 'API Token', 'c924990fad638f0195585af6773ec00bf46e068365a71e95044c10d4281c915a', '[\"admin-tenant\"]', '2025-01-03 04:41:34', NULL, '2025-01-03 04:41:24', '2025-01-03 04:41:34'),
(435, 'App\\Models\\User', 30, 'API Token', '5c08b78cda885c20d07770615e024b38815d8580d79078cd5605be1c2f7561cc', '[\"admin-tenant\"]', '2025-01-03 04:47:35', NULL, '2025-01-03 04:47:23', '2025-01-03 04:47:35'),
(436, 'App\\Models\\User', 30, 'API Token', 'e33da0ebc770d79f464d9e000415c562cc86bc06f6ac98d48c3da1527399eb3b', '[\"admin-tenant\"]', '2025-01-03 04:54:31', NULL, '2025-01-03 04:54:20', '2025-01-03 04:54:31'),
(437, 'App\\Models\\User', 30, 'API Token', '672672233915fca1a560da9c084f31163b84f2ba9a215c109bffe2b2cd9dd222', '[\"admin-tenant\"]', '2025-01-03 04:58:45', NULL, '2025-01-03 04:58:10', '2025-01-03 04:58:45'),
(438, 'App\\Models\\User', 30, 'API Token', 'd8fd0c334dc452baa412794d2a00cb2a3161e36bfa33dcc4587108a7b06f33e5', '[\"admin-tenant\"]', '2025-01-03 05:00:11', NULL, '2025-01-03 05:00:00', '2025-01-03 05:00:11'),
(439, 'App\\Models\\User', 30, 'API Token', '4966ae7cb9bc323aa697b1b6195310b63bc3548d60e12042043b80c64e2640ff', '[\"admin-tenant\"]', '2025-01-03 05:00:52', NULL, '2025-01-03 05:00:25', '2025-01-03 05:00:52'),
(440, 'App\\Models\\User', 7, 'API Token', '6d2870252364b8232e22d29bb39ed319a5ab60834abe871e3aee3483b2432065', '[\"admin-tenant\"]', '2025-01-03 05:01:58', NULL, '2025-01-03 05:01:39', '2025-01-03 05:01:58'),
(441, 'App\\Models\\User', 30, 'API Token', 'db8195dec240b6285af12915e7771c9a8b3c7b1890d8866759ba6995b307db63', '[\"admin-tenant\"]', '2025-01-03 05:04:43', NULL, '2025-01-03 05:04:31', '2025-01-03 05:04:43'),
(442, 'App\\Models\\User', 30, 'API Token', 'fc3cdb3a4b566a029e28c335be9ad4cfd9afd7dc1edb599b8d31625f2c65650e', '[\"admin-tenant\"]', '2025-01-03 05:05:49', NULL, '2025-01-03 05:05:36', '2025-01-03 05:05:49'),
(443, 'App\\Models\\User', 30, 'API Token', '3833e5567713994ba0198659288d5009b03d470089cc7e6d4aa86848e1af35d6', '[\"admin-tenant\"]', '2025-01-03 05:10:28', NULL, '2025-01-03 05:09:25', '2025-01-03 05:10:28'),
(444, 'App\\Models\\User', 7, 'API Token', '817ee5d330d5d1bf8d721d27b18d657a80073fc59903ea7d0f36db0b6b1fcf52', '[\"admin-tenant\"]', '2025-01-03 05:22:13', NULL, '2025-01-03 05:10:49', '2025-01-03 05:22:13'),
(445, 'App\\Models\\User', 30, 'API Token', '4acbddf216550dcbef5348fa0e863df2bca91972dfc831fc35b9f7553f743be8', '[\"admin-tenant\"]', '2025-01-03 05:24:04', NULL, '2025-01-03 05:22:48', '2025-01-03 05:24:04'),
(446, 'App\\Models\\User', 7, 'API Token', '0f6a74d7bfcb02ea268003159390065b3b9d3bf5aed8223af257e96cbfa96a90', '[\"admin-tenant\"]', '2025-01-03 05:25:34', NULL, '2025-01-03 05:24:27', '2025-01-03 05:25:34'),
(447, 'App\\Models\\User', 30, 'API Token', '5004c8313b8715aabc386ce60cc795a9b3500b7c34539b8b64483a304f5b5682', '[\"admin-tenant\"]', '2025-01-03 05:44:04', NULL, '2025-01-03 05:25:45', '2025-01-03 05:44:04'),
(448, 'App\\Models\\User', 7, 'API Token', 'c5a4c5294db70f6c3172862c3efb8c9e29ec5708c50429fbaf564a6725160038', '[\"admin-tenant\"]', '2025-01-03 05:50:15', NULL, '2025-01-03 05:44:06', '2025-01-03 05:50:15'),
(449, 'App\\Models\\User', 30, 'API Token', 'f2701d2926d43db05205759df03bc255d6ebe84c85c4ab002a0b876a919cfce0', '[\"admin-tenant\"]', '2025-01-03 05:50:52', NULL, '2025-01-03 05:50:22', '2025-01-03 05:50:52'),
(450, 'App\\Models\\User', 7, 'API Token', '78747da4b2d681fa0c3b288af42f7c691888d3f0239deb42c17220cf35899087', '[\"admin-tenant\"]', '2025-01-03 05:55:43', NULL, '2025-01-03 05:50:56', '2025-01-03 05:55:43'),
(451, 'App\\Models\\User', 30, 'API Token', '4eae9dfbd909f9188dd8dcb940e525280c9079d4f1f4889ceeaa2a188e8cc5b8', '[\"admin-tenant\"]', '2025-01-03 05:56:17', NULL, '2025-01-03 05:55:49', '2025-01-03 05:56:17'),
(452, 'App\\Models\\User', 7, 'API Token', '35694ac23e8ea1c21976422ad44d57f9bb6ff8002febf801cad6a2567b83bb6e', '[\"admin-tenant\"]', '2025-01-03 06:00:12', NULL, '2025-01-03 05:56:23', '2025-01-03 06:00:12'),
(453, 'App\\Models\\User', 30, 'API Token', '30e1189b2ffe8ae3cbb6d5765eb6e2512cc13ccc571e399b008f90e738e88924', '[\"admin-tenant\"]', '2025-01-03 06:07:44', NULL, '2025-01-03 06:00:20', '2025-01-03 06:07:44'),
(454, 'App\\Models\\User', 7, 'API Token', '9738cb126690af8c4d4f7c48df4bcd93c99e23c8661af5e280f0b000cedd60ea', '[\"admin-tenant\"]', '2025-01-03 06:15:48', NULL, '2025-01-03 06:08:00', '2025-01-03 06:15:48'),
(455, 'App\\Models\\User', 30, 'API Token', 'e989db611ef65533cb2da5c72cb1f27826a1992aeb02a6f182c6819c82585df4', '[\"admin-tenant\"]', '2025-01-03 06:16:29', NULL, '2025-01-03 06:16:05', '2025-01-03 06:16:29'),
(456, 'App\\Models\\User', 7, 'API Token', 'b8374e9706089adf6cca9e394da18e64e8f27e9bd7e02e0ae2f757122c15c183', '[\"admin-tenant\"]', '2025-01-03 07:29:18', NULL, '2025-01-03 06:16:37', '2025-01-03 07:29:18'),
(457, 'App\\Models\\User', 30, 'API Token', '0ac3df77c8e06eee7634d3b081ded1229e34b6aeb75b9e50646ca68dd63d7ed0', '[\"admin-tenant\"]', '2025-01-03 07:36:28', NULL, '2025-01-03 07:29:12', '2025-01-03 07:36:28'),
(458, 'App\\Models\\User', 7, 'API Token', '90251f4e0053f7201f74aa340d2e8e1f289947cb2ca8331ca6bfc2bce42e033c', '[\"admin-tenant\"]', '2025-01-03 07:55:21', NULL, '2025-01-03 07:36:42', '2025-01-03 07:55:21'),
(459, 'App\\Models\\User', 30, 'API Token', 'fc2640c0800774b856785478253817f7ca49391b5bed1251cdfcba11485286d3', '[\"admin-tenant\"]', '2025-01-03 07:56:10', NULL, '2025-01-03 07:55:24', '2025-01-03 07:56:10'),
(460, 'App\\Models\\User', 7, 'API Token', 'ccf5ef2f4b4175829d4e2a1a97cc104b4c732806d179775194096805432f5390', '[\"admin-tenant\"]', '2025-01-03 08:00:16', NULL, '2025-01-03 07:56:13', '2025-01-03 08:00:16'),
(461, 'App\\Models\\User', 30, 'API Token', '41ea7c1ec38e27afc5c8b6fdada461c5cbb8cb55a71ed8fd929612335c00cd6d', '[\"admin-tenant\"]', '2025-01-03 08:02:25', NULL, '2025-01-03 08:00:23', '2025-01-03 08:02:25'),
(462, 'App\\Models\\User', 7, 'API Token', '4041fe3c90b97e3903e630c81f7863001fbe45a22de1874d6dee141ea9e222a6', '[\"admin-tenant\"]', '2025-01-03 08:09:31', NULL, '2025-01-03 08:02:29', '2025-01-03 08:09:31'),
(463, 'App\\Models\\User', 30, 'API Token', 'd13b9070c81e5650a448894e4e9ce5465843f988961390a8c868c05d4bf4e628', '[\"admin-tenant\"]', '2025-01-03 08:10:10', NULL, '2025-01-03 08:09:41', '2025-01-03 08:10:10'),
(464, 'App\\Models\\User', 7, 'API Token', 'f7133c77e321e88f154312df8f7300a76e5aac652c626f2d2fcdc84f7dc39f56', '[\"admin-tenant\"]', '2025-01-03 08:22:40', NULL, '2025-01-03 08:10:14', '2025-01-03 08:22:40'),
(465, 'App\\Models\\User', 30, 'API Token', '86d507652aca38533f2fdadc5bf6545ddf22c45f624c4c36cd9f39bccdde5d18', '[\"admin-tenant\"]', '2025-01-03 08:23:20', NULL, '2025-01-03 08:22:46', '2025-01-03 08:23:20'),
(466, 'App\\Models\\User', 7, 'API Token', '53d84bc9f59d6423e6e0459290030350f26010f5485adeee82e7ae4fffaf6181', '[\"admin-tenant\"]', '2025-01-03 10:59:50', NULL, '2025-01-03 08:23:24', '2025-01-03 10:59:50'),
(467, 'App\\Models\\User', 7, 'API Token', 'd6101c55b6d170ac81f6268761a035f186ae9f39a2bbc6e8934532ced6a37b9b', '[\"admin-tenant\"]', NULL, NULL, '2025-01-03 10:59:55', '2025-01-03 10:59:55'),
(468, 'App\\Models\\User', 7, 'API Token', '6e453a23f9c317d2c9b65fe742f9d0deb8be7658a2e323cb66fd03c3ecec54ba', '[\"admin-tenant\"]', '2025-01-03 11:02:14', NULL, '2025-01-03 11:01:52', '2025-01-03 11:02:14'),
(469, 'App\\Models\\User', 7, 'API Token', '2d50a5ee42e26269dd4fec18ee7591b77307a2020a75dd1974d43eebc8039f1c', '[\"admin-tenant\"]', '2025-01-04 02:58:42', NULL, '2025-01-04 02:58:20', '2025-01-04 02:58:42'),
(470, 'App\\Models\\User', 7, 'API Token', '6e65c18121ddc4b1f8762be4f2c412134a276ba44686b09f60e6f12d9e56d3f9', '[\"admin-tenant\"]', '2025-01-04 03:21:37', NULL, '2025-01-04 03:21:14', '2025-01-04 03:21:37'),
(471, 'App\\Models\\User', 31, 'GoogleLogin', 'a38f8bed43e85779060e40aa5385f541c45a61c2737e1c2ae10fea0ccce522c6', '[\"*\"]', '2025-01-04 04:37:17', NULL, '2025-01-04 04:37:00', '2025-01-04 04:37:17'),
(472, 'App\\Models\\User', 28, 'GoogleLogin', 'd2c6bc22c7655fc68121a984e1bc366d140aecb83933b2875dd1a13b9bd45caf', '[\"*\"]', '2025-01-04 04:44:45', NULL, '2025-01-04 04:37:30', '2025-01-04 04:44:45'),
(473, 'App\\Models\\User', 7, 'API Token', '914f522e60802734dfe30d8f79dd170cbe0ff288d4b8890922668cb7a72c35ed', '[\"admin-tenant\"]', '2025-01-04 05:36:43', NULL, '2025-01-04 04:56:56', '2025-01-04 05:36:43'),
(474, 'App\\Models\\User', 29, 'GoogleLogin', 'd74b9e05a899cdd96b8ff6a12873cc0bf6ea34499606dcc048d6783f8bb1ace9', '[\"*\"]', NULL, NULL, '2025-01-04 06:10:57', '2025-01-04 06:10:57'),
(475, 'App\\Models\\User', 7, 'API Token', 'dea36143cca014639a429c4c48bddb0eca98bf37a2d36da1fb7e725f1f72acf0', '[\"admin-tenant\"]', '2025-01-04 06:12:59', NULL, '2025-01-04 06:12:41', '2025-01-04 06:12:59'),
(476, 'App\\Models\\User', 7, 'API Token', '9cba6a1733fabc34bbd06ccdab744e144f4787f040015c1e7dc6c663731a8cc9', '[\"admin-tenant\"]', '2025-01-04 06:14:01', NULL, '2025-01-04 06:13:41', '2025-01-04 06:14:01'),
(477, 'App\\Models\\User', 27, 'API Token', 'a07564063707dcb3082630383bbaf1397900bb05e78c0ded4aa1e0785e3afbce', '[\"admin-tenant\"]', '2025-01-04 06:51:51', NULL, '2025-01-04 06:18:58', '2025-01-04 06:51:51'),
(478, 'App\\Models\\User', 7, 'API Token', 'a34c856b68295306e3237787a0a9dcb7ba082f86fd4951bfd20b4d255e626911', '[\"admin-tenant\"]', '2025-01-04 18:20:36', NULL, '2025-01-04 17:52:05', '2025-01-04 18:20:36'),
(479, 'App\\Models\\User', 7, 'API Token', '6f189fe28db1524aff0573c4434b5af8cf314f410895cbf94b91513d1e540a8e', '[\"admin-tenant\"]', '2025-01-04 18:31:59', NULL, '2025-01-04 18:20:42', '2025-01-04 18:31:59'),
(480, 'App\\Models\\User', 7, 'API Token', '83a1960e80612efdce0971a5d35d182b5584bee4c80314021bf05dd9d7441ed8', '[\"admin-tenant\"]', '2025-01-04 19:21:43', NULL, '2025-01-04 19:17:38', '2025-01-04 19:21:43'),
(481, 'App\\Models\\User', 28, 'GoogleLogin', 'eb71e5ab7962801ffba48c43fc6651ab7eb1f45e6013548d0b4b103a88b65429', '[\"*\"]', NULL, NULL, '2025-01-04 19:22:25', '2025-01-04 19:22:25'),
(482, 'App\\Models\\User', 7, 'API Token', 'fa09b201dbaccbea2a2f3d2b654489cba313661ccc30e4369c6f8891f888d45e', '[\"admin-tenant\"]', '2025-01-04 19:22:54', NULL, '2025-01-04 19:22:46', '2025-01-04 19:22:54'),
(483, 'App\\Models\\User', 30, 'API Token', '43f3971290c3f7b5c75f9f98f64e7a479557b0c520e4a9abfd405912e25caad9', '[\"admin-tenant\"]', '2025-01-05 08:38:49', NULL, '2025-01-05 08:38:39', '2025-01-05 08:38:49'),
(484, 'App\\Models\\User', 33, 'GoogleLogin', '19eef522f0598439a88edfea0702a54b4391d341dcb89969b78b43f516b6b57c', '[\"*\"]', '2025-01-05 09:12:43', NULL, '2025-01-05 09:11:05', '2025-01-05 09:12:43'),
(485, 'App\\Models\\User', 34, 'API Token', '4b902b7da427327efa885dc374ff13827439ba45481dce208abf7a8a2c55d2f0', '[\"guest\"]', '2025-01-05 09:51:40', NULL, '2025-01-05 09:51:32', '2025-01-05 09:51:40'),
(486, 'App\\Models\\User', 7, 'API Token', '4ae1dac04365dec073106fbf4cc120774ed721f5aeaeba100fa69ea7c6bf3e44', '[\"admin-tenant\"]', '2025-01-05 15:28:48', NULL, '2025-01-05 13:54:27', '2025-01-05 15:28:48'),
(487, 'App\\Models\\User', 7, 'API Token', '646a985bfe1d06ec94b7be65f284ea46d777b76522f76ccc0ae6ebc40c7a51c2', '[\"admin-tenant\"]', '2025-01-05 16:06:58', NULL, '2025-01-05 15:36:08', '2025-01-05 16:06:58'),
(488, 'App\\Models\\User', 7, 'API Token', 'ffdebd5ba69a60340eb84f91510871da6f845b38f3e7018e515c59d97fc58c4d', '[\"admin-tenant\"]', '2025-01-05 16:07:13', NULL, '2025-01-05 16:07:08', '2025-01-05 16:07:13'),
(489, 'App\\Models\\User', 30, 'API Token', '40753f62552c75d89e98e8d4d5bad62374efd34cbd7d1e4756b82fae809932a1', '[\"admin-tenant\"]', '2025-01-05 16:08:11', NULL, '2025-01-05 16:08:03', '2025-01-05 16:08:11'),
(490, 'App\\Models\\User', 30, 'API Token', '3c96c12212d22f186b93d9a546c1ef9f1ef37e3e4a9c92bae014d7077ab707df', '[\"admin-tenant\"]', '2025-01-05 16:32:56', NULL, '2025-01-05 16:10:01', '2025-01-05 16:32:56'),
(491, 'App\\Models\\User', 7, 'API Token', '5f19a9137a6515dec999000cb40051203684e56087d0379dfbf8b6f3d8eed33b', '[\"admin-tenant\"]', '2025-01-05 16:38:43', NULL, '2025-01-05 16:38:39', '2025-01-05 16:38:43'),
(492, 'App\\Models\\User', 30, 'API Token', '04d8c9f8c13587b6f16c7ab77cfe28ae4fdcffd1f6e8eb9d48380460d88269c5', '[\"admin-tenant\"]', '2025-01-05 17:08:23', NULL, '2025-01-05 16:40:12', '2025-01-05 17:08:23'),
(493, 'App\\Models\\User', 7, 'API Token', '63dbc582b89388758ab7da3ecf861369572923859f163c673fd919ebc2be537c', '[\"admin-tenant\"]', '2025-01-05 17:08:51', NULL, '2025-01-05 17:08:27', '2025-01-05 17:08:51'),
(494, 'App\\Models\\User', 7, 'API Token', '9f55cae02f9851b96de27a4815084735c81107caa39ebfcc39172d3a4c0ee02d', '[\"admin-tenant\"]', '2025-01-05 17:21:38', NULL, '2025-01-05 17:14:52', '2025-01-05 17:21:38'),
(495, 'App\\Models\\User', 7, 'API Token', '4e27e6cae8659ce8feaf0bbc493ea2a4e92d8a412fa4c2ebcdba2b387845f48e', '[\"admin-tenant\"]', '2025-01-05 23:52:30', NULL, '2025-01-05 23:51:48', '2025-01-05 23:52:30'),
(496, 'App\\Models\\User', 30, 'API Token', 'f3b040246560ab5b755710f162d9738bc0a1b9a543584bbfaf6cf1a223873acf', '[\"admin-tenant\"]', '2025-01-05 23:53:44', NULL, '2025-01-05 23:53:02', '2025-01-05 23:53:44'),
(497, 'App\\Models\\User', 30, 'API Token', 'c7b6c5f4dcc1fc0f749a9e1d7d0885a91ed7cd2e1a63641ef8842fcd7c25d2c3', '[\"admin-tenant\"]', '2025-01-06 00:17:37', NULL, '2025-01-06 00:00:34', '2025-01-06 00:17:37'),
(498, 'App\\Models\\User', 7, 'API Token', '069fb8acf073b0d1d930583d436c56875b277ca8cfd64da8580661c00a3b96f8', '[\"admin-tenant\"]', '2025-01-06 00:22:37', NULL, '2025-01-06 00:22:32', '2025-01-06 00:22:37'),
(499, 'App\\Models\\User', 35, 'API Token', '22432b3bff536878297a69f44fb5301f1ae18ddb4997c4119000fc7e68ae0275', '[\"admin-tenant\"]', '2025-01-06 00:23:49', NULL, '2025-01-06 00:23:42', '2025-01-06 00:23:49'),
(500, 'App\\Models\\User', 35, 'API Token', '3faa54bec83b328c5661562e92ee09d282065f197f1274d0ac290c629ac0d1f7', '[\"admin-tenant\"]', '2025-01-06 01:21:09', NULL, '2025-01-06 00:24:16', '2025-01-06 01:21:09'),
(501, 'App\\Models\\User', 7, 'API Token', '47dac82bdfbc811c3c61e1101e43c9f5c99723dd321e1469e3d15e0c98a7637c', '[\"admin-tenant\"]', '2025-01-06 04:30:09', NULL, '2025-01-06 04:29:38', '2025-01-06 04:30:09'),
(502, 'App\\Models\\User', 30, 'API Token', 'c3758449af3ea47136950e23ad4f55f86f350ce2726840cad3d31707d6079d87', '[\"admin-tenant\"]', '2025-01-06 04:37:51', NULL, '2025-01-06 04:34:39', '2025-01-06 04:37:51'),
(503, 'App\\Models\\User', 7, 'API Token', '2fc2058eb641b7af455fa9260723d19fd826bf4e86297e0984abd94453af7ede', '[\"admin-tenant\"]', '2025-01-06 04:38:49', NULL, '2025-01-06 04:38:04', '2025-01-06 04:38:49'),
(504, 'App\\Models\\User', 7, 'API Token', '4eec16c560ea918496b3f9e5a7edd854964eba5257d70ccfd85e190d143d4aa5', '[\"admin-tenant\"]', '2025-02-20 23:33:30', NULL, '2025-01-06 07:16:26', '2025-02-20 23:33:30'),
(505, 'App\\Models\\User', 7, 'API Token', '5d9f67d43815fdb75e2f0f9f5ad672ecb0fcb24d7bb8eb77fae6e8e911fda90d', '[\"admin-tenant\"]', '2025-02-20 23:39:25', NULL, '2025-02-20 23:34:19', '2025-02-20 23:39:25'),
(506, 'App\\Models\\User', 7, 'API Token', '5fb2551ad461bc5274f2d216262889b7139fdbd4bfcdee058a0062964d50eaec', '[\"admin-tenant\"]', '2025-02-20 23:50:59', NULL, '2025-02-20 23:50:53', '2025-02-20 23:50:59'),
(507, 'App\\Models\\User', 30, 'API Token', '47ac444b996b5ce143d89db5dc095b7959ccece2073237a12c2868b37c6b3636', '[\"admin-tenant\"]', '2025-02-20 23:55:13', NULL, '2025-02-20 23:52:40', '2025-02-20 23:55:13'),
(508, 'App\\Models\\User', 7, 'API Token', '75a1bef7ed4b1d75169529738038771ecc081d8861fe433bf23d7e726fd81ad6', '[\"admin-tenant\"]', '2025-02-23 23:43:37', NULL, '2025-02-23 23:43:17', '2025-02-23 23:43:37'),
(509, 'App\\Models\\User', 7, 'API Token', '46e948d9efd54fadd8d3d8f2345ca48cfc71b6d5c0b9126b906027796cb0ff33', '[\"admin-tenant\"]', '2025-02-24 05:27:31', NULL, '2025-02-24 05:23:17', '2025-02-24 05:27:31'),
(510, 'App\\Models\\User', 7, 'API Token', 'c2e01fd6020360a39335272c044b9026f868b70215420c09271bdc0e7471c845', '[\"admin-tenant\"]', '2025-03-03 08:00:36', NULL, '2025-03-03 07:59:53', '2025-03-03 08:00:36'),
(511, 'App\\Models\\User', 7, 'API Token', '37716d3a85c3949a093aaf05466233d36abd106b1d947c498d5af3de1f69cd1e', '[\"admin-tenant\"]', '2025-03-04 00:48:06', NULL, '2025-03-04 00:47:43', '2025-03-04 00:48:06'),
(512, 'App\\Models\\User', 7, 'API Token', 'dd07ff437826ae67f040a6d03f869419bbce79c147da892398c9623497e8d989', '[\"admin-tenant\"]', NULL, NULL, '2025-03-04 00:47:46', '2025-03-04 00:47:46'),
(513, 'App\\Models\\User', 30, 'API Token', '36574bc0d78143ea94458a76b1385480ba8a87cdb137c95a305f61700a17ed64', '[\"admin-tenant\"]', '2025-03-04 06:47:05', NULL, '2025-03-04 00:49:19', '2025-03-04 06:47:05');
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(514, 'App\\Models\\User', 7, 'API Token', '9a711d9941f6c6e71e5a8ec4aff60f21728674d5a4eeb6ff5f884be8d3cf6b40', '[\"admin-tenant\"]', '2025-03-07 11:56:04', NULL, '2025-03-07 11:33:29', '2025-03-07 11:56:04'),
(515, 'App\\Models\\User', 7, 'API Token', '25833213fb59815c6650ef795701877a72508040a9567c74d41d16e10452b4a6', '[\"admin-tenant\"]', '2025-03-07 11:58:41', NULL, '2025-03-07 11:58:32', '2025-03-07 11:58:41'),
(516, 'App\\Models\\User', 30, 'API Token', '924b513e7cf2e45ed1d2c00430495038038d8bc6eda26d3f843ff1fc11ac0f89', '[\"admin-tenant\"]', '2025-03-11 00:46:04', NULL, '2025-03-10 01:20:09', '2025-03-11 00:46:04'),
(517, 'App\\Models\\User', 7, 'API Token', 'af6a69a803b6482857e19b1e26be7cde5d9d602ea753457d15d9f9cfa28e4b55', '[\"admin-tenant\"]', '2025-03-11 01:53:52', NULL, '2025-03-11 00:59:59', '2025-03-11 01:53:52'),
(518, 'App\\Models\\User', 7, 'API Token', 'b9dd872590c17feb814269e72ffd0a4e309d159e229efc17c00928873fc24edf', '[\"admin-tenant\"]', NULL, NULL, '2025-03-11 01:00:00', '2025-03-11 01:00:00'),
(519, 'App\\Models\\User', 30, 'API Token', 'e785e1783c1ab48bba94ce416d9fb389be081f84849e1075754f20540de59bf4', '[\"admin-tenant\"]', '2025-03-14 05:54:53', NULL, '2025-03-14 05:53:05', '2025-03-14 05:54:53'),
(520, 'App\\Models\\User', 30, 'API Token', '546476a177331ad00eaaefa090f4e617dbc17496a87ed914e2d3f5f8d315e8bb', '[\"admin-tenant\"]', '2025-03-14 08:27:25', NULL, '2025-03-14 05:58:38', '2025-03-14 08:27:25'),
(521, 'App\\Models\\User', 30, 'API Token', '9f7c5147048434e52bbdd0895c8734e4c387014ca599f3c8b4e0d5fde12687fd', '[\"admin-tenant\"]', '2025-03-17 00:28:46', NULL, '2025-03-16 05:44:55', '2025-03-17 00:28:46'),
(522, 'App\\Models\\User', 30, 'API Token', 'eafe55e521bdf3aeb908dfafd7254c4fa342c489c713afe1b025b802162c52dc', '[\"admin-tenant\"]', '2025-03-17 00:56:28', NULL, '2025-03-17 00:29:45', '2025-03-17 00:56:28'),
(523, 'App\\Models\\User', 7, 'API Token', 'c36a948d909b00e18fa8bf89010657430661c5c41d0ed0ee933315dc13a40265', '[\"admin-tenant\"]', '2025-03-17 01:31:39', NULL, '2025-03-17 01:09:10', '2025-03-17 01:31:39'),
(524, 'App\\Models\\User', 7, 'API Token', '0e290dc5664287c511b925de59bf67830fbb44518c2d93fc76cb86582ac0eca7', '[\"admin-tenant\"]', '2025-03-17 01:33:12', NULL, '2025-03-17 01:33:05', '2025-03-17 01:33:12'),
(525, 'App\\Models\\User', 37, 'GoogleLogin', '2837647c497f13a4eb32e716cc59d05355149b89c6c8a5b4dd91004aa7e59e2b', '[\"*\"]', NULL, NULL, '2025-03-17 01:35:27', '2025-03-17 01:35:27'),
(526, 'App\\Models\\User', 7, 'API Token', 'ec55023a2f5ec5cfd22e7f754c01920b4dee6bb34f34421fb0f03b8c92f151ee', '[\"admin-tenant\"]', '2025-03-17 01:37:27', NULL, '2025-03-17 01:35:43', '2025-03-17 01:37:27'),
(527, 'App\\Models\\User', 7, 'API Token', 'e0a04b19c1371f45d2401512069ff3001f07f15a411df7df582a89c6aae27920', '[\"admin-tenant\"]', '2025-03-17 02:03:28', NULL, '2025-03-17 01:44:06', '2025-03-17 02:03:28'),
(528, 'App\\Models\\User', 40, 'API Token', '4b54cfa7dfd72a1ab9118ee9a413e596b9f07bf08cbe04b3c2c42b3b49344dff', '[\"admin-tenant\"]', '2025-03-17 06:15:30', NULL, '2025-03-17 02:04:35', '2025-03-17 06:15:30'),
(529, 'App\\Models\\User', 40, 'API Token', '936ece12ca2cec4861704c359af6b2f61fe6c9662ad9f3f4d19bdcc7bd098c7d', '[\"admin-tenant\"]', '2025-03-18 05:36:59', NULL, '2025-03-18 00:08:08', '2025-03-18 05:36:59'),
(530, 'App\\Models\\User', 40, 'API Token', 'f7a95d56920d3a53fb44fbf7494910163c35146ac05ff656ec15a4e1bac3db5a', '[\"admin-tenant\"]', '2025-03-19 02:30:47', NULL, '2025-03-18 05:56:07', '2025-03-19 02:30:47'),
(531, 'App\\Models\\User', 7, 'API Token', '6fc46462af6d2afaa9584f6a51875487da32b6add492f385ac1056d2bd86859e', '[\"admin-tenant\"]', '2025-03-19 05:18:01', NULL, '2025-03-19 02:53:36', '2025-03-19 05:18:01'),
(532, 'App\\Models\\User', 40, 'API Token', '04bad0bbba36546a1b2069d3c39be957133ad88623cac9be8e098bebbbcefbc8', '[\"admin-tenant\"]', '2025-03-19 05:29:46', NULL, '2025-03-19 05:23:01', '2025-03-19 05:29:46'),
(533, 'App\\Models\\User', 7, 'API Token', '2b66731258882b2ff093dd26b12253341992e777b6f90c4e0a412b513a3c5304', '[\"admin-tenant\"]', '2025-03-20 00:14:51', NULL, '2025-03-19 07:36:58', '2025-03-20 00:14:51'),
(534, 'App\\Models\\User', 7, 'API Token', 'f4baa24ba69155c6d47b1c292f88b4f6720a4515b5c453e1ee1821f17d8a3fbf', '[\"admin-tenant\"]', '2025-03-20 00:57:10', NULL, '2025-03-20 00:15:26', '2025-03-20 00:57:10'),
(535, 'App\\Models\\User', 40, 'API Token', 'dd45aa60f80bc9ed4eef0dd88a09f2d4a83c9e2bc54255f2ddbef767f4cc069c', '[\"admin-tenant\"]', '2025-03-20 00:59:27', NULL, '2025-03-20 00:59:15', '2025-03-20 00:59:27'),
(536, 'App\\Models\\User', 7, 'API Token', 'fb616afc0654378c67fccb08fbcfb0b0fbc5a7e87ad1e832711810f20efc5193', '[\"admin-tenant\"]', '2025-03-20 01:56:10', NULL, '2025-03-20 01:23:13', '2025-03-20 01:56:10'),
(537, 'App\\Models\\User', 40, 'API Token', 'ba4306f1ecd8d9d941c481770b14aa27e4366400ba60ef362542150153d21d48', '[\"admin-tenant\"]', '2025-03-20 02:00:17', NULL, '2025-03-20 02:00:08', '2025-03-20 02:00:17'),
(538, 'App\\Models\\User', 7, 'API Token', 'ba0f8793108eac47157eeb91785a860d9872a988c11b8e92136e894c53fb7083', '[\"admin-tenant\"]', '2025-03-20 02:31:31', NULL, '2025-03-20 02:12:15', '2025-03-20 02:31:31'),
(539, 'App\\Models\\User', 7, 'API Token', 'fadc1fbf08dd530c31a4c5e6cc1eb159ac5fa8594ea7532a4919c3c6c6577131', '[\"admin-tenant\"]', '2025-03-20 03:11:48', NULL, '2025-03-20 02:37:43', '2025-03-20 03:11:48'),
(540, 'App\\Models\\User', 7, 'API Token', '0c33f66df9fac37af7e313e6eb4c64bd6dd8f20527d8a9a689818f73f6e12fe3', '[\"admin-tenant\"]', '2025-03-20 03:26:37', NULL, '2025-03-20 03:13:44', '2025-03-20 03:26:37'),
(541, 'App\\Models\\User', 42, 'API Token', '08787fd0a5cc38769ca2db4609acfe15e565895df239bdc5a32db588e7812a94', '[\"admin-tenant\"]', '2025-03-20 03:26:54', NULL, '2025-03-20 03:26:47', '2025-03-20 03:26:54'),
(542, 'App\\Models\\User', 7, 'API Token', '86326df7088e44e51d5c8dd67396c012cf64955c1329e6513b5235c7afe9fad1', '[\"admin-tenant\"]', '2025-03-20 05:09:39', NULL, '2025-03-20 05:09:34', '2025-03-20 05:09:39'),
(543, 'App\\Models\\User', 7, 'API Token', '2588c3c0b2f15e6ddc940d7fd89c94b10f2acbe9a9e088f87dc05546301eb603', '[\"admin-tenant\"]', '2025-03-20 05:59:21', NULL, '2025-03-20 05:45:21', '2025-03-20 05:59:21'),
(544, 'App\\Models\\User', 42, 'API Token', '322f7c83400468d28e2a718371ae0d7a5749d3664e3d3a1bb13521366c0e0fe5', '[\"admin-tenant\"]', '2025-03-20 06:19:48', NULL, '2025-03-20 05:59:54', '2025-03-20 06:19:48'),
(545, 'App\\Models\\User', 42, 'API Token', 'd2fe12ec53cc3fa25bc1806f1d1fda5629b2305f10195e48ed41ffdc8f8bfb3e', '[\"admin-tenant\"]', '2025-03-20 06:22:40', NULL, '2025-03-20 06:22:34', '2025-03-20 06:22:40'),
(546, 'App\\Models\\User', 7, 'API Token', 'c446b94e4af9096035438d7e69fb587e8e9810a3b74f02805c6efd8ce7707f56', '[\"admin-tenant\"]', '2025-03-20 07:31:08', NULL, '2025-03-20 06:23:55', '2025-03-20 07:31:08'),
(547, 'App\\Models\\User', 7, 'API Token', 'f005fb8fab1fe0fe8a2f42a2a03b0fc9f18e41abefc9d8d7f393b964b9496211', '[\"admin-tenant\"]', '2025-03-20 07:53:43', NULL, '2025-03-20 07:35:32', '2025-03-20 07:53:43'),
(548, 'App\\Models\\User', 7, 'API Token', 'dd9ccd550c5dc7ea70e0a6f7d9b9b52ec5d8605e430629864b0a9e6b61f78372', '[\"admin-tenant\"]', '2025-03-20 08:05:10', NULL, '2025-03-20 07:55:39', '2025-03-20 08:05:10');

-- --------------------------------------------------------

--
-- Table structure for table `places`
--

CREATE TABLE `places` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` varchar(100) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `places`
--

INSERT INTO `places` (`id`, `name`, `category`, `latitude`, `longitude`, `description`, `created_at`, `updated_at`) VALUES
(1, 'University of Santo Tomas (UST)', 'Universities and Colleges', 14.60960000, 120.98930000, 'A prestigious private Catholic university known for its comprehensive academic programs.', '2024-12-21 09:23:40', '2024-12-21 09:23:40'),
(2, 'Far Eastern University (FEU)', 'Universities and Colleges', 14.60360000, 120.98610000, 'A private university offering a variety of undergraduate and graduate courses.', '2024-12-21 09:23:40', '2024-12-21 09:23:40'),
(3, 'University of the East (UE)', 'Universities and Colleges', 14.61120000, 120.98710000, 'A private university renowned for its programs in business, law, and dentistry.', '2024-12-21 09:23:40', '2024-12-21 09:23:40'),
(4, 'Technological University of the Philippines (TUP)', 'Universities and Colleges', 14.58620000, 120.98470000, 'A state university known for engineering, technology, and industrial education programs.', '2024-12-21 09:23:40', '2024-12-21 09:23:40'),
(5, 'SM City San Lazaro', 'Shopping Centers', 14.61950000, 120.98580000, 'A large shopping mall featuring numerous retail stores, dining options, and entertainment facilities.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(6, 'Isetann Recto', 'Shopping Centers', 14.60650000, 120.98660000, 'A shopping center offering a variety of shops and services, popular for its budget-friendly items.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(7, 'Divisoria Market', 'Shopping Centers', 14.60100000, 120.97290000, 'A bustling market known for its wholesale goods, textiles, and affordable prices.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(8, 'SM Manila', 'Shopping Centers', 14.58940000, 120.98180000, 'A mid-sized shopping mall offering retail stores, a cinema, and dining options.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(9, 'UST Hospital', 'Hospitals and Medical Centers', 14.61000000, 120.99060000, 'A private hospital affiliated with the University of Santo Tomas, providing comprehensive medical services.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(10, 'Mary Chiles General Hospital', 'Hospitals and Medical Centers', 14.60800000, 120.99300000, 'A general hospital offering various healthcare services, particularly for general and specialty care.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(11, 'Philippine General Hospital (PGH)', 'Hospitals and Medical Centers', 14.57960000, 120.98660000, 'A leading tertiary hospital in the Philippines, providing specialized medical services.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(12, 'UST Botanical Garden', 'Parks and Recreation', 14.60950000, 120.99000000, 'A serene garden within the university campus, featuring diverse plant species.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(13, 'Morayta Park', 'Parks and Recreation', 14.60850000, 120.98580000, 'A small urban park ideal for relaxation, especially for students in the area.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(14, 'Rizal Park (Luneta)', 'Parks and Recreation', 14.58250000, 120.97940000, 'A historical park in Manila featuring monuments, open spaces, and cultural landmarks.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(15, 'Paco Park', 'Parks and Recreation', 14.58040000, 120.98850000, 'A tranquil circular park built around a historical cemetery, ideal for picnics and small concerts.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(16, 'Arroceros Forest Park', 'Parks and Recreation', 14.59430000, 120.98040000, 'A green sanctuary in the heart of Manila, known for its dense trees and peaceful environment.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(17, 'Liwasang Bonifacio', 'Parks and Recreation', 14.59420000, 120.98170000, 'A public square dedicated to Filipino revolutionary Andres Bonifacio.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(18, 'Plaza Miranda', 'Parks and Recreation', 14.60020000, 120.98350000, 'A bustling plaza near Quiapo Church, known for its vibrant atmosphere.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(19, 'Quiapo Church (Minor Basilica of the Black Nazarene)', 'Religious and Cultural Sites', 14.59800000, 120.98310000, 'A popular Catholic church and pilgrimage site in Manila.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(20, 'San Sebastian Basilica', 'Religious and Cultural Sites', 14.59840000, 120.98970000, 'A historic all-steel church, recognized for its unique Gothic architecture.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(21, 'UST Museum of Arts and Sciences', 'Religious and Cultural Sites', 14.60960000, 120.98930000, 'The oldest museum in the Philippines, showcasing natural history and cultural artifacts.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(22, 'QuickClean España', 'Laundries', 14.60310000, 120.98990000, 'A self-service laundry offering quick and efficient washing and drying services.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(23, 'Wash & Go Laundry', 'Laundries', 14.60600000, 120.99020000, 'A 24/7 laundromat with modern equipment and affordable rates.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(24, '24/7 Wash Station', 'Laundries', 14.60580000, 120.98530000, 'A 24-hour laundry service catering to nearby residents.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(25, 'Aling Nena\'s Eatery', 'Carinderias', 14.60450000, 120.98920000, 'Known for its affordable home-cooked Filipino meals.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(26, 'Mang Ambo\'s Carinderia', 'Carinderias', 14.60330000, 120.98750000, 'A budget-friendly eatery serving Filipino comfort food.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(27, 'Lola Puring\'s Eatery', 'Carinderias', 14.60550000, 120.98880000, 'A popular spot for students offering a variety of Filipino dishes.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(28, '7-Eleven - España', 'Convenience Stores', 14.60830000, 120.98900000, 'Open 24/7, offering snacks, essentials, and hot meals.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(29, 'Mini Stop - Lacson', 'Convenience Stores', 14.60690000, 120.98840000, 'A go-to convenience store for quick bites and essentials.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(30, 'FamilyMart - España', 'Convenience Stores', 14.60900000, 120.98980000, 'A Japanese convenience store chain offering premium snacks and groceries.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(31, 'All Day Convenience Store - SM Manila', 'Convenience Stores', 14.58860000, 120.98110000, 'A modern convenience store offering a variety of ready-to-eat meals and groceries.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(32, 'Toner Copy Center', 'Printing and Internet Shops', 14.60840000, 120.99110000, 'Offers printing, photocopying, and scanning services. Affordable rates for students.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(33, 'Netopia - SM San Lazaro', 'Printing and Internet Shops', 14.61950000, 120.98580000, 'Internet shop offering printing, gaming, and computer rentals.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(34, 'CyberZone - Isetann Recto', 'Printing and Internet Shops', 14.60790000, 120.98660000, 'Provides high-speed internet, printing, and scanning services.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(35, 'UST Internet and Printing Services', 'Printing and Internet Shops', 14.60910000, 120.98920000, 'Affordable in-campus service for students.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(36, 'UST Miguel de Benavides Library', 'Libraries', 14.60980000, 120.98900000, 'Extensive academic library within UST, offering free access for students.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(37, 'National Library of the Philippines', 'Libraries', 14.58260000, 120.98310000, 'Government-owned library featuring historical archives and academic resources.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(38, 'FEU Library', 'Libraries', 14.60480000, 120.98620000, 'Modern library with access to various academic journals and e-books.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(39, 'Legarda LRT Station', 'LRT Stations', 14.60120000, 120.99250000, 'Connects to Line 2 for easy travel to universities and shopping hubs.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(40, 'Doroteo Jose LRT Station', 'LRT Stations', 14.60670000, 120.98360000, 'Links LRT Line 1 and 2 for interline transfers.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(41, 'España Jeepney Stop (UST)', 'Bus and Jeepney Stops', 14.60950000, 120.99060000, 'Common pick-up and drop-off point for España route jeepneys.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(42, 'Recto Bus Terminal', 'Bus and Jeepney Stops', 14.60600000, 120.98610000, 'Bus terminal serving various provincial and city routes.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(43, 'Morayta Jeepney Stop', 'Bus and Jeepney Stops', 14.60680000, 120.98770000, 'Jeepney stop providing access to Morayta and Recto routes.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(44, 'Gold\'s Gym - SM Manila', 'Gyms and Fitness Centers', 14.58900000, 120.98220000, 'High-end fitness center offering personal training and group classes.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(45, 'UST Gym', 'Gyms and Fitness Centers', 14.61000000, 120.98850000, 'In-campus gym facility available to students and faculty.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(46, 'Anytime Fitness - Lacson', 'Gyms and Fitness Centers', 14.60550000, 120.98820000, '24/7 access fitness center with modern equipment.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(47, 'Sampaloc Police Station (PS 4)', 'Police and Fire Stations', 14.60420000, 120.98980000, 'Police station ensuring safety in the Sampaloc area.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(48, 'Manila Fire District', 'Police and Fire Stations', 14.60480000, 120.98560000, 'Local fire station responding to emergencies within the district.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(49, 'Barangay 472 Outpost', 'Barangay Outpost', 14.60370000, 120.98910000, 'Nearby barangay office assisting with community concerns.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(50, 'City of Manila - Sampaloc District Office', 'Offices', 14.60320000, 120.98840000, 'Handles administrative services for the Sampaloc district.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(51, 'BIR Office - Sampaloc', 'Offices', 14.60650000, 120.98550000, 'Local Bureau of Internal Revenue office for tax-related inquiries.', '2024-12-21 09:23:41', '2024-12-21 09:23:41'),
(52, 'Philippine Statistics Authority', 'Offices', 14.60460000, 120.98750000, 'Government office offering civil registration and census services.', '2024-12-21 09:23:41', '2024-12-21 09:23:41');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('2azjNDl6ZEtFaNagrqT1JjLDODdNdd8gwKjBPG2y', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibG1XWUFwN1NrT1laeGk4bmRxS0Z4Q3cxR3R1NjI4c1BxRFF4Ujk2dSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1731140820),
('lrXe42Ra9sKnCL7YV9qbnKI7uoRO3FTlNMP9UV8L', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiekN2UEtTTm5MeHd4NnBZRHFvaHFJZTREY3VtNDF3SEFadVgxV3VYSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1731168652),
('ndOR2XfE99fhBd80eFOuvi8rnYyZNULxjfthduas', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT3RhMWViMnk5T2gyNk9MNGVVMzNsTU5LZ0JMRXF2cFFzU0FxdEF6UiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1731417299),
('nnFCQIVwhiHOlHDToGhaRhbwNAgiuUi5oSTpRUTT', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM3ZuN1Q4akQ5RWlZcEVla2hFYUlvZzh6Y0lqekhwV3ljMkR2dFo5USI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1731167052),
('td8zRmTO7VpIYq1pNKJwJdSU4HaHav5T6SiCEpNU', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNkRHb3VyWTFHM2VXWkZyV2pUU21XT2MzaWNpVldwUjdVMXdyWHM0SSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1731208167),
('VamQFus9SaEWn2wd12YNPm3MqlcSQdSCuAdYWkMO', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWjJGODF5VWlWY0lTWWo0Y1ZzR1NvZDNUNDhMTzZ1Sk5DS3FVOWdMZCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1730916000),
('XOwkyYD1Brfge2sSutw5SnS2aMJ3F8T6OHemejwY', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSDNpaUM0ZWpvbWNVdTQyb2swVWRGbTlnZ0Z0MGZ5cExocWdZdDBFSiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1731168323);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `phone_number`, `email`, `created_at`, `updated_at`) VALUES
(1, 'landlord_contact', '09517765432', 'landlord@example.com', '2024-12-13 10:39:33', '2024-12-13 06:05:57');

-- --------------------------------------------------------

--
-- Table structure for table `terminated_tenants`
--

CREATE TABLE `terminated_tenants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `address` text DEFAULT NULL,
  `contact_number` varchar(50) DEFAULT NULL,
  `check_in_date` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `valid_id_url` varchar(255) DEFAULT NULL,
  `terminated_at` datetime DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `terminated_tenants`
--

INSERT INTO `terminated_tenants` (`id`, `user_id`, `email`, `full_name`, `address`, `contact_number`, `check_in_date`, `duration`, `occupation`, `unit_id`, `valid_id_url`, `terminated_at`, `created_at`, `updated_at`) VALUES
(7, 47, 'bolokshana.tenant@gmail.com', 'Shana Bolok', '166 Libis, Rosario, Rodriguez, Rizal 1860', '9517764536', '2025-03-28 15:00:00', 2, 'Student', 5, 'http://localhost:8000/storage/uploads/valid_ids/JYe89pTY5XNIOJQlJ83cqPqqhia86xjzD4QOLA7k.jpg', '2025-03-20 15:53:31', '2025-03-20 07:53:31', '2025-03-20 07:53:31');

-- --------------------------------------------------------

--
-- Table structure for table `tour_availabilities`
--

CREATE TABLE `tour_availabilities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `time` varchar(255) NOT NULL,
  `status` enum('available','unavailable','booked') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tour_availabilities`
--

INSERT INTO `tour_availabilities` (`id`, `date`, `time`, `status`, `created_at`, `updated_at`) VALUES
(1, '2024-12-31', '09:00 AM', 'unavailable', '2024-12-31 02:45:31', '2025-01-01 03:24:26'),
(2, '2025-01-01', '09:00 AM', 'unavailable', '2025-01-01 02:43:54', '2025-01-01 04:01:06'),
(3, '2025-01-01', '10:00 AM', 'booked', '2025-01-01 02:44:06', '2025-01-02 17:51:48'),
(4, '2025-01-01', '11:00 AM', 'available', '2025-01-01 03:25:20', '2025-01-02 08:12:00'),
(5, '2025-01-01', '12:00 PM', 'available', '2025-01-01 03:25:21', '2025-01-02 14:44:07'),
(6, '2025-01-01', '01:00 PM', 'available', '2025-01-01 03:26:29', '2025-01-02 14:41:33'),
(7, '2025-01-01', '02:00 PM', 'booked', '2025-01-01 03:26:31', '2025-01-05 09:51:40'),
(8, '2025-01-01', '03:00 PM', 'booked', '2025-01-01 03:26:32', '2025-01-05 09:11:20'),
(9, '2025-01-01', '04:00 PM', 'available', '2025-01-01 03:26:32', '2025-01-02 10:44:08'),
(10, '2025-01-02', '02:00 PM', 'booked', '2025-01-02 12:39:59', '2025-01-02 14:36:35'),
(11, '2025-01-02', '04:00 PM', 'booked', '2025-01-02 12:49:07', '2025-01-02 14:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `unit_code` varchar(50) DEFAULT NULL,
  `capacity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` enum('available','unavailable') DEFAULT 'available',
  `stay_type` enum('short-term','long-term') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`id`, `name`, `unit_code`, `capacity`, `price`, `created_at`, `updated_at`, `status`, `stay_type`) VALUES
(1, 'Ceiling Fan Room (20 Persons up)', 'CF-1', 20, 2500.00, '2024-12-02 05:49:42', '2025-03-20 01:43:07', 'available', 'short-term'),
(2, 'Ceiling Fan Room (14-18 Persons)', 'CF-2', 18, 3000.00, '2024-12-02 05:49:42', '2025-03-19 03:12:11', 'unavailable', 'short-term'),
(3, 'Ceiling Fan Room (4-6-12 Persons)', 'CF-3', 12, 3500.00, '2024-12-02 05:49:42', '2025-03-20 05:50:42', 'available', 'short-term'),
(4, 'Ceiling Fan Room (1 Person)', 'CF-Solo', 1, 6500.00, '2024-12-02 05:49:42', '2025-03-20 05:51:23', 'available', 'short-term'),
(5, 'Ceiling Fan Room (2 Persons)', 'CF-4', 2, 4000.00, '2024-12-02 05:49:42', '2024-12-02 05:49:42', 'available', 'short-term'),
(6, 'Fully Air-Conditioned Room (14 or more Persons)', 'FAC-1', 14, 4500.00, '2024-12-02 05:49:42', '2025-03-20 07:20:15', 'available', 'short-term'),
(7, 'Fully Air-Conditioned Room (10-12 Persons)', 'FAC-2', 12, 4500.00, '2024-12-02 05:49:42', '2024-12-02 05:49:42', 'available', 'long-term'),
(8, 'Direct Air-Con Room (2 Persons)', 'DAC-1', 2, 6000.00, '2024-12-02 05:49:42', '2025-03-20 07:20:15', 'unavailable', 'short-term'),
(9, 'Direct Air-Con Room (4-6-8 Persons)', 'DAC-2', 8, 5000.00, '2024-12-02 05:49:42', '2025-03-20 00:57:00', 'available', 'short-term'),
(10, 'Solo Room (1 Person)', 'AC-Solo', 1, 11000.00, '2024-12-02 05:49:42', '2025-03-20 05:47:08', 'available', 'short-term'),
(12, 'Practice', 'AR-1', 10, 2000.00, '2025-03-11 01:53:39', '2025-03-20 05:59:09', 'available', 'long-term');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'tenant',
  `status` varchar(20) DEFAULT 'active',
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `role`, `status`, `unit_id`) VALUES
(7, 'Admin User', 'admin23@example.com', NULL, '$2y$12$Lis2Xn8qF8vwmCx8xunB7.kO0xcyEF9yyL9OcUn0c4cCa8TVLXfiG', NULL, '2024-11-12 08:57:36', '2024-11-12 08:57:36', 'admin', 'active', NULL),
(27, 'Rodolfo Giron', 'friskysoda1001@gmail.com', NULL, '$2y$12$HYnAbM6pJZYjblwVzHijCusAtWD1qSHzy5en2GVocEXGxqCegulgS', NULL, '2024-12-13 02:42:22', '2024-12-13 02:42:22', 'tenant', 'active', 3),
(28, 'Kristina Hernandez', 'hernandezkc.tenant@gmail.com', NULL, '$2y$12$vZNt3IgTDxTXyUBIqhv37eJLkO3ow8Xo.RK7i3hVNmPZEfLaoiiny', NULL, '2024-12-20 07:26:56', '2024-12-20 07:26:56', 'tenant', 'active', 8),
(31, 'Lila', 'shanacarmellabolok@gmail.com', NULL, '$2y$12$ma6feiMwMubRG12AjSFjueshLKUgxBAVZQ09zAupW9ihoYXf0yCXC', NULL, '2025-01-04 04:36:59', '2025-01-04 04:36:59', 'tenant', 'active', NULL),
(34, 'Kat Ermitaaaa', 'katermita.tenant@gmail.com', NULL, '$2y$12$R1xALdC8.f6eHzOE8Bhc9.I.YRScH115hz00qmqXBctFfBVGJbfFa', NULL, '2025-01-05 09:51:32', '2025-01-05 09:51:32', 'tenant', 'active', NULL),
(35, 'Kat Ermita', 'ermitakat.tenant@gmail.com', NULL, '$2y$12$Eb.MH6GMBYnTgR0sQAFxHuWRdyLttRmGJNdl9b82A.wAwFgnhFsni', NULL, '2025-01-06 00:23:08', '2025-01-06 00:23:08', 'tenant', 'active', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `applications_unit_id_foreign` (`unit_id`);

--
-- Indexes for table `booked_tour`
--
ALTER TABLE `booked_tour`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_email` (`user_email`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_email` (`user_email`);

--
-- Indexes for table `gallery`
--
ALTER TABLE `gallery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `guest_user`
--
ALTER TABLE `guest_user`
  ADD PRIMARY KEY (`user_email`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `maintenance_requests_user_id_foreign` (`user_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_user_id_foreign` (`user_id`),
  ADD KEY `payments_unit_id_foreign` (`unit_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `places`
--
ALTER TABLE `places`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key` (`key`);

--
-- Indexes for table `terminated_tenants`
--
ALTER TABLE `terminated_tenants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tour_availabilities`
--
ALTER TABLE `tour_availabilities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unit_code` (`unit_code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_unit_id_foreign` (`unit_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `booked_tour`
--
ALTER TABLE `booked_tour`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gallery`
--
ALTER TABLE `gallery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=549;

--
-- AUTO_INCREMENT for table `places`
--
ALTER TABLE `places`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `terminated_tenants`
--
ALTER TABLE `terminated_tenants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tour_availabilities`
--
ALTER TABLE `tour_availabilities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booked_tour`
--
ALTER TABLE `booked_tour`
  ADD CONSTRAINT `booked_tour_ibfk_1` FOREIGN KEY (`user_email`) REFERENCES `guest_user` (`user_email`) ON DELETE CASCADE;

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`user_email`) REFERENCES `guest_user` (`user_email`) ON DELETE SET NULL;

--
-- Constraints for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  ADD CONSTRAINT `maintenance_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
