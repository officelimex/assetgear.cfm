<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_material_returned#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qWRe">
	SELECT * FROM whs_return
    WHERE returnId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qI">
    SELECT
    	ir.ItemReturnId,ir.ReturnId,ir.ItemId,ir.Quantity,ir.UnitPrice,ir.`Status`,
    	CONVERT(CONCAT(it.Description,'~',ir.ItemId) USING utf8) Description
    FROM
    	whs_return_item AS ir
    INNER JOIN whs_item AS it ON ir.ItemId = it.ItemId
    INNER JOIN whs_return AS wr ON ir.ReturnId = wr.ReturnId
    where wr.ReturnId =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery>

<cfset qID = application.com.Item.GetItems()/>

<cfset qCU = application.com.User.GetUsers()/>

<cfif url.id eq 0>
	<br/>
</cfif>

<f:Form id="#mrId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMaterialReturn" EditId="#url.id#">
	<div>

		<table width="100%" border="0">
			<tr>
				<td width="50%" valign="top">
						<f:TextBox name="IssueId" label="Issue ##" value="#qWRe.IssueId#" class="span5" />
						<f:DatePicker name="Datereturned" label="Date Returned" required value="#dateformat(qWRe.Datereturned,'yyyy/mm/dd')#"/>
				</td>
				<td class="horz-div" valign="top">
					<f:TextBox name="Note" value="#qWRe.Note#" label="Remark"/>
						<f:Select name="ReturnedByUserId" autoselect label="Returned By" validate="integer" required ListValue="#Valuelist(qCU.UserId,'`')#" ListDisplay="#Valuelist(qCU.UserName,'`')#" delimiters="`" Selected="#qWRe.returnedByUserId#"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">

						<et:Table allowInput height="180px" id="ItemReturn" bind="IssueId" Event="keyup" data="modules/ajax/warehouse.cfm?cmd=getIssue">
								<et:Headers>
										<et:Header title="Description" size="10" type="int">
												<et:Select ListValue="#Valuelist(qID.ItemId,'`')#" ListDisplay="#Valuelist(qID.ItemDescription,'`')#" delimiters="`"/>
										</et:Header>
										<et:Header title="Qty" size="1" type="int"/>
										<et:Header title="" size="1"/>
								</et:Headers>
								<et:Content Query="#qI#" Columns="Description,Quantity" type="int-select,int" PKField="ItemReturnId"/>
						</et:Table>

				</td>
			</tr>
		</table>


	</div>

	<cfparam name="url.newpage" default="false">
	<cfif url.newpage == "true">
		<f:ButtonGroup>
			<f:Button value="Issue Item" class="btn-primary" IsSave/>
		</f:ButtonGroup>
  </cfif>

</f:Form>

</cfoutput>
