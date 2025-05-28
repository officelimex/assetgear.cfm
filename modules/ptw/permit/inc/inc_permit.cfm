<cfoutput>

<cfinclude template="../inc_var.cfm"/>

<cfimport taglib="../../../../assets/awaf/tags/xUtil/" prefix="util" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset PmtId = "__permit_c_unapproved_permit" & url.id/>

<cfset qP = application.com.Permit.GetPermit(url.id)/>
<cfset qJ = application.com.Permit.GetJHA(qP.JHAId)/>
<cfset qJL = application.com.Permit.GetJHAList(qP.JHAId)/>
<cfset qAL = application.com.Asset.GetAssetLocationInWorkOrder(qP.AssetLocationIds)/>
<cfset qL = application.com.WorkOrder.GetLabourers(val(qP.WorkOrderId))/>
<style>
	.qaz, .qaz dt,.qaz dd{ line-height:25px;}
	.cimg0 img,.cimg1 img { margin-bottom:5px;}.cimg1{color:blue;}
	.r270{-o-transform:rotate(270deg); -moz-transform:rotate(270deg); -webkit-transform:rotate(270deg); font-weight:bold; vertical-align:middle;}
	.divx{text-align:center; padding-bottom:7px; margin-bottom:5px;margin-top:5px; padding-top:3px; text-shadow:white 1px 0 1px; font-weight:bold; background-color:##F9F9F9; border-top:solid 1px ##eee;}
</style>


<div class="qaz">
    <div class="row-fluid">
        <div class="span12"> 
            <div class="row-fluid">
                <div class="span1 r270">Section_1</div>
                <div class="span5">
									<dl class="dl-horizontal">
										<dt>Facility/Intallation:</dt>
										<dd>#qP.Asset#</dd>
										<dt>Work Description:</dt>
										<dd>#qP.Work#</dd>
										<dt>Location:</dt>
										<dd>#replace(valuelist(qAL.Location),',',', ','all')#</dd>
										<dt>Time:</dt>
										<dd>#lcase(Dateformat(qP.StartTime,'dd/mm/yy'))# #lcase(timeformat(qP.StartTime,'hh:mm tt'))# - #lcase(Dateformat(qP.EndTime,'dd/mm/yy'))# #lcase(timeformat(qP.EndTime,'hh:mm tt'))#</dd>
									</dl>  
                </div>
                <div class="span6">
									<dl class="dl-horizontal">
										<dt>Department:</dt>
										<dd>#qP.Department#</dd>
										<dt>Contractor:</dt>
										<dd>#qP.Contractor#-</dd>
										<dt>Num. of Workers:</dt>
										<dd><cfif qP.NumberOfWorkers eq 0>#qL.Recordcount#<cfelse>#qP.NumberOfWorkers#</cfif></dd> 
										<dt>Tools to be used:</dt>
										<dd>#qJ.EquipmentToUse#</dd>
									</dl> 
                </div>
            </div>
        </div>
    </div>
    <div class="row-fluid">
    	<div class="span12 divx">&mdash; Safety Precautions to be taking at work place &mdash;</div>
    </div>
    <div class="row-fluid">
        <div class="span9"> 
            <div class="row-fluid">
                <div class="span1 r270">Section_2</div>
                <div class="span5">
                	<strong>Required Attached documents:</strong><br/>
                    <cfloop list="#request.required_docs#" index="it"> 
                    	<cfset chk = getCheck(qP.SafetyRequirement2,it)/>
                    	<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="12px" height="12px"> #it#</div> 
                    </cfloop>  
                </div>
                <div class="span6">
                	<strong>Safety Precautions to be taken:</strong><br/>
                    <cfloop list="#request.safety_req#" index="it"> 
                    	<cfset chk = getCheck(qP.SafetyRequirement3,it)/>
                    	<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="12px" height="12px"> #it#</div> 
                    </cfloop> 
 					<BR/>
                	<strong>Facility to be Prepared:</strong><br/>
									<cfloop list="#request.facility_prepared#" index="it"> 
										<cfset chk = getCheck(qP.SafetyRequirement4,it)/>
										<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="12px" height="12px"> #it#</div> 
									</cfloop> 
                </div>
            </div>
            <div class="row-fluid">
            	<div class="span1"></div>
                <div class="span11">
                    <dl class="">
                        <dt>Additional Precautions:</dt>
                        <dd>#qP.AdditionalPrecaution#</dd>
                    </dl>
                 </div>
            </div>            
        </div>
        <div class="span3">
            <strong>Personnel Requirements:</strong><br/>
            <cfloop list="#request.ppe#" index="it"> 
							<cfset chk = getCheck(qP.PPE,it)/>
							<div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="12px" height="12px"> #it#</div> 
            </cfloop> 
        </div>
    </div>
    <div class="row-fluid">
    	<div class="span12 divx">&mdash; Certificates (Indicated as required) &mdash;</div>
    </div>
    
    <div class="row-fluid">
        <div class="span12"> 
            <div class="row-fluid">
                <div class="span1 r270">Section_3</div>
                <div class="span5">  
                    <cfloop list="#request.certificate#" index="it">
                    <cfset chk = getCheck(qP.Hotwork,it)/>
                    <div class="cimg#chk#"><img src="assets/img/ptw_checkbox_#chk#.png" width="12px" height="12px"> #it#</div>
                    </cfloop>
                    
                </div>
            </div>           
        </div>
    </div>

    <div class="row-fluid">
        <div class="span12"> 
            <div class="row-fluid">
                <div class="span1 r270">Job_Hazard_Analysis</div>
                <div class="span11">  
                    <dl class="">
                        <dt>JHA Number:</dt>
                        <dd>#qJ.JHAId#</dd>
                    </dl>
<table width="100%" class="table table-striped table-bordered table-hover table-condensed">
    <thead><tr>
      <th>&nbsp;</th>
      <th nowrap="nowrap">Job Sequence</th>
      <th>Hazard</th>
      <th align="center">Target</th>
      <th align="center">Risk</th>
      <th>Consequences</th>
      <th>Control Measure</th>
      <th>Recovery Plan</th>
      <!---<th>Responsible Party</th>--->      
    </tr></thead>
  <cfloop query="qJL">
    <tr>
      <td valign="top">#qJL.Currentrow#.</td>
      <td valign="top">#qJL.JobSequence#</td>
      <td valign="top">#qJL.Hazard#</td>
      <td align="left" valign="top" nowrap="nowrap">#ucase(qJL.Target)#</td>
      <td align="left" valign="top" nowrap="nowrap">#ucase(qJL.Risk)#</td>
      <td valign="top">#qJL.Consequences#</td>
      <td valign="top">#qJL.ControlMeasure#</td>
      <td valign="top">#qJL.RecoveryPlan#</td>
      <!---<td valign="top">#qJL.ResponsibleParty#</td>--->      
    </tr>
  </cfloop> 
</table>
<table>
	<tr>
		<td>
			<util:FileView type="a" table="ptw_jha" pk="#qp.JHAId#" source="doc/attachment/" column="4"/>
		</td>
		<td>
			<util:FileView type="a" table="ptw_permit" pk="#qp.PermitId#" source="doc/attachment/" column="4"/>
		</td>
	</tr>
</table>

                </div> 
            </div>           
        </div>
    </div>
       
</div>

<f:Form id="#PmtId#frm" action="modules/ajax/ptw.cfm?cmd=FSApprovePermit&id=#url.id#" EditId="#url.id#">
	<cfif request.userInfo.DepartmentId EQ application.department.admin AND qP.Status EQ "Sent to Admin">
		<f:ButtonGroup>
			<f:Button 
				value="Approve" 
				class="btn-success" 
				IsSave 
				subpageId="unapproved_permit" 
				ReloadURL="modules/ptw/permit/unapproved_permit.cfm"/>
		</f:ButtonGroup>
	</cfif>

	<cfif (
			request.userInfo.DepartmentId EQ application.department.operations || request.userInfo.DepartmentId EQ application.department.lpg
		) AND qP.Status EQ "Sent to Operations">

		<f:ButtonGroup>
			<f:Button 
				value="Approve"
				class="btn-success" 
				IsSave 
				subpageId="unapproved_permit" 
				ReloadURL="modules/ptw/permit/unapproved_permit.cfm"/>
		</f:ButtonGroup>

	</cfif>
	<cfif listFindNoCase(qP.Status,"Approved") AND request.userInfo.DepartmentId EQ qP.WODepartmentId>
			<cfif (request.IsSv OR request.IsSUP) AND !(val(qP.SVCloseByUserId))>	<!--- SV closer ---->
				<f:ButtonGroup>
					<f:Button 
						value="Revalidate"
						beforeSave="if (!confirm('Are you sure?')) return True"
						class="btn-info" IsSave
						prompt="Enter comments"
						onSuccess="win_view_permit.close()"
						subpageId="permit_for_pa" 
						actionURL="modules/ajax/ptw.cfm?cmd=RevalidatePermit&id=#url.id#"
						ReloadURL="modules/ptw/permit/pa/permit_for_pa.cfm"/>
					<f:Button 
						value="Work Completed (SV)"
						beforeSave="if (!confirm('Are you sure?')) return True"
						class="btn-success" IsSave 
						prompt="Enter comments"
						onSuccess="win_view_permit.close()"
						subpageId="permit_for_pa" 
						actionURL="modules/ajax/ptw.cfm?cmd=SVClosePermit&id=#url.id#"
						ReloadURL="modules/ptw/permit/pa/permit_for_pa.cfm"/>
				</f:ButtonGroup>
			</cfif>	
			<cfif (qP.PAApprovedByUserId EQ request.userInfo.UserId) && !(val(qP.PACloseByUserId))> <!--- PA closer ---->
				<f:ButtonGroup>
					<f:Button 
						value="Work Completed (PH)"
						class="btn-success" IsSave 
						onSuccess="win_view_permit.close()"
						prompt="Enter comments"
						subpageId="permit_for_pa" 
						actionURL="modules/ajax/ptw.cfm?cmd=PAClosePermit&id=#url.id#&completed=Yes"
						ReloadURL="modules/ptw/permit/pa/permit_for_pa.cfm"/>
					
					<f:Button 
						value="Work Not Completed/Suspended (PH)"
						class="btn-danger" IsSave 
						onSuccess="win_view_permit.close()"
						prompt="Enter comments"
						subpageId="permit_for_pa" 
						actionURL="modules/ajax/ptw.cfm?cmd=PAClosePermit&id=#url.id#&completed=No"
						ReloadURL="modules/ptw/permit/pa/permit_for_pa.cfm"/>
				</f:ButtonGroup>					
			</cfif>
	</cfif>
 
</f:Form>

<cffunction name="getCheck" access="private" returntype="string">
	<cfargument name="lst1" type="string" required="yes"/>
    <cfargument name="vl" type="string" required="yes"/>
    
	<cfset var chk = 0/>
    <cfif ListFindNoCase(arguments.lst1,arguments.vl)>
			<cfset chk=1/>
    </cfif>	
    
    <cfreturn chk/>
</cffunction>

</cfoutput>