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
        $params = array();

        $users = new Users();
        $result = $users->add(['login' => 'empty', 'password' => '34234234']);
        if ($result === true) {
            $params['layout']['messages'] = array(__('ACCOUNT_SUCCESSFULLY_CREATED').'!');
        } else {
            $params['layout']['errors'] = $result->getMessage();
        }

        $data = [0,1,2,3,4];

        $params = array_merge($params, array(
            'base_dir' => 'tested information',
            'data' => $data,
        ));

        return $this->render('default.tpl', $params);
    }
}
