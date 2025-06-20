-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 20, 2025 at 04:55 PM
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
-- Database: `surevote`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `email`, `password`) VALUES
(1, 'admin@example.com', 'password123');

-- --------------------------------------------------------

--
-- Table structure for table `candidates`
--

CREATE TABLE `candidates` (
  `id` int(11) NOT NULL,
  `candidate_name` varchar(255) NOT NULL,
  `candidate_symbol_image_path` varchar(255) DEFAULT NULL,
  `party_name` varchar(255) DEFAULT NULL,
  `position_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`id`, `candidate_name`, `candidate_symbol_image_path`, `party_name`, `position_id`) VALUES
(5, 'Tejaswi Yadav', 'uploads/1000118070.jpg', 'RJD', 5),
(6, 'Nitish Kumar', 'uploads/1000115149.png', 'JDU', 5),
(7, 'Narendra Modi', 'uploads/1000118073.jpg', 'BJP', 6),
(8, 'Rahul Gandhi', 'uploads/1000118071.png', 'Congress', 6);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'Bihar'),
(2, 'India');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` char(64) NOT NULL,
  `status` enum('active','used') DEFAULT 'active',
  `expiration_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`id`, `user_id`, `token`, `status`, `expiration_date`) VALUES
(38, 7, '14445ef3cc89969d85babe960e1597d2', 'active', '2025-04-10 12:46:41'),
(39, 7, 'f21744dd24da2b4cecf0b580b5b115e5', 'active', '2025-04-10 12:55:51'),
(40, 7, 'a171c57a1ee16107330627fa62f86a85', 'active', '2025-04-10 13:24:49'),
(41, 7, '0f3c008efd82c16a0bb071a4a7d7e9b5', 'active', '2025-04-10 13:42:40'),
(42, 7, '3ebad5d85bf67987c1cb5cc0bf6d4d54', 'active', '2025-04-10 13:57:05'),
(43, 7, 'f9bde33bfb91ff01fd812bad514f3079', 'active', '2025-04-10 14:26:36'),
(44, 7, '936f14e8dd124aabf6e33b45f3e3e5f4', 'active', '2025-04-10 15:01:38'),
(47, 7, 'f72778048e412dfbb0a1247c4258dae9', 'active', '2025-04-12 17:16:37'),
(48, 7, '26ca204bf93ccb241673ca7cf345ed66', 'active', '2025-04-12 17:19:05'),
(49, 7, 'c68aca8dfca6b59a84dbf2720760eb70', 'active', '2025-04-12 17:19:57'),
(50, 7, 'ca0df23533b2808a7ed943b538018436', 'active', '2025-04-12 17:22:06'),
(51, 7, '0ab92116d9ec83f565785a6e2f3043e8', 'active', '2025-04-13 02:56:39'),
(52, 7, '487903cc46904497e80400a1bcb359b4', 'active', '2025-04-13 03:15:24'),
(53, 7, '3b197604d52c63b4bafc2e313472f338', 'active', '2025-04-13 03:18:58'),
(54, 7, '7d015b9e5d330422abbb8867ffa990a4', 'active', '2025-04-13 03:20:51'),
(55, 7, 'c775e4b2188ee429bd38e733921d96e4', 'active', '2025-04-13 03:21:43'),
(56, 7, '141e89e833cc3fc240e627c7d70d9911', 'active', '2025-04-13 03:23:18'),
(57, 7, '0819180686eaeaa79af822a26328f3f9', 'active', '2025-04-13 03:30:30'),
(58, 7, '212001e4648e78da45a0d8135c20c99e', 'active', '2025-04-13 03:43:33'),
(59, 7, 'f42eeda17119fcb58087535e9e665759', 'active', '2025-04-13 03:45:12'),
(60, 7, '744f64ee28ca95f54e7873dc16935f42', 'active', '2025-04-25 05:17:07'),
(61, 7, '36911b997ffd5df48fef983cecc46853', 'active', '2025-04-25 05:19:21');

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

CREATE TABLE `positions` (
  `id` int(11) NOT NULL,
  `position_name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `positions`
--

INSERT INTO `positions` (`id`, `position_name`, `category`, `created_at`, `category_id`) VALUES
(5, 'Chief Minister', '', '2025-02-10 06:35:18', 1),
(6, 'Prime Minister', '', '2025-02-10 07:02:23', 2);

-- --------------------------------------------------------

--
-- Table structure for table `voters`
--

CREATE TABLE `voters` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `aadhaar` varchar(12) NOT NULL,
  `voter_id` varchar(10) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `registration_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `reset_token` varchar(100) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(10) NOT NULL,
  `face_encoding` longblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `voters`
--

INSERT INTO `voters` (`id`, `name`, `email`, `password`, `phone`, `aadhaar`, `voter_id`, `image_path`, `registration_date`, `reset_token`, `reset_token_expiry`, `dob`, `gender`, `face_encoding`) VALUES
(4, 'Shreya Shankar ', 'shristishreya3@gmail.com', '$2y$10$FoWI9E9yrh2S2uJ4788dvuVu68trGbD4Mdk97CI5b6yxkC65e/BZ2', '7050581646', '822561757324', 'SSA1234567', 'uploads/677a13b013a70.png', '2025-01-05 05:08:00', NULL, NULL, NULL, '', NULL),
(7, 'Rabia Rizwan ', 'rabiarizwanmgr@gmail.com', '$2y$10$8unaGjw120VMCjUtmSp.iePdvQUkGkQ9gz0DpIkJrmcdpWj8asNnC', '9263948969', '123456789101', 'ABC1234567', 'uploads/679cd1b46ae23.png', '2025-01-31 09:05:48', NULL, NULL, NULL, '', NULL),
(39, 'John Doe', 'john@example.com', '$2y$10$syQ1RsmgxB2yAW5k7Wpi/.xK9hY.lT9QQTVp345UxifeDBWUjVS36', '9876543210', '123456789012', 'VOTE12345', 'uploads/67b935dc07a99.png', '2025-02-21 21:56:36', NULL, NULL, '2000-01-01', '', NULL),
(59, 'Rabia ', 'therabia412@gmail.com', '$2y$10$lqxFRzyxbHCGa.gjqb6eiOuHxudsmOu8pZ8wu3WWMR3jTU/rATsz2', '9852760179', '123456777777', 'RRR1234567', 'uploads/67c87e267365c.jpg', '2025-03-05 16:39:02', NULL, NULL, '2006-01-25', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `id` int(11) NOT NULL,
  `voter_id` varchar(20) NOT NULL,
  `position_id` int(11) NOT NULL,
  `candidate_id` int(11) NOT NULL,
  `vote_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `votes`
--

INSERT INTO `votes` (`id`, `voter_id`, `position_id`, `candidate_id`, `vote_time`, `category_id`) VALUES
(17, 'ABC1234567', 6, 7, '2025-02-10 09:48:45', 2),
(18, 'SSA1234567', 6, 7, '2025-02-10 09:52:10', 2),
(23, 'SSA1234567', 5, 5, '2025-03-04 09:44:05', 1),
(26, 'ABC1234567', 5, 5, '2025-03-05 11:09:30', 1),
(27, 'RRR1234567', 5, 6, '2025-03-05 16:42:06', 1);

-- --------------------------------------------------------

--
-- Table structure for table `voting_results`
--

CREATE TABLE `voting_results` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `position_id` int(11) DEFAULT NULL,
  `candidate_id` int(11) DEFAULT NULL,
  `votes` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `voting_results`
--

INSERT INTO `voting_results` (`id`, `category_id`, `position_id`, `candidate_id`, `votes`) VALUES
(50, 1, 5, 5, 3),
(51, 1, 5, 6, 1),
(52, 2, 6, 7, 2),
(53, 2, 6, 8, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `candidates`
--
ALTER TABLE `candidates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `position_id` (`position_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_category` (`category_id`);

--
-- Indexes for table `voters`
--
ALTER TABLE `voters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `aadhaar` (`aadhaar`),
  ADD UNIQUE KEY `voter_id` (`voter_id`);

--
-- Indexes for table `votes`
--
ALTER TABLE `votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `voter_id` (`voter_id`,`position_id`),
  ADD UNIQUE KEY `voter_id_2` (`voter_id`,`position_id`),
  ADD KEY `idx_voter` (`voter_id`),
  ADD KEY `idx_position` (`position_id`),
  ADD KEY `idx_candidate` (`candidate_id`),
  ADD KEY `idx_votes_voter_position` (`voter_id`,`position_id`);

--
-- Indexes for table `voting_results`
--
ALTER TABLE `voting_results`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_id` (`category_id`,`position_id`,`candidate_id`),
  ADD KEY `position_id` (`position_id`),
  ADD KEY `candidate_id` (`candidate_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `candidates`
--
ALTER TABLE `candidates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `positions`
--
ALTER TABLE `positions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `voters`
--
ALTER TABLE `voters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `votes`
--
ALTER TABLE `votes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `voting_results`
--
ALTER TABLE `voting_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `candidates`
--
ALTER TABLE `candidates`
  ADD CONSTRAINT `candidates_ibfk_1` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `voters` (`id`);

--
-- Constraints for table `positions`
--
ALTER TABLE `positions`
  ADD CONSTRAINT `fk_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE;

--
-- Constraints for table `votes`
--
ALTER TABLE `votes`
  ADD CONSTRAINT `votes_ibfk_1` FOREIGN KEY (`voter_id`) REFERENCES `voters` (`voter_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `votes_ibfk_2` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `votes_ibfk_3` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `voting_results`
--
ALTER TABLE `voting_results`
  ADD CONSTRAINT `voting_results_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  ADD CONSTRAINT `voting_results_ibfk_2` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`),
  ADD CONSTRAINT `voting_results_ibfk_3` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
