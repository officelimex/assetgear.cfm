<cfoutput> 
  <cfset poId = '__transaction_c'/>
  <cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
   
  <g:Grid renderTo="#poId#_all_po" url="modules/ajax/warehouse.cfm?cmd=getPO" commandWidth="75px" class="table-hover table-condensed"  firstSortOrder="DESC">
    <g:Columns>
      <g:Column id="POId" caption="##" sortable searchable/>
      <g:Column id="Ref" caption="PO Number" searchable nowrap/>
      <g:Column id="MRId" caption="MR ##" searchable/>
      <g:Column id="Note" caption="Note" searchable />
      <g:Column id="Date" nowrap/>      
      <g:Column id="Status"/>      
      <g:Column id="Status" hide/>      
    </g:Columns>
    <g:Commands>
      <g:Command id="viewPO" icon="file" help="View PO" class="btn btn-mini"/>
      <g:Command id="editPO" icon="pencil" help="Edit PO" class="btn btn-mini" condition="row[6]=='Open'"/>
      <g:Command id="receivePO" text="Receive" condition="row[6]!='Close'" help="Receive PO" class="btn btn-info btn-mini"/>
    </g:Commands>
         
    <g:Event command="editPO">
      <g:Window title="'Edit Purchase Order ## '+d[0] " url="'modules/warehouse/transaction/po/edit.cfm'"/>
    </g:Event>

    <g:Event command="viewPO">
      <g:Window title="'View Purchase Order ## '+d[0] " url="'modules/warehouse/transaction/po/view.cfm'"/>
    </g:Event>

    <g:Event command="receivePO">
      <g:Window title="'Receive Purchase Order ## '+d[0] " url="'modules/warehouse/transaction/po/receive.cfm'" id="receive_po"/>
    </g:Event>
  </g:Grid> 
   
  </cfoutput>
  