<?php

class Validator
{
    protected $allowedTypes = array('required', 'min', 'max', 'login');

    public function validate($value, $validate)
    {
        $result = [];
        foreach ($validate as $type => $data) {
            $data = is_array($data) ? $data : array($data);
            if (!in_array($type, $this->allowedTypes)) {
                continue;
            }
            switch ($type) {
                case 'required':
                    if (empty($value)) {
                        $result[] = $data[0];
                    }
                    break;
                case 'min':
                    if (strlen($value) < $data[0]) {
                        $result[] = sprintf($data[1], $data[0]);
                    }
                    break;
                case 'max':
                    if (strlen($value) > $data[0]) {
                        $result[] = sprintf($data[1], $data[0]);
                    }
                    break;
                case 'login':
                    if (!preg_match('/^[a-z\d_-]{5,20}$/i',$value)) {
                        $result[] = $data[0];
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