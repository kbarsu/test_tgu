DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
  `id` int(11) NOT NULL,
  `city_name` varchar(50) DEFAULT NULL,
  `city_latitude` float DEFAULT NULL,
  `city_longitude` float DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `cities` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `city_name` (`city_name`);
ALTER TABLE `cities` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

INSERT INTO `cities` (`id`, `city_name`, `city_latitude`, `city_longitude`, `insert_time`) VALUES
(1, 'Тольятти', 53.5088, 49.4192, '2020-03-01 19:14:47'),
(4, 'Жигулёвск', 53.4017, 49.4947, '2020-03-01 22:26:45'),
(5, 'Сызрань', 53.1558, 48.4745, '2020-03-02 00:28:10'),
(6, 'проспект Дзержинского', 53.8746, 27.4957, '2020-03-04 17:16:32'),
(7, 'Москва', 55.7532, 37.6225, '2020-03-04 17:17:04'),
(12, 'Санкт-Петербург', 59.9389, 30.3156, '2020-03-04 19:27:35'),
(13, 'Таганрог', 47.2206, 38.9147, '2020-03-05 16:38:41'),
(14, 'Кривой Рог', 47.9105, 33.3918, '2020-03-05 16:38:53'),
(15, 'посёлок городского типа Зеленовка', 46.7181, 32.6398, '2020-03-05 16:39:01'),
(16, 'Ульяновск', 54.3142, 48.4031, '2020-03-05 16:39:33'),
(17, 'Кемерово', 55.3547, 86.0884, '2020-03-05 16:39:40');

COMMIT;


