<?php 

$opts = array(
    'http' => array('proxy' => 'tcp://www-cache:3128', 'request_fulluri' => true), 
    'ssl' => array('verify_peer' => false, 'verify_peer_name' => false)
);

$context = stream_context_create($opts);
$access_key = 'b18ac1c07d9a3bcbb57bef9e38c76a69';
$ip = $_SERVER['REMOTE_ADDR'];
$ipData = file_get_contents('http://api.ipstack.com/'.$ip.'/?access_key='.$access_key.'&output=xml', NULL, $context);
$gps = simplexml_load_string($ipData);

$meteoKey = "ARsDFFIsBCZRfFtsD3lSe1Q8ADUPeVRzBHgFZgtuAH1UMQNgUTNcPlU5VClSfVZkUn8AYVxmVW0Eb1I2WylSLgFgA25SNwRuUT1bPw83UnlUeAB9DzFUcwR4BWMLYwBhVCkDb1EzXCBVOFQoUmNWZlJnAH9cfFVsBGRSPVs1UjEBZwNkUjIEYVE6WyYPIFJjVGUAZg9mVD4EbwVhCzMAMFQzA2JRMlw5VThUKFJiVmtSZQBpXGtVbwRlUjVbKVIuARsDFFIsBCZRfFtsD3lSe1QyAD4PZA%3D%3D";


$url_meteo = "https://www.infoclimat.fr/public-api/gfs/xml?_ll={$gps->latitude},{$gps->longitude}&_auth={$meteoKey}&_c=19f3aa7d766b6ba91191c8be71dd1ab2";

$meteoData = file_get_contents($url_meteo, false, $context);


$xmlMeteo = new SimpleXMLElement($meteoData);

$xslMeteo = new DOMDocument();
$xslMeteo->load('meteo.xsl');
$proc = new XSLTProcessor();
$proc->importStylesheet($xslMeteo);

$html_meteo = $proc->transformToXML($xmlMeteo);

$url_velo = 'https://api.jcdecaux.com/vls/v3/stations?apiKey=frifk0jbxfefqqniqez09tw4jvk37wyf823b5j1i&contract=nancy';

$json_velo = json_decode(file_get_contents($url_velo, false, $context), true);

$xml = new SimpleXMLElement('<root/>');
array2xml($json_velo, $xml);
$string = $xml->asXML();

$xsl_velo = new DOMDocument();
$xsl_velo->load('velo.xsl');

$xml_velo = new DOMDocument();
$xml_velo->loadXML($string);

$proc = new XSLTProcessor();
$proc->importStylesheet($xsl_velo);

$html_velo = $proc->transformToXML($xml_velo);

function array2xml($array, $xml) {
    foreach ($array as $key => $value) {
        if(is_int($key)) {
            $key = "station";
        }
        if(is_array($value)) {
            $label = $xml->addChild($key);
            array2xml($value, $label);
        } else {
            $xml->addChild($key, $value);
        }
    }
}

$html_velo = str_replace('$meteo$', $html_meteo, $html_velo);
$html_velo = str_replace('$lat$', $gps->latitude, $html_velo);
$html_velo = str_replace('$lon$', $gps->longitude, $html_velo);

echo $html_velo;
