<?php
require "DatabasePDO.php";



$response = array();
$errors = array();
http_response_code(400);


$db = new DatabasePDO('../helptexts.ini');

?>