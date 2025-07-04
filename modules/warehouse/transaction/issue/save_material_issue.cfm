<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_material_issue#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qWI">
	SELECT * FROM whs_issue
    WHERE IssueId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qI">
	SELECT
		ii.ItemIssueId,ii.IssueId,ii.ItemId,ii.Quantity,ii.UnitPrice,ii.`Status`,
		CONVERT(CONCAT(it.Description,'~',ii.ItemId) USING utf8) Description
	FROM
		whs_issue_item AS ii
	INNER JOIN whs_item AS it ON ii.ItemId = it.ItemId
	INNER JOIN whs_issue AS wi ON ii.IssueId = wi.IssueId
	where ii.IssueId =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery>

<!--- <cfquery name="qID" cachedwithin="#CreateTime(1,0,0)#">
	SELECT ItemId, CONCAT("[",Code,"] ",Description," ",VPN) Description FROM whs_item
	WHERE Obsolete = "No" AND Status <> "Deleted"
		ORDER BY Description ASC
</cfquery> --->
<cfset qID = application.com.Item.GetItems()/> 
<cfset qD = application.com.User.GetDepartments()/>
<cfset qCU = application.com.User.GetUsers()/>

<!---<cfquery name="qD">
	SELECT * FROM core_department
    ORDER BY Name
</cfquery>--->

<!--- <cfquery name="qWR">
	SELECT * FROM whs_mr ORDER BY Note
</cfquery> --->

<!---<cfquery name="qCU">
	SELECT UserId,concat(Surname," ", OtherNames) as Names FROM core_user
</cfquery>--->
<cfset editable=false/>
<cfif url.id eq 0>
	<br/><cfset editable = true/>
</cfif>
<f:Form id="#mrId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMaterialIssue" EditId="#url.id#">
	<div>
		<table width="100%" border="0">
			<tr>
				<td width="50%" valign="top">
					<input type="hidden" name="MRId" value="0"/>
					<f:TextBox name="WorkOrderId" help="Approved Work Order only" label="Work Order ##" value="#qWI.WorkOrderId#" class="span5" Disabled="#!editable#"/>
					<f:TextBox name="Ref" label="Reference" value="#qWI.Ref#"/>
					<f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qD.DepartmentId)#" ListDisplay="#Valuelist(qD.Name)#" Selected="#qWI.DepartmentId#"/>
				</td>
				<td  valign="top">
					<f:DatePicker name="DateIssued" help="the date you issued out the items" label="Date Issued" required value="#dateformat(qWI.DateIssued,'yyyy/mm/dd')#"/>
					<f:TextBox name="Remark" label="Remark" value="#qWI.Remark#"/>
					<f:Select name="IssuedToUserId" label="Received by" autoselect required delimiters="`" ListValue="#Valuelist(qCU.UserId,'`')#" ListDisplay="#Valuelist(qCU.UserName,'`')#" Selected="#qWI.IssuedToUserId#"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<et:Table allowInput="#editable#" allowUpdate="#editable#" height="170px" id="ItemIssue" bind="WorkOrderId" Event="keyup" data="modules/ajax/warehouse.cfm?cmd=getWorkOrderItems2">
						<et:Headers>
							<et:Header title="Description" size="10" type="int" disabled>
								<et:Select ListValue="#Valuelist(qID.ItemId,'`')#" ListDisplay="#Valuelist(qID.ItemDescription,'`')#" delimiters="`"/>
							</et:Header>
							<et:Header title="Qty" size="1" type="int"/>
							<et:Header title="" size="1" disabled="true"/>
						</et:Headers>
						<et:Content Query="#qI#" Columns="Description,Quantity" type="int-select,int" PKField="ItemIssueId"/>
					</et:Table>
				</td>
			</tr>
		</table>

	</div>
	<cfparam name="url.newpage" default="false">
	<cfif url.newpage == "true">
		<f:ButtonGroup>
			<f:Button value="Issue Item" class="btn-primary" IsSave subpageId="save_material_issue" ReloadURL="modules/warehouse/transaction/issue/save_material_issue.cfm?newpage=true"/>
		</f:ButtonGroup>
	</cfif>
</f:Form>

</cfoutput>
