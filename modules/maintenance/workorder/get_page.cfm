<!---<cfthrow message="#url.id#">--->
<cfparam name="url.id" default=""> 
<cfparam name="url.other" default="false"> 
<cfparam name="url.material" default="false"> 

<cfif IsDefined("url.filter")>
	<cfset request.filter = url.filter/>
</cfif>
<cfquery name="qWS">
	SELECT Status, WorkClassId, Status2, DepartmentId
  FROM work_order
  WHERE WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

<cfset page = "view_workorder"/>

<cfif qWS.Status NEQ "Open" AND qWS.WorkClassId EQ 12>
	<cfset page="view_workorder" />
</cfif>

<cfif qWS.Status EQ "Close" OR url.other EQ "true">
	<cfset page="view_workorder" />
</cfif>

<cfif qWS.WorkClassId EQ 12 AND listFindNoCase("Sent to Warehouse,Sent to Manager,Rejected by Manager", qWS.Status2) >
	<cfset page = "ms_view_wo"/>
</cfif>

<cfif qWS.Status EQ "Open" AND qWS.DepartmentId EQ request.userinfo.departmentId AND qWS.WorkClassId NEQ 12>
	<cfset page = "save_workorder"/>
</cfif>

<cfinclude template="#page#.cfm" />