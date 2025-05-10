<cfoutput>
<cfset wrhou = '__material_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />
<cfparam name="url.ob" default="">
<cfparam name="url.sortorder" default="DESC"/>
<cfparam name="url.perpage" default="50"/>
<style>
##__material_c_warehouse_item_t td:first-child, 
##__material_c_warehouse_item_t th:first-child {
  display: none;
} 

##__material_c_warehouse_item_t tfoot td:first-child {
    display: table-cell; 
}
</style>
<g:Grid renderTo="#wrhou#_warehouse_item#url.ob#" url="modules/ajax/warehouse.cfm?cmd=getWarehouseItem&ob=#url.ob#" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="ItemId" caption="##" sortable  />
		<g:Column id="Code" caption="ICN" searchable field="whi.Code" sortable/>
		<g:Column id="Description" searchable field="whi.Description" sortable />
		<g:Column id="VPN" searchable />
		<g:Column id="QOH" sortable/>
		<g:Column id="QOR" sortable/>
		<g:Column id="QOO" sortable/>
		<g:Column id="MinimumInStore" caption="Order Lv"/>
		<g:Column id="UnitPrice" caption="Unit Price" hide/> 
		<g:Column id="Location" searchable field="sl.Code" caption="Shelf Location"/>
		<g:Column id="Obsolete" hide/>
		<g:Column id="AssetCategoryId" hide />
		<g:Column id="UMId" hide />
		<g:Column id="ShelfLocationId" hide />
		<g:Column id="DepartmentId" hide />
		<g:Column id="Maker" searchable caption="Manufacturer" hide />
	</g:Columns>
	<g:Commands>
		<g:Command id="editItem" icon="pencil"/>
		<g:Command id="viewItem" icon="file"/>
		<g:Command id="adjustItem" icon="indent-right" help="Inventory Correction"/>
	</g:Commands>

	<g:Event command="editItem">
		<g:Window title="'Edit ""' + d[1] + '"" ' " width="900px" height="435px" url="'modules/warehouse/material/save_warehouse_item.cfm'">
			<g:Button value="Delete" class="btn-danger" icon="icon-remove icon-white" executeURL="'controllers/Warehouse.cfc?method=deleteItem'"/>
			<g:Button IsSave />
		</g:Window>
	</g:Event>
	<g:Event command="viewItem">
		<g:Window title="'View Warehouse Item'" url="'modules/warehouse/material/view_warehouse_item.cfm'">
		</g:Window>
	</g:Event>
	<g:Event command="adjustItem">
		<g:Window title="'Inventory Correction on ' + d[1]" width="900px" height="310px" url="'modules/warehouse/material/inv_correction.cfm'">
			<g:Button value="Correct Item" IsSave />
		</g:Window>
	</g:Event>
</g:Grid>

</cfoutput>
