-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 29 août 2024 à 12:53
-- Version du serveur :  10.4.14-MariaDB
-- Version de PHP : 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `patient_management`
--

-- --------------------------------------------------------

--
-- Structure de la table `admissions`
--

CREATE TABLE `admissions` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `bed_id` int(11) DEFAULT NULL,
  `admission_date` datetime NOT NULL,
  `discharge_date` date DEFAULT NULL,
  `status` enum('Pending','Admitted','Discharged') DEFAULT 'Admitted'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `admissions`
--

INSERT INTO `admissions` (`id`, `patient_id`, `service_id`, `room_id`, `bed_id`, `admission_date`, `discharge_date`, `status`) VALUES
(3, 7, 2, 3, 4, '2024-07-17 00:00:00', NULL, 'Admitted'),
(4, 3, 1, 1, 1, '2024-07-09 00:00:00', '2024-07-28', 'Discharged'),
(5, 3, 1, 1, 1, '2024-07-26 00:00:00', '2024-08-28', 'Discharged'),
(6, 8, 2, 5, 4, '2024-07-27 00:00:00', NULL, ''),
(7, 3, 1, 1, 1, '2024-07-26 00:00:00', '2024-07-28', ''),
(8, 1, 1, 1, 1, '2024-07-01 00:00:00', NULL, 'Admitted'),
(9, 2, 2, 2, 2, '2024-07-02 00:00:00', NULL, 'Admitted'),
(10, 4, 1, 1, 1, '2024-07-26 00:00:00', NULL, 'Admitted'),
(11, 1, 3, 4, 1, '2024-07-31 00:00:00', NULL, ''),
(12, 8, 4, 1, 1, '2024-07-17 00:00:00', NULL, 'Admitted'),
(13, 1, 1, 1, 1, '2024-07-30 00:00:00', NULL, ''),
(14, 1, 3, 1, 1, '2024-08-20 00:00:00', NULL, 'Admitted'),
(15, 1, 3, 1, 1, '2024-08-20 00:00:00', NULL, 'Admitted'),
(16, 1, 1, 1, 1, '2024-08-21 00:00:00', NULL, 'Admitted');

-- --------------------------------------------------------

--
-- Structure de la table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `appointment_date` date DEFAULT NULL,
  `appointment_time` time DEFAULT NULL,
  `appointment_type` varchar(255) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `confirmation` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('scheduled','completed','canceled') DEFAULT 'scheduled',
  `consultation_fee` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `appointments`
--

INSERT INTO `appointments` (`id`, `patient_id`, `doctor_id`, `appointment_date`, `appointment_time`, `appointment_type`, `reason`, `notes`, `confirmation`, `created_at`, `status`, `consultation_fee`) VALUES
(3, 3, 3, '2023-07-18', '11:00:00', 'Consultation', 'New symptoms', 'Discuss recent changes in health', 1, '2024-07-20 07:52:34', 'completed', NULL),
(4, 4, 1, '2023-07-19', '14:00:00', 'consultation', 'Routine checkup', 'Patient has been feeling well', 0, '2024-07-20 07:52:34', 'scheduled', NULL),
(6, 5, 1, '2024-07-17', '11:09:00', 'consultation', 'JHJ', 'JK', 0, '2024-07-20 09:07:11', 'scheduled', NULL),
(12, 2, 2, '2023-07-17', '10:00:00', 'Consultation', 'Follow-up', 'Bring previous test results', NULL, '2024-07-22 11:56:11', 'scheduled', NULL),
(13, 3, 3, '2023-07-18', '11:00:00', 'Consultation', 'New symptoms', 'Discuss recent changes in health', NULL, '2024-07-22 11:56:11', 'scheduled', NULL),
(15, 1, 2, '2024-07-24', '02:50:00', 'wcxx', 'khgfdd', 'pppppp', 0, '2024-07-24 22:48:28', 'scheduled', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `appointment_history`
--

CREATE TABLE `appointment_history` (
  `id` int(11) NOT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('Scheduled','Completed','Canceled','No Show','Rescheduled') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `appointment_history`
--

INSERT INTO `appointment_history` (`id`, `appointment_id`, `updated_at`, `status`) VALUES
(1, 3, '2024-07-24 13:01:31', 'Rescheduled'),
(2, 3, '2024-07-24 13:02:16', 'Completed');

-- --------------------------------------------------------

--
-- Structure de la table `availability`
--

CREATE TABLE `availability` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `specialty` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `consultation_fee` decimal(10,2) DEFAULT NULL,
  `day_of_week` varchar(50) DEFAULT NULL,
  `month` varchar(50) DEFAULT NULL,
  `status` enum('active','archived') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `availability`
--

INSERT INTO `availability` (`id`, `doctor_id`, `start_time`, `end_time`, `specialty`, `department`, `consultation_fee`, `day_of_week`, `month`, `status`) VALUES
(1, 2, '12:28:00', '15:31:00', 'cardiologue', 'cardiologie', '333.00', 'Monday', 'January', 'active'),
(2, 2, '12:57:00', '16:57:00', 'cardiologue', 'cardiologie', '2000.00', 'Monday', 'January', 'active'),
(3, 2, '11:36:00', '14:39:00', 'cardiologue', 'cardiologie', '3000.00', 'Monday', 'January', 'archived'),
(4, 2, '12:17:00', '16:21:00', 'churigien', 'ccc', '33.00', 'Saturday', 'January', 'active');

-- --------------------------------------------------------

--
-- Structure de la table `beds`
--

CREATE TABLE `beds` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `bed_number` varchar(50) NOT NULL,
  `status` enum('Available','Occupied') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `beds`
--

INSERT INTO `beds` (`id`, `room_id`, `bed_number`, `status`) VALUES
(1, 1, 'Bed-1', 'Available'),
(2, 1, 'Bed-2', 'Available'),
(3, 2, 'Bed-1', 'Available'),
(4, 2, 'Bed-2', 'Available'),
(5, 1, '1A', 'Available'),
(6, 2, '2A', 'Available'),
(7, 2, '2B', 'Available');

-- --------------------------------------------------------

--
-- Structure de la table `care_coordination`
--

CREATE TABLE `care_coordination` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `professional_id` int(11) NOT NULL,
  `observations` text NOT NULL,
  `care_plan` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `checkins`
--

CREATE TABLE `checkins` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `arrival_date` date NOT NULL,
  `arrival_time` time NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('en attente','en consultation','terminé') DEFAULT 'en attente',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `checkins`
--

INSERT INTO `checkins` (`id`, `patient_id`, `arrival_date`, `arrival_time`, `reason`, `status`, `notes`, `created_at`) VALUES
(1, 5, '2024-07-20', '11:32:00', 'fsdfdsf', 'en attente', 'sfsdfdsfd', '2024-07-20 09:31:15');

-- --------------------------------------------------------

--
-- Structure de la table `communications`
--

CREATE TABLE `communications` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `consultations`
--

CREATE TABLE `consultations` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `consultation_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `doctors`
--

CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `specialty` varchar(255) DEFAULT NULL,
  `license_number` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `doctors`
--

INSERT INTO `doctors` (`id`, `full_name`, `specialty`, `license_number`, `phone_number`, `email`, `password`) VALUES
(1, 'Dr. John Doe', 'Cardiologist', '123456', '123-456-7890', 'johndoe@example.com', 'password123'),
(2, 'Dr. Jane Smith', 'Neurologist', '654321', '987-654-3210', 'janesmith@example.com', 'password123');

-- --------------------------------------------------------

--
-- Structure de la table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `invoices`
--

INSERT INTO `invoices` (`id`, `patient_id`, `admission_id`, `total_amount`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 4, '250.00', 'pending', '2024-07-02 22:00:00', '2024-07-26 08:28:08'),
(2, 2, 5, '300.00', 'paid', '2024-07-03 22:00:00', '2024-07-26 08:28:17');

-- --------------------------------------------------------

--
-- Structure de la table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `medical_records`
--

CREATE TABLE `medical_records` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `history` text DEFAULT NULL,
  `family_history` text DEFAULT NULL,
  `allergies` text DEFAULT NULL,
  `current_medications` text DEFAULT NULL,
  `vaccinations` text DEFAULT NULL,
  `previous_tests` text DEFAULT NULL,
  `clinical_observations` text DEFAULT NULL,
  `current_diagnosis` text DEFAULT NULL,
  `current_treatment` text DEFAULT NULL,
  `symptoms` text DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `recommended_tests` text DEFAULT NULL,
  `medications` text DEFAULT NULL,
  `treatment_instructions` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `record_date` date DEFAULT NULL,
  `treatment` text NOT NULL,
  `notes` text DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `medical_records`
--

INSERT INTO `medical_records` (`id`, `patient_id`, `history`, `family_history`, `allergies`, `current_medications`, `vaccinations`, `previous_tests`, `clinical_observations`, `current_diagnosis`, `current_treatment`, `symptoms`, `diagnosis`, `recommended_tests`, `medications`, `treatment_instructions`, `created_at`, `record_date`, `treatment`, `notes`, `update_time`) VALUES
(1, 1, 'jkkjkklk', 'para', 'para', 'para', 'para', 'para', 'para', 'para', 'para', 'Headache, fever', 'Flu', 'Blood test', 'Paracetamol', 'Rest and drink plenty of fluids', '2024-07-22 11:27:03', NULL, '', NULL, '2024-08-19 09:30:43'),
(2, 2, 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'Shortness of breath, chest pain', 'Asthma', 'Spirometry', 'Albuterol inhaler', 'Avoid triggers and use inhaler as needed', '2024-07-22 11:27:03', NULL, '', NULL, '2024-07-29 01:28:21'),
(3, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Joint pain, fatigue', 'Rheumatoid arthritis', 'Blood test', 'Methotrexate', 'Regular exercise and medication', '2024-07-22 11:27:03', NULL, '', NULL, '2024-07-29 01:28:21'),
(4, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'High blood sugar levels', 'Diabetes', 'Blood glucose test', 'Metformin', 'Maintain a healthy diet and exercise regularly', '2024-07-22 11:27:03', NULL, '', NULL, '2024-07-29 01:28:21');

-- --------------------------------------------------------

--
-- Structure de la table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `recipient_role` enum('doctor','nurse','secretary','patient') NOT NULL,
  `sender_id` int(11) NOT NULL,
  `sender_role` enum('doctor','nurse','secretary','patient') NOT NULL,
  `attachments` varchar(255) DEFAULT NULL,
  `status` enum('unread','read','important') DEFAULT 'unread',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `messages`
--

INSERT INTO `messages` (`id`, `subject`, `body`, `recipient_id`, `recipient_role`, `sender_id`, `sender_role`, `attachments`, `status`, `timestamp`, `is_read`) VALUES
(9, 'Appointment Reminder', 'This is a reminder for your appointment.', 1, 'patient', 2, 'doctor', NULL, 'read', '2024-07-22 15:20:53', 0),
(10, 'Follow-up Needed', 'Please schedule a follow-up appointment.', 5, 'patient', 2, 'doctor', NULL, 'read', '2024-07-22 15:20:53', 0),
(11, 'Lab Results', 'Your lab results are in.', 1, 'patient', 3, 'nurse', NULL, 'unread', '2024-07-22 15:20:53', 0),
(13, 'Medication Update', 'Your prescription has been updated.', 1, 'patient', 2, 'doctor', NULL, 'read', '2024-07-22 15:20:53', 0),
(14, 'New Appointment', 'You have a new appointment scheduled.', 5, 'patient', 2, 'doctor', NULL, 'read', '2024-07-22 15:20:53', 0),
(17, 'bonjour', 'GGHHHFDD', 1, 'patient', 9, 'doctor', 'WhatsApp Image 2024-07-21 à 23.47.52_9bb55a04.jpg', 'important', '2024-07-23 01:54:11', 0),
(18, 'bonjour', 'GGHHHFDD', 1, 'patient', 9, 'doctor', 'WhatsApp Image 2024-07-21 à 23.47.52_9bb55a04.jpg', 'read', '2024-07-23 01:54:46', 0),
(19, 'bonjour', 'GGHHHFDD', 1, 'patient', 9, 'doctor', 'WhatsApp Image 2024-07-21 à 23.47.52_9bb55a04.jpg', 'unread', '2024-07-23 01:55:44', 0),
(20, 'bonjour', 'GGHHHFDD', 1, 'patient', 9, 'doctor', 'WhatsApp Image 2024-07-21 à 23.47.52_9bb55a04.jpg', 'unread', '2024-07-23 01:55:45', 0),
(21, 'bonjour', 'GGHHHFDD', 1, 'patient', 9, 'doctor', 'WhatsApp Image 2024-07-21 à 23.47.52_9bb55a04.jpg', 'unread', '2024-07-23 01:57:25', 0);

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `status` enum('unread','read') DEFAULT 'unread',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `doctor_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `nurses`
--

CREATE TABLE `nurses` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `specialty` varchar(255) DEFAULT NULL,
  `license_number` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `patients`
--

CREATE TABLE `patients` (
  `id` int(11) NOT NULL,
  `unique_id` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `emergency_contact` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `ssn` varchar(50) DEFAULT NULL,
  `medical_history` text DEFAULT NULL,
  `family_history` text DEFAULT NULL,
  `allergies` text DEFAULT NULL,
  `current_medications` text DEFAULT NULL,
  `vaccinations` text DEFAULT NULL,
  `previous_tests` text DEFAULT NULL,
  `clinical_observations` text DEFAULT NULL,
  `current_diagnosis` text DEFAULT NULL,
  `current_treatment` text DEFAULT NULL,
  `full_name` varchar(511) GENERATED ALWAYS AS (concat(`first_name`,' ',`last_name`)) VIRTUAL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `patients`
--

INSERT INTO `patients` (`id`, `unique_id`, `first_name`, `last_name`, `birth_date`, `gender`, `address`, `phone`, `email`, `emergency_contact`, `dob`, `ssn`, `medical_history`, `family_history`, `allergies`, `current_medications`, `vaccinations`, `previous_tests`, `clinical_observations`, `current_diagnosis`, `current_treatment`) VALUES
(1, 'P001', 'John', 'Doe', '1980-01-01', 'male', '123 Main St', '1234567890', 'john.doe@example.com', 'Jane Doe', '1980-01-01', '123-45-6789', 'No significant medical history', 'No significant family history', 'None', 'None', 'Up to date', 'None', 'Normal', 'Healthy', 'None'),
(2, 'P002', 'Jane', 'Smith', '1990-02-02', 'female', '456 Elm St', '0987654321', 'jane.smith@example.com', 'John Smith', '1990-02-02', '987-65-4321', 'Asthma', 'Diabetes in family', 'Penicillin', 'Albuterol', 'Up to date', 'None', 'Normal', 'Asthma', 'Inhaler'),
(3, 'P003', 'Alice', 'Johnson', '1985-03-03', 'female', '789 Oak St', '5555555555', 'alice.johnson@example.com', 'Bob Johnson', '1985-03-03', '555-55-5555', 'Hypertension', 'Heart disease in family', 'None', 'Lisinopril', 'Up to date', 'None', 'Normal', 'Hypertension', 'Medication'),
(4, 'P004', 'Bob', 'Brown', '1975-04-04', 'male', '101 Maple St', '4444444444', 'bob.brown@example.com', 'Alice Brown', '1975-04-04', '444-44-4444', 'Diabetes', 'Obesity in family', 'None', 'Metformin', 'Up to date', 'None', 'Normal', 'Diabetes', 'Diet and medication'),
(5, '', '', '', NULL, 'male', '407', '695870534', 'nonobrice441@gmail.com', NULL, '2007-01-25', '987654', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, '', '', '', NULL, NULL, '2545', '63521456', 'bricenonocarles@gmail.com', NULL, '2024-07-11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, '', 'brice', 'nono', '2024-07-15', 'male', '4556', '69865434', 'nana@gmail.com', NULL, '2024-07-29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, '', 'nono', 'brice', '2024-07-09', 'male', '2545', '63521456', 'nana@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, '', '', '', '1980-01-01', 'male', '123 Main St', '1234567890', 'john.doe@example.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, '', '', '', '1990-02-02', 'female', '456 Elm St', '0987654321', 'jane.smith@example.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `role` enum('patient','secretary','doctor','nurse') NOT NULL,
  `section` varchar(255) NOT NULL,
  `access_level` enum('Lecture','Écriture','Modification','Suppression') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `medication_name` varchar(255) NOT NULL,
  `dosage` varchar(255) NOT NULL,
  `frequency` varchar(255) NOT NULL,
  `duration` varchar(255) NOT NULL,
  `additional_instructions` text DEFAULT NULL,
  `prescribed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `archived` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `prescriptions`
--

INSERT INTO `prescriptions` (`id`, `patient_id`, `doctor_id`, `medication_name`, `dosage`, `frequency`, `duration`, `additional_instructions`, `prescribed_at`, `archived`) VALUES
(1, 1, 2, 'Paracetamol', '500mg', '2 fois par jour Matin/Soir', '2 semaines', 'Bien manger avant de prendre', '2024-07-24 12:22:04', 1),
(2, 7, 5, 'Paracetamol', '500mg', '2 fois par jour Matin/Soir', '2 semaines', '', '2024-07-27 21:22:39', 0);

-- --------------------------------------------------------

--
-- Structure de la table `professionals`
--

CREATE TABLE `professionals` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `specialty` varchar(255) DEFAULT NULL,
  `license_number` varchar(50) DEFAULT NULL,
  `role` enum('Doctor','Nurse') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `room_number` varchar(50) NOT NULL,
  `room_type` enum('Private','Semi-Private','Ward') NOT NULL,
  `number_of_beds` int(11) NOT NULL,
  `price_per_night` decimal(10,2) NOT NULL,
  `status` enum('Available','Occupied') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `rooms`
--

INSERT INTO `rooms` (`id`, `room_number`, `room_type`, `number_of_beds`, `price_per_night`, `status`) VALUES
(1, 'chambre403', 'Ward', 2, '3000.00', 'Available'),
(2, 'chambre401', 'Ward', 2, '5000.00', 'Available'),
(3, 'chambre401', 'Ward', 2, '3000.00', 'Available'),
(4, 'chambre402', 'Semi-Private', 3, '2000.00', 'Available'),
(5, 'chambre403', 'Private', 1, '7000.00', 'Available'),
(6, '101', 'Private', 1, '200.00', 'Available'),
(7, '102', 'Semi-Private', 2, '150.00', 'Available');

-- --------------------------------------------------------

--
-- Structure de la table `secretaries`
--

CREATE TABLE `secretaries` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `services`
--

CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `services`
--

INSERT INTO `services` (`id`, `name`, `description`, `price`) VALUES
(1, 'consultation', 'pour les consultations', '3000.00'),
(2, 'consultation', 'scsdccsqdcsqd', '3000.00'),
(3, 'General Consultation', 'A general medical consultation', '50.00'),
(4, 'Specialized Consultation', 'A consultation with a specialist', '100.00');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('patient','doctor','nurse','secretary','admin') NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `specialty` varchar(255) DEFAULT NULL,
  `license_number` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `ssn` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `full_name`, `email`, `phone`, `address`, `specialty`, `license_number`, `dob`, `gender`, `ssn`, `status`) VALUES
(1, 'nono@gmail.com', 'pbkdf2:sha256:600000$6JJAsZE3CA0hO8Q6$d59a99dc122b88056960c4405108836fc28ecefba0a5684f9f09061fc03dab93', 'admin', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active'),
(2, 'nana@gmail.com', 'pbkdf2:sha256:600000$l5zBkK4YMPFZ61je$8cb78c054fdd4b9399e4190c0825a4b828e6852677a1146bb7aea6275df5a295', 'doctor', 'nana@gmail.com', 'nana@gmail.com', 'doctor', 'nana', '2545', 'cardiologue', '0000-00-00', 'male', 'male', 'inactive'),
(3, 'Tchinda', 'pbkdf2:sha256:600000$8q44NtwJjvt8ITaa$85d60ebd5d818d730ff62c8a9d4c04237a7f3b1dbbe82dd06af384e1a0007f58', 'doctor', 'Tchinda', 'Tchinda@gmail.com', '69865434', '4556', 'churigien', '23456', '0000-00-00', 'male', '', 'active'),
(5, 'cela', 'pbkdf2:sha256:600000$1XNuPpSCJWAHFWxF$9af1bc426d0cd7c54a35d679662f68dd0920e40c17164cccbefdc5854bd39a8f', 'secretary', 'cela', 'cela@gmail.com', '69865434', '2545', '', '', '0000-00-00', 'male', '', 'active'),
(7, 'brice', 'pbkdf2:sha256:600000$YEHssh126ReK7fvc$e61e623dee18457b1c325c49c718e2e1ea6eb2d899b80d2d042f7cf8db09f5de', 'nurse', 'brice', 'brice@gmail.com', '63521456', '4556', 'cardiologue', 'cardiologie', '0000-00-00', 'male', '', 'active'),
(8, 'kenne', 'pbkdf2:sha256:600000$cnzpfLvbXSr0hjjf$e2b98289a07f4db6a4dbb1ccfff13b31339ca2f3da92b50f55ae7a0461a19876', 'nurse', 'kenne', 'kenne@gmail.com', '63521456', '2545', 'cardiologue', '12345', '0000-00-00', 'male', '', 'active'),
(9, 'valdo', 'pbkdf2:sha256:600000$Q7DuMchdSIcdOIG2$3f69260e0d4e8e4c2c9500e6f2c07affa3d2722e4d00ee5517ca9c3b60011fc8', 'patient', 'valdo', 'valdo@gmail.com', '63521456', '2545', '', '', '0000-00-00', 'male', '', 'active'),
(10, 'yankam', 'pbkdf2:sha256:600000$Br9VGlAp6kyiGj7z$b9d2c5ab7aea28640dcb27a9bdbb0e8e40929649ed7e7f28c68d1da4e1163f53', 'doctor', 'yankam', 'yankam@gmail.com', '63521456', '4556', 'cardiologue', '23456', '0000-00-00', 'male', '', 'active');

-- --------------------------------------------------------

--
-- Structure de la table `user_activities`
--

CREATE TABLE `user_activities` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `activity_type` varchar(255) NOT NULL,
  `activity_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `admissions`
--
ALTER TABLE `admissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `service_id` (`service_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `bed_id` (`bed_id`);

--
-- Index pour la table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `appointments_ibfk_1` (`patient_id`);

--
-- Index pour la table `appointment_history`
--
ALTER TABLE `appointment_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointment_id` (`appointment_id`);

--
-- Index pour la table `availability`
--
ALTER TABLE `availability`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Index pour la table `beds`
--
ALTER TABLE `beds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`);

--
-- Index pour la table `care_coordination`
--
ALTER TABLE `care_coordination`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `professional_id` (`professional_id`);

--
-- Index pour la table `checkins`
--
ALTER TABLE `checkins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- Index pour la table `communications`
--
ALTER TABLE `communications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- Index pour la table `consultations`
--
ALTER TABLE `consultations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- Index pour la table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `admission_id` (`admission_id`);

--
-- Index pour la table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`);

--
-- Index pour la table `medical_records`
--
ALTER TABLE `medical_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- Index pour la table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recipient_id` (`recipient_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Index pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recipient_id` (`recipient_id`);

--
-- Index pour la table `nurses`
--
ALTER TABLE `nurses`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Index pour la table `professionals`
--
ALTER TABLE `professionals`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `secretaries`
--
ALTER TABLE `secretaries`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_activities`
--
ALTER TABLE `user_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `admissions`
--
ALTER TABLE `admissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `appointment_history`
--
ALTER TABLE `appointment_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `availability`
--
ALTER TABLE `availability`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `beds`
--
ALTER TABLE `beds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `care_coordination`
--
ALTER TABLE `care_coordination`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `checkins`
--
ALTER TABLE `checkins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `communications`
--
ALTER TABLE `communications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `consultations`
--
ALTER TABLE `consultations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `medical_records`
--
ALTER TABLE `medical_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `nurses`
--
ALTER TABLE `nurses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `professionals`
--
ALTER TABLE `professionals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `secretaries`
--
ALTER TABLE `secretaries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `services`
--
ALTER TABLE `services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `user_activities`
--
ALTER TABLE `user_activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `admissions`
--
ALTER TABLE `admissions`
  ADD CONSTRAINT `admissions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `admissions_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `admissions_ibfk_3` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `admissions_ibfk_4` FOREIGN KEY (`bed_id`) REFERENCES `beds` (`id`);

--
-- Contraintes pour la table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`);

--
-- Contraintes pour la table `appointment_history`
--
ALTER TABLE `appointment_history`
  ADD CONSTRAINT `appointment_history_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `availability`
--
ALTER TABLE `availability`
  ADD CONSTRAINT `availability_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `beds`
--
ALTER TABLE `beds`
  ADD CONSTRAINT `beds_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `care_coordination`
--
ALTER TABLE `care_coordination`
  ADD CONSTRAINT `care_coordination_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `care_coordination_ibfk_2` FOREIGN KEY (`professional_id`) REFERENCES `professionals` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `checkins`
--
ALTER TABLE `checkins`
  ADD CONSTRAINT `checkins_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `communications`
--
ALTER TABLE `communications`
  ADD CONSTRAINT `communications_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`);

--
-- Contraintes pour la table `consultations`
--
ALTER TABLE `consultations`
  ADD CONSTRAINT `consultations_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `consultations_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`);

--
-- Contraintes pour la table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `invoices_ibfk_2` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`id`);

--
-- Contraintes pour la table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`);

--
-- Contraintes pour la table `medical_records`
--
ALTER TABLE `medical_records`
  ADD CONSTRAINT `medical_records_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_activities`
--
ALTER TABLE `user_activities`
  ADD CONSTRAINT `user_activities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
