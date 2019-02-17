-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Хост: uchifeek.mysql.ukraine.com.ua
-- Время создания: Фев 18 2019 г., 00:46
-- Версия сервера: 5.7.16-10-log
-- Версия PHP: 7.0.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `uchifeek_zfi2`
--

-- --------------------------------------------------------

--
-- Структура таблицы `lang_data`
--

CREATE TABLE `lang_data` (
  `id` int(11) NOT NULL,
  `ident` varchar(100) NOT NULL,
  `value` json NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `lang_data`
--

INSERT INTO `lang_data` (`id`, `ident`, `value`) VALUES
(1, 'NO_PASSWORD_OR_LOGIN_SPECIFIED', '{\"en\": \"No password or login specified\", \"ru\": \"Не указан пароль или логин\", \"ua\": \"Не вказано логін або пароль\"}'),
(2, 'THIS_LOGIN_IS_ALREADY_RESERVED', '{\"en\": \"This login is already reserved\", \"ru\": \"Такой логин уже зарезервирован\", \"ua\": \"Вказаний логін вже зарезервовано\"}'),
(3, 'OR', '{\"en\": \"or\", \"ru\": \"или\", \"ua\": \"або\"}'),
(4, 'ACCOUNT_SUCCESSFULLY_CREATED', '{\"en\": \"Account successfully created\", \"ru\": \"Аккаунт успешно создан\", \"ua\": \"Аккаунт успішно створено\"}'),
(5, 'AUTHORIZATION', '{\"en\": \"Authorization\", \"ru\": \"Авторизация\", \"ua\": \"Авторизація\"}'),
(6, 'LOGIN', '{\"en\": \"Login\", \"ru\": \"Логин\", \"ua\": \"Логін\"}'),
(7, 'PASSWORD', '{\"en\": \"Password\", \"ru\": \"Пароль\", \"ua\": \"Пароль\"}'),
(8, 'LOG_IN', '{\"en\": \"Log in\", \"ru\": \"Войти\", \"ua\": \"Увійти\"}'),
(9, 'FORM_REQUIRED_FIELD', '{\"en\": \"Required field\", \"ru\": \"Обязательное поле\", \"ua\": \"Обов\'язкове поле\"}'),
(10, 'FORM_MIN_FIELD_LONG', '{\"en\": \"The field must be at least %s long\", \"ru\": \"Поле должно быть длинной не менее %s\", \"ua\": \"Поле має бути довжиною не менше %s\"}'),
(11, 'FORM_MAX_FIELD_LONG', '{\"en\": \"The field must be no more than %s long\", \"ru\": \"Поле должно быть длинной не более %s\", \"ua\": \"Поле має бути довжиною не більше %s\"}'),
(12, 'FORM_REMEMBER_ME', '{\"en\": \"Rememeber me\", \"ru\": \"Запомни меня\", \"ua\": \"Запам\'ятай мене\"}'),
(13, 'FORM_LOGIN_TYPE_VALIDATION_TEXT', '{\"en\": \"The field can contain only Latin letters, numbers, hyphens and underscores\", \"ru\": \"Поле может содержать только латиницу, цифры, дефис и нижнее подчеркивание\", \"ua\": \"Поле може містити тільки латиницю, цифри, дефіс та нижнє підкреслювання\"}');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `login` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `is_active` int(11) NOT NULL DEFAULT '1',
  `role_id` int(11) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `login`, `password`, `username`, `is_active`, `role_id`) VALUES
(1, 'empty', 'a2e4822a98337283e39f7b60acf85ec9', 'empty', 1, 1),
(2, 'empty2', '085724c672c3bc054d1c266613d17803', 'empty2', 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `users_roles`
--

CREATE TABLE `users_roles` (
  `id` int(11) NOT NULL,
  `name` varchar(25) NOT NULL,
  `code` varchar(25) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `users_roles`
--

INSERT INTO `users_roles` (`id`, `name`, `code`) VALUES
(1, 'Пользователь', 'ZFI_USER'),
(2, 'Админ', 'ZFI_ADMIN');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `lang_data`
--
ALTER TABLE `lang_data`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users_roles`
--
ALTER TABLE `users_roles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `lang_data`
--
ALTER TABLE `lang_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `users_roles`
--
ALTER TABLE `users_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
