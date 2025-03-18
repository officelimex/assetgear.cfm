<cfparam name="url.month" default="">
<cfparam name="url.year" default="">
<cfoutput>
  <cfquery name="getCountDueItems" cachedWithin="#createTime(0,0,0)#">
    SELECT 

      cdi.ItemId, 
      cdi.SystemQty, 
      cdi.CurrentQty, 
      l.Code ShelfLocation,
      i.Code ItemCode, i.Description

    FROM count_due cd
    INNER JOIN count_due_item cdi ON cd.CountDueId      = cdi.CountDueId
    INNER JOIN whs_item i         ON cdi.ItemId         = i.ItemId
    INNER JOIN shelf_location l   ON l.ShelfLocationId  = i.ShelfLocationId
    WHERE cd.Month = <cfqueryparam value="#url.month#" cfsqltype="cf_sql_integer">
      AND cd.Year = <cfqueryparam value="#url.year#" cfsqltype="cf_sql_integer">
    ORDER BY l.Code, i.Code, i.Description
  </cfquery>
  
  <cfif getCountDueItems.RecordCount EQ 0>
    <tr><td colspan="5">No data found for the selected Month and Year.</td></tr>
  <cfelse>
    <cfloop query="getCountDueItems">
      <tr>
        <td>#CurrentRow#</td>
        <td>#ItemCode# - #Description#</td>
        <td>#SystemQty#</td>
        <td>#CurrentQty#</td>
        <td>#ShelfLocation#</td>
      </tr>
    </cfloop>
  </cfif>
</cfoutput>
