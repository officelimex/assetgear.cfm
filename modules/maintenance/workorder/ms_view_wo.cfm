

<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfparam name="url.filter" default=""/>
<cfset woId = "__workorder_c_all_workorder#url.cid##url.filter#" & url.id/>
 
<cfset Id1 = "#woId#_1"/>
<cfset Id4 = "#woId#_4"/>

 
<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />
 
<cfset qWO = application.com.WorkOrder.GetWorkOrder(url.id)/>
<cfset qOI = application.com.WorkOrder.GetWorkOrderItems(url.id)/> 
 
<cfquery name="qAS">
	SELECT *
    FROM asset
    WHERE AssetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWO.AssetId#"/>
</cfquery>

<cfquery name="qAl">
	SELECT l.`Name` 
	FROM asset_location a 
	INNER JOIN location l on a.LocationId = l.LocationId 
	WHERE a.AssetLocationId IN (
		<cfqueryparam value="#qWO.AssetLocationIds#" cfsqltype="cf_sql_integer" list="true">
	)
</cfquery>

<cfset qSU = application.com.User.GetUser(val(qWO.SupervisedByUserId))/> 
<cfset qCU = application.com.User.GetUser(val(qWO.ClosedByUserId))/>
 
<cfif url.id eq 0>
	<br/>
</cfif>
<cfset AssetLocation =""/>
<cfloop query="qAl">
	<cfset AssetLocation = AssetLocation & "#qAl.Name#, "/>
</cfloop>

<f:Form id="#woId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveWorkOrder" EditId="#url.id#"> 
  <div id="#Id1#">
    <table width="100%" border="0">
      <tr>
        <td width="50%" valign="top"> 
          <cfif qWO.createdBy != "">
            <f:Label name="Created by" value="#qWO.createdBy#"/>
          </cfif>
          <f:Label name="Work Description" value="#qWO.Description#"/>
          <cfif qWO.Status2 EQ "Approved">
            <a href="modules/warehouse/transaction/mr/print_mr.cfm?id=#qWO.MRId#" target="_blank">
              <f:Label name="MR ##" hideOnBlank value="#qWO.MRId#"/>
            </a>
          <cfelse>
            <f:Label name="MR ##" hideOnBlank value="#qWO.MRId#"/>
          </cfif>
          <f:Label name="Asset" value="#qAS.Description#"/>
        </td>
        <td class="horz-div" valign="top"> 
          <f:Label name="Service Request ##" hideOnBlank label="Service Request ##" value="#qWO.ServiceRequestId#" />
          <f:Label name="Department" value="#qWO.Department# &mdash;  #qWO.Unit#" />
          <f:Label name="Work Class" value="#qWO.JobClass#" />
          <f:Label name="Date Opened" value="#dateformat(qWO.DateOpened,'dd/mmm/yyyy')#"/>
          <f:Label name="Asset Location" value="#AssetLocation# "/> 
          <cfset _pclass = "info"/>
          <cfswitch expression="#qWO.Priority#">
            <cfcase value="Critical">
              <cfset _pclass = "error"/>
            </cfcase>
            <cfcase value="High">
              <cfset _pclass = "warning"/>
            </cfcase>
            <cfcase value="Low">
              <cfset _pclass = "info"/>
            </cfcase>
          </cfswitch>
          <f:Label name="Priority" label="Priority" class="text-#_pclass# text-bold" value="#qWO.Priority#"/>
        </td>
      </tr> 
      <tr>
        <td colspan="2">
        </td>
      </tr>
      <tr>
        <td colspan="2"> 
          <f:label name="Work Details" value="#qWO.WorkDetails#" class="span10" rows="6"/>
        </td>
      </tr>
    </table>

    <h5>Materials Needed</h5>
    <table width="100%" border="0">
      <tr>
        <td valign="top" style="padding-left:10px;">
          <table class="table"><thead>
            <tr>
              <th>##</th>
              <th>ICN</th>
              <th>Item Description</th>
              <th>Quantity</th>
              <th>OEM</th>
              <th>Part/Serial/Model No</th>
            </tr>
            </thead>
            <cfloop query="qOI">
              <tr>
                <td>#qOI.Currentrow#</td>
                <td>#qOI.Code#</td>
                <td>
                  <cfif val(qOI.ItemId)>
                    #replaceNoCase(qOI.Item,chr(10),'<br/>','all')#
                  <cfelse>
                    #replaceNoCase(qOI.Description,chr(10),'<br/>','all')#
                  </cfif>
                </td>
                <td>#qOI.Quantity# #qOI.UOM##qOI.UM#</td>
                <td>#qOI.Maker##qOI.OEM#</td>
                <td>#qOI.VPN##qOI.WOItemVPN#</td>
              </tr>
            </cfloop>
          </table>
        </td>
      </tr> 
    </table> 
    <hr/>
    
    <cfquery name="qC">
      SELECT 
        c.*,
        CONCAT(u.Surname,' ',u.OtherNames) `By` 
      FROM core_comment c
      INNER JOIN core_user u ON u.UserId = c.CommentByUserId 
      WHERE `PK` = "#val(qWO.WorkOrderId)#" AND `Table` = "wo"
    </cfquery>
    <cfif qC.recordcount>
      <h5>Review and Feedbacks</h5>
    </cfif>
    <cfloop query="qC">
      <cfset bg = "fff"/>
      <cfif qC.currentrow mod 2>
        <cfset bg = "efefef"/>
      </cfif>
      <div style="background-color:###bg#; padding:10px;">
        <f:Label name="
          #qC.By#<br/>
          <small>#DateTimeFormat(qC.Date,'dd,mmm yy hh:mm')#</small>
        " value="#replaceNocase(qC.Comments,chr(13),'<br/>','all')#"/>
      </div>
    </cfloop>
    <br/>
    <f:TextArea name="Comment" value="" rows="6" Label="Comments/Remarks"  class="span10"/>
  </div>
  
  <div id="#Id4#"> 
    <util:FileView type="a" table="work_order" pk="#url.id#" source="doc/attachment/" column="4"/>
  </div>
    
  <nt:NavTab renderTo="#woId#">
    <nt:Tab>
      <nt:Item title="Request Open Section" isActive/>
      <nt:Item title="Supporting Documents"/>
    </nt:Tab>
    <nt:Content>
      <nt:Item id="#Id1#" isActive/>
      <nt:Item id="#Id4#"/>
    </nt:Content>
  </nt:NavTab>
  
  <f:ButtonGroup>
    <cfif qWO.WorkClassId EQ 12 AND qWO.Status2 NEQ "Approved" AND (request.IsMGR OR (request.IsWarehouseAdmin AND qWO.DepartmentId EQ 8))>
      <cfset _show = true>
      <cfif qWO.DepartmentId NEQ request.userInfo.DepartmentId>
        <cfset _show = false>
        <cfif listFindNoCase("#application.department.operations#,#application.department.lpg#", qWO.DepartmentId) && request.userInfo.departmentId EQ application.department.operations>
          <cfset _show = true>
        </cfif>
      </cfif>
      
      <cfif _show>
        <!--- add recall button --->
        <cfif qWO.CreatedByUserId EQ request.userInfo.UserId && qWO.Status2 EQ "Sent to Warehouse">
          <f:Button IsSave 
            value="Recall Request" 
            class="btn-warning" 
            actionURL="modules/ajax/maintenance.cfm?cmd=RecallRequest"
            onSuccess="win_save_wo_window.close()"
            icon="icon-thumbs-down icon-white"
          />
        </cfif>
        <f:Button IsSave 
          value="Request Review" 
          class="btn-info" 
          actionURL="modules/ajax/maintenance.cfm?cmd=RequestReview"
          onSuccess="win_save_wo_window.close()"
        />
        <f:Button IsSave
          value="Approve Request" 
          class="btn-success" 
          actionURL="modules/ajax/maintenance.cfm?cmd=MGRApprove" 
          icon="icon-thumbs-up icon-white"
          onSuccess="win_save_wo_window.close()"/>
      </cfif>
    </cfif>
  </f:ButtonGroup>
<!--- <g:Button value="Approve" executeURL="'modules/ajax/maintenance.cfm?cmd=MSApprove'" class="btn-success"/>
      <g:Button value="Reject" prompt="Reason" icon="icon-thumbs-down icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=RejectWO'" class="btn-danger"/> 
      <g:Button value="Reject" prompt="Reason" icon="icon-thumbs-down icon-white" executeURL="'modules/ajax/maintenance.cfm?cmd=RejectReq'" class="btn-danger"/> --->
</f:Form>

<script>
 
	function #woId#changePT(d)	{ 
		if(d.value == 'm')	{
		 	$('#Id1#_a').addClass('hide');
			$('#Id1#_b').removeClass('hide'); 
		}
		else	{
		 	$('#Id1#_b').addClass('hide');
			$('#Id1#_a').removeClass('hide'); 
		}	
	}
</script></cfoutput>