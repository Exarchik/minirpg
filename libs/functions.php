<?php

function __($ident)
{
    return \App::getLang()->__($ident);
}

function addFenomModifiersAndFunctions($fenom)
{

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

    echo $tpl->fetch($template, $vars);
    exit();
}

// валидация $data по типу
function validateData($data, $type = 'text')
{
    switch ($type) {
        case 'int':
            return intval($data);
            break;
        case 'text':
        default:
            return strip_tags($data);
            break;
    }
}

// проверка на совпадение $data до и после валидации, если идентично TRUE
function isDataValid($data, $type = 'text')
{
    return ($data == validateData($data));
}