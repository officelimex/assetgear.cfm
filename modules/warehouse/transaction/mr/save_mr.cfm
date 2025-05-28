<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_all_mr#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />
<cfimport taglib="../../../../assets/awaf/tags/xUploader_1000/" prefix="u" />

<cfset qMR = application.com.Transaction.GetMR(url.id)/>
<cfset qWI = application.com.Transaction.GetMRItems(url.id)/>

<cfset qID = application.com.Item.GetItems()/>
<cfquery name="qD" cachedWithin="#CreateTime(5,0,0)#">
	SELECT * FROM core_department ORDER BY Name
</cfquery>
<cfquery name="qU" cachedWithin="#CreateTime(5,0,0)#">
	SELECT * FROM core_unit ORDER BY Name
</cfquery>

<cfif url.id eq 0>
	<br/>
</cfif>
<f:Form id="#mrId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMR&type=SI" EditId="#url.id#">
<div>
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top">
			<f:DatePicker name="DateIssued" label="Date Issued" required value="#dateformat(qMR.Date,'yyyy/mm/dd')#"/>
			<f:DatePicker name="DateRequired" label="Date Required" required value="#dateformat(qMR.DateRequired,'yyyy/mm/dd')#"/>
			<f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qD.DepartmentId)#" ListDisplay="#Valuelist(qD.Name)#" Selected="#qMR.DepartmentId#"/>
			<f:Select name="UnitId" label="Unit" ListValue="#Valuelist(qU.UnitId)#" ListDisplay="#Valuelist(qU.Name)#" Selected="#qMR.UnitId#"/>
    </td>
    <td class="horz-div" valign="top">
			<f:Select name="Currency" required ListValue="NGN,USD" ListDisplay="Naira,Dollars" Selected="#qMR.Currency#" class="span4"/>
			<f:TextArea name="Note" required value="#qMR.Note#" class="span11"/>
			<div id="#mrId#frm1" style="display:none">
				<f:TextBox name="WorkOrderId" required label="Work Order ##" value="#qMR.WorkOrderId#" class="span4"/>
			</div>
			<f:TextBox name="Ref" label="Ref info" value="#qMR.Ref#" class="span11"/>
    </td>
  </tr>
  <tr>
  	<td colspan="2">
			<et:Table allowInput id="MRSIItem" bind="WorkOrderId" Event="keyup" data="modules/ajax/warehouse.cfm?cmd=getWorkOrder">
				<et:Headers>
					<et:Header title="Description" size="8" type="int">
						<et:Select ListValue="#Valuelist(qID.ItemId,'`')#" ListDisplay="#Valuelist(qID.ItemDescriptionWithVPN,'`')#" delimiters="`"/>
					</et:Header>
					<et:Header title="Qty" size="1" type="int"/>
					<et:Header title="Unit Cost" size="2" type="float" required="false"/>
					<et:Header title="" size="1"/>
				</et:Headers>
				<et:Content Query="#qWI#" Columns="ItemDescription,Quantity,UnitPrice" type="int-select,int,float" PKField="MRItemId"/>
			</et:Table>
    </td>
  </tr>
	<tr>
		<td colspan="2">
			<hr/>
			<div class="alert alert-info">Attach Documents to MR.</div>
			<u:UploadFile id="Attachments" table="whs_mr" pk="#url.id#" />
		</td>
	</tr>
</table>
<br/>
<br/>
</div>

	<cfparam name="url.newpage" default="false">
	<cfif url.newpage>
		<f:ButtonGroup>
			<f:Button value="Create MR" class="btn-primary" IsSave/>
		</f:ButtonGroup>
  </cfif>

</f:Form>

	<script type="text/javascript">

		<cfif qMR.Category eq "m" >

			$(#mrId#frm1).setStyle('display','block');
		</cfif>
		function #mrId#changeWI(i){
			var p_= $(#mrId#frm1);
			if (i.value == 'r'){
				p_.setStyle('display','none');
			}else{
				p_.setStyle('display','block');
			}

		}
	</script>
</cfoutput>
