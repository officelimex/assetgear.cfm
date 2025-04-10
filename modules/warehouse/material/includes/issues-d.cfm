<cfoutput>
<div style="font-size:20px;font-weight:bold;" align="center">Issues to Operating Unit &mdash; Details</div>
<div align="center">Period Ended: #DateFormat(eDate,'dd. mmmm, yyyy')#</div>
<br/>

<table width="100%" border="0" cellpadding="0" cellSpacing="0" >
  <tr>
    <th width="" style="text-align:center;">TR##</th>
    <th width="" style="text-align:center;">Date</th>
    <th width="" style="text-align:center;">WO. ##</th>
    <th width="">Asset ##</th>
    <th width="" style="text-align:center;">Item Description</th>
    <th width="" align="right">Qty</th>
    <th width="" style="text-align:left;">UM</th>
    <th width="" style="text-align:center;" nowrap="nowrap">Cost N</th>
    <th width="" style="text-align:center;" nowrap="nowrap">Cost $</th>
    </tr>  
  <tr>
    <td colspan="9">&nbsp;</td>
  </tr>
<cfquery name="qD">
  SELECT 
    l.LocationId, l.Name AS LocName
  FROM whs_issue_item wii
  INNER JOIN whs_issue wi ON wi.IssueId = wii.IssueId
  INNER JOIN whs_item i ON i.ItemId = wii.ItemId
  INNER JOIN work_order wo ON wo.WorkOrderId = wi.WorkOrderId
  INNER JOIN asset_location al ON wo.AssetLocationIds = al.AssetLocationId 
  INNER JOIN location l ON l.LocationId = al.LocationId
  WHERE wi.DateIssued BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#sDate#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>  
  GROUP BY l.LocationId, l.Name
  ORDER BY l.Name
</cfquery>    
    <cfset td = tn = 0/>
    <cfloop query="qD">
      <tr>
        <td height="20" valign="middle" colspan="9">EFN: #qD.LocationId# - #uCase(LocName)#</td>
      </tr>
      <cfquery name="qD2">
        SELECT 
          wii.ItemIssueId, wii.Quantity, 
          wi.DateIssued,
          a.AssetId, a.Code AssetCode,
          wo.WorkOrderId,
          i.Description ItemDescription,
          um.Code UMCode,
          SUM(CASE WHEN i.Currency = 'NGN' THEN i.UnitPrice * wii.Quantity ELSE 0 END) AS Total_NGN,
          SUM(CASE WHEN i.Currency = 'USD' THEN i.UnitPrice * wii.Quantity ELSE 0 END) AS Total_USD
        FROM whs_issue_item wii
        INNER JOIN whs_issue wi       ON wi.IssueId = wii.IssueId
        INNER JOIN whs_item i         ON i.ItemId = wii.ItemId
        INNER JOIN um                 ON i.UMId = um.UMId
        INNER JOIN work_order wo      ON wo.WorkOrderId = wi.WorkOrderId
        INNER JOIN asset_location al  ON wo.AssetLocationIds = al.AssetLocationId 
        INNER JOIN asset a            ON a.AssetId = wo.AssetId
        INNER JOIN location l         ON l.LocationId = al.LocationId
        WHERE wi.DateIssued BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#sDate#"/> AND <cfqueryparam cfsqltype="cf_sql_date" value="#eDate#"/>  
          AND l.LocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qD.LocationId#"/>
        GROUP BY i.ItemId
        ORDER BY wi.DateIssued ASC
      </cfquery>
      <cfset td = 0/>
      <cfset tn = 0/>
      <cfloop query="qD2">
        <cfset td = td + qD2.Total_USD/>
        <cfset tn = tn + qD2.Total_NGN/>
        <tr>
          <td height="20" valign="middle">#qD2.ItemIssueId#</td>
          <td valign="middle" nowrap="nowrap">#dateFormat(qD2.DateIssued,'dd-mmm-yy')#</td>
          <td valign="middle">&nbsp;&nbsp;&nbsp;#qD2.WorkOrderId#&nbsp;&nbsp;&nbsp;</td>
          <td valign="middle">#qD2.AssetId#/#qD2.AssetCode#</td>
          <td valign="middle">#left(qD2.ItemDescription,40)#..</td>
          <td valign="middle" align="right">#qD2.Quantity#</td>
          <td valign="middle" align="left">#qD2.UMCode#</td>
          <td valign="middle" align="right">N#numberFormat(qD2.Total_NGN,'9,999.99')#</td>
          <td valign="middle" align="right">#DollarFormat(qD2.Total_USD)#</td>
        </tr>
      </cfloop>
      <tr>
        <td height="29" align="right" valign="middle" colspan="7" class="noline">&nbsp;</td>
        <td align="right" valign="middle" style="border-bottom:white;"><div style="font:15 bold;">N#NumberFormat(tn,'9,999.99')#</div></td>
        <td align="right" valign="middle" style="border-bottom:white;"><div style="font:15 bold;">#DollarFormat(td)#</div></td>
      </tr>
   </cfloop>
  <tr>
    <td height="29" align="right" valign="middle" colspan="8" class="noline">&nbsp;</td>
  </tr>
   
</table>
</cfoutput>