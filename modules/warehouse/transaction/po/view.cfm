<cfparam default="0" name="url.id"/>

<cfset poId = "__transaction_c_view_po" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qI = application.com.Transaction.GetPOItems(url.id) />
<cfset qPO = application.com.Transaction.GetPO(url.id) />

<f:Form id="#poId#frm" action="x"> 
<div>

<table width="100%" border="0">
  <tr>
    <td width="50%" valign="top"> 
			<f:Label name="MR ##" value="#qPO.MRId#"/>
			<f:Label name="Reference" value="#qPO.Ref#"/>
			<f:Label name="Delivery Info" value="#qPO.DeliveryInfo#"/>
    </td>
    <td class="horz-div" valign="top"> 
			<f:Label name="Created by" value="#qPO.CreatedBy# on #dateFormat(qPO.Date,'yyyy/mm/dd')#"/>
			<cfif isDate(qPO.DateReceived)>
				<f:Label name="Received by" value="#qPO.ReceivedBy# on #dateFormat(qPO.DateReceived,'yyyy/mm/dd')#"/>
			</cfif>
    </td>
  </tr> 
  <tr>
  	<td colspan="2"><br/>
			<table class="table table-hover table-striped table-bordered">
				<thead>
					<tr>
						<th width="1">##</th>
						<th>ICN</th>
						<th>Description</th>
						<th width="1">Quantity</th> 
						<th width="1">Received</th> 
						<th nowrap="nowrap" width="65">Unit price</th>
						<th width="1">Subtotal</th>
					</tr>
				</thead>
				<tbody>
					<cfset tsum=0/>
					<cfloop query="qI">
						<tr>
							<td>#qI.CurrentRow#</td>
							<td>#qI.ICN#</td>
							<td>#qI.ItemDescription#</td>
							<td>#qI.Quantity#</td>
							<td>#qI.RQuantity# #qI.UM#</td>
							<td style="text-align:right;">#numberformat(qI.Unitprice,'9,999.99')#</td>
							<td style="text-align:right;">
							<cfset lsum = qI.Unitprice*qI.Quantity/>
							<cfset tsum = tsum + lsum/>
							#numberformat(lsum,'9,999.99')#</td> 
						</tr>
					</cfloop>
					<tr>
						<td colspan="6"></td>
						<td style="text-align:right;">#numberformat(tsum,'9,999.99')#</td>
					</tr>
				</tbody>
			</table>  		
     </td>
  </tr>
</table>

</div>
 


</f:Form>

</cfoutput>