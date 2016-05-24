<?php
require "../handler/DatabasePDO.php";
$response = array();
$errors = array();
http_response_code(400);

//Init database connection
$db = new DatabasePDO('../helptexts.ini');


// Validate api action
$action = explode("/", $_GET['action']);
$apiFile = "../api/" . $action[0] . ".php";
if(file_exists($apiFile)) {
	include $apiFile;
} else {
	$errors[] = "Not a valid request: " . $action;
}


//Return response as json
header('Content-type: application/json');
if(!empty($errors)) {
    $response['errors'] = $errors;
}
echo json_encode($response, JSON_NUMERIC_CHECK);  
?>