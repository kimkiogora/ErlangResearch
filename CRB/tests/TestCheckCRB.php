<?php
require_once "Utils.php";

#TestCase 1: Max Deposit per Transaction 
echo "\n\n";
//254707188026 |  24633429 
$data_string = json_encode($payload, JSON_PRETTY_PRINT);
#die("$data_string\n\n");
$url = 'http://localhost:9002/check?msisdn=254711240985';
$resp = send_post_request( $url, $data_string,'GET');
$resp = json_encode($resp,JSON_PRETTY_PRINT);
print_r($resp);

echo "\n\n\n";
