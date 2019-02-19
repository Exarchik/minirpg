<?php

namespace ZFI;

class RefferalHash
{
    public static function getHashData($hash)
    {
        $db = \App::getPDO();
        $sql = "SELECT type, id FROM refferal_hash WHERE is_active = 1 AND hash = ".$db->quote($hash);
        return $db->getRow($sql);
    }

    public static function checkHashRegister($hash)
    {
        $errors = array();

        $validator = new \Validator();
        // хэш должен содержать только латиницу и цифры
        $hash = $validator->validate($hash, 'alphanum') ? $hash : false;

        if (is_null($hash) || empty($hash)) {
            return __('REF_LINK_REGISTER_ONLY_BY');
        }

        $hash = self::getHashData($hash);
        if (!isset($hash) || empty($hash) || $hash['type'] != 'register') {
            return __('REF_LINK_NOT_AVAILABLE');
        }
        return $errors;
    }

    // "убиваем" реферальный хэш и указываем ИД юзера который им воспользовался
    public static function killHash($hash, $userId = null)
    {
        $validator = new \Validator();
        // хэш должен содержать только латиницу и цифры
        $hash = $validator->validate($hash, 'alphanum') ? $hash : false;

        if (!$hash) {
            return false;
        }

        // пречем хеш
        $sqlValues = array("is_active = 0");
        // и указываем ИД юзера, если есть
        if (!is_null($userId)) {
            $sqlValues[] = "id_user = {$userId}";
        }

        $sql = "UPDATE `refferal_hash` SET ".join(', ', $sqlValues)." WHERE hash = ".\App::getPDO()->quote($hash);
        \App::getPDO()->query($sql);
        return true;
    }
}