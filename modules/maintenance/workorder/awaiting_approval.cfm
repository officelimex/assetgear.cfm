<cfoutput>

  <cfset Status2 = "">
  <cfif request.IsMGR>
    <cfset Status2 = "Sent to Manager"/>
  </cfif>
  <cfif request.IsWarehouseMan>
    <cfset Status2 = "Sent to Warehouse"/>
  </cfif>
  <cfif request.IsSUP>
    <cfset Status2 = "Sent to Superintendent"/>
  </cfif>

  <cfif Status2 == "">
    <cfset Status2 = "?"/>
  </cfif>

  <cfquery name="qT">
    SELECT Count(*) total FROM work_order WHERE Status2 = "#Status2#"
  </cfquery>
  <cfset woId = '__workorder_c'/>
  <cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />
  
<cfif qT.total>
  <g:Grid renderTo="#woId#_awaiting_approval" url="modules/ajax/maintenance.cfm?cmd=getAllWorkOrder&status2=#Status2#&filter=status2" commandWidth="70px" class="table-hover" firstsortOrder="DESC">
    <g:Columns>
      <g:Column id="WorkOrderId" caption="W.O.##" field="wo.WorkOrderId" sortable searchable />
      <g:Column id="ServiceRequestId" hide caption="S.R.##" field="wo.ServiceRequestId" sortable searchable />
      <g:Column id="Description" caption="W.O description" field="wo.Description" template="row[2] + ' <strong>ON</strong> ' + row[3]" searchable />
      <g:Column id="Asset" field="a.Description" searchable hide/>
      <g:Column id="WorkClass" caption="Work class"/>
      <g:Column id="DateOpened" caption="Due date" sortable nowrap/>
      <g:Column id="Status"/>
      <g:Column id="Statu2" caption="Workflow"/>
      <g:Column id="DepartmentId" hide/>
      <g:Column id="UnitId" hide/>
       
    </g:Columns>
  
    <g:Commands>
      <g:Command id="editA" icon="file" text="View" help="Edit/View Work Order" />
      <g:Command id="Print" icon="print" help="Print Work Order"/>
    </g:Commands>
  
    <g:Event command="editA">
      <g:Window 
        title="'Work order ##' +d[0]" width="990px" height="500px" 
        url="'modules/maintenance/workorder/get_page.cfm'" 
        id="save_wo_window">
      </g:Window>
    </g:Event>
    <g:Event command="viewWH">
      <g:Window title="'Work order ##' +d[0]" width="990px" height="500px" url="'modules/maintenance/workorder/get_page.cfm'" id="">
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
      <g:Window title="'Work order ##' +d[0]" width="990px" height="500px" url="'modules/maintenance/workorder/get_page.cfm'" id="">
      </g:Window>
    </g:Event>
    <g:Event command="viewMs">
      <g:Window title="'Work order ##' +d[0]" width="990px" height="500px" url="'modules/maintenance/workorder/get_page.cfm?material=true&'" id="save_wo_window">
      </g:Window>
    </g:Event>
    <g:Event command="Print">
      <g:Window title="'Print Work order for ""' + d[0] + '""' " IsNewWindow url="'modules/maintenance/workorder/print_workorder.cfm'" />
    </g:Event>
  
  </g:Grid>
<cfelse>
 
  <div style="padding-top:100px; font-size:30px; color:gray; text-align:center">No Work Order awaiting your Approval</div>

</cfif>
  
  </cfoutput>
  