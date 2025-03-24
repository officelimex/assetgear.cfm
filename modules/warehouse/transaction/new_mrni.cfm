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

<cfquery name="qID">
	Select * From whs_item
</cfquery>

<cfquery name="qD">
	SELECT * FROM core_department ORDER BY Name 
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
    <td width="50%" valign="top"> 
      <f:TextBox name="Note" requiredclass="span10"/>
      <f:DatePicker name="DateIssued" label="Date Issued" required />
      <f:DatePicker name="DateRequired" label="Date Required" required/>
    </td>
    <td class="horz-div" valign="top"> 
      <f:Select name="Currency" required ListValue="NGN,USD" ListDisplay="Naira,Dollars" class="span4"/>        
      <f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(qD.DepartmentId)#" ListDisplay="#Valuelist(qD.Name)#" />
      <f:TextBox name="WorkOrderId" label="Work Order ##" class="span5"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"> 
      <et:Table allowInput height="330px" id="ItemFromWO" bind="WorkOrderId" Event="keyup" 
        data="modules/ajax/warehouse.cfm?cmd=getWorkOrderNI">
        <et:Headers>
          <et:Header title="Materials from Work Order" size="5" type="text"/>
          <et:Header title="Qty" size="1" type="int"/>
          <et:Header title="UOM" size="1" type="text">
            <et:Select listvalue="#ValueList(qUM.Title,'`')#" delimiters="`"/>
          </et:Header>
          <et:Header title="OEM" size="2" type="text" required="false"/>
          <et:Header title="Part/Serial/Model No" size="2" type="text" required="false"/>
          <et:Header title="" size="1"/>
        </et:Headers>
      </et:Table>    
    </td>
  </tr>
  <tr>
  	<td colspan="2"><hr/></td>
  </tr>
  <tr>
  	<td colspan="2"> 
      <et:Table allowInput height="222px" id="DirectItems" bind="WorkOrderId" Event="keyup" 
        data="modules/ajax/warehouse.cfm?cmd=getWorkOrder">
        <et:Headers>
          <et:Header title="Materials from Warehouse" size="7" type="int">
            <et:Select ListValue="#Valuelist(qItem.ItemId,'`')#" ListDisplay="#Valuelist(qItem.ItemDescription,'`')#" delimiters="`"/>
          </et:Header>
          <et:Header title="Qty" size="2" type="int" />
          <et:Header title="Unit Price" size="2" type="float" required="false"/>
          <et:Header title="" size="1"/>
        </et:Headers>
      </et:Table> 
    </td>
  </tr>
</table>

</div>

<f:ButtonGroup>
  <f:Button value="Create new MR" class="btn-primary" IsSave subpageId="new_mrni" ReloadURL="modules/warehouse/transaction/new_mrni.cfm"/>
</f:ButtonGroup>

</f:Form>

</cfoutput>