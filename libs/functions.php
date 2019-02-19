<?php

function __($ident)
{
    return \App::getLang()->__($ident);
}

function addFenomModifiersAndFunctions($fenom)
{

}

// пока не знаю как использовать в Феноме флеш-сообщения, буду юзать этот метод
function __flash()
{
    $flashMessages = \App::getSession()['_symfony_flashes'];
    // удаляем сообщения из сессии, непонятно почему они скапливаются
    \App::getSession()['_symfony_flashes'] = [];
    $flashMessages['notice'] = isset($flashMessages['notice']) ? $flashMessages['notice'] : [];
    $flashMessages['error'] = isset($flashMessages['error']) ? $flashMessages['error'] : [];
    return $flashMessages;
}

function getTemplateHandle(string $tplPath = MAIN_TEMPLATES)
{
    $fenom = Fenom\Extra::factory($tplPath, "/tmp/", array('disable_cache' => true));
    
    addFenomModifiersAndFunctions($fenom);

    return $fenom;
} // end getTemplateHandle

function basicDisplay($content, $template = false, $vars = array())
{    
    if (!$template) {
        $template = 'main.tpl';
    }

    $tpl = getTemplateHandle();
    
    $vars['content'] = $content;
    $vars['user'] = \App::getUsers();
    $vars['current_language'] = \App::getConfig()->getCurrentLang();
    $vars['lang_selector'] = \App::getLang()->getLanguageList();

    echo $tpl->fetch($template, $vars);
    exit();
}

function textToIdent($text)
{
    $text = str_replace(array(' ','-'), '_', trim($text));
    return mb_strtoupper($text);
}