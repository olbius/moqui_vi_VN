<#macro encodeText textValue>
    <#assign textValue = (Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(textValue!"", false))!"">
    ${textValue}
</#macro>

<#assign fontArial = "Arial">