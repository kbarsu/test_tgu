<?php
class Database {

    // данные для доступа к БД
    protected $database_host = 'localhost';
    protected $database_user = 'kbarsu_db';
    protected $database_pass = 'V_1234567';
    protected $database_name = 'kbarsu_db';
    protected $mysqli;
                                                                                                                                                     
    /**
     * Метод установки соединения с базой
     *
     * @return void
     */
    public function connect() {
        $this->mysqli = new mysqli($this->database_host, $this->database_user, $this->database_pass, $this->database_name);
        return empty($this->mysqli->connect_errno);
    }

    /**
     * Метод закрытия подключения
     *
     * @return void
     */
    public function disconnect() {
        if (!empty($this->mysqli)) {
            return $this->mysqli->close();
        } else {
            return true;
        }
    }

    /**
     * Добавление записи
     *
     * @param  mixed $table_name
     * @param  mixed $insert_arr
     *
     * @return void
     */
    public function insert($table_name, $insert_arr) {

    $fields = [];
    $values = [];
    foreach ($insert_arr as $field => $value) {
        $fields[] = $field;
        $values[] = '"' . $this->mysqli->real_escape_string($value) . '"';
    }

        $sql = "INSERT INTO $table_name (" . join(',', $fields) . ") VALUES (" . join(',', $values) . ");";
        if ($this->mysqli->query($sql)) {
            return $this->mysqli->insert_id;
        } else {
            throw new Exception('Ошибка добавления записи');
        }
    }

    /**
     * Плучение всех записей таблицы с возможностью указания условия
     *
     * @param  mixed $table_name
     * @param  mixed $select_arr
     *
     * @return void
     */
    public function get_all($table_name, $select_arr = []) {

        $where = '';
        foreach ($select_arr as $field => $value) {
            $filter[] = $field . ' = ' . $this->mysqli->real_escape_string($value);
        }

        if (!empty($filter)) {
            $where = ' WHERE ' . join(' AND ', $filter);
        }
    
        $sql = "SELECT * FROM $table_name" . $where . ";";
        $result_return = [];
        if ($result = $this->mysqli->query($sql)) {
            while ($row = $result->fetch_assoc()) {
                $result_return[] = $row;
            }
        }
        return $result_return;
    }

    /**
     * Получение одной записи из таблицы по условию или без
     *
     * @param  mixed $table_name
     * @param  mixed $select_arr
     *
     * @return void
     */
    public function get_row($table_name, $select_arr = []) {
        $where = '';
        foreach ($select_arr as $field => $value) {
            $filter[] = $field . ' = ' . $this->mysqli->real_escape_string($value);
        }

        if (!empty($filter)) {
            $where = ' WHERE ' . join(' AND ', $filter);
        }
    
        $sql = "SELECT * FROM $table_name" .  $where . " LIMIT 1;";

        $result_return = [];
        if ($result = $this->mysqli->query($sql)) {
            $result_return = $result->fetch_assoc();
        }
        return $result_return;
    }
}