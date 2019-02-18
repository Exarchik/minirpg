<?php

class Validator
{
    protected $allowedTypes = array('required', 'min', 'max', 'login', 'fio');

    protected $cyrillicSings = 'абвгдеёжзийклмнопрстуфхцчшщьъыэюяіїґАБВГДЕЁЖЗИЙКЛМНОПРАСТУФХЦЧШЩЬЪЫЭЮЯІЇҐ';

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
                case 'required':
                    $msg = !empty($data[0]) ? $data[0] : __('FORM_REQUIRED_FIELD');
                    if (empty($value)) {
                        $result[] = $msg;
                    }
                    break;
                case 'min':
                    $msg = !empty($data[1]) ? $data[1] : __('FORM_MIN_FIELD_LONG');
                    if (mb_strlen($value) < $data[0]) {
                        $result[] = sprintf($msg, $data[0]);
                    }
                    break;
                case 'max':
                    $msg = !empty($data[1]) ? $data[1] : __('FORM_MAX_FIELD_LONG');
                    if (mb_strlen($value) > $data[0]) {
                        $result[] = sprintf($msg, $data[0]);
                    }
                    break;
                case 'login':
                    $msg = !empty($data[0]) ? $data[0] : __('FORM_LOGIN_TYPE_VALIDATION_TEXT');
                    if (!preg_match('/^[a-z\d_-]+$/i', $value)) {
                        $result[] = $msg;
                    }
                    break;
                case 'fio':
                    $msg = !empty($data[0]) ? $data[0] : __('FORM_FIO_TYPE_VALIDATION_TEXT');
                    if (!preg_match('/^[\sa-z'.$this->cyrillicSings.']+$/i', $value)) {
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
        $result = array();
        foreach ($validationData as $key => $data) {
            if (isset($values[$key])) {
                $result[$key] = $this->validate($values[$key], $data);
            }
        }
        return $result;
    }
}