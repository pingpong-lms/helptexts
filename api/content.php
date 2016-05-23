<?php

include_once('api-init.php');
include_once('../handler/ContentHandler.php');


if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $response['content'] = ContentHandler::getContent($_GET['pageId'], $_GET['lang'], $_GET['version']);

    $response['availableVersions'] = ContentHandler::getAvailableVersions($_GET['pageId'], $_GET['lang']);

    http_response_code(200);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $obj = new StdClass ();
    foreach ($_POST as $var => $value) {
        $obj -> $var = $value;
    }

    error_log($obj->content);

    if($obj->publish){
        ContentHandler::publishDocument($obj, $_SERVER['REMOTE_USER']);
    } else{
        ContentHandler::saveDocument($obj, $_SERVER['REMOTE_USER']);
    }
}

include_once('api-finish.php');