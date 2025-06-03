<cfparam default="0" name="url.id"/>
<cfset poId = "__transaction_c_all_po_d" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />
<cfset qWI = application.com.Item.GetItems()/>

<br/>
<br/>
<f:Form id="#poId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveDirectPO" EditId="#url.id#"> 
<div>
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top"> 
			<f:TextBox name="Ref" label="Ref info" class="span7" required/>
			<f:RadioBox name="Currency" inline showLabel label="Currency" required ListValue="NGN,USD" ListDisplay="Naira,US Dollar" />
    </td>
    <td width="50%" valign="top"> 
      <f:DatePicker name="Date" label="Date Received" required class="span5" type="date" />								
			<f:TextBox name="DeliveryInfo" label="Delivery Info" class="span5"/>
    </td>
  </tr>
  <tr>
  	<td colspan="2">
      <hr/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"> 
      <et:Table allowInput allowUpdate id="Items">
        <et:Headers>
          <et:Header title="Description" size="6" type="int">
            <et:Select ListValue="#Valuelist(qWI.ItemId,'`')#" ListDisplay="#Valuelist(qWI.ItemDescriptionWithVPNAndQOH,'`')#" delimiters="`"/>
          </et:Header>
          <et:Header title="Quantity" size="1" type="int" disabled/>
          <et:Header title="Unit Price" size="2" type="float"/>
          <et:Header title="Waybill/Packing List" size="2" type="text" required="false"/>
          <et:Header title="" size="1"/>
        </et:Headers>
      </et:Table>    
    </td>
  </tr>
  <tr>
  	<td colspan="2"><hr/></td>
  </tr>
</table>

</div>

<f:ButtonGroup>
  <f:Button value="Create New Direct PO" class="btn-primary" IsSave subpageId="new_po_d" ReloadURL="modules/warehouse/transaction/po/new_d.cfm"/>
</f:ButtonGroup>

</f:Form>

</cfoutput>