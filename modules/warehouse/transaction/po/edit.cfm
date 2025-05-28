<cfparam default="0" name="url.id"/>
<cfset poId = "__transaction_c_all_po" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfquery name="qPO" >
	SELECT * FROM whs_po 
  WHERE POId = #val(url.id)#
</cfquery>

<cfquery name="qPOI" >
	SELECT 
    poi.*,
    CONCAT("[", i.Code, "] ", i.Description, " [", i.VPN, "]") ItemDescription,
    mri.Quantity QtyReq
  FROM whs_po_item poi
  INNER JOIN whs_mr_item mri  ON mri.MRItemId = poi.POItemId
  INNER JOIN whs_item i       ON mri.ItemId   = i.ItemId
  WHERE POId = #val(url.id)#
</cfquery>

<br/>
<br/>
<f:Form id="#poId#frm" action="modules/ajax/warehouse.cfm?cmd=SavePO" EditId="#url.id#"> 
<div>
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top"> 
			<f:TextBox name="Ref" label="Ref info" value="#qPO.Ref#" class="span10"/>
			<f:RadioBox name="Currency" inline showLabel label="Currency" selected="#qPO.Currency#" required ListValue="NGN,USD" ListDisplay="Naira,US Dollar" />
    </td>
    <td class="horz-div" valign="top"> 
      <f:TextBox name="MRId" value="#qPO.MRId#" disabled label="MR ##" class="span5"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"> 
      <!--- getWorkOrderNI--->
      <et:Table allowInput="false" allowUpdate id="ItemsFromMR">
        <et:Headers>
          <et:Header title="Item Description" size="7" type="text" disabled/>
          <et:Header title="Qty Req" size="1" type="int" disabled/>
          <et:Header title="Qty Ordered" size="1" type="int"/>
          <et:Header title="Total Price" size="2" type="float"/>
          <et:Header title="" size="1"/>
        </et:Headers>
				<!--- <et:Content Query="#qPOI#" Columns="IntegrateTable,PK" type="text,int" PKField="IntegratIonId"/> --->
				<et:Content Query="#qPOI#" Columns="ItemDescription,QtyReq,Quantity,UnitPrice" type="text,int,int,float" PKField="POItemId"/>
      </et:Table>    
    </td>
  </tr>
  <tr>
  	<td colspan="2"><hr/></td>
  </tr>
</table>

</div>

<f:ButtonGroup>
  <!--- <f:Button value="Create PO" class="btn-primary" IsSave subpageId="new_po" ReloadURL="modules/warehouse/transaction/po/new.cfm"/> --->
</f:ButtonGroup>

</f:Form>

</cfoutput>