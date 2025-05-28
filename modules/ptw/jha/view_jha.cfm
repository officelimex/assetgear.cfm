<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f"/>
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et"/>
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />

<cfset locId = '__jha_c_all_jha_' & url.id/>

<cfset qJS = application.com.Permit.GetJHA(url.id)/>
<cfset qJ = application.com.Permit.GetJHAList(url.id)/>
<cfoutput>


<cfif url.id eq 0><br/></cfif>
<f:Form id="#locId#frm" action="modules/ajax/ptw.cfm?cmd=saveJHA" EditId="#url.id#"> 
	<table width="100%"  border="0">
		<tr>
				<td width="50%" >
					<f:Label name="Work Description" value="#qJS.WorkDescription#"/> 
				</td>
				<td class="horz-div" valign="top">
					<f:Label name="Equipment to use" value="#qJS.EquipmentToUse#"/> 
				</td>
			</tr>
			<tr>
				<td></td>
			</tr>
			<tr>
				<td colspan="2">
			<table width="100%" border="0">
				<tr>
					<td valign="top" style="padding-left:10px;">
							<table class="table"><thead><tr>
									<th>Job Sequence</th>
									<th>Potential Hazard</th>
									<th>Target</th>
									<th>Risk</th>
									<th>Consequences</th>
									<th>Control Measure</th>
									<th>Recovery Plan</th>
									<!---<th>Responsible Party</th>--->                    
								</tr></thead>
								<cfloop query="qJ">
									<tr><td>#qJ.JobSequence#</td>
										<td>#qJ.Hazard#</td>
										<td>#qJ.Target#</td>
										<td>#qJ.Risk#</td>
										<td>#qJ.Consequences#</td>
										<td>#qJ.ControlMeasure#</td>
										<td>#qJ.RecoveryPlan#</td>
										<!---<td>#qJ.ResponsibleParty#</td>--->
									</tr>
								</cfloop>
							</table>

					</td>
				</tr>
				<tr>
					<td valign="top" style="padding-left:10px;">
						<util:FileView type="a" table="ptw_jha" pk="#url.id#" source="doc/attachment/" column="4"/> 
					</td>
				</tr> 
			</table> 
					
					</td>
			</tr>
		<tr>
				<td></td>
			</tr>
			
	</table>
	<f:ButtonGroup>
			<!--- creator --->
			<cfif qJS.PreparedByUserId EQ request.userInfo.userid AND qJS.Status EQ "Draft">

				<f:Button IsSave 
					value="Send to Admin Supervisor" 
					class="btn-info" 
					actionURL="modules/ajax/ptw.cfm?cmd=sendJHAToSupervisorA"
					onSuccess="win_view_jha.close()"
				/>

				<f:Button IsSave 
					value="Send to Operations Supervisor" 
					class="btn-primary" 
					actionURL="modules/ajax/ptw.cfm?cmd=sendJHAToSupervisorO"
					onSuccess="win_view_jha.close()"
				/>
				
			</cfif>
			<!--- supervisor --->
			<cfif	qJS.Status EQ "Sent to Supervisor" AND 
				request.IsSv>

				<f:Button IsSave 
					value="Send Back for Review" 
					class="btn-warning"
					prompt="Enter your comment"
					actionURL="modules/ajax/ptw.cfm?cmd=sendBackToCreator"
					onSuccess="win_view_jha.close()"
				/>

				<f:Button IsSave 
					value="Approve & Send to HSE" 
					class="btn-info" 
					actionURL="modules/ajax/ptw.cfm?cmd=sendJHAToHSE"
					onSuccess="win_view_jha.close()"
				/>
			</cfif>
			<!--- hse --->
			<cfif qJS.Status EQ "Sent to HSE" AND request.IsHSE>

				<f:Button IsSave
					value="Send Back for Review"
					class="btn-warning"
					prompt="Enter your comment" 
					onSuccess="win_view_jha.close()"
					actionURL="modules/ajax/ptw.cfm?cmd=SendBackToSupervisor"/>

				<f:Button IsSave
					value="Approve"
					class="btn-success"
					onSuccess="win_view_jha.close()"
					actionURL="modules/ajax/ptw.cfm?cmd=HSEApproveJHA"/>
			</cfif>
	</f:ButtonGroup>

</f:Form>

<cfif qJS.Status eq "c">
	$$('###locId# div.dbx-but-frame a.btn').setStyle('display','none');</script>
</cfif>
</cfoutput>