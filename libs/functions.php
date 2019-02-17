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