<cfoutput>
  <div style="font-size:20px;font-weight:bold;" align="center">Warehouse Receipts</div>
  <div align="center">Period Ended: #DateFormat(eDate,'dd. mmmm, yyyy')#</div>
  <br/>

  <table width="100%" border="0" cellpadding="0" cellSpacing="0" >
    <tr>
      <th width="" style="text-align:center;">TR##</th>
      <th width="" style="text-align:center;">Date</th>
      <th width="" style="text-align:center;">Reference</th>
      <th width="" style="text-align:center;">Packing List </th>
      <th width="" style="text-align:center;">ICN</th>
      <th width="" style="text-align:center;">Item Description</th>
      <th width="" align="right">Qty</th>
      <th style="text-align:left;">UM</th>
      <th style="text-align:right;">Amt. N</th>
      <th style="text-align:right;">Amt. $</th>
    </tr>
    <tr>
      <td colspan="10">&nbsp;</td>
    </tr>
    <cfquery name="qD">
      SELECT 
        i.Code ItemCode, i.Description ItemDescription,
        SUM(CASE WHEN i.Currency = 'NGN' THEN i.UnitPrice * poi.RQuantity ELSE 0 END) AS Total_NGN,
        SUM(CASE WHEN i.Currency = 'USD' THEN i.UnitPrice * poi.RQuantity ELSE 0 END) AS Total_USD,
        poi.*,
        po.Date, po.Ref PORef,
        um.Code UMCode
      FROM whs_po_item poi
      INNER JOIN whs_po po ON po.POId = poi.POId
      INNER JOIN whs_item i ON i.ItemId = poi.ItemId
      INNER JOIN um         ON um.UMId  = i.UMId
      WHERE po.DateReceived BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#sDate#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>  
        AND po.Status = "Close"
      GROUP BY poi.POItemId
    </cfquery>

    <cfset totalAmtNGN = totalAmtUSD = 0/>
    <cfloop query="qD">
      <tr>
        <td height="20" class="noline" valign="middle">#qD.POId#.#qD.POItemId#</td>
        <td height="20" class="noline" valign="middle">#dateFormat(qD.Date,'dd-mmm-yy')#</td>
        <td height="20" class="noline" valign="middle">#qD.PORef#</td>
        <td height="20" class="noline" align="left" valign="middle" >#qD.Ref#</td>
        <td height="20" class="noline" align="left" valign="middle" >#qD.ItemCode#</td>
        <td height="20" class="noline" align="left" valign="middle" >#qD.ItemDescription#</td>
        <td height="20" class="noline" align="right" valign="middle" >#qD.RQuantity#</td>
        <td height="20" class="noline" align="left" valign="middle" >#qD.UMCode#</td>
        <td height="20" class="noline" align="right" valign="middle" >#NumberFormat(qD.Total_NGN,'9,999.99')#</td>
        <td height="20" class="noline" align="right" valign="middle" >#NumberFormat(qD.Total_USD,'9,999.99')#</td>
      </tr>
      <cfset totalAmtNGN = totalAmtNGN + qD.Total_NGN/>
      <cfset totalAmtUSD = totalAmtUSD + qD.Total_USD/>
    </cfloop>
    <tr>
      <td align="right" valign="middle" colspan="10">&nbsp;</td>
    </tr>
    <tr>
      <td  align="right" valign="middle" colspan="5" class="noline">&nbsp;</td>
      <td height="29" align="right" valign="middle" colspan="5" class="">
        <table width="50%">
          <tr>
            <td width="50px" align="right" valign="middle" class="noline">Total</td>
            <td width="1px" align="left" valign="middle" nowrap="nowrap" class="noline"><b>N#NumberFormat(totalAmtNGN,'9,999.99')#</b></td>
            <td width="10px"  valign="middle" class="noline">&nbsp;</td>
            <td width="50px" align="right" valign="middle" class="noline">Total </td>
            <td width="1px" align="right" nowrap="nowrap" valign="middle" class="noline"><b>$#NumberFormat(totalAmtUSD,'9,999.99')#</b></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfoutput>