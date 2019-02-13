<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        // replace this example code with whatever you need
        $db = $this->get('zfi.db');
        $userData = $db->getAssoc('SELECT * FROM users');

        $someData = range(1, 20);

        return $this->render('default.tpl', array(
            'base_dir' => 'tested information',
            'data' => $someData,
        ));
    }
}
