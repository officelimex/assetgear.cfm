<cfparam default="0" name="url.id"/>

<cfset poId = "__transaction_c_view_po" & url.id/>

<cfoutput>
<cfimport taglib="../../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset qI = application.com.Transaction.GetPOItems(url.id) />
<cfset qPO = application.com.Transaction.GetPO(url.id) />

<style>
	.history-rows thead th {
		padding: 2px 0px 2px 5px;
		margin: 0; font-size: 10px;
	}
	.history-rows tbody td {
		padding: 2px 0px 2px 5px;
		font-size: 11px;
	}
</style>
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
						<th nowrap="nowrap" width="65">Cost</th>
					</tr>
				</thead>
				<tbody>
					<cfset tsum=0/>
					<cfloop query="qI">
						<cfquery name="qH">
							SELECT 
								ph.*,
								CONCAT(u.Surname," ",u.OtherNames) ReceivedBy
							FROM whs_po_item_history ph 
							INNER JOIN core_user u ON u.UserId = ph.ReceivedByUserId
							WHERE POItemId = #val(qI.POItemId)#
						</cfquery>
						<tr class="item-row <cfif qI.Quantity NEQ qI.PQuantity>warning bold</cfif>" onclick="toggleHistory(this, '#qI.POItemId#')" style="cursor: pointer;">
							<td>#qI.CurrentRow#</td>
							<td>#qI.ICN#</td>
							<td>#qI.ItemDescription#</td>
							<td>#qI.Quantity#</td>
							<td>#qI.PQuantity# #qI.UM#</td>
							<td style="text-align:right;">#numberformat(qI.UnitPrice,'9,999.99')#</td>
							<cfset tsum = qI.UnitPrice + tsum/>
						</tr>
						<cfif qH.RecordCount>
							<tr id="history_#qI.POItemId#" class="history-rows" style="display: none;">
								<td colspan="6">
									<table class="table table-striped">
										<thead>
											<tr>
												<th width="50px"></th>
												<th>##</th>
												<th>Date</th>
												<th>Received By</th>
												<th>Ref</th>
												<th></th> 
											</tr>
										</thead>										
										<tbody> 
											<cfloop query="qH">
												<tr class="history-item ">
													<td></td>
													<td>#qH.Currentrow#</td>
													<td>#dateFormat(qH.Date,"yyyy-mm-dd")#</td>
													<td>#qH.ReceivedBy#</td>
													<td>#qH.Ref#</td>
													<td align="right">#qH.Quantity# #qI.UM#</td>
												</tr>
											</cfloop>
										</tbody>
									</table>
								</td>
							</tr>
						</cfif>
					</cfloop>
					<tr>
						<td colspan="5"></td>
						<td style="text-align:right;">#numberformat(tsum,'9,999.99')#</td>
					</tr>
				</tbody>

			</table>  		
     </td>
  </tr>
</table>

</div>
 
</f:Form>

<script>
	function toggleHistory(element, itemId) {
		var historyRow = document.getElementById('history_' + itemId);
		if (historyRow) {
			if (historyRow.style.display === 'none') {
				historyRow.style.display = 'table-row';
				element.classList.add('active');
			} else {
				historyRow.style.display = 'none';
				element.classList.remove('active');
			}
		}
	}
</script>

</cfoutput>