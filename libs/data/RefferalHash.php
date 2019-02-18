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
        if (is_null($hash) || empty($hash)) {
            return __('REF_LINK_REGISTER_ONLY_BY');
        }

        $hash = self::getHashData($hash);
        if (!isset($hash) || empty($hash) || $hash['type'] != 'register') {
            return __('REF_LINK_NOT_AVAILABLE');
        }
        return $errors;
    }

    public static function killHash($hash)
    {
        
    }
}