<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
  <xsl:template match="/previsions">
  <html>
    <head>
      <style>
        h1 {
          color: red;
          text-align : center;
        }
        h2 {
          color: blue;
        }
        p {
          font-size: 14px;
          line-height: 1.5;
        }
        .temperature {
          font-weight: bold;
        }
      </style>
    </head>
  <body>
    <h1>Météo pour aujourd'hui</h1>
    <xsl:apply-templates select="./echeance[@hour=114 or @hour=120 or @hour=126]"/>
  </body>
</html>
  </xsl:template>

  <xsl:template match="echeance[@hour=114 or @hour=120 or @hour=126]">
    <xsl:if test="@hour='114'">
      <h2> Matin</h2>
    </xsl:if>
    <xsl:if test="@hour='120'">
      <h2>Midi</h2>
    </xsl:if>
    <xsl:if test="@hour='126'">
        <h2>Soir</h2>
    </xsl:if>
      
    <p>
      <strong>Date 🗓️ : </strong>
      <xsl:value-of select="substring(@timestamp, 1, 10)"/>
    </p>
    <p>
      <strong>Heure ⏱️: </strong>
      <xsl:value-of select="substring(@timestamp, 12, 8)"/>
    </p>
    <p><strong>Température 🌡️: </strong><span class="temperature"><xsl:value-of select="concat(round(number(temperature/level[@val='2m'])-273.15) , '°C')"/></span></p>   
    <p><strong>Humidité : </strong><xsl:value-of select="humidite/level[@val='2m']"/>%</p>
    <p><strong>Vent moyen 🍃: </strong><xsl:value-of select="vent_moyen/level[@val='10m']"/>km/h</p>
    <p><strong>Pluie ☔: </strong><xsl:value-of select="pluie"/>mm</p>
    <p><strong>Pluie convective 🌧️: </strong><xsl:value-of select="pluie_convective"/> mm</p>
  </xsl:template>
</xsl:stylesheet>