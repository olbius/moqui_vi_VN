<#--
This software is in the public domain under CC0 1.0 Universal plus a Grant of Patent License.

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide. This software is distributed without any
warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software (see the LICENSE.md file). If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.
-->
<#-- See the mantle.ledger.LedgerReportServices.run#BalanceSheet service for data preparation -->
<#assign showDetail = (detail! == "true")>
<#assign currencyFormat = currencyFormat!"#,##0.00;">
<#assign indentChar = indentChar!'    '>
<#macro csvValue textValue>
    <#if textValue?contains(",") || textValue?contains("\"")><#assign useQuotes = true><#else><#assign useQuotes = false></#if>
    <#t><#if useQuotes>"</#if>${textValue?replace("\"", "\"\"")}<#if useQuotes>"</#if>
</#macro>
<#macro showClass classInfo depth>
    <#assign hasChildren = classInfo.childrenList?has_content>
    <#assign classDesc><#list 1..depth as idx>${indentChar}</#list> ${ec.l10n.localize(classInfo.name)}</#assign>
    <#t><@csvValue classDesc/>,
    <#t><@csvValue classInfo.code/>,
    <#t><@csvValue classInfo.demonstration!""/>,
    <#assign currentAmt = classInfo.value!0>
    <#assign previousCurrentAmt = classInfo.previousValue!0>
    <#t><@csvValue ec.l10n.format(currentAmt, currencyFormat)/>,
    <#t><@csvValue ec.l10n.format(previousCurrentAmt, currencyFormat)/>
    <#t>${"\n"}
    <#t><#if hasChildren><#list classInfo.childrenList as childrenInfo><#if !showDetail && depth &gt;1><#return/></#if><@showClass childrenInfo depth + 1/></#list></#if>
</#macro>
<#t><@csvValue organizationName!""/> - ${ec.l10n.localize("Balance Sheet")} (${ec.l10n.format(ec.user.nowTimestamp, 'dd MMM yyyy HH:mm')}),
<#t>${ec.l10n.localize("Number Code")},${ec.l10n.localize("Demonstration")},
<#t><@csvValue previousTimePeriod.periodName/>,
<#t><@csvValue timePeriod.periodName/>
<#t>${"\n"}
<#t><#if resultList??><@showClass resultList[0] 1/></#if>
<#t><#if resultList??><@showClass resultList[1] 1/></#if>
