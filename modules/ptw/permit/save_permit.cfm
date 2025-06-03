<cfinclude template="inc_var.cfm"/>
<cfparam default="0" name="url.id"/>

<cfif url.id eq 0><br /></cfif>

<cfset PmtId = "__permit_c_unapproved_permit" & url.id/>

<cfset Id1 = "#PmtId#_1"/>
<cfset Id2 = "#PmtId#_2"/>
<cfset Id3 = "#PmtId#_3"/>
<cfset Id5 = "#PmtId#_5"/>

<cfoutput>
    <cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
    <cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
    <cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
    <cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />
    
    <!--- QUERIES --->
    <cfset qPM = application.com.Permit.GetPermit(url.id)/> 
    <cfquery name="qGT">
			SELECT
				gt.*, 
				Date_Format(gt.Date,'%d-%m-%y %r') Dates
			FROM
				ptw_gas_test AS gt
			INNER JOIN ptw_permit AS pp ON gt.PermitId = pp.PermitId 
			WHERE gt.PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
		</cfquery>

<style>
.pad35	{padding:35px;}
</style> 
    
    <f:Form id="#PmtId#frm" action="modules/ajax/ptw.cfm?cmd=SavePermit" EditId="#url.id#"> 
        <div id="#Id1#">
        <table border="0" width="100%">
					<tr>
						<td width="50%" valign="top">
							<f:TextBox name="JHAId" label="JHA ##" required value="#qPM.JHAId#" class="span5"/>
							<f:RadioBox ShowLabel Label="Job type" name="WorkType" ListValue="Hot Work,Cold Work,Electrical Work" selected="#qPM.WorkType#" Inline/>
							<f:TextBox name="ZoneClass" label="Zone Classification" value="#qPM.ZoneClass#" class="span11"/>
						</td>
						<td class="horz-div"  valign="top">
							<f:DatePicker name="StartTime" label="Start Date/Time" required value="#qPM.StartTime#" type="datetime"/>
							<f:DatePicker name="EndTime" label="End Date/Time" required value="#DateFormat(qPM.EndTime,'dd/mmm/yyyy')# #TimeFormat(qPM.EndTime,'HH:MM')#" type="datetime"/>
							<f:TextBox name="Contractor" label="Contractor" value="#qPM.Contractor#" class="span11"/>
							<f:TextBox name="NumberOfWorkers" label="Number of workers" required  value="#qPM.NumberOfWorkers#" validate="integer" class="span2"/>                
						</td>
					</tr>
 
        </table>
        </div>
        <div id="#Id2#" <cfif url.id neq 0>style="height:420px;"</cfif>>
        <table width="100%" border="0">
            <tr>
            	<td>
								REQUIRED DOCUMENTS TO BE ATTACHED
              	<f:CheckBox name="SafetyRequirement5" ListValue="#request.required_docs#" selected="#qPM.SafetyRequirement5#" /> 
              </td>
							<td rowspan="2" valign="top">
								<f:CheckBox name="PPE" selected="#qPM.PPE#" label="PERSONNEL REQUIREMENTS" showLabel ListValue="#request.ppe#"/>
							</td>
            </tr>
        		<tr>
            	<td width="50%" valign="top">
								SAFETY PRECAUTIONS TO BE TAKEN <br/>
                <f:CheckBox name="SafetyRequirement1" ListValue="#request.safety_req#" selected="#qPM.SafetyRequirement1#" delimiter="'"/> 
                FACILITIES TO BE PREPARED BY <br/>
                <f:CheckBox name="SafetyRequirement3" selected="#qPM.SafetyRequirement3#" ListValue="#request.facility_prepared#"  /> 
              	WORK AREA TO BE PREPARED BY<br/>
                <f:CheckBox name="SafetyRequirement4" selected="#qPM.SafetyRequirement4#" ListValue="#request.work_prepared#"/> 
              </td>
            </tr>
            <tr>
            	<td>
                	<br/>
                </td>
           </tr>
           <tr>
           		<td colspan="2">
                	<f:TextArea name="AdditionalPrecaution" label="Additional precautions" value="#qPM.AdditionalPrecaution#" class="span10" rows="4"/>
                </td>
           </tr>
        </table>
        </div>
        <div id="#Id3#" <cfif url.id neq 0>style="height:420px;"</cfif>>
					<table width="100%">
						<tr class="vert-div" >
							<td colspan="2" align="center">CERTIFICATES (INDICATE AS REQUIRED)</td>
						</tr>
						<tr>
							<td valign="top" width="50%">
								<br/>
								<f:CheckBox selected="#qPM.Certificate#"  label="CERTIFICATES REQUIRED FOR THIS PERMIT" name="Certificate" ListValue="#request.certificate#" showlabel /> 
							</td>
						</tr>
        	</table>
        </div>
        <div id="#Id5#" <cfif url.id neq 0>style="height:320px;"</cfif>>
					<div class="alert alert-info">Attach Documents here.</div>
					<u:UploadFile id="Attachments" table="ptw_permit" pk="#url.id#" />
        </div>
        
        <nt:NavTab renderTo="#PmtId#">
        <nt:Tab>
            <nt:Item title="Section 1" isactive/>
            <nt:Item title="Section 2"/>
            <nt:Item title="Section 3"/>
            <nt:Item title="Supporting Documents (Attachments)"/>
        </nt:Tab>
        <nt:Content>
            <nt:Item id="#Id1#" isactive/>
            <nt:Item id="#Id2#"/>
            <nt:Item id="#Id3#"/>
            <nt:Item id="#Id5#"/>    
        </nt:Content>
        </nt:NavTab>
        
				<f:ButtonGroup>
					<cfif url.id eq 0>
						<f:Button value="Create new Permit" class="btn-primary" IsSave subpageId="save_permit" ReloadURL="modules/ptw/permit/save_permit.cfm"/>
					<cfelse>
						<cfif qPM.DepartmentId eq request.userInfo.DepartmentId>
							<cfswitch expression="#qPM.Status#">
								<cfcase value="Open">
									<f:Button IsSave 
										value="Save & Send to Supervisor" 
										class="btn btn-success" 
										icon="icon-share icon-white" 
										actionURL="modules/ajax/ptw.cfm?cmd=SendPermitToSupervisor"
										onSuccess="win_save_permit.close()"/>
<!--- 									<f:Button 
										IsSave 
										value="Save Permit Only"
										class="btn-primary"
										actionURL="modules/ajax/ptw.cfm?cmd=SavePermit"
										onSuccess="win_save_permit.close()"/>  ---> 
								</cfcase>	

								<cfcase value="Sent to Supervisor">
									<cfif request.IsSV>
										<f:Button IsSave 
											value="Approve & Send to Operations" 
											class="btn btn-warning" 
											icon="icon-share icon-white" 
											actionURL="modules/ajax/ptw.cfm?cmd=SendPermitToFacilityManager&user=Operations"
											onSuccess="win_save_permit.close()"/>
										<f:Button IsSave 
											value="Approve & Send to Admin" 
											class="btn btn-success" 
											icon="icon-share icon-white" 
											actionURL="modules/ajax/ptw.cfm?cmd=SendPermitToFacilityManager&user=Admin"
											onSuccess="win_save_permit.close()"/>
<!--- 										<f:Button 
											IsSave 
											value="Save Permit Only"
											class="btn-primary"
											actionURL="modules/ajax/ptw.cfm?cmd=SavePermit"
											onSuccess="win_save_permit.close()"/> --->  
									</cfif>
								</cfcase>

							</cfswitch>
						</cfif>
					</cfif>
				</f:ButtonGroup>
    </f:Form>
</cfoutput>

	
