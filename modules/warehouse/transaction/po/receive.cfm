<cfparam default="0" name="url.id"/>

<cfset poId = "__transaction_c_receive_po" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qI = application.com.Transaction.GetPOItems(url.id) />
<cfset qPO = application.com.Transaction.GetPO(url.id) />


<f:Form id="#poId#frm" action="modules/ajax/warehouse.cfm?cmd=ReceiveOrder" EditId="#url.id#"> 
  <div>
    <table width="100%" border="0">
      <tr>
        <td width="50%" valign="top"> 
          <f:Label name="PO ##" value="#qPO.POId#"/>
          <f:Label name="Reference" value="#qPO.Ref#"/>
          <f:TextBox name="DeliveryInfo" label="Waybill/Invoice No"/>  
          <input type="hidden" name="mrid" value="#qPO.MRId#"/>
        </td>
        <td class="horz-div" valign="top"> 
          <f:Label name="Created on" value="#dateFormat(qPO.Date,'yyyy/mm/dd')#"/>
          <f:DatePicker name="DateReceived" label="Date Received" required value="#dateFormat(now(),'dd/mmm/yyyy')#"/>
        </td>
      </tr> 
      <tr>
        <td colspan="2"> 
          <et:Table allowInput="false" allowUpdate id="POItemId">
            <et:Headers>
              <et:Header title="Description" size="7" type="text" disabled />
              <et:Header title="Ordered Qty" size="1" type="int" disabled/>
              <et:Header title="Received Qty" size="1" type="int" />
              <et:Header title="Waybill/Inv No" size="2" type="text" required="false"/>
              <et:Header title="" size="1"/>
            </et:Headers>
            <et:Content Query="#qI#" Columns="ItemDescription,Quantity,RQuantity,Ref" type="text,int,int,text" PKField="POItemId"/>
          </et:Table>
        </td>
      </tr>
    </table>
  </div>

  <f:ButtonGroup>
    <f:Button value="Receive Items" class="btn-primary" IsSave onSuccess="win_receive_po.close()"/>
  </f:ButtonGroup>
</f:Form>

</cfoutput>