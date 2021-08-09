# frozen_string_literal: true

module PrettyHTML
  HTML_XSL = <<~XSL
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
    <xsl:copy-of select="."/>
    </xsl:template>
    </xsl:stylesheet>
  XSL

  def pretty_html(html)
    doc = Nokogiri::XML(html)
    Nokogiri::XSLT(HTML_XSL)
            .transform(doc)
            .to_s
            .gsub('<?xml version="1.0" encoding="UTF-8"?>', '')
            .strip
  end
end
