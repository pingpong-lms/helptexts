<?php

header('Content-type: application/json');
if(!empty($errors)) {
    $response['errors'] = $errors;
}
echo json_encode($response, JSON_NUMERIC_CHECK);  

?>