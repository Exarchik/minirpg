<?php

class Validator
{
    public function validate($value, $validate)
    {
        $result = [];
        foreach ($validate as $type => $data) {
            switch ($type) {
                case 'required':
                    if (empty($value)) {
                        $result[] = $data[0];
                    }
                    break;
                case 'min':
                    if  (strlen($value) < $data[0]) {
                        $result[] = sprintf($data[1], $data[0]);
                    }
                    break;
                case 'max':
                    if  (strlen($value) > $data[0]) {
                        $result[] = sprintf($data[1], $data[0]);
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