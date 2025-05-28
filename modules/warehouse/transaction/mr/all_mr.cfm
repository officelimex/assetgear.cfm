<cfoutput> 
<cfset mrId = '__transaction_c'/>
<cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#mrId#_all_mr" url="modules/ajax/warehouse.cfm?cmd=getMR&t=SI" commandWidth="75px" class="table-hover table-condensed"  firstsortOrder="DESC">
	<g:Columns>
		<g:Column id="MRId" caption="##" field="mr.MRId" sortable searchable/>
		<g:Column id="WorkOrderId" field="mr.WorkOrderId" caption="W.O. ##" searchable/>
		<g:Column id="ServiceRequestId" field="mr.ServiceRequestId" caption="S.R. ##" searchable hide/>
		<g:Column id="Ref" caption="Ref" searchable />
		<g:Column id="Note" searchable field="Note"/>
		<g:Column id="DateIssued" caption="Date issued" nowrap/>        
		<g:Column id="TotalValue" caption="Total value" />
		<g:Column id="Status" />
		<g:Column id="Status" hide/>
	</g:Columns>
	<g:Commands>
		<g:Command id="editMR" text="Edit" help="Edit MR" class="btn btn-mini" condition="row[8]=='Open'"/>
		<g:Command id="printMR" help="Print MR" class="btn btn-mini" icon="print"/>        
	</g:Commands>
       
	<g:Event command="editMR">
		<g:Window title="'Edit material requisition ## '+d[0] " url="'modules/warehouse/transaction/mr/save_mr.cfm'">
			<g:Button value="Close MR" class="btn-warning" warning="Are you sure? You will not be able to undo this" icon="icon-remove icon-white" executeURL="'controllers/Warehouse.cfc?method=closeMR'"/>
			<g:Button IsSave /> 
		</g:Window>
  </g:Event>

<!--- 	<cfif request.IsWarehouseAdmin>
		<g:Event command="capturePO">
			<g:Window title="'Capture PO for MR ## '+d[0] " width="850px" height="440px" url="'modules/warehouse/transaction/mr/new_po.cfm'">
				<g:Button value="Create PO" class="btn-success" icon="icon-remove icon-white" executeURL="'controllers/Warehouse.cfc?method=declineMR'"/>
			</g:Window>
		</g:Event>
	</cfif> --->

	<g:Event command="printMR">
		<g:Window IsNewWindow url="'modules/warehouse/transaction/mr/print_mr.cfm'"/> 
	</g:Event> 

</g:Grid> 
 
</cfoutput>
