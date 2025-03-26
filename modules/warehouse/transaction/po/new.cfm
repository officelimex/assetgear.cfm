<cfparam default="0" name="url.id"/>
<cfset poId = "__transaction_c_all_po" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qItem = application.com.Item.GetItems()/>
<br/>
<br/>
<f:Form id="#poId#frm" action="modules/ajax/warehouse.cfm?cmd=SavePO" EditId="#url.id#"> 
<div>
<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top"> 
			<f:TextBox name="Ref" label="Ref info" class="span10"/>
    </td>
    <td class="horz-div" valign="top"> 
      <f:TextBox name="MRId" label="MR ##" class="span5"/>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"> 
      <!--- getWorkOrderNI--->
      <et:Table allowInput="false" allowUpdate height="330px" id="ItemsFromMR" bind="MRId" Event="keyup" 
        data="modules/ajax/warehouse.cfm?cmd=getMRItems">
        <et:Headers>
          <et:Header title="Item Description" size="5" type="text" disabled/>
          <et:Header title="Qty Req" size="1" type="int"/>
          <et:Header title="Qty Ordered" size="1" type="int"/>
          <et:Header title="Currency" size="1" type="text" required="true">
						<et:Select ListValue="NGN,USD"/>
					</et:Header>
          <et:Header title="Unit Price" size="2" type="float"/>
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
  <f:Button value="Create new MR" class="btn-primary" IsSave subpageId="new_mrni" ReloadURL="modules/warehouse/transaction/new_mrni.cfm"/>
</f:ButtonGroup>

</f:Form>

</cfoutput>