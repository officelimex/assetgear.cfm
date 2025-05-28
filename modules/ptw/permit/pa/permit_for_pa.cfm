<cfoutput>

<cfset PwId = '__permit_c'/>
<cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
<cfset now_ = dateformat(now(),'d-mmm-yyyy')/>

<g:Grid renderTo="#PwId#_permit_for_pa" url="modules/ajax/ptw.cfm?cmd=GetApprovedPermitByFS" commandWidth="160px" class="table-hover" firstsortOrder="DESC">

	<g:Columns>
		<g:Column id="PermitId" caption="Permit ##" field="p.PermitId" sortable searchable/>
		<g:Column id="JHAId" caption="JHA ##" searchable/>   
		<g:Column id="Work" caption="WO: Work Description" field="wo.Description" searchable/>
		<g:Column id="PA" caption="Created by"/>
		<g:Column id="Date" nowrap/>
		<g:Column id="EndTime" caption="End Time" nowrap/>
		<g:Column id="CurrentValidity" caption="Validated For" nowrap/>
		<g:Column id="StatusDescription" caption="Status" />
		<g:Column id="Status" hide/>
	</g:Columns>
	<g:Commands>
		<g:Command id="viewPermit" help="View Permit" text="View" icon="file"/>
		<g:Command id="printPermit" icon="print" help="Print Permit"/> 
	</g:Commands>

	<!--- 	
		<g:Event command="revalidatePermit">
			<g:Window title="'Permit ##'+d[0]" url="'modules/ptw/permit/pa/view_permit.cfm'" id="">  	
				<g:Button value="Ask for Extension" icon="icon-eye-open icon-white" onClick="AskForExtension();"/> 
			</g:Window>
		</g:Event>  
	--->
    
	<g:Event command="viewPermit">
		<g:Window title="'Permit ##'+d[0]" url="'modules/ptw/permit/pa/view_permit.cfm'" id="view_permit">  	 
		<!--- 			
			<g:Button value="Work Suspended/Not Completed" class="btn btn-info" icon="icon-off icon-white" onClick="workNotCompleted();"/>
			<g:Button value="Work Completed" class="btn btn-success" icon="icon-ok icon-white" onClick="workCompleted();"/> 
		--->
		</g:Window>
	</g:Event>
         
	<g:Event command="printPermit">
   	<g:Window title="'Print Work Order ##' + d[0]" IsNewWindow  url="'modules/ptw/permit/print_permit.cfm'"/>
  </g:Event>  
<!---<cfdump var="#request.grid.columns.1#">--->
</g:Grid> 
<!---  <cfdump var="#request.userinfo.departmentid#"/> --->
</cfoutput>
