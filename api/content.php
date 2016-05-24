<?php
include_once('../handler/ContentHandler.php');


if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $pageId = $action[1];
    $lang = $action[2];
    $version = $action[3];

    

    $content = ContentHandler::getContent($pageId, $lang, $version);
    if(empty($content)) {
        $errors[] = "No content found. PageId: $pageId, lang: $lang, version: $version";
    } else {
        http_response_code(200);
        $response['content'] = $content;
        $response['availableVersions'] = ContentHandler::getAvailableVersions($pageId, $lang);
    }



    

    
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
