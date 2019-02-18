<?php

class Validator
{
    protected $currentValues = array();

    protected $allowedTypes = array(
        'required', 'min', 'max', 'login', 'fio', 'identical', 'unique'
    );

    protected $cyrillicSings = 'абвгдеёжзийклмнопрстуфхцчшщьъыэюяіїґАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЪЫЭЮЯІЇҐ';

    public function validate($value, $validate)
    {
        $result = [];
        foreach ($validate as $type => $data) {
            // валидация по умолчанию, если передаем только тип
            if (is_string($data) && in_array($data, $this->allowedTypes)) {
                $type = $data;
                $data = '';
            }
            // валидация если шалон в виде строки, а не массива
            $data = is_array($data) ? $data : array($data);
            if (!in_array($type, $this->allowedTypes)) {
                continue;
            }
            switch ($type) {
                // поле недолжно быть пустым
                case 'required':
                    $msg = !empty($data[0]) ? __($data[0]) : __('FORM_REQUIRED_FIELD');
                    if (empty($value)) {
                        $result[] = $msg;
                    }
                    break;
                // минимум % знаков
                case 'min':
                    $msg = !empty($data[1]) ? __($data[1]) : __('FORM_MIN_FIELD_LONG');
                    if (mb_strlen($value) < $data[0]) {
                        $result[] = sprintf($msg, $data[0]);
                    }
                    break;
                // максимум % знаков
                case 'max':
                    $msg = !empty($data[1]) ? __($data[1]) : __('FORM_MAX_FIELD_LONG');
                    if (mb_strlen($value) > $data[0]) {
                        $result[] = sprintf($msg, $data[0]);
                    }
                    break;
                // проверка логина только латиница, цифры, дефис и нижнее подчеркивание
                case 'login':
                    $msg = !empty($data[0]) ? __($data[0]) : __('FORM_LOGIN_TYPE_VALIDATION_TEXT');
                    if (!preg_match('/^[a-z\d_-]+$/i', $value)) {
                        $result[] = $msg;
                    }
                    break;
                // толко латиница и цифры без пробелов и прочего (для проверка хеша например)
                case 'alphanum':
                    $msg = !empty($data[0]) ? __($data[0]) : __('FORM_ERROR');
                    if (!preg_match('/^[a-z\d]+$/i', $value)) {
                        $result[] = $msg;
                    }
                    break;
                // все доступные буквы латиница и кирилица
                case 'fio':
                    $msg = !empty($data[0]) ? __($data[0]) : __('FORM_FIO_TYPE_VALIDATION_TEXT');
                    if (!preg_match('/^[\sa-z'.$this->cyrillicSings.']+$/i', $value)) {
                        $result[] = $msg;
                    }
                    break;
                // когда нужно совпадение по указаному значению в другом поле (например для паролей)
                case 'identical':
                    $msg = !empty($data[1]) ? __($data[1]) : __('FORM_FIELD_NOT_IDENTICAL');
                    if ($value != $this->currentValues[$data[0]]) {
                        $result[] = $msg;
                    }
                    break;
                // когда значение может быть только одно в указаной таблице
                case 'unique':
                    $msg = !empty($data[1]) ? __($data[1]) : __('FORM_FIELD_NOT_IDENTICAL');
                    if (!$this->isUniqueValidation($value, $data[0])) {
                        $result[] = $msg;
                    }
                    break;
                default:
                    break;
            }
        }

        return !empty($result) ? $result : true;
    }

    public function validateProcess($values, $validationData)
    {
        $this->currentValues = $values;
        $result = array();
        foreach ($validationData as $key => $data) {
            if (isset($values[$key])) {
                $result[$key] = $this->validate($values[$key], $data);
            }
        }
        return $result;
    }

    // fieldParam вида <TABLE>.<FIELD> всегда через точку пример: users.login
    protected function isUniqueValidation($value, $fieldParam)
    {
        list($tmpTable, $tmpField) = explode('.', $fieldParam);
        $sql = "SELECT {$tmpField} FROM `{$tmpTable}` WHERE {$tmpField} = ".\App::getPDO()->quote($value);
        return empty(\App::getPDO()->getOne($sql));
    }
}