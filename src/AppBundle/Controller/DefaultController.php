<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

use Users;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        require MAIN_LIBS.'/data/Users.php';
        #$db = $this->get('zfi.db');

        $users = new Users();
        try {
            $result = $users->add(['login' => 'empty', 'password' => 'parolchik']);
        } catch (Exception $e) {
            print_r([$e->getMessage()]);
        }

        print_r([$result]);

        $data = [0,1,2,3,4];

        return $this->render('default.tpl', array(
            'base_dir' => 'tested information',
            'data' => $data,
        ));
    }
}
