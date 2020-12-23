<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Response;

// специальный файл контроллер - прокладка
class ZFIController extends Controller
{
    protected $params = array(
        'errors' => array(),
        'messages' => array(),
        'invalid_feedback' => array(),
    );
    
    // добавляет ошибку в layout
    public function addInvalidFeedback($msgs)
    {
        $msgs = is_array($msgs) ? $msgs : array($msgs);
        $this->params['invalid_feedback'] = array_merge($this->params['invalid_feedback'], $msgs);
    }

    // добавляет ошибку в layout
    public function addError($msgs)
    {
        $msgs = is_array($msgs) ? $msgs : array($msgs);
        $this->params['errors'] = array_merge($this->params['errors'], $msgs);
    }

    // добавляет сообщение в layout
    public function addMessage($msgs)
    {
        $msgs = is_array($msgs) ? $msgs : array($msgs);
        $this->params['messages'] = array_merge($this->params['messages'], $msgs);
    }

    // измененный рендер
    public function render($template, array $params = array(), Response $response = null)
    {
        $invalidFeedback = empty($this->params['invalid_feedback']) ? "false" : json_encode($this->params['invalid_feedback']);
        $this->params['invalid_feedback'] = "var invalidFeedback = {$invalidFeedback};";
        $params = array_merge($params, array('layout' => $this->params));

        return parent::render($template, $params, $response);
    }

    protected function addSpecificValidData($formAlias)
    {
        return false;
    }

    protected function getValidationData($formAlias)
    {
        if (!isset($this->validationData[$formAlias])) {
            // нет данных для валидации
            return false;
        }
        
        $this->addSpecificValidData($formAlias);

        return $this->validationData[$formAlias];
    }

    // своя функция валидации
    // formAlias -> <bundle>.<controller>.<action>  // app.main.login
    protected function validate($request, $formAlias = null, $formValidParams = null)
    {
        if (!$request->isMethod('post')) {
            return true;
        }

        // если форм алиас нет -- создаем из данных экшна
        $formAlias = !is_null($formAlias) ? $formAlias : $this->actionToActionAlias($request->attributes->get('_controller'));

        // обязательно наличие массива $this->validationData
        $valiData = $this->getValidationData($formAlias);
        if ($valiData === false) {
            return true; // валидация не нужна получается?
        }

        $validator = new \Validator();
        $errorsData = $validator->validateProcess($request->request->all(), $valiData);
        if ($request->isXmlHttpRequest()) {
            return $this->json($errorsData);
        }

        // если обычный post генерим массив с ошибками и продолжаем работу
        if ($errorsData !== true) {
            $this->addInvalidFeedback($errorsData);
        }
        return $errorsData;
    }

    // конвертирует AppBundle\Controller\MainController::loginAction в app.main.login
    public function actionToActionAlias($actionPath)
    {
        list($bundle, ,$controller) = explode('\\', $actionPath);
        list($controller, $action) = explode('::', $controller);

        $bundle = str_replace('bundle', '', strtolower($bundle));
        $controller = str_replace('controller', '', strtolower($controller));
        $action = str_replace('action', '', strtolower($action));

        return "{$bundle}.{$controller}.{$action}";
    }

    public function isJsonResponse($obj)
    {
        if (strstr(get_class($obj), 'JsonResponse') !== false) {
            return true;
        }
        return false;
    }
}