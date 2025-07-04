<cfoutput> 
	<style>
		##__sparepart_c_spare_part_item_t td:first-child, 
		##__sparepart_c_spare_part_item_t th:first-child,
		##__sparepart_c_critical_item  td:first-child,
		##__sparepart_c_critical_item  th:first-child{
			display: none;
		} 

		##__sparepart_c_spare_part_item_t tfoot td:first-child, 
		##__sparepart_c_critical_item_t tfoot td:first-child {
			display: table-cell; 
		}


	</style>
	<cfparam name="url.perpage" default="50"/>
	<cfset spId = '__sparepart_c'/>
	<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
	
	<g:Grid renderTo="#spId#_spare_part_item" url="modules/ajax/warehouse.cfm?cmd=getWarehouseItem" commandWidth="70px" class="table-hover table-condensed">
		<g:Columns>
			<g:Column id="ItemId" caption="##" field="whi.ItemId" />
			<g:Column id="Code" caption="ICN" searchable field="whi.Code" sortable/>
			<g:Column id="Description" searchable field="whi.Description" sortable />
			<g:Column id="VPN" searchable />
			<g:Column id="QOH" caption="Qty"/>
			<g:Column id="QOR"/>
			<g:Column id="QOO" hide/>
			<g:Column id="MinimumInStore" caption="Order Lv"/>
			<g:Column id="UnitPrice" caption="Unit Price" hide />
			<g:Column id="Location" field="sl.Code" caption="Shelf Location"/>
			<g:Column id="Obsolete" hide/>
			<g:Column id="AssetCategoryId" hide />
			<g:Column id="UMId" hide />
			<g:Column id="ShelfLocationId" hide />
			<g:Column id="DepartmentId" hide />
			<g:Column id="Maker" hide caption="Manufacturer" searchable/>
		</g:Columns>
		<g:Commands>
			<g:Command id="viewA" icon="file" help="View Spare Part"/>
		</g:Commands>

		<g:Event command="viewA">
			<g:Window 
				title="'View ""' + d[1] + '"" ' " 
				url="'modules/maintenance/spare_part/view_spare_part_item.cfm?from=sp'"
				id="view_sp_item"/>
		</g:Event>
	</g:Grid>  
</cfoutput>