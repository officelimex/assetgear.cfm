<cfoutput>
	<cfparam name="url.cid" default=""/>

	<cfset PwId = '__permit_c'/>
	<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 

	<cfset did = request.userInfo.DepartmentId/>
	<cfif request.IsHSE OR listFind('#application.department.hse#,#application.department.lpg#,#application.department.operations#',request.userInfo.DepartmentId) >
		<cfset did = 0/>
	</cfif>

	<g:Grid renderTo="#PwId#_unapproved_permit#url.cid#" url="modules/ajax/ptw.cfm?cmd=GetUnApprovedPermit&did=#did#" commandWidth="70px" class="table-hover" firstsortOrder="DESC">
		<g:Columns>
			<g:Column id="PermitId" caption="Permit ##" field="p.PermitId" sortable searchable />
			<g:Column id="JHAId" caption="JHA ##" searchable/> 
			<g:Column id="Work" caption="Work Description" field="wo.Description" searchable />
			<g:Column id="Date"/>
			<g:Column id="EndTime" caption="End Time"/>
			<g:Column id="StatusDescription" caption="Status"/>
			<g:Column id="Status" hide/>
		</g:Columns>
		<g:Commands>
			<g:Command id="editA" icon="edit" help="Edit Permit" condition="row[6]!='Approved'"/>
			<g:Command id="viewB" text="view" help="View Permit" condition="row[6]!='Approved'"/><!--- only for admin an operations ---->
			<g:Command id="Print" icon="print" help="Print Permit"/> 
		</g:Commands>

		<g:Event command="editA">
			<g:Window title="'Permit ##'+d[0]" url="'modules/ptw/permit/save_permit.cfm?cid=#url.cid#'" id="save_permit"/>        	
		</g:Event>

		<g:Event command="viewB">
			<g:Window title="'Permit ##'+d[0]" url="'modules/ptw/permit/pa/view_permit.cfm?cid=#url.cid#'" id="view_permit"/>        	
		</g:Event>   

		<g:Event command="Print">
			<g:Window title="'Print Work Order For ""' + d[1] + '""' " IsNewWindow  url="'modules/ptw/permit/print_permit.cfm?cid=#url.cid#'"/>
		</g:Event>  
	
	</g:Grid> 	
 
</cfoutput>