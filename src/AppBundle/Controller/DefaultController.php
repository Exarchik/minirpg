<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

require MAIN_LIBS.'/data/Users.php';
use Users;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        $db = $this->get('zfi.db');

        $users = new Users();

        print_r([$users->getData(1), $users]);

        $userData = ['tst' => 'data', 'tst2' => 'data2'];

        return $this->render('default.tpl', array(
            'base_dir' => 'tested information',
            'data' => $userData,
        ));
    }
}
