<cfparam default="0" name="url.id"/>

<cfparam name="url.cid" default=""/>
<cfset mrId = "__transaction_c_all_mrni#url.cid#" & url.id/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qWI">
    SELECT 
		mri.*, mri.VPN Description
	FROM 
		whs_mr_item mri
  WHERE mri.MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#">
</cfquery> 

<cfquery name="qD">
	SELECT * FROM core_department ORDER BY Name 
</cfquery> 

<cfquery name="qU">
	SELECT * FROM core_unit ORDER BY Name 
</cfquery> 

<cfset qUM = application.com.Item.GetAllUM()/>
<cfset qItem = application.com.Item.GetItems()/>

<cfif url.id eq 0>
	<br/>
</cfif>
<f:Form id="#mrId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveMR&type=NI" EditId="#url.id#"> 
<div>
<table width="100%" border="0">
  <tr>
    <td colspan="2">
      <f:TextBox name="Note" class="span12"/>
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top"> 
			<f:TextBox name="Ref" label="Ref info" class="span10"/>
      <f:DatePicker name="DateIssued" label="Date Issued" required class="span8"/>
      <f:DatePicker name="DateRequired" label="Date Required" required class="span8"/>
    </td>
    <td class="horz-div" valign="top"> 
      <f:Select name="Currency" required ListValue="NGN,USD" ListDisplay="Naira,Dollars" class="span4"/>        
      <f:Select name="DepartmentId" label="Department" required ListValue="#ValueList(qD.DepartmentId)#" ListDisplay="#Valuelist(qD.Name)#" />
      <f:Select name="UnitId" label="Unit" ListValue="#ValueList(qU.UnitId)#" ListDisplay="#Valuelist(qU.Name)#" />
      <div class="control-group">
        <label for="__transaction_c_all_mrni0frmWorkOrderId" class="control-label">Work Order	</label>
        <div class="controls">
          <input type="text" class="span4" id="__transaction_c_all_mrni0frmWorkOrderId" name="WorkOrderId">
         <!---  <f:TextBox name="WorkOrderId" label="Work Order ##" class="span4"/> --->
          <button class="btn" type="button" onclick="lookupWorkOrder()"><i class="icon-search"></i></button>
        </div>
      </div>
    </td>
  </tr> 
  <tr>
  	<td colspan="2" > 
      <div style="border:1px solid ##ddd; padding:10px; border-radius:10px;">
        <!--- <span class="red">*</span> Materials captured here will eventually be added into the warehouse inventory. --->
        <et:Table allowInput id="ItemFromWO" bind="WorkOrderId" Event="keyup" 
          data="modules/ajax/warehouse.cfm?cmd=getWorkOrderNI">
          <et:Headers>
            <et:Header title="Non Stocked Materials/Services" size="5" type="text"/>
            <et:Header title="Qty" size="1" type="int"/>
            <et:Header title="UOM" size="1" type="text">
              <et:Select listvalue="#ValueList(qUM.Title,'`')#" delimiters="`"/>
            </et:Header>
            <et:Header title="OEM" size="1" type="text" required="false"/>
            <et:Header title="VPN" size="2" type="text" required="false"/>
            <et:Header title="Create ICN" size="1" type="text" required>
              <et:Select listvalue="Yes,No"/>
            </et:Header>
            <et:Header title="" size="1"/>
          </et:Headers>
        </et:Table> 
      </div>   
    </td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
  	<td colspan="2"> 
      <div style="border:1px solid ##ddd; padding:10px; border-radius:10px;">
        <et:Table allowInput id="DirectItems" bind="WorkOrderId" Event="keyup" 
          data="modules/ajax/warehouse.cfm?cmd=getWorkOrder">
          <et:Headers>
            <et:Header title="Warehouse Materials" size="7" type="int">
              <et:Select ListValue="#Valuelist(qItem.ItemId,'`')#" ListDisplay="#Valuelist(qItem.ItemDescription,'`')#" delimiters="`"/>
            </et:Header>
            <et:Header title="Qty" size="2" type="int" />
            <et:Header title="Unit Price" size="2" type="float" required="false"/>
            <et:Header title="" size="1"/>
          </et:Headers>
        </et:Table> 
      </div>
    </td>
  </tr>
  
</table>

</div>

<f:ButtonGroup>
  <f:Button value="Create new MR" class="btn-primary" IsSave subpageId="new_mrni" ReloadURL="modules/warehouse/transaction/new_mrni.cfm"/>
</f:ButtonGroup>

</f:Form>

</cfoutput>

<script>
function lookupWorkOrder() {
    const workOrderId = document.querySelector('[name="WorkOrderId"]').value.trim();
    
    if (!workOrderId) {
        alert('Please enter a Work Order ID');
        return;
    }

    const request = new Request.JSON({
        url: 'modules/ajax/warehouse.cfm',
        method: 'get',
        data: {
            cmd: 'lookupWorkOrder',
            id: workOrderId
        },
        onSuccess: response => {
            if (response?.success) {
              const fields = {
                'Note': response.data.note || '',
                'DepartmentId': response.data.unit_id || '',
                'UnitId': response.data.unit_id || ''
              };

              Object.entries(fields).forEach(([field, value]) => {
                const element = document.getElementById(`__transaction_c_all_mrni0frm${field}`);
                if (element) element.value = value;
              });
            } else {
              alert('Work Order not found.');
            }
        },
        onFailure: () => alert('Failed to lookup Work Order.')
    }).send();
}
</script>