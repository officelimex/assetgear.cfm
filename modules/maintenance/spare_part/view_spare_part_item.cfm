<cfparam default="0" name="url.id"/>
<cfparam default="cl" name="url.from"/>

<cfset spId = "__sparepart_c_spare_part_item" & url.id/>

<cfset Id1 = "#spId#_1"/>
<cfset Id4 = "#spId#_4"/>
<cfset Id3 = "#spId#_3"/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />

<!--- Getting Data From Whs_item--->
<cfquery name="qWI" cachedwithin="#CreateTime(5,0,0)#">
	SELECT * FROM whs_item 
  WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>
  	
<cfquery name="qSL" cachedwithin="#CreateTime(5,0,0)#">
	SELECT * FROM shelf_location
	WHERE ShelfLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.ShelfLocationId#">
	ORDER BY CAST(SUBSTRING(code, 2) AS UNSIGNED)
</cfquery>

<cfquery name="qD" cachedwithin="#CreateTime(5,0,0)#">
	SELECT * FROM core_department 
    WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.DepartmentIds#">
</cfquery>

<!--- Get for Asset Category --->
<cfquery name="qAC" cachedwithin="#CreateTime(5,0,0)#">
	SELECT * FROM asset_category 
    WHERE AssetCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.AssetCategoryId#">
</cfquery>

<!--- Get for UM --->
<cfquery name="qUM" cachedwithin="#CreateTime(5,0,0)#">
	SELECT * FROM um
    WHERE UMId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qWI.UMId#">
</cfquery>

<!--- Get Custom Fields --->
<cfquery name="qCu">
	SELECT * 
    FROM custom_field
    WHERE `Table` = "whs_item"
    AND PK = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

<cfif url.id eq 0><br/><br/></cfif>

	<f:Form id="#spId#frm" action="modules/ajax/warehouse.cfm?cmd=x" EditId="#url.id#"> 
		<div id="#Id1#">
			<table border="0" width="100%">
				<tr>
					<td width="50%" valign="top">
							<util:FileView type="p" table="whs_item" pk="#url.id#" source="doc/photo/" column="1" height="275px"/>
					</td>
					<td class="horz-div"  valign="top">
							
						<f:label name="Description" value="#qWI.Description#"/> 
						<f:label name="Asset Category" value="#qAC.Name#"/>
						<f:label name="Department" value="#qD.Name#"/> 
						<f:label name="Reference" value="#qWI.Reference#"/> 
						<f:label name="Shelf Location" value="#qSL.Code#"/>
						<f:label name="VPN" value="#qWI.VPN#"/> 
						
						<f:label name="UM" value="#qUM.Title#"/> 
						<f:label name="Minimum In Store" value="#qWI.MinimumInStore#"/> 
						<f:label name="Maximum In Store" value="#qWI.MaximumInStore#"/> 
					
					</td>
					</tr>
			</table>
		</div>
		<div id="#Id4#">
			<div class="alert alert-info">Use this area to define custom fields that is specific to this Asset. </div>
			<util:ViewCustomFields table="whs_item" pk="#url.id#"/> 
		</div>
		<div id="#Id3#">
			<div class="alert alert-info">Use this area to store equipment documents for easy access such as manuals, spreadsheets, or any other type of document.</div>
			<u:UploadFile id="Attachments" table="whs_item" pk="#url.id#" />
		</div>

		<nt:NavTab renderTo="#spId#">
			<nt:Tab>
				<nt:Item title="General" isactive/>
				<nt:Item title="Other details"/>
				<nt:Item title="Attachments"/>
			</nt:Tab>
			<nt:Content>
				<nt:Item id="#Id1#" isactive/>
				<nt:Item id="#Id4#"/>
				<nt:Item id="#Id3#"/>
			</nt:Content>
		</nt:NavTab>
		<cfif request.IsPlanner>
			<f:ButtonGroup>
				<cfif qWI.Critical EQ "Yes">
					<f:Button IsSave 
						value="Remove from Critical list" 
						class="btn-warning" 
						actionURL="modules/ajax/maintenance.cfm?cmd=removeFromCriticalList"
						onSuccess="win_view_#url.from#_item.close()" />
				<cfelse>
					<f:Button IsSave 
						value="Make Critical" 
						class="btn-success" 
						actionURL="modules/ajax/maintenance.cfm?cmd=addToCriticalList"
						onSuccess="win_view_#url.from#_item.close()" /> 
				</cfif>
			</f:ButtonGroup>
		</cfif>
	</f:Form>

</cfoutput>
