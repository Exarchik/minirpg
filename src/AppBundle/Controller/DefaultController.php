<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class DefaultController extends ZFIController
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        #$db = $this->get('zfi.db');
        $params = array();

        $users = $this->get('zfi.users');
        $result = $users->add(['login' => 'empty', 'password' => '34234234']);
        if ($result === true) {
            $this->addMessage(__('ACCOUNT_SUCCESSFULLY_CREATED').'!');
        } else {
            $this->addError($result->getMessage());
        }

        $data = [0,1,2,3,4];

        $params = array_merge($params, array(
            'base_dir' => 'tested information',
            'data' => $data,
        ));

        return $this->render('default.tpl', $params);
    }
}
