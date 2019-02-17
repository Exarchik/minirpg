<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

use ZFI\Users;

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
        $result = $users->add(['login' => 'empty', 'password' => '']);
        if ($result === true) {
            print_r(['Учетка создана успешно!']);
        } else {
            print_r([$result->getMessage()]);
        }

        $data = [0,1,2,3,4];

        return $this->render('default.tpl', array(
            'base_dir' => 'tested information',
            'data' => $data,
        ));
    }
}
