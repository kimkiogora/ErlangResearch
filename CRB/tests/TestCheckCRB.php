<?php
require_once "Utils.php";

echo "\n\n";
$url = 'http://localhost:9002/check?contact=254711240985';
$resp = send_post_request( $url, NULL,'GET');
$resp = json_encode($resp,JSON_PRETTY_PRINT);
print_r($resp);

echo "\n\n\n";
