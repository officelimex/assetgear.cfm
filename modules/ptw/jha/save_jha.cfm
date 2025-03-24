<cfparam default="0" name="url.id"/> 

<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f"/>
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et"/>
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />

<cfset locId = '__jha_c_all_jha' & url.id/>

<cfset qJS = application.com.Permit.GetJHA(val(url.id))/>
<cfset qJ = application.com.Permit.GetJHAList(url.id)/>

<cfoutput>
<cfif url.id eq 0><br/></cfif>
<f:Form id="#locId#frm" action="modules/ajax/ptw.cfm?cmd=saveJHA" EditId="#url.id#"> 
	<table width="100%"  border="0">
    	<tr>
        	<td width="26%" >
    			<f:TextBox name="WorkOrderId" label="Work Order ##" required value="#qJS.WorkOrderId#" class="span9"/>
            </td>
            <td class="horz-div" valign="top">
                <f:TextBox name="EquipmentToUse" required label="Equipment/Tools to be used" value="#qJS.EquipmentToUse#" class="span11" />
            </td> 
        </tr>
        <tr>
        	<td></td>
        </tr>
        <tr>
        	<td colspan="2">
						<hr/>
						<et:Table allowInput height="240px" id="JHAList">
							<et:Headers>
								<et:Header title="Job Sequence" size="2" type="text"/>
								<et:Header title="Hazard" size="1" type="text"/>
								<et:Header title="Who may be Harmed" size="1" type="text" />
								<et:Header title="Severity" size="1" type="text"/>
								<et:Header title="Likelihood" size="1" type="text"/>
								<et:Header title="Risk Rating" size="1" type="text"/>
								<et:Header title="Control Measures" size="2" type="text"/>
								<et:Header title="Recovery Plan" size="1" type="text"/>
								<et:Header title="Action Parties" size="1" type="text"/>                   
								<et:Header title="" size="1"/>
							</et:Headers>
							<et:Content Query="#qJ#" Columns="JobSequence,Hazard,Whom,Severity,Likelihood,Risk,ControlMeasure,RecoveryPlan,ActionParties" type="text,text,text,text,text,text,text,text,text" PKField="JHAListId"/> 
						</et:Table>            	
					</td>
        </tr>
        <tr>
          <td colspan="2">
            <div class="alert alert-info">Attach third party JHA.</div>
            <u:UploadFile id="Attachments" table="ptw_jha" pk="#url.id#" />
          </td>
        </tr>
    	<tr>
        	<td></td>
        </tr>
       
    </table>
   
    <cfif url.id eq 0>
			<f:ButtonGroup>
				<f:Button value="Create new JHA" class="btn-primary" IsSave subpageId="save_jha" ReloadURL="modules/ptw/jha/save_jha.cfm"/>
			</f:ButtonGroup>
    </cfif>
</f:Form>


</cfoutput>