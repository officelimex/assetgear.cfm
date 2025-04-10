<cfoutput>
<!--- <h2 align="center">
  Issues to Operating Unit &mdash; Summary
  <div>#dateformat(form.Date_,'mmmm, yyyy')#</div>
</h2><br /> --->

<div style="font-size:20px;font-weight:bold;" align="center">Issues to Operating Unit &mdash; Summary</div>
<div align="center">Period Ended: #DateFormat(eDate,'dd. mmmm, yyyy')#</div>
<br/>

<table width="100%" border="0" cellpadding="0" cellSpacing="0" >
  <tr>
    <th width="5%" align="left">EFN</th>
    <th width="45%" align="left">Description</th>
    <th width="10%" nowarp="nowrap" style="text-align:right;">Item Count</th>
    <th width="20%" style="text-align:right;">Amount (N)</th>
    <th width="20%" style="text-align:right;"> Amount ($)</th>
    </tr>  
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
<cfquery name="qD">
  SELECT 
    l.LocationId, l.Name AS LocName,
    SUM(CASE WHEN i.Currency = 'NGN' THEN i.UnitPrice * wii.Quantity ELSE 0 END) AS Total_NGN,
    SUM(CASE WHEN i.Currency = 'USD' THEN i.UnitPrice * wii.Quantity ELSE 0 END) AS Total_USD,
    COUNT(*) AS TotalIssuedCount
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
        <td height="27" valign="middle">#qD.LocationId#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td valign="middle">#uCase(LocName)#</td>
        <td align="right" valign="middle">#TotalIssuedCount#</td>
        <td align="right" valign="middle">N #NumberFormat(qD.Total_NGN,'9,999.99')#</td>
        <td align="right" valign="middle"> 
          #DollarFormat(qD.Total_USD)#
            <cfset td = td + qD.Total_USD/>
            <cfset tn = tn + qD.Total_NGN/>
        </td>
      </tr>
   </cfloop>
  <tr>
    <td height="29" align="right" valign="middle" colspan="3" class="noline">&nbsp;</td>
    <td align="right" valign="middle"><div style="font:15 bold;">N#NumberFormat(tn,'9,999.99')#</div></td>
    <td align="right" valign="middle"><div style="font:15 bold;">#DollarFormat(td)#</div></td>
  </tr>
   
</table>
</cfoutput>