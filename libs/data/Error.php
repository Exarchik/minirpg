<?php

namespace ZFI;

class Error
{
    public $messages = [];

    public function __construct($message = null)
    {
        $this->addMessage($message);
    }

    public function addMessage($message = null)
    {
        if (!is_null($message)) {
            $this->messages[] = $message;
        }
    }

    public function hasErrors()
    {
        return count($this->messages) > 0 ? true : false;
    }

    public function getMessage()
    {
        return $this->messages;
    }
}