<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" doctype-system="about:legacy-compat" encoding="UTF-8"/>

  <!-- Keys -->
  <xsl:key name="pln-po-nazwie" match="Transakcja[Waluta='PLN']" use="Nazwa"/>
  <xsl:key name="eur-po-nazwie" match="Transakcja[Waluta='EUR']" use="Nazwa"/>
  <xsl:key name="wykonawcy" match="Transakcja[Wykonawca != '']" use="Wykonawca"/>

  <!-- Main template -->
  <xsl:template match="/">
    <html>
      <body>
        <!-- PLN Table -->
        <h2>Transakcje w PLN:</h2>
        <table>
          <tr><th>Lp.</th><th>Nazwa transakcji</th><th>Kwota</th></tr>
          <xsl:call-template name="pln-transakcje"/>
          <tr>
            <td></td>
            <th>SUMA</th>
            <td>
              <xsl:value-of select="format-number(
                sum(//Transakcja[Waluta='PLN']/Kwota/translate(translate(., ' ', ''), ',', '.')),
                '0.00'
              )"/>
            </td>
          </tr>
        </table>

        <!-- EUR Table -->
        <h2>Transakcje w EUR:</h2>
        <table>
          <tr><th>Lp.</th><th>Nazwa transakcji</th><th>Ilość</th></tr>
          <xsl:call-template name="eur-transakcje"/>
          <tr>
            <td></td>
            <th>SUMA</th>
            <td><xsl:value-of select="count(//Transakcja[Waluta='EUR'])"/></td>
          </tr>
        </table>

        <!-- People Table -->
        <h2>Ilość transakcji wykonanych przez poszczególne osoby:</h2>
        <table>
          <tr><th>Lp.</th><th>Wykonawca</th><th>Ilość transakcji</th></tr>
          <xsl:for-each select="//Transakcja[Wykonawca != ''][generate-id() = generate-id(key('wykonawcy', Wykonawca)[1])]">
            <xsl:sort select="Wykonawca"/>
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="Wykonawca"/></td>
              <td><xsl:value-of select="count(key('wykonawcy', Wykonawca))"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>

  <!-- Templates for grouping -->
  <xsl:template name="pln-transakcje">
    <xsl:for-each select="//Transakcja[Waluta='PLN'][generate-id() = generate-id(key('pln-po-nazwie', Nazwa)[1])]">
      <xsl:sort select="
        (contains(Nazwa, 'wpłata') * 1) + 
        (contains(Nazwa, 'odsetki') * 2) + 
        (contains(Nazwa, 'przelew') * 3) + 
        (contains(Nazwa, 'korekta') * 4)
      "/>
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="Nazwa"/></td>
        <td>
          <xsl:value-of select="format-number(
            sum(key('pln-po-nazwie', Nazwa)/Kwota/translate(translate(., ' ', ''), ',', '.')),
            '0.00'
          )"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="eur-transakcje">
    <xsl:for-each select="//Transakcja[Waluta='EUR'][generate-id() = generate-id(key('eur-po-nazwie', Nazwa)[1])]">
      <xsl:sort select="
        (contains(Nazwa, 'wpłata') * 1) + 
        (contains(Nazwa, 'odsetki') * 2) + 
        (contains(Nazwa, 'przelew') * 3) + 
        (contains(Nazwa, 'korekta') * 4)
      "/>
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="Nazwa"/></td>
        <td><xsl:value-of select="count(key('eur-po-nazwie', Nazwa))"/></td>
      </tr>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>