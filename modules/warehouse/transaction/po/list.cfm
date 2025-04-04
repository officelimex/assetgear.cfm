<cfoutput> 
  <cfset poId = '__transaction_c'/>
  <cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
   
  <g:Grid renderTo="#poId#_all_po" url="modules/ajax/warehouse.cfm?cmd=getPO" commandWidth="75px" class="table-hover table-condensed"  firstSortOrder="DESC">
    <g:Columns>
      <g:Column id="POId" caption="##" sortable searchable/>
      <g:Column id="Ref" caption="PO Number" searchable />
      <g:Column id="MRId" caption="MR ##" searchable/>
      <g:Column id="Note" caption="Note" searchable />
      <g:Column id="Date"/>      
      <g:Column id="Status"/>      
    </g:Columns>
    <g:Commands>
      <g:Command id="viewPO" text="View" help="view PO" class="btn btn-mini"/>
      <g:Command id="receivePO" text="Receive" condition="row[5]!='Close'" help="Receive PO" class="btn btn-info btn-mini"/>
    </g:Commands>
         
    <g:Event command="viewPO">
      <g:Window title="'View Purchase Order ## '+d[0] " url="'modules/warehouse/transaction/po/view.cfm'"/>
    </g:Event>

    <g:Event command="receivePO">
      <g:Window title="'Receive Purchase Order ## '+d[0] " url="'modules/warehouse/transaction/po/receive.cfm'" id="receive_po"/>
    </g:Event>
  </g:Grid> 
   
  </cfoutput>
  