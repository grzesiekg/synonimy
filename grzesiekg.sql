-- phpMyAdmin SQL Dump
-- version home.pl
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Czas wygenerowania: 10 Lut 2013, 14:02
-- Wersja serwera: 5.5.29-log
-- Wersja PHP: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Baza danych: `grzesiekg`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `synonimy`
--

CREATE TABLE IF NOT EXISTS `synonimy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wyraz1` varchar(255) DEFAULT NULL,
  `wyraz2` varchar(255) DEFAULT NULL,
  `wyraz3` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Zrzut danych tabeli `synonimy`
--

INSERT INTO `synonimy` (`id`, `wyraz1`, `wyraz2`, `wyraz3`) VALUES
(1, 'kradzież', 'grabież', 'rabunek'),
(2, 'zrzucać', 'strącać', 'strząsać'),
(3, 'ładny', 'urokliwy', 'piękny'),
(4, 'krojenie', 'operacja', NULL),
(9, 'kompozytor', 'mistrz', NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
