<cfoutput>

	<cfparam default="0" name="url.id"/>

	<cfparam name="url.cid" default=""/>
	<cfset pmtId = "__pm_task_c_all_pm_task#url.cid#" & url.id/>

	<cfset Id1 = "#pmtId#_1"/>
	<cfset Id2 = "#pmtId#_2"/>
	<cfset Id3 = "#pmtId#_3"/>
	<cfset Id4 = "#pmtId#_4"/>

	<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
	<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
	<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

	<cfset qPM = application.com.PMTask.GetPMTask(url.id)/>
	<cfquery name="qA">
			SELECT
			CONCAT(a.Description,' @ ',l.Name,' ',IFNULL(al.LocDescription,'')) Asset, al.AssetLocationId
			FROM asset a
			LEFT JOIN asset_location al ON (al.AssetId = a.AssetId)
			INNER JOIN location l ON (l.LocationId = al.LocationId)
			WHERE a.Status = "Online"
			ORDER BY a.Description
	</cfquery>
	<cfquery name="qD">
		SELECT * FROM core_department ORDER BY Name
	</cfquery>
	<cfquery name="qUt">
		SELECT * FROM core_unit ORDER BY Name
	</cfquery>
	<cfquery name="qF">
		SELECT * FROM frequency
	</cfquery>
	<cfquery name="qRT">
		SELECT * FROM reading_type
	</cfquery>
	<cfif url.id eq 0>
		<br/>
	</cfif>

	<f:Form id="#pmtId#frm" action="modules/ajax/maintenance.cfm?cmd=SavePMTask" EditId="#url.id#">
		
		<div id="#Id1#">
			<table width="100%" border="0">
				<tr>
					<td width="58%" valign="top">
						<f:Select name="AssetLocationId" label="Asset" required ListValue="#valuelist(qA.AssetLocationId,'`')#" autoselect delimiters="`" ListDisplay="#valuelist(qA.Asset,'`')#" Selected="#qPM.AssetLocationId#" class="span11"/>
						<f:TextArea name="Description" required value="#qPM.Description#" class="span11"/>
						<f:TextBox name="ExpectedWorkDuration" help="How long in hours will it take to complete the job" required class="span4" type="number" validate="integer" label="Est. Work Duration (hrs)" value="#qPM.ExpectedWorkDuration#" />
						<cfif request.IsPlanner>
							<f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qD.DepartmentId)#" ListDisplay="#Valuelist(qD.Name)#" Selected="#qPM.DepartmentId#"/>
							<f:Select name="UnitId" label="Unit" ListValue="#Valuelist(qUt.UnitId)#" ListDisplay="#Valuelist(qUt.Name)#" Selected="#qPM.UnitId#"/>
						</cfif>
					</td>
					<td class="horz-div" valign="top">
						<f:Select name="Type" label="Tracking type" ListValue="d,m" ListDisplay="Date,Milestone" required Selected="#qPM.Type#" class="span7" onchange="#pmtId#changePT(this)"/>
						<div id="#Id1#_a" <cfif qPM.Type neq "d">class="hide"</cfif>>
							<f:Select name="FrequencyId" label="Frequency" ListValue="#Valuelist(qF.FrequencyId,'`')#" required delimiters="`" ListDisplay="#Valuelist(qF.Description,'`')#" Selected="#qPM.FrequencyId#" class="span7"/>
							<f:TextBox name="NotifyBefore" label="Notify" inlinehelp="days in advance" required value="#val(qPM.NotifyBefore)#" class="span2"/>
							<f:DatePicker name="StartTime" label="Start date" required value="#dateformat(qPM.StartTime,'yyyy/mm/dd')#"/>
						</div>
						<div id="#Id1#_b" <cfif qPM.Type neq "m">class="hide"</cfif>>
							<f:Select name="ReadingTypeId" label="Reading type" required ListValue="#Valuelist(qRT.ReadingTypeId)#" ListDisplay="#Valuelist(qRT.Type)#" Selected="#qPM.ReadingTypeId#" class="span7"/>
							<f:TextBox name="Milestone" label="Recurring: Every" required value="#qPM.Milestone#" class="span4"/>
							<f:TextBox name="NotifyBefore" label="Notify at" inlinehelp="readings in advance" required value="#val(qPM.NotifyBefore)#" class="span4"/>
						</div>
						<cfset defIsActive = qPM.IsActive/>
						<cfif defIsActive eq "">
							<cfset defIsActive = "Yes"/>
						</cfif>
						<f:RadioBox name="IsActive" ListValue="Yes,No" showlabel label="Active" selected="#defIsActive#" inline/>
						<cfset defRequireShutdown = qPM.RequireShutdown/>
						<cfif defRequireShutdown eq "">
							<cfset defRequireShutdown = "No"/>
						</cfif>
						<f:RadioBox name="RequireShutdown" ListValue="Yes,No" showlabel label="Require Shutdown" selected="#defRequireShutdown#" inline/>
					</td>
				</tr>
			</table>
		</div>

		<div id="#Id2#" align="center">

			<f:TextArea IsEditor name="TaskDetails" ShowLabel="false" style="width:94%;" required value="#qPM.TaskDetails#"/>

		</div>

		<div id="#Id3#">
			<cfset qPMI = application.com.PMTask.GetPMTaskItems(url.id)/>
			<cfset qItems = application.com.Item.GetItems()/>
			<et:Table allowInput id="ItemsNeeded">
				<et:Headers>
					<et:Header title="Description" size="6" type="int">
						<et:Select ListValue="#Valuelist(qItems.ItemId,'`')#" ListDisplay="#Valuelist(qItems.ItemDescriptionWithVPN,'`')#" delimiters="`"/>
					</et:Header>
					<et:Header title="Purpose" size="4" type="text" required="false" />
					<et:Header title="Quantity" size="1" type="int" required />
					<et:Header title="" size="1"/>
				</et:Headers>
				<et:Content Query="#qPMI#" Columns="ItemDescription,Purpose,Quantity" type="int-select,text,int" PKField="PMTaskItemId"/>
			</et:Table>
		</div>

		<div id="#Id4#" align="center">
			<textarea id="Note" name="Note" style="width:94%; height:270px;">#qPM.Note#</textarea>
		</div>

		<nt:NavTab renderTo="#pmtId#">
			<nt:Tab>
				<nt:Item title="General" isactive/>
				<nt:Item title="Task Details"/>
				<nt:Item title="Parts Needed"/>
				<nt:Item title="Note"/>
			</nt:Tab>
			<nt:Content>
				<nt:Item id="#Id1#" isactive/>
				<nt:Item id="#Id2#"/>
				<nt:Item id="#Id3#"/>
				<nt:Item id="#Id4#"/>
			</nt:Content>
		</nt:NavTab>

		<cfif url.id eq 0>
			<f:ButtonGroup>
				<f:Button value="Create new PM Task" class="btn-primary" IsSave/>
			</f:ButtonGroup>
		</cfif>

	</f:Form>

	<script>
		function #pmtId#changePT(d)	{
			if(d.value == 'm')	{
				$('#Id1#_a').addClass('hide');
				$('#Id1#_b').removeClass('hide');
			}
			else	{
				$('#Id1#_b').addClass('hide');
				$('#Id1#_a').removeClass('hide');
			}
		}
	</script>
</cfoutput>