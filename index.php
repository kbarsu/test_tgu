<?php
// подключаем нужные файлы с классами
include('app/App.php');
include('app/Database.php');

// глобальная обработка наших исключений
try {

    //создаем экземпляр класса приложения
    $app = new App();

    // запускаем маршрутизацию
    $app->route($_GET['action'] ?? '');

} catch (Exception $e) {

    // если поймали исключение - выдаем сообщение со статусом error и текстом этого исключения
    die(json_encode([
        'status' => 'error',
        'message'=> $e->getMessage()
    ]));
}