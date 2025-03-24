<!---
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
--->
<cfoutput>
<style>
	tr.tt td{border-bottom: 1px solid ##fff !important;}
	tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
</style>
<cfset trans = '__transaction_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="transaction/issue/material_issue.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">

	<div class="span2" style="position:fixed;">
		<n:Nav renderTo="#trans#">
		<!--- subpageId="save_mr_ni" ReloadURL="modules/warehouse/transaction/received/save_m_received.cfm?newpage=true"/> --->

			<n:NavItem type="header" title="Issuance"/>
			<n:NavItem title="Issue Out Material" url="modules/warehouse/transaction/issue/save_material_issue.cfm?newpage=true" id="save_material_issue"/>
			<n:NavItem title="Material Issued" isactive url="modules/warehouse/transaction/issue/material_issue.cfm" id="material_issue"/>
			<n:NavItem title="Return Material back" url="modules/warehouse/transaction/save_material_returned.cfm?newpage=true" id="save_material_returned"/>
			<n:NavItem title="Material Returns" url="modules/warehouse/transaction/return/material_returned.cfm" id="material_returned"/>
			
			<n:NavItem type="header" title="Material Requisition"/>
			<n:NavItem title="New MR (Stocked)" url="modules/warehouse/transaction/save_mr.cfm?newpage=true" id="save_mr"/>
			<n:NavItem title="New MR (Non-Stocked)" url="modules/warehouse/transaction/new_mrni.cfm?newpage=true" id="new_mrni"/>
			<n:NavItem title="M.R. (In Stock)" url="modules/warehouse/transaction/mr/all_mr.cfm" id="all_mr"/>
			<n:NavItem title="M.R. (Not In Stock)" url="modules/warehouse/transaction/mr/all_mrni.cfm"  id="all_mrni"/>
			<n:navItem type="divider">
			<n:NavItem title="Receive into Store" url="modules/warehouse/transaction/received/save_m_received.cfm?newpage=true" id="save_mr_ni"/>
			<n:NavItem title="Material Received" url="modules/warehouse/transaction/received/m_received.cfm" id="material_received"/>
			
			<!--- <n:navItem type="divider"> --->
			<n:NavItem type="header" title="Delivery"/>
			<n:NavItem title="M.R. Delivery Note" url="modules/warehouse/transaction/delivery/all_delivery_note.cfm"  id="all_delivery_note"/>
			<n:NavItem title="Material Delivery Note" url="modules/warehouse/transaction/delivery/all_mdelivery_note.cfm"  id="all_mdelivery_note"/>
			<n:NavItem type="header" title="Reports"/>
			<n:NavItem title="Recommended Order list" url="modules/warehouse/transaction/rec_order_list.cfm" id="rec_order_list"/>
			<!---<n:NavItem title="Physical Inventory Worksheet" url="modules/settings/warehouse/shelf_location.cfm" id="shelf_location"/>--->
			<n:NavItem title="Issue to Operational unit" url="modules/warehouse/transaction/issue/report_issue.cfm" id="report_issue"/>
			<n:NavItem title="Received Items" url="modules/warehouse/transaction/received/report_receipt.cfm" id="report_receipt"/>
		</n:Nav>
	</div>
    <div class="span10" style="float:right">
    	<div id="#trans#_grid">
        <div class="sub_page material_issue" id="#trans#_material_issue"></div>
      </div>
    </div>
  </div>
</div>
</cfoutput>
