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

<#--
    Data prepared by the mantle.account.PaymentServices.get#PaymentCheckInfo service, such as:

    <set field="paymentIdList" from="paymentIds instanceof List ? paymentIds : paymentIds.split(',') as List"/>
    <service-call name="mantle.account.PaymentServices.get#PaymentCheckInfo" out-map="context"
            in-map="[paymentIdList:paymentIdList]"/>
-->

<#assign fontSize = "10pt">
<#assign dateFormat = dateFormat!"dd MMM yyyy">

<#assign cellPadding = "1pt">
<#assign tableFontSize = tableFontSize!"10pt">

<#include "../EncodeText.macro.ftl">
<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="${fontArial}, sans-serif" font-size="${fontSize}">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter-portrait" page-width="8.5in" page-height="11in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="0in" margin-bottom="0.5in"/>
            <#--<fo:region-before extent="1in"/>--><fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <#list paymentInfoList as paymentInfo>
        <fo:page-sequence master-reference="letter-portrait" initial-page-number="1" force-page-count="no-force">
            <fo:static-content flow-name="xsl-region-after" font-size="8pt">
                <fo:block border-top="thin solid black">
                    <fo:block text-align="center"><#if paymentInfo.payment.paymentRefNum?has_content>${ec.l10n.localize("Check")} #${paymentInfo.payment.paymentRefNum} -- </#if>${ec.l10n.localize("Payment")} #${paymentInfo.payment.paymentId} -- ${ec.l10n.format(paymentInfo.payment.effectiveDate, dateFormat)} -- ${ec.l10n.formatCurrency(paymentInfo.payment.amount, paymentInfo.payment.amountUomId)} -- ${ec.l10n.localize("Page")} <fo:page-number ref-id="mainSequence"/></fo:block>
                </fo:block>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body">
                <fo:block>
                    <fo:block font-size="14pt" text-align="center" margin-bottom="0"><@encodeText (paymentInfo.fromPartyDetail.organizationName!"")/></fo:block>
                    <fo:block font-size="13pt" text-align="center" margin-bottom="0.1in">${ec.l10n.localize("Payment Detail")}</fo:block>

                    <fo:table table-layout="fixed" width="7.5in"><fo:table-body><fo:table-row font-size="10pt">
                        <fo:table-cell padding="0.05in" width="3.5in">
                            <#assign contactInfo = paymentInfo.toBillingContactInfo>
                            <fo:block text-align="left"><@encodeText (paymentInfo.toPartyDetail.partyName!"")/></fo:block>
                            <#if (contactInfo.postalAddress.address1)?has_content><fo:block text-align="left"><@encodeText contactInfo.postalAddress.address1/><#if (contactInfo.postalAddress.unitNumber)?has_content> #${contactInfo.postalAddress.unitNumber}</#if></fo:block></#if>
                            <#if (contactInfo.postalAddress.address2)?has_content><fo:block text-align="left"><@encodeText contactInfo.postalAddress.address2/></fo:block></#if>
                            <#if (contactInfo.postalAddress)?has_content><fo:block text-align="left"><@encodeText (contactInfo.postalAddress.city!"")/><#if (contactInfo.postalAddressStateGeo.geoCodeAlpha2)?has_content>, ${contactInfo.postalAddressStateGeo.geoCodeAlpha2} </#if>${contactInfo.postalAddress.postalCode!}<#if (contactInfo.postalAddress.postalCodeExt)?has_content>-${contactInfo.postalAddress.postalCodeExt}</#if><#if (contactInfo.postalAddressCountryGeo.geoCodeAlpha3)?has_content> ${contactInfo.postalAddressCountryGeo.geoCodeAlpha3}</#if></fo:block></#if>
                            <#if (contactInfo.telecomNumber)?has_content><fo:block text-align="left"><#if (contactInfo.telecomNumber.countryCode)?has_content>${contactInfo.telecomNumber.countryCode}-</#if><#if (contactInfo.telecomNumber.areaCode)?has_content>${contactInfo.telecomNumber.areaCode}-</#if>${contactInfo.telecomNumber.contactNumber!}</fo:block></#if>
                        </fo:table-cell>
                        <fo:table-cell padding="0.05in" width="2in">
                            <#if paymentInfo.payment.paymentRefNum?has_content>
                                <fo:block text-align="left" font-weight="bold">${ec.l10n.localize("Check")} #</fo:block>
                                <fo:block text-align="left">${paymentInfo.payment.paymentRefNum}</fo:block>
                            </#if>
                            <fo:block text-align="left" font-weight="bold">${ec.l10n.localize("Payment Ref")} #</fo:block>
                            <fo:block text-align="left">${paymentInfo.payment.paymentId}</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="0.05in" width="1.5in">
                            <fo:block text-align="left" font-weight="bold">${ec.l10n.localize("Amount")}</fo:block>
                            <fo:block text-align="left">${ec.l10n.formatCurrency(paymentInfo.payment.amount, paymentInfo.payment.amountUomId)}</fo:block>
                            <fo:block text-align="left" font-weight="bold">${ec.l10n.localize("Date")}</fo:block>
                            <fo:block text-align="left">${ec.l10n.format(paymentInfo.payment.effectiveDate, dateFormat)}</fo:block>
                        </fo:table-cell>
                    </fo:table-row></fo:table-body></fo:table>
                    <#if paymentInfo.payment.memo?has_content>
                        <fo:block text-align="left" margin-bottom="0.1in"><@encodeText paymentInfo.payment.memo/></fo:block>
                    </#if>

                    <#if paymentInfo.invoiceList?has_content>
                        <#list paymentInfo.invoiceList as invoice>
                            <#assign invoiceItemList = ec.entity.find("mantle.account.invoice.InvoiceItem").condition("invoiceId", invoice.invoiceId).list()>
                            <#assign invoiceTotals = ec.service.sync().name("mantle.account.InvoiceServices.get#InvoiceTotal").parameter("invoiceId", invoice.invoiceId).call()>
                            <fo:table table-layout="fixed" width="7.5in">
                                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("Our Ref")} #</fo:block></fo:table-cell>
                                    <fo:table-cell width="2.0in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("Your Ref")} #</fo:block></fo:table-cell>
                                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("Invoice Date")}</fo:block></fo:table-cell>
                                    <fo:table-cell width="1.6in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize("Invoice Amount")}</fo:block></fo:table-cell>
                                    <fo:table-cell width="1.6in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize("Amount Paid")}</fo:block></fo:table-cell>
                                </fo:table-header>
                                <fo:table-body>
                                    <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${invoice.invoiceId}</fo:block></fo:table-cell>
                                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"><@encodeText (invoice.referenceNumber!"")/><#if invoice.otherPartyOrderId?has_content> - PO <@encodeText invoice.otherPartyOrderId/></#if></fo:block></fo:table-cell>
                                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.format(invoice.invoiceDate, dateFormat)}</fo:block></fo:table-cell>
                                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(invoiceTotals.invoiceTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(invoice.amountApplied, invoice.currencyUomId)}</fo:block></fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                            <fo:table table-layout="fixed" width="7.5in">
                                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black" border-top="solid black">
                                    <fo:table-cell width="0.3in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("Item")}</fo:block></fo:table-cell>
                                    <fo:table-cell width="3.3in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("Description")}</fo:block></fo:table-cell>
                                    <fo:table-cell width="0.7in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize("Qty")}</fo:block></fo:table-cell>
                                    <fo:table-cell width="1.6in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize("Amount")}</fo:block></fo:table-cell>
                                    <fo:table-cell width="1.6in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize("Total")}</fo:block></fo:table-cell>
                                </fo:table-header>
                                <fo:table-body>
                                    <#list invoiceItemList as invoiceItem>
                                        <#assign itemTypeEnum = invoiceItem.type!>
                                        <fo:table-row font-size="${tableFontSize}">
                                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${invoiceItem.invoiceItemSeqId}</fo:block></fo:table-cell>
                                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"><@encodeText (invoiceItem.description)!(itemTypeEnum.description)!""/></fo:block></fo:table-cell>
                                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right">${invoiceItem.quantity!"1"}</fo:block></fo:table-cell>
                                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(invoiceItem.amount, invoice.currencyUomId, 3)}</fo:block></fo:table-cell>
                                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(((invoiceItem.quantity!1) * (invoiceItem.amount!0)), invoice.currencyUomId, 3)}</fo:block></fo:table-cell>
                                        </fo:table-row>
                                    </#list>
                                </fo:table-body>
                            </fo:table>
                        </#list>
                    </#if>

                    <#if paymentInfo.financialAccountTrans??>
                        <fo:table table-layout="fixed" width="7in">
                            <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                                <fo:table-cell width="1.6in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("Account")} #</fo:block></fo:table-cell>
                                <fo:table-cell width="1.6in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("TX")} #</fo:block></fo:table-cell>
                                <fo:table-cell width="1.6in" padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.localize("TX Date")}</fo:block></fo:table-cell>
                                <fo:table-cell width="2in" padding="${cellPadding}"><fo:block text-align="right">${ec.l10n.localize("TX Amount")}</fo:block></fo:table-cell>
                            </fo:table-header>
                            <fo:table-body>
                                <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${paymentInfo.financialAccount.finAccountCode!paymentInfo.financialAccount.finAccountId}</fo:block></fo:table-cell>
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${paymentInfo.financialAccountTrans.finAccountTransId}</fo:block></fo:table-cell>
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.format(paymentInfo.financialAccountTrans.transactionDate, dateFormat)}</fo:block></fo:table-cell>
                                    <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(paymentInfo.financialAccountTrans.amount, paymentInfo.financialAccount.currencyUomId)}</fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </#if>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </#list>
</fo:root>
