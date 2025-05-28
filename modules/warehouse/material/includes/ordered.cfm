<cfoutput>
<div style="font-size:20px;font-weight:bold;" align="center">Purchase Order Awaiting Receipts</div>
<div align="center">Period Ended: #DateFormat(eDate,'dd. mmmm, yyyy')#</div>
<br/>

<table width="100%" border="0" cellpadding="0" cellSpacing="0" >
  <tr>
    <th width="" style="text-align:center;">TR##</th>
    <th width="" style="text-align:center;">Packing List </th>
    <th width="" style="text-align:center;">ICN/SCN </th>
    <th width="" style="text-align:center;">Item Description</th>
    <th width="" align="right">Qty</th>
    <th width="1px" style="text-align:left;">UM</th>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <cfquery name="qD">
    SELECT 
      *
    FROM whs_po po
    WHERE po.Date BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#sDate#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>  
      AND po.Status = "Open"
  </cfquery>

  <cfset td = tn = 0/>
  <cfloop query="qD">
    <tr>
      <td height="20" valign="middle" colspan="2">PO: #qD.POId# #qD.Ref#</td>
      <td height="20" align="center" valign="middle" colspan="2">Date: #dateFormat(qD.Date,'dd-mmm-yy')#</td>
      <td height="20" valign="middle" colspan="3" align="right">MR: #qD.MRId#</td>
    </tr>
    <cfquery name="qD2">
      SELECT 
        poi.*,
        i.Description ItemDescription, i.Code ItemCode,
        um.Code UMCode
      FROM whs_po_item poi
      INNER JOIN whs_item i ON i.ItemId = poi.ItemId
      INNER JOIN um         ON um.UMId  = i.UMId
      WHERE poi.POId = #qD.POId#
    </cfquery>
    <cfset td = 0/>
    <cfset tn = 0/>
    <cfloop query="qD2">
      <tr>
        <td height="20" valign="middle">#qD2.POItemId#</td>
        <td valign="middle" nowrap="nowrap">#qD2.Ref#.</td>
        <td valign="middle" >#qD2.ItemCode#</td>
        <td valign="middle">#left(qD2.ItemDescription,40)#..</td>
        <td valign="middle" align="right">#qD2.Quantity#</td>
        <td valign="middle" align="left">#qD2.UMCode#</td>
      </tr>
    </cfloop>
    <tr>
      <td height="29" align="right" valign="middle" colspan="7" class="noline">&nbsp;</td>
    </tr>
  </cfloop>
  <tr>
    <td height="29" align="right" valign="middle" colspan="7" class="noline">&nbsp;</td>
  </tr>
</table>
</cfoutput>