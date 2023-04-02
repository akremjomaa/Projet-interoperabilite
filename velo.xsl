<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/root">
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;
</xsl:text>
<html lang="en">
<head>
	<base target="_top"/>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	
	<title>À bicyclette</title>
	
	<link rel="shortcut icon" type="image/x-icon" href="docs/images/favicon.ico" />

    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI=" crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js" integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM=" crossorigin=""><xsl:text> </xsl:text></script>

	<style>
		html, body {
			height: 100%;
			margin: 0;
		}
		.leaflet-container {
			height: 500px;
			
		}
		#map { height: 600px; 
			height: 400px;
		}
		#meteo, #bicyclette, #sources {
			margin-top: 3%;
			padding: 5%;
			padding-top: 2%;
			border: 1px solid black;
			border-radius: 10px;
		}
	</style>
</head>
<body>
	<div id="meteo">
    $meteo$
</div>
	<div id="bicyclette">
	<h2>Les stations de velos sur Nancy</h2>	
<div id="map"></div>
</div>
<div id="sources">
	Sources: <br></br> 
	<a href="http://api.ipstack.com">Geolocalisation</a><br></br>
	<a href="https://www.infoclimat.fr/public-api/gfs/xml">Meteo</a><br></br>
	<a href="https://api.jcdecaux.com/vls/v3/stations">Velos</a>
  </div>
  <script type="text/javascript">

	window.map = L.map('map').setView([$lat$, $lon$], 18);

	const tiles = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
		maxZoom: 15,
		attribution: 'Map data © <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
	}).addTo(map);

	const circle = L.circle([$lat$, $lon$], {
		color: 'red',
		fillColor: '#f03',
		fillOpacity: 0.5,
		radius: 25
	}).addTo(map).bindPopup('Vous êtes ici !'); 


	const popup = L.popup()

	function onMapClick(e) {
        let str = `Vous avez cliqué sur la carte en position ${e.latlng.toString()}`;
        let a = str.substr(0, 33);
        let b = str.substr(39);
		popup
			.setLatLng(e.latlng)
			.setContent(a+b)
			.openOn(map);
	}

	map.on('click', onMapClick);
</script>
<xsl:text>    </xsl:text><ul>
            <xsl:apply-templates select="./station"/>
<xsl:text>    </xsl:text></ul>

  <xsl:text>
</xsl:text>
</body>
</html>
</xsl:template>

<xsl:template match="station">
        <xsl:text>
</xsl:text>

<script type="text/javascript">
const marker<xsl:value-of select="number"/> = L.marker([<xsl:value-of select="position/latitude"/>, <xsl:value-of select="position/longitude"/>]).addTo(map)
    .bindPopup('<strong><xsl:value-of select="name"/></strong><br/>'
	+ 'Adresse : <xsl:value-of select= "address"/><br/>'
	+ 'Les vélos disponibles <xsl:value-of select="mainStands/availabilities/bikes"/><br />'
	+ 'Supports à vélos disponibles: <xsl:value-of select="mainStands/availabilities/stands" /><br />'
	+ 'Statut: <xsl:value-of select="status" /><br />'
	+ 'Nom du contrat: <xsl:value-of select="contractName" /><br />'
	+ 'Dernière mise à jour: <xsl:value-of select="lastUpdate" />'

	).openPopup(); 
</script>
</xsl:template>

</xsl:stylesheet>
