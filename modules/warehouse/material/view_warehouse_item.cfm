<cfparam default="0" name="url.id"/>
<cfset whsId = "__material_c_warehouse_item" & url.id/>

<cfset Id1 = "#whsId#_1"/>
<cfset Id2 = "#whsId#_2"/>
<cfset Id3 = "#whsId#_3"/>
<cfset Id4 = "#whsId#_4"/>
<cfset Id5 = "#whsId#_5"/>
<cfset Id6 = "#whsId#_6"/>
<cfset Id7 = "#whsId#_7"/>
<cfset Id8 = "#whsId#_8"/>

<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />

<!--- Getting Data From Whs_item--->
<cfquery name="qWI">
	SELECT * FROM whs_item
    WHERE ItemId = #val(url.id)# AND 
	Obsolete = "No" AND Status <> "Deleted"
</cfquery>

<cfquery name="qSL" cachedWithin="#CreateTime(5,0,0)#">
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
    AND PK = #val(url.id)#
</cfquery>

<cfquery name="qIssue">
	SELECT 
		ii.ItemIssueId, isu.WorkOrderId,
		CONCAT(it.Surname, " ", it.OtherNames) IssuedTo,
		ib.OtherNames IssuedBy,
		isu.DateIssued,
		isu.Remark Note,
		ii.Quantity
	FROM whs_issue_item ii
	INNER JOIN whs_issue isu 	ON isu.IssueId = ii.IssueId
	INNER JOIN core_user it 	ON it.UserId = isu.IssuedToUserId
	INNER JOIN core_user ib 	ON ib.UserId = isu.IssuedByUserId
  WHERE ii.ItemId = #val(url.id)#
	ORDER BY isu.DateIssued DESC
	LIMIT 0,100
</cfquery>

<cfquery name="qRvs">
	SELECT * FROM (
		SELECT 
			poih.POItemHistoryId AS TransId,
			rb.OtherNames AS ReceivedBy,
			mr.Note,
			po.POId AS DocId,
			po.Ref AS Ref, 
			po.MRId, 
			poih.Date AS DateReceived, 
			poih.Quantity, "invoice" AS `Type`
		FROM whs_po_item_history poih
		INNER JOIN whs_po_item pi ON pi.POItemId = poih.POItemId
		INNER JOIN whs_po po ON po.POId = pi.POId
		INNER JOIN core_user rb ON rb.UserId = poih.ReceivedByUserId
		LEFT JOIN whs_mr mr ON mr.MRId = po.MRId
		WHERE pi.ItemId = #val(url.id)#

		UNION ALL

		SELECT 
			mri.MaterialReceivedItemId AS TransId,
			rb.OtherNames AS ReceivedBy,
			mr.Note,
			mrv.MaterialReceivedId DocId,
			mrv.Reference AS Ref, 
			mrv.MRId,  
			mrv.Date AS DateReceived, 
			mri.Quantity, "direct" AS `Type`
		FROM whs_material_received_item mri
		INNER JOIN whs_material_received mrv ON mrv.MaterialReceivedId = mri.MaterialReceivedId
		INNER JOIN core_user rb ON rb.UserId = mrv.ReceivedByUserId
		LEFT JOIN whs_mr mr ON mr.MRId = mrv.MRId
		WHERE mri.ItemId = #val(url.id)#
	) AS combined_results
	ORDER BY DateReceived DESC
	LIMIT 100;
</cfquery>

<cfquery name="qM">
	SELECT 
		mr.MRId,
		mr.Note,
		mr.Date,
		mri.Quantity,
		d.Name AS Department
	FROM whs_mr_item mri 
	INNER JOIN whs_mr mr ON mr.MRId = mri.MRId
	INNER JOIN core_department d ON d.DepartmentId = mr.DepartmentId
	WHERE mri.ItemId = #val(url.id)#
	ORDER BY mr.Date DESC
	LIMIT 100;
</cfquery>

<f:Form id="#whsId#frm" action="modules/ajax/warehouse.cfm?cmd=SaveWarehouseItem" EditId="#url.id#">
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
										<cfif len(qWI.Reference)>
                    	<f:label name="Reference" value="#qWI.Reference#"/>
										</cfif>
                    <f:label name="Shelf Location" value="#qSL.Code#"/>
										<cfif len(qWI.Maker)>
                    	<f:label name="Manufacturer" value="#qWI.Maker#"/>
										</cfif>
                    <f:label name="VPN" value="#qWI.VPN#"/>
                    <f:label name="UM" value="#qUM.Title#"/>
                    <f:label name="Minimum In Store" value="#qWI.MinimumInStore#"/>
                    <f:label name="Maximum In Store" value="#qWI.MaximumInStore#"/>

               </td>
           </tr>
        </table>
    </div>
    <div id="#Id2#">
<table class="table table-striped table-condensed table-hover"><thead><tr>
    <th>##</th><th>Asset</th>
  </tr></thead>
<cfset asid=qWI.AssetIds/>
<cfif qWI.AssetIds eq "">
	<cfset asid="0"/>
</cfif>
<cfquery name="qSP" cachedwithin="#CreateTime(1,0,0)#">
	SELECT * FROM asset
    WHERE AssetId IN (#asid#)
</cfquery>
<tbody>
<cfloop query="qSP">
  <tr><td>#qsp.currentrow#</td><td>#qSP.Description#</td></tr></cfloop>
  </tbody>

</table>
    </div>
    <div id="#Id3#">
			<div class="alert alert-info">Use this area to store equipment documents for easy access such as manuals, spreadsheets, or any other type of document.</div>
			<u:UploadFile id="Attachments" table="whs_item" pk="#url.id#" />
    </div>
    <div id="#Id4#">
			<div class="alert alert-info">Use this area to define custom fields that is specific to this Asset. </div>
			<util:ViewCustomFields table="whs_item" pk="#url.id#"/>
    </div>
    <div id="#Id5#">
			<table class="table table-striped table-condensed table-hover">
				<thead>
					<tr>
					<th nowrap="nowrap">Tran. ##</th>
					<th nowrap="nowrap">W.O. ##</th>
					<th>Note</th>
					<th>Issued to</th>
					<th>Issued by</th>
					<th nowrap="nowrap">Date</th>
					<th>Qty</th>
					</tr>
				</thead>
				<cfloop query="qIssue">
					<tr>
						<td>#qIssue.ItemIssueId#</td>
						<td>
							<a target="_blank" href="modules/maintenance/workorder/print_workorder.cfm?id=#qIssue.WorkOrderId#">#qIssue.WorkOrderId#</a>
						</td>
						<td>#qIssue.Note#</td>
						<td>#qIssue.IssuedTo#</td>
						<td>#qIssue.IssuedBy#</td>
						<td>#dateformat(qIssue.DateIssued,'dd-mmm-yyyy')#</td>
						<td>#qIssue.Quantity#</td>
					</tr>
				</cfloop>
			</table>
    </div>
    <div id="#Id6#">
			<table class="table table-striped table-condensed table-hover">
				<thead>
					<tr>
					<th nowrap="nowrap">Tran. ##</th>
					<th>MR. ##</th>
					<!--- <th>PO. ##</th> --->
					<th>Note</th>
					<th nowrap="nowrap">Received By</th>
					<th>Date</th>
					<th>Qty</th>
					</tr>
				</thead>
				<cfloop query="qRvs">
					<tr>
						<td nowrap="nowrap">#qRvs.TransId#</td>
						<td>
							<cfif qRvs.Type EQ "direct">
								<a target="_blank" href="modules/warehouse/transaction/received/print_m_received.cfm?id=#qRvs.DocId#">#qRvs.DocId#</a>
							<cfelse>
								<cfif val(qRvs.MRId)>
									<a target="_blank" href="modules/warehouse/transaction/mr/print_mr.cfm?id=#qRvs.MRId#">#qRvs.MRId#</a>
								</cfif>
							</cfif>
						</td>
						<td>#qRvs.Note#</td>
						<td>#qRvs.ReceivedBy#</td>
						<td nowrap="nowrap">#dateformat(qRvs.DateReceived,'dd-mmm-yyyy')#</td>
						<td>#qRvs.Quantity#</td>
					</tr>
				</cfloop>
			</table>
    </div>
    <div id="#Id7#">
			<table class="table table-striped table-condensed table-hover">
				<thead>
					<tr>
						<th nowrap="nowrap">M.R. ##</th>
						<th>Note</th>
						<th nowrap="nowrap">Department</th>
						<th>Date</th>
						<th>Qty</th>
					</tr>
				</thead>
				<cfloop query="qM">
					<tr>
						<td nowrap="nowrap">
							<a target="_blank" href="modules/warehouse/transaction/mr/print_mr.cfm?id=#qM.MRId#">#qM.MRId#</a>
						</td>
						<td>#qM.Note#</td>
						<td>#qM.Department#</td>
						<td>#dateformat(qM.Date,'dd-mmm-yyyy')#</td>
						<td>#qM.Quantity#</td>
					</tr>
				</cfloop>
			</table>
    </div>
     <nt:NavTab renderTo="#whsId#">
			<nt:Tab>
					<nt:Item title="General" isactive/>
					<nt:Item title="Use with"/>
					<nt:Item title="Attachments"/>
					<nt:Item title="Custom Field"/>
					<nt:Item title="Issues"/>
					<nt:Item title="Receipts"/>
					<nt:Item title="M.R."/>
			</nt:Tab>
			<nt:Content>
				<nt:Item id="#Id1#" isactive/>
				<nt:Item id="#Id2#"/>
				<nt:Item id="#Id3#"/>
				<nt:Item id="#Id4#"/>
				<nt:Item id="#Id5#"/>
				<nt:Item id="#Id6#"/>
				<nt:Item id="#Id7#"/>
			</nt:Content>
     </nt:NavTab>
		<cfif url.id eq 0>
			<f:ButtonGroup>
				<f:Button value="Create new Item" class="btn-primary" IsSave/>
			</f:ButtonGroup>
     </cfif>
 </f:Form>

</cfoutput>
