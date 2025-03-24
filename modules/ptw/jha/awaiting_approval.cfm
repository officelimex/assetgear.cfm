<cfoutput>

<!--- for frequency as category {url.cid}--->
<cfparam name="url.cid" default=""/>

<cfset JSId = '__jha_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
<cfset comW = "110"/>
<cfset dept = request.userInfo.DepartmentId/>
<cfset status ="-"/>
<cfif request.IsSV>
	<cfset status = "Sent to Supervisor"/>
</cfif>
<cfif request.IsHSE>
	<cfset status = "Sent to HSE"/>
	<cfset dept = "0"/>
	<cfset comW = "80"/>
</cfif>

<g:Grid renderTo="#JSId#_awaiting_approval" url="modules/ajax/ptw.cfm?cmd=getJHAByUsers&status=#status#&d=#dept#" commandWidth="#comW#px" class="table-hover" firstsortOrder="DESC">
    <g:Columns>
			<g:Column id="JHAId" caption="##" field="j.JHAId" sortable searchable /> 
			<g:Column id="WorkDescription" caption="Job Description" field="wo.Description" searchable />
			<g:Column id="Equipment" caption="EquipmentToUse" />
			<g:Column id="Date" nowrap/>
			<g:Column id="PreparedBy" caption="Prepared by" nowrap/>
			<g:Column id="ReviewedBy" hide/>
			<g:Column id="StatusDescription" caption="Status"/>
			<g:Column id="Status" hide/>
			<g:Column id="DepartmentId" hide/>
		</g:Columns>
    <g:Commands>
			<g:Command id="viewJHA" icon="file" help="View JHA"/>
			<g:Command id="PrintJHA" icon="print" help="Print JHA"/> 
    </g:Commands>
    
		<g:Event command="viewJHA">
    	<g:Window title="'JHA ## '+d[0]" width="1050px" height="430px" url="'modules/ptw/jha/view_jha.cfm?cid=#url.cid#'" id="view_jha"/>  
    </g:Event>
    
		<g:Event command="PrintJHA">
    	<g:Window title="'JHA ## ' + d[1]" IsNewWindow  url="'modules/ptw/jha/print_jha.cfm?cid=#url.cid#'" />
    </g:Event>  
</g:Grid> 
 
</cfoutput>
