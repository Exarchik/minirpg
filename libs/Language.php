<?php

class Language
{
    public $data = null;

    public function __construct($db, $langDefault = 'en')
    {
        $sql = "SELECT ident, value->>'$.".$langDefault."'
                FROM `lang_data`
                ORDER BY CHAR_LENGTH(ident) DESC, ident ASC";
        $this->data = $db->getAssoc($sql);
    }

    public function __($ident)
    {
        return isset($ident) && !empty($ident) && isset($this->data[$ident]) ? $this->data[$ident] : $ident;
    }
}