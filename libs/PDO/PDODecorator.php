<?php 

class PDODecorator
{
    public $db;

    public function __construct($host, $dbname, $login, $pass)
    {
        $dsn = 'mysql:dbname='.$dbname.';host='.$host;
        try {
            $this->db = new PDO($dsn, $login, $pass);
        } catch (PDOException $e) {
            echo 'Подключение не удалось: ' . $e->getMessage();
        }
    }

    public function getAll($sql, $type = false)
    {
        $data = array();
        try {
            foreach ($this->db->query($sql, PDO::FETCH_ASSOC) as $value) {
                if ($type == 'row') {
                    return $value;
                }
                if ($type == 'col' || ($type == 'assoc' && count($value) == 1)) {
                    foreach ($value as $val) {
                        $data[] = $val;
                        continue 2;
                    }
                }
                if ($type == 'assoc') {
                    if (count($value) == 2) {
                        $data[reset($value)] = end($value);
                        continue;
                    } else {
                        $firstValue = reset($value);
                        $firstKey = key($value);
                        $data[$firstValue] = array_diff_key($value, array($firstKey => ''));
                        continue;
                    }
                }
                $data[] = $value;
            }
        } catch (PDOException $e) {
            echo 'Ошибка запроса: ' . $e->getMessage();
        }
        return $data;
    }

    public function getRow($sql)
    {
        return $this->getAll($sql, 'row');
    }

    public function getCol($sql)
    {
        return $this->getAll($sql, 'col');
    }

    public function getAssoc($sql) 
    {
        return $this->getAll($sql, 'assoc');
    }
}