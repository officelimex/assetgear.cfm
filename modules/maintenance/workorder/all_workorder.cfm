<cfoutput>

<!--- for frequency as category {url.cid}--->

<cfparam name="url.cid" default="#request.userinfo.departmentid#"/>
<cfparam name="url.jid" default=""/>
<cfparam name="url.filter" default="d"/>

<cfset woId = '__workorder_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />

<g:Grid renderTo="#woId#_all_workorder#url.jid##url.cid##url.filter#" url="modules/ajax/maintenance.cfm?cmd=getAllWorkOrder&cid=#url.cid#&jid=#url.jid#&filter=#url.filter#" commandWidth="70px" class="table-hover" firstsortOrder="DESC">
  <g:Columns>
    <g:Column id="WorkOrderId" caption="W.O.##" field="wo.WorkOrderId" sortable searchable />
    <g:Column id="ServiceRequestId" hide caption="S.R.##" field="wo.ServiceRequestId" sortable searchable />
    <g:Column id="Description" caption="W.O description" field="wo.Description" template="row[2] + ' <strong>ON</strong> ' + row[3]" searchable />
    <g:Column id="Asset" field="a.Description" searchable hide/>
    <cfif url.filter eq "d">
      <g:Column id="WorkClass" caption="Work class" field="jc.Class" searchable/>
    <cfelse>
      <cfif url.cid eq "">
        <g:Column id="WorkClass" caption="Work class" field="jc.Class" searchable/>
      <cfelse>
        <g:Column id="WorkClass" caption="Work class" field="jc.Class" hide searchable/>
      </cfif>
    </cfif>
    
    <g:Column id="DateOpened" caption="Due date" sortable nowrap/>

    <g:Column id="Status"/>
    <g:Column id="Statu2" caption="Workflow"/>

    <g:Column id="DepartmentId" hide/>
    <g:Column id="UnitId" hide/>
     
  </g:Columns>

  <g:Commands>
    <!--- <g:Command id="editA" icon="pencil" help="Edit/View Work Order" condition="row[8]=='#request.userinfo.departmentid#'||row[9]=='#request.userinfo.unitid#'"/> --->

    <!--- <cfif request.userinfo.role == "FS"> --->
<!---     <cfif !request.isWarehouseMan>
      <g:Command id="editA" icon="pencil" help="Edit/View Work Order" condition="row[8]=='#request.userinfo.departmentid#'||row[9]=='#request.userinfo.unitid#'"/>
    </cfif> --->
<!---     <cfif request.isUser>
      <g:Command id="editA" icon="pencil" help="Edit/View Work Order" condition="row[8]=='#request.userinfo.departmentid#'||row[9]=='#request.userinfo.unitid#'"/> 
    </cfif> --->
    <g:Command id="editA" icon="file" text="View" help="Edit/View Work Order" />

<!---     <cfif request.IsMGR >
      <g:Command id="viewMs" icon="file" help="View Work Order" />
    </cfif>
    <cfif request.isSup || request.isSV>
      <g:Command id="editA" icon="pencil" help="Edit/View Work Order" />
      <g:Command id="viewSup" icon="file" help="View Work Order" />
    </cfif>
    <cfif request.isWarehouseMan>
      <g:Command id="viewWH" icon="file" help="View Work Order" />
    </cfif> --->
    <g:Command id="Print" icon="print" help="Print Work Order"/>

  </g:Commands>

	<g:Event command="editA">
    <g:Window 
      title="'Work order ##' +d[0]"  
      url="'modules/maintenance/workorder/get_page.cfm?cid=#url.cid#&filter=#url.filter#'" 
      id="save_wo_window">
      
      <cfif request.isSv>
        <!--- <g:Button value="Send to Superintendent" executeURL="'modules/ajax/maintenance.cfm?cmd=sendToSupervisor'" class="btn-warning"/> --->
        <!--- <g:Button value="Send to Superintendent" executeURL="'modules/ajax/maintenance.cfm?cmd=sendToSuperintendent'" class="btn-warning"/> --->
      </cfif>
      <cfif request.isSup>
        <!--- <g:Button value="Approve & Send to FS" icon="icon-thumbs-up icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=SupervisorApproveWO&to=FS'" class="btn-success"/> --->
        <!--- <g:Button value="Approve & Send to Materials" icon="icon-thumbs-up icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=SupervisorApproveWO&to=WH'" class="btn-success"/> --->
      <!---   
        <g:Button value="Approve & Send to Manager" icon="icon-thumbs-up icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=SupApproveWO-MM'" class="btn-success"/>
        <g:Button value="Approve & Send to Materials" icon="icon-thumbs-up icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=SupApproveWO-WH'" class="btn-success"/>
        <g:Button value="Reject" prompt="Reason" icon="icon-thumbs-down icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=RejectWO'" class="btn-danger"/> --->
      </cfif>

      <!--- <g:Button IsSave /> --->
    </g:Window>
  </g:Event>
	<g:Event command="viewWH">
    <g:Window title="'Work order ##' +d[0]"  url="'modules/maintenance/workorder/get_page.cfm?cid=#url.cid#&filter=#url.filter#&other=true'" id="">
      <!--- <g:Button value="Approve & Send to FS" executeURL="'modules/ajax/maintenance.cfm?cmd=WHApprove'" class="btn-success"/> --->
      
      <!--- if its a warehouse item use this process --->
      <cfswitch expression="#request.userinfo.role#">
        <cfcase value="WH_SV">
          <g:Button value="Approve & Send to Manager" condition="d[8]==#request.userinfo.departmentId#" executeURL="'modules/ajax/maintenance.cfm?cmd=WHApproveSendToWM'" class="btn-success"/>
        </cfcase>
        <cfcase value="MS,WH_SUP">
          <g:Button value="Approve" condition="d[8]==#request.userinfo.departmentId#" executeURL="'modules/ajax/maintenance.cfm?cmd=WHApproveOnly'" class="btn-success"/>
          <g:Button value="Reject" prompt="Reason" icon="icon-thumbs-down icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=RejectWO'" class="btn-danger"/>
        </cfcase>
      </cfswitch>

    </g:Window>
  </g:Event>
	<g:Event command="viewSup">
    <g:Window title="'Work order ##' +d[0]" width="990px" height="500px" url="'modules/maintenance/workorder/get_page.cfm?cid=#url.cid#&filter=#url.filter#&other=true'" id="">
      <!--- <g:Button value="Approve" executeURL="'modules/ajax/maintenance.cfm?cmd=FSApprove'" class="btn-success"/> --->
      <!--- <g:Button value="Approve" executeURL="'modules/ajax/maintenance.cfm?cmd=SupritentedApprove'" class="btn-success"/>
      <g:Button value="Reject" prompt="Reason" icon="icon-thumbs-down icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=RejectWO'" class="btn-danger"/> --->
    </g:Window>
  </g:Event>
	<g:Event command="viewMs">
    <g:Window title="'Work order ##' +d[0]" width="990px" height="500px" url="'modules/maintenance/workorder/get_page.cfm?cid=#url.cid#&filter=#url.filter#&material=true&'" id="save_wo_window">
<!---       <g:Button value="Approve" executeURL="'modules/ajax/maintenance.cfm?cmd=MSApprove'" class="btn-success"/>
      <g:Button value="Reject" prompt="Reason" icon="icon-thumbs-down icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=RejectWO'" class="btn-danger"/> 
      <g:Button value="Reject" prompt="Reason" icon="icon-thumbs-down icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=RejectReq'" class="btn-danger"/> --->
    </g:Window>
  </g:Event>

<!---   <g:Event command="editA">
  <g:Window title="'Permit ##'+d[0]" width="1000px" height="400px" url="'modules/ptw/permit/save_permit.cfm?cid=#url.cid#'" id="">        	
        <g:Button value="Send to Facility Supervisor" class="btn btn-success" icon="icon-share icon-white" executeURL="'modules/ajax/ptw.cfm?cmd=SendToPS&jhaid='+d[1]"/>
        <g:Button IsSave /> 
    </g:Window>
</g:Event>    ---> 
	<g:Event command="Print">
    <g:Window title="'Print Work order for ""' + d[0] + '""' " IsNewWindow url="'modules/maintenance/workorder/print_workorder.cfm?cid=#url.cid#'" />
  </g:Event>

</g:Grid>

</cfoutput>
