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
<#assign currencyFormat = currencyFormat!"#,##0.00;(#,##0.00)">

<#macro showClass classInfo depth>
    <#assign hasChildren = classInfo.childrenList?has_content>

    <#if depth == 1><tr class="text-info" style="border-bottom:solid black;border-top:solid black;">
            <td style="padding-left: ${(depth-1)}em!important;"><strong>${ec.l10n.localize(classInfo.name)}</strong></td>
            <td class="text-right text-mono"><strong>${classInfo.code}</strong></td>
            <td class="text-right text-mono"><strong><#if classInfo.demonstration??>${classInfo.demonstration}</#if></strong></td>
            <#assign currentAmt = classInfo.value!0>
            <#assign previousCurrentAmt = classInfo.previousValue!0>
            <td class="text-right text-mono" <#if (currentAmt < 0)> style="color:red!important;"</#if>><strong>${ec.l10n.format(currentAmt, currencyFormat)}</strong><#if (currentAmt >= 0)>&nbsp;</#if></td>
            <td class="text-right text-mono" <#if (previousCurrentAmt < 0)> style="color:red!important;"</#if>><strong>${ec.l10n.format(previousCurrentAmt, currencyFormat)}</strong><#if (previousCurrentAmt >= 0)>&nbsp;</#if></td>
        </tr>
    <#else>
        <tr>
            <td style="padding-left: ${(depth-1)}em!important;">${ec.l10n.localize(classInfo.name)}</td>
            <td class="text-right text-mono">${classInfo.code}</td>
            <td class="text-right text-mono"><#if classInfo.demonstration??>${classInfo.demonstration}</#if></td>
            <#assign valueAmount = classInfo.value!0>
            <#assign previousCurrentAmt = classInfo.previousValue!0>
            <td class="text-right text-mono"<#if (valueAmount < 0)> style="color:red!important;"</#if>><#if valueAmount != 0>${ec.l10n.format(valueAmount, currencyFormat)}<#if (valueAmount >= 0)>&nbsp;</#if><#else>&nbsp;</#if></td>
            <td class="text-right text-mono"<#if (previousCurrentAmt < 0)> style="color:red!important;"</#if>><#if previousCurrentAmt != 0>${ec.l10n.format(previousCurrentAmt, currencyFormat)}<#if (previousCurrentAmt >= 0)>&nbsp;</#if><#else>&nbsp;</#if></td>
        </tr>
        </#if>
    <#if hasChildren>
        <#list classInfo.childrenList as childrenInfo>
            <#if !showDetail && depth &gt;1><#return/></#if>
            <@showClass childrenInfo depth + 1/>
        </#list>
    </#if>
</#macro>

<div<#if sri.getRenderMode() == 'qvt'> class="q-table__container q-table__card q-table--horizontal-separator q-table--dense q-table--flat"</#if>>
    <table class="<#if sri.getRenderMode() == 'qvt'>q-table<#else>table table-striped table-hover table-condensed</#if>">
        <thead>
            <tr>
                <th>${organizationName!""} - ${ec.l10n.localize("Balance Sheet")} <small>(${ec.l10n.format(ec.user.nowTimestamp, 'dd MMM yyyy HH:mm')})</small></th>
                <th class="text-right">${ec.l10n.localize("Number Code")}</th>
                <th class="text-right">${ec.l10n.localize("Demonstration")}</th>
                <th class="text-right">${timePeriod.periodName}</th>
                <th class="text-right">${previousTimePeriod.periodName}</th>
            </tr>
        </thead>
        <tbody>
            <#if resultList??><@showClass resultList[0] 1/></#if>
            <#if resultList??><@showClass resultList[1] 1/></#if>
        </tbody>
    </table>
</div>
