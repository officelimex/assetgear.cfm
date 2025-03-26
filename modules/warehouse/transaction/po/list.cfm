<cfoutput> 
  <cfset poId = '__transaction_c'/>
  <cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
   
  <g:Grid renderTo="#poId#_all_po" url="modules/ajax/warehouse.cfm?cmd=getPO" commandWidth="75px" class="table-hover table-condensed"  firstSortOrder="DESC">
    <g:Columns>
      <g:Column id="POId" caption="##" sortable searchable/>
      <g:Column id="MRId" caption="MR ##" searchable/>
      <g:Column id="Ref" caption="Ref" searchable />
      <g:Column id="Date"/>      
    </g:Columns>
    <g:Commands>
      <g:Command id="editMR" text="Edit" help="Edit MR" class="btn btn-mini"/>
    </g:Commands>
         
    <g:Event command="editMR">
      <g:Window title="'Edit material requisition ## '+d[0] " width="850px" height="440px" url="'modules/warehouse/transaction/mr/save_mr.cfm'">
        <g:Button value="Decline MR" class="btn-success" icon="icon-remove icon-white" executeURL="'controllers/Warehouse.cfc?method=declineMR'"/>
        <g:Button IsSave /> 
      </g:Window>
    </g:Event>
  </g:Grid> 
   
  </cfoutput>
  