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
        $db = $this->get('zfi.db');
        /*
        $sql = 'SELECT password, login, id, username FROM users';
        print_r([
            $db->getAll($sql),
            $db->getRow($sql),
            $db->getCol($sql),
            $db->getAssoc($sql),
            $db->getOne($sql),
        ]);
        */

        $userData = ['tst' => 'data', 'tst2' => 'data2'];

        return $this->render('default.tpl', array(
            'base_dir' => 'tested information',
            'data' => $userData,
        ));
    }
}
