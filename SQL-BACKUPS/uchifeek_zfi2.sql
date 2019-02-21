-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Хост: uchifeek.mysql.ukraine.com.ua
-- Время создания: Фев 21 2019 г., 23:27
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
(13, 'FORM_LOGIN_TYPE_VALIDATION_TEXT', '{\"en\": \"The field can contain only Latin letters, numbers, hyphens and underscores\", \"ru\": \"Поле может содержать только латиницу, цифры, дефис и нижнее подчеркивание\", \"ua\": \"Поле може містити тільки латиницю, цифри, дефіс та нижнє підкреслювання\"}'),
(14, 'LOG_OUT', '{\"en\": \"Log out\", \"ru\": \"Выйти\", \"ua\": \"Вийти\"}'),
(15, 'YOU_ARE_WELCOME', '{\"en\": \"You are welcome\", \"ru\": \"Добро пожаловать\", \"ua\": \"Ласкаво просимо\"}'),
(16, 'FORM_ERROR_ACCOUNT_DOES_NOT_EXIST', '{\"en\": \"Account does not exist\", \"ru\": \"Такой учетной записи не существует\", \"ua\": \"Такого аккаунту не існує\"}'),
(17, 'REGISTRATION', '{\"en\": \"Registration\", \"ru\": \"Регистрация\", \"ua\": \"Реєстрація\"}'),
(18, 'SIGN_UP', '{\"en\": \"Sign up\", \"ru\": \"Зарегистрироваться\", \"ua\": \"Зареєструватись\"}'),
(19, 'YOUR_NAME', '{\"en\": \"Your name\", \"ru\": \"Ваше имя\", \"ua\": \"Ваше ім\'я\"}'),
(20, 'FORM_FIO_TYPE_VALIDATION_TEXT', '{\"en\": \"Only letters are available\", \"ru\": \"Доступны только буквы\", \"ua\": \"Доступні лише літери\"}'),
(21, 'REF_LINK_REGISTER_ONLY_BY', '{\"en\": \"Registration is available only by referral link\", \"ru\": \"Регистрация доступна только по реферальной ссылке\", \"ua\": \"Реєстрація доступна тільки за реферальним посиланням\"}'),
(22, 'REF_LINK_NOT_AVAILABLE', '{\"en\": \"The referral link does not exist or is not available\", \"ru\": \"Реферальная ссылка не существует или недоступна\", \"ua\": \"Реферальне посилання недоступне або не існує\"}'),
(23, 'PASSWORD_REPEAT', '{\"en\": \"Repeat password\", \"ru\": \"Повторить пароль\", \"ua\": \"Повторити пароль\"}'),
(24, 'FORM_FIELD_NOT_IDENTICAL', '{\"en\": \"Values do not match\", \"ru\": \"Значения не совпадают\", \"ua\": \"Значення не співпадають\"}'),
(25, 'FORM_FIELD_NOT_UNIQUE', '{\"en\": \"Value is not unique\", \"ru\": \"Значение не уникально\", \"ua\": \"Значення не унікальне\"}'),
(26, 'NOW_YOU_CAN_LOG_IN_WITH_YOUR_ACCOUNT', '{\"en\": \"Now You can log in with your account\", \"ru\": \"Теперь Вы можете зайти под своей учетной записью\", \"ua\": \"Тепер Ви можете зайти під своїм обліковим записом\"}'),
(28, 'ADD_TERM_TO_DICTIONARY', '{\"en\": \"Add term to dictionary\", \"ru\": \"Добавить термин в словарь\", \"ua\": \"Додати термін у словник\"}'),
(29, 'IDENT', '{\"en\": \"Ident\", \"ru\": \"Идентификатор\", \"ua\": \"Ідентифікатор\"}'),
(30, 'LANGUAGE_IDENT_SUCCESSFULLY_INSERTED', '{\"en\": \"Ident has been successfully added\", \"ru\": \"Идентификатор был успешно добавлен\", \"ua\": \"Ідентифікатор було успішно додано\"}'),
(31, 'FORM_IDENT_TYPE_VALIDATION_TEXT', '{\"en\": \"The field can contain only Latin letters, spaces, numbers, hyphens and underscores\", \"ru\": \"Поле может содержать только латиницу, пробелы, цифры, дефис и нижнее подчеркивание\", \"ua\": \"Поле може містити тільки латиницю, пробіл, цифри, дефіс та нижнє підкреслювання\"}'),
(33, 'LANGUAGE_FORM_IDENT_HELPER', '{\"en\": \"All characters will be changed to uppercase, spaces to underscore\", \"ru\": \"Все символы будут изменены на uppercase, пробелы на нижнее подчеркивание\", \"ua\": \"Всі символи будуть змінені на uppercase, пробіли на нижнє підкреслення\"}'),
(34, 'LANGUAGE', '{\"en\": \"Language\", \"ru\": \"Язык\", \"ua\": \"Мова\"}');

-- --------------------------------------------------------

--
-- Структура таблицы `refferal_hash`
--

CREATE TABLE `refferal_hash` (
  `id` int(11) NOT NULL,
  `hash` varchar(40) NOT NULL,
  `type` varchar(40) NOT NULL,
  `options` varchar(100) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `is_active` int(11) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `refferal_hash`
--

INSERT INTO `refferal_hash` (`id`, `hash`, `type`, `options`, `id_user`, `is_active`) VALUES
(1, '24d4594d40c0ce3d8a7ec7e6a333f739', 'register', NULL, 26, 1);

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
(1, 'empty', '7d665d9fa18a26df451d111b34afd89f', 'empty', 1, 1),
(2, 'empty2', '7d665d9fa18a26df451d111b34afd89f', 'empty2', 1, 1),
(3, 'exarchik', '4761436adfd1810131941e5ab48a3478', 'Экзарыч', 1, 3);

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
(2, 'Админ', 'ZFI_ADMIN'),
(3, 'Суперадмин', 'ZFI_SUPERADMIN');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `lang_data`
--
ALTER TABLE `lang_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ident` (`ident`);

--
-- Индексы таблицы `refferal_hash`
--
ALTER TABLE `refferal_hash`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT для таблицы `refferal_hash`
--
ALTER TABLE `refferal_hash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT для таблицы `users_roles`
--
ALTER TABLE `users_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
