<cfoutput>  
	<cfparam name="url.perpage" default="50"/>
	<cfset spId = '__sparepart_c'/>
	<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
	
	<g:Grid renderTo="#spId#_critical_item" url="modules/ajax/warehouse.cfm?cmd=getWarehouseItem&critical=Yes" commandWidth="70px" class="table-hover table-condensed">
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
				url="'modules/maintenance/spare_part/view_spare_part_item.cfm?from=cl'"
				id="view_cl_item"/>
		</g:Event>
	</g:Grid>  
</cfoutput>