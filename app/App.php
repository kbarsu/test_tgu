<?php

class App {

    // ссылка на экземпляр объекта базы данных
    protected $database;

    // ключ апи-геокодера
    protected $api_key = 'ae92b63e-477d-428b-9d79-65774b3c8fc3';

    function __construct() {
        // подключаемся к базе данных
        $this->database = new \Database();

        if(!$this->database->connect()) {
		throw new Exception('Не удалось подключиться к базе данных');
	}
    }

    function __destruct() {
        $this->database->disconnect();
    }

    /**
     * Маршрутизация - выбираем метод по названию действия
     *
     * @param  mixed $action
     *
     * @return void
     */
    public function route($action) {

        $response = [];

        // вызываем метод в зависимости от указанного в запросе действия (параметр action)
        switch ($action) {
            // сохранение города
            case 'save_city':
                $response = $this->save_city();
                break;
            // получение дистанции между городами
            case 'get_distance':
                $response = $this->get_distance();
                break;
            // получение списка городов, сораненных в базе
            case 'get_cities':
                $response = $this->get_cities();
                break;
            // поиск города через апи геокодера
            case 'find_city':
                $response = $this->find_city($_GET['name']);
                break;

            // по умолчанию - отдаем шаблон index.tpl
            default:
                include('templates/index.tpl');
                die();
                break;
        }

        // формируем ответ для обработки на фронте
        die(json_encode([
            'status' => 'ok',
            'data'   => $response
        ]));
    }

    /**
     * Сохранение города в БД
     *
     * @return void
     */
    private function save_city() {

        // проверка на наличие всех необходимых значений для сохранения города - имени и координат
        if (empty($_GET['name']) || empty($_GET['latitude']) || empty($_GET['longitude'])) {
            throw new Exception('Не передан город и его координаты для сохранения');
        }

        return [
            $this->database->insert('cities', [
                'city_name' => $_GET['name'],
                'city_latitude' => (float)$_GET['latitude'],
                'city_longitude' => (float)$_GET['longitude']
            ])
        ];
    }

    /**
     * Расчет дистанции
     *
     * @return void
     */
    private function get_distance() {

        // проверка на то, что в запросе переданы ID двух городов
        if (empty((int)$_GET['city1']) || empty((int)$_GET['city2'])) {
            throw new Exception('Не передан город для подсчета расстояния');
        }

        $city1 = $this->database->get_row('cities', ['id' => (int)$_GET['city1']]);
        $city2 = $this->database->get_row('cities', ['id' => (int)$_GET['city2']]);

        // проверка на наличие всех необходимых значений для рассчета дистанции между координатами
        if (empty($city1) || empty($city2)) {
            throw new Exception('Не найден город в базе данных');
        }
        if (empty($city1['city_longitude']) || empty($city1['city_latitude']) || empty($city2['city_longitude']) || empty($city2['city_latitude'])) {
            throw new Exception('У одного из городов не указаны координаты');
        }

        // получаем радиан
        $rad = M_PI / 180;
        $theta = $city1['city_longitude'] - $city2['city_longitude'];

        // формула расчета длины дуги
        $dist = sin($city1['city_latitude'] * $rad) * sin($city2['city_latitude'] * $rad) + cos($city1['city_latitude'] * $rad) * cos($city2['city_latitude'] * $rad) * cos($theta * $rad);
        
        return [
            'city1'    => $city1['city_name'],
            'city2'    => $city2['city_name'],
            'distance' => acos($dist) / $rad * 60 * 1.853
        ];  
    }

    /**
     * Получаение всех городов
     *
     * @return void
     */
    private function get_cities() {
        return  $this->database->get_all('cities');
    }

    /**
     * ПОиск города по названию
     *
     * @param  mixed $city_name
     *
     * @return void
     */
    private function find_city($city_name) {
        // проверка на то, что в запросе передана строка для поиска города
        if (empty($city_name)) {
            throw new Exception('Введите название города для поиска');
        }

        // путь к апи
        $url = 'https://geocode-maps.yandex.ru/1.x/?apikey=' . $this->api_key . '&format=json&kind=locality&results=1&geocode=' . urlencode($city_name);

        // curl-запрос
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_URL, $url);

        // отключаем ssl-проверку
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        // декодируем результат запроса в ассоциативный массив
        $result = json_decode(curl_exec($ch), true);
        curl_close($ch);

        // парсинг результата
        if (!empty($result['response']['GeoObjectCollection']['metaDataProperty']['GeocoderResponseMetaData']['found'])) {
            $city_name = $result['response']['GeoObjectCollection']['featureMember'][0]['GeoObject']['name'];
            $coords = explode(" ", $result['response']['GeoObjectCollection']['featureMember'][0]['GeoObject']['Point']['pos']);
            return [
                'city_name' => $city_name,
                'longitude'  => $coords[0],
                'latitude' => $coords[1],
            ];
        } else {
            // бросаем исключение, если город не найден
            throw new Exception('Не найден город по запросу "' .$city_name . '"');
        }
    }
}