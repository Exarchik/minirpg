<?php

namespace ZFI;

class Session implements \ArrayAccess
{
    private $sessionData = array();

    public function __construct(&$sessionData)
    {
        $this->sessionData = &$sessionData;
    }

    public function offsetSet($offset, $value)
    {
        if (empty($offset)) {
            throw new Exception('Session need offset');
        }
        else {
            $this->sessionData[$offset] = $value;
        }
    }

    public function offsetExists($offset)
    {
        return isset($this->sessionData[$offset]);
    }

    public function offsetUnset($offset)
    {
        unset($this->sessionData[$offset]);
    }

    public function offsetGet($offset)
    {
        return isset($this->sessionData[$offset]) ? $this->sessionData[$offset] : null;
    }

    public function clear()
    {
        $this->sessionData = array();
    }
}