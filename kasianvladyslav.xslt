<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head><title>Transakcje</title></head>
      <body>
        <h2>Transakcje w PLN:</h2>
        <table border="1">
          <tr><th>Lp.</th><th>Nazwa transakcji</th><th>Kwota</th></tr>
          <xsl:for-each select="transakcje/transakcja[waluta='PLN']">
            <tr>
              <td><xsl:value-of select="lp"/></td>
              <td><xsl:value-of select="nazwa"/></td>
              <td><xsl:value-of select="kwota"/></td>
            </tr>
          </xsl:for-each>
          <tr>
            <td colspan="2">SUMA</td>
            <td>
              <xsl:value-of select="format-number(sum(transakcje/transakcja[waluta='PLN']/kwota), '#.00')"/>
            </td>
          </tr>
        </table>

        <h2>Transakcje w EUR:</h2>
        <table border="1">
          <tr><th>Lp.</th><th>Nazwa transakcji</th><th>Ilość</th></tr>
          <xsl:for-each select="distinct-values(transakcje/transakcja[waluta='EUR']/nazwa)">
            <xsl:variable name="nazwa" select="."/>
            <tr>
              <td><xsl:number value="position()"/></td>
              <td><xsl:value-of select="$nazwa"/></td>
              <td><xsl:value-of select="count(/transakcje/transakcja[waluta='EUR' and nazwa=$nazwa])"/></td>
            </tr>
          </xsl:for-each>
          <tr>
            <td colspan="2">SUMA</td>
            <td><xsl:value-of select="count(/transakcje/transakcja[waluta='EUR'])"/></td>
          </tr>
        </table>

        <h2>Ilość transakcji wykonanych przez osoby:</h2>
        <table border="1">
          <tr><th>Lp.</th><th>Wykonawca</th><th>Ilość transakcji</th></tr>
          <xsl:for-each select="distinct-values(transakcje/transakcja/wykonal)">
            <xsl:sort/>
            <xsl:variable name="person" select="."/>
            <tr>
              <td><xsl:number value="position()"/></td>
              <td><xsl:value-of select="$person"/></td>
              <td><xsl:value-of select="count(/transakcje/transakcja[wykonal=$person])"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
