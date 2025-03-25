<?php

class Language
{
    public $data = null;

    protected $langDefault = 'en';

    protected $langList = [
        'en' => 'English',
        'ua' => 'Українська',
        'ru' => 'Русский',
    ];

    public function __construct($db, $langDefault = 'en')
    {
        $this->setDefaultLang($langDefault);

        $sql = "SELECT ident, value->>'$." . $this->langDefault . "'
                FROM `lang_data`
                ORDER BY CHAR_LENGTH(ident) DESC, ident ASC";
        $this->data = $db->getAssoc($sql);
    }

    public function __($ident)
    {
        return isset($ident) && !empty($ident) && isset($this->data[$ident]) ? $this->data[$ident] : $ident;
    }

    public function setDefaultLang($lang)
    {
        if (in_array($lang, $this->getLanguageListIdents())) {
            $this->langDefault = $lang;
            \App::getSession()['language'] = $lang;
            return true;
        }
        return false;
    }

    public function getLanguageList()
    {
        return $this->langList;
    }

    public function getLanguageListIdents()
    {
        return array_keys($this->getLanguageList());
    }
}