<?php

class Users
{
    public $id;

    public $data;

    public function getData(int $id)
    {
        $this->data = App::getPDO()->getAssoc("SELECT id, login, password, username, is_active, role_id FROM users WHERE id = {$id}");
        return !empty($this->data) ? $this->data : false;
    }
}