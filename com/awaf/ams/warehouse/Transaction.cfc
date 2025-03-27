<cfcomponent>

	<cffunction name="init" returnType="Transaction" access="public">

		<cfset this.PO_SQL = '
			SELECT
				po.*,
				mr.Note,
				CONCAT(u.Surname, " ", u.OtherNames) CreatedBy,
				CONCAT(r.Surname, " ", r.OtherNames) ReceivedBy
			FROM whs_po po
			INNER JOIN core_user u 	ON u.UserId = po.CreatedByUserId
			LEFT  JOIN core_user r 	ON r.UserId = po.ReceivedByUserId
			INNER JOIN whs_mr mr 		ON mr.MRId 	= po.MRId 
		'/>

		<cfset this.PO_COUNT_SQL = '
			SELECT COUNT(po.POId) C
			FROM whs_po po
			INNER JOIN core_user u 	ON u.UserId = po.CreatedByUserId
			INNER JOIN whs_mr mr 		ON mr.MRId 	= po.MRId 
		'/>

		<cfset this.PO_ITEM_SQL = '
			SELECT
				poi.*,
				i.Description ItemDescription, i.Code ICN,
				um.Code UM,
				po.Currency
			FROM whs_po_item poi
			INNER JOIN whs_item i ON i.ItemId = poi.ItemId
			INNER JOIN um 				ON um.UMId 	= i.UMId
			INNER JOIN whs_po po 	ON po.POId 	= poi.POId
		'/>

		<cfset this.MR_SQL = '
			SELECT
				mr.*,
				d.Name Department,
				CONCAT(u.Surname, " ", u.OtherNames) CreatedBy,
				CONCAT(mgr.Surname, " ", mgr.OtherNames) ManagerName,
				wo.Description WODescription, CONCAT(cr.Surname, " ", cr.OtherNames) WOCreatedBy, 
					cr.UserId WOCreatedByUserId,
					wo.FSUserId, wo.DateOpened WOCreated, wo.FSApprovedDate,
					un.Name WOUnit, wd.Name WODepartment
			FROM whs_mr mr
			INNER JOIN core_user u 				ON u.UserId 				= mr.CreatedByUserId
			LEFT JOIN core_department d 	ON d.DepartmentId 	= mr.DepartmentId
			LEFT JOIN work_order wo 			ON wo.WorkOrderId 	= mr.WorkOrderId 
			LEFT JOIN core_user cr 				ON cr.UserId 				= wo.CreatedByUserId
			LEFT JOIN core_user mgr 			ON mgr.UserId 			= wo.FSUserId
			LEFT JOIN core_unit un 				ON un.UnitId 				= wo.UnitId
			LEFT JOIN core_department wd 	ON wd.DepartmentId	= wo.DepartmentId
		'/>
		<cfset this.MR_COUNT_SQL = '
			SELECT COUNT(mr.MRId) C
			FROM whs_mr mr
		'/>

		<cfset this.MR_ITEM_SQL = '
			SELECT
				mri.*,
		  	CONCAT(wi.Description,"~",wi.ItemId) ItemDescription, 
				wi.Description,	wi.Obsolete, wi.Status,
				wi.Currency, wi.Code, wi.VPN ItemVPN, wi.Maker,
				um.Code UM
			FROM whs_mr_item mri
			INNER JOIN whs_item wi ON wi.ItemId = mri.ItemId
			INNER JOIN um ON um.UMId = wi.UMId
		'/>

		<cfset this.MR_NI_ITEM_SQL = '
			SELECT
				mri.*, mri.VPN Item
			FROM whs_mr_item mri
		'/>

		<cfset this.MI_SQL = '
			SELECT
				mi.*,
				CONCAT(cu.Surname," ",cu.OtherNames) IssuedBy,
				CONCAT(cu2.Surname," ",cu2.OtherNames) IssuedTo,
				d.Name Department,
				wo.Description WONote
			FROM whs_issue mi
			LEFT JOIN work_order wo 			ON wo.WorkOrderId = mi.WorkOrderId
			INNER JOIN core_department d 	ON mi.DepartmentId = d.DepartmentId
			INNER JOIN core_user cu 			ON mi.IssuedByUserId = cu.UserId
			INNER JOIN core_user cu2 			ON mi.IssuedToUserId = cu2.UserId
		'/>

		<cfset this.MI_COUNT_SQL = '
			SELECT
				COUNT(mi.IssueId) C
			FROM whs_issue mi
			LEFT JOIN work_order wo 			ON wo.WorkOrderId = mi.WorkOrderId
			INNER JOIN core_department d ON mi.DepartmentId = d.DepartmentId
			INNER JOIN core_user cu ON mi.IssuedByUserId = cu.UserId
			INNER JOIN core_user cu2 ON mi.IssuedToUserId = cu2.UserId
		'/>

		<cfset this.MI_ITEM_SQL = '
			SELECT
				mii.*,
				mi.DateIssued, mi.WorkOrderId,wi.Code,
				d.Name Department,
				CONCAT(wi.Description," ",wi.VPN) Item, wi.Currency,
				um.Code UM
			FROM whs_issue_item mii
			INNER JOIN whs_issue mi ON mi.IssueId = mii.IssueId
			INNER JOIN core_department d ON d.DepartmentId = mi.DepartmentId
			INNER JOIN whs_item wi ON wi.ItemId = mii.ItemId
			INNER JOIN um ON um.UMId = wi.UMId
		'/>

		<cfset this.MATERIAL_RECEIVED_ITEM_SQL = '
			SELECT
				ri.*,
				r.Date, r.MRId,
				CONCAT("[",i.Code,"] ",i.Description," ",i.VPN) Item,
				um.Code UM
			FROM whs_material_received_item ri
			INNER JOIN whs_material_received r ON r.MaterialReceivedId = ri.MaterialReceivedId
			INNER JOIN whs_item i ON (ri.ItemId = i.ItemId)
			INNER JOIN um ON (um.UMId = i.UMId)
		'/>

		<cfset this.MATERIAL_RECEIVED_SQL = '
            SELECT
            	r.*,
                CONCAT(cu.Surname," ",cu.OtherNames) ReceivedBy
            FROM whs_material_received r
        	-- LEFT JOIN whs_mr mr ON (mr.MRId = r.MRId)
        	INNER JOIN core_user cu ON (r.ReceivedByUserId = cu.UserId)
		'/>

		<cfset this.MATERIAL_RECEIVED_COUNT_SQL = '
            SELECT
            	COUNT(r.MaterialReceivedId) C
            FROM whs_material_received r
        	-- LEFT JOIN whs_mr mr ON (mr.MRId = r.MRId)
		'/>

		<cfset this.MATERIAL_RETURN_SQL = '
			SELECT
				wr.*,
				CONCAT(cu.Surname," ",cu.OtherNames) ReturnedBy,
				CONCAT(cu2.Surname," ",cu2.OtherNames) ReturnedTo,
				cd.`Name` as Department
			FROM whs_return AS wr
			INNER JOIN core_user AS cu ON wr.ReturnedByUserId = cu.UserId
			INNER JOIN core_user AS cu2 ON wr.ReturnedToUserId = cu2.UserId
			INNER JOIN whs_issue wi ON wr.IssueId = wi.IssueId
			INNER JOIN core_department cd ON wi.DepartmentId = cd.DepartmentId
		'/>

		<cfset this.MATERIAL_RETURN_COUNT_SQL = '
			SELECT COUNT(ReturnId) C
			FROM whs_return
		'/>

		<cfset this.DN_SQL = '
			SELECT
				dn.*,
				CONCAT(cu.Surname," ",cu.OtherNames) DeliverTo,
				d.`Name` as Department
			FROM whs_dn AS dn
			INNER JOIN core_user AS cu ON dn.DeliverToUserId= cu.UserId
			INNER JOIN whs_mr mr ON mr.MRId = dn.MRId
			INNER JOIN core_department d ON d.DepartmentId = mr.DepartmentId
		'/>

		<cfset this.DN_COUNT_SQL = '
			SELECT COUNT(DeliveryNoteId) C
			FROM whs_dn
		'/>

		<cfreturn this/>
	</cffunction>

	<cffunction name="GetDN" return="query" access="public">
		<cfargument name="did" hint="delivery note id" required="true" type="numeric"/>

		<cfquery name="qDN">
			#this.DN_SQL#
			WHERE dn.DeliveryNoteId = <cfqueryparam value="#arguments.did#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qDN/>
	</cffunction>

	<cffunction name="GetDNItems" return="query" access="public">
		<cfargument name="did" hint="dn id" required="true" type="numeric"/>

		<cfquery name="qdni">
            SELECT dni.*
            FROM whs_dn_item dni
			WHERE dni.DeliveryNoteId = <cfqueryparam value="#arguments.did#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qdni/>
	</cffunction>

	<cffunction name="GetMR" return="query" access="public">
		<cfargument name="mrid" hint="material requisition id" required="true" type="numeric"/>

		<cfquery name="qMR">
			#this.MR_SQL#
			WHERE mr.MRId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMR/>
	</cffunction>

	<cffunction name="GetPO" return="query" access="public">
		<cfargument name="poid" hint="po id" required="true" type="numeric"/>

		<cfquery name="qPO">
			#this.PO_SQL#
			WHERE po.POId = <cfqueryparam value="#arguments.poid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qPO/>
	</cffunction>

	<cffunction name="GetMaterialReceived" return="query" access="public">
		<cfargument name="mrid" hint="material received id" required="true" type="numeric"/>

		<cfquery name="qMR">
			#this.MATERIAL_RECEIVED_SQL#
			WHERE r.MaterialReceivedId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMR/>
	</cffunction>

	<cffunction name="GetMaterialReceivedItems" return="query" access="public">
		<cfargument name="mrid" hint="material received id" required="true" type="numeric"/>

		<cfquery name="qMR">
			#this.MATERIAL_RECEIVED_ITEM_SQL#
			WHERE ri.MaterialReceivedId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMR/>
	</cffunction>

	<cffunction name="GetMRItems" return="query" access="public">
		<cfargument name="mrid" hint="material requisition id" required="true" type="numeric"/>

		<cfquery name="qMRI">
			#this.MR_ITEM_SQL#
			WHERE mri.MRId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMRI/>
	</cffunction>

	
	<cffunction name="GetPOItems" return="query" access="public">
		<cfargument name="poid" hint="po id" required="true" type="numeric"/>

		<cfquery name="qPOI">
			#this.PO_ITEM_SQL#
			WHERE poi.POId = <cfqueryparam value="#arguments.poid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qPOI/>
	</cffunction>

	<cffunction name="GetMRNIItems" return="query" access="public">
		<cfargument name="mrid" hint="material requisition id" required="true" type="numeric"/>

		<cfquery name="qMRI">
			#this.MR_NI_ITEM_SQL#
			WHERE mri.MRId = <cfqueryparam value="#arguments.mrid#" cfsqltype="cf_sql_integer"/>
        AND mri.ItemId IS NULL
		</cfquery>

		<cfreturn qMRI/>
	</cffunction>

	<cffunction name="GetMI" return="query" access="public">
		<cfargument name="mid" hint="material issue id" required="true" type="numeric"/>

		<cfquery name="qMI">
			#this.MI_SQL#
			WHERE mi.IssueId = <cfqueryparam value="#arguments.mid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMI/>
	</cffunction>

	<cffunction name="GetMIItems" return="query" access="public">
		<cfargument name="miid" hint="material issue id" required="true" type="numeric"/>

		<cfquery name="qMII">
			#this.MI_ITEM_SQL#
			WHERE mii.IssueId = <cfqueryparam value="#arguments.miid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qMII/>
	</cffunction>

	<cffunction name="SaveMR" returntype="numeric" access="public" hint="Save material requisition">
		<cfargument name="mr_" hint="material requisition data in struct form" type="struct" required="true"/>

		<cfset mr = arguments.mr_/>
		<cfset mrid = mr.id/>

    <cfparam name="form.ServiceRequestId" default="0"/>
		<cftransaction action="begin">

			<cfquery result="rt">
				<cfif mrid eq 0>
					INSERT INTO
				<cfelse>
					UPDATE
				</cfif>
					whs_mr SET
				<cfif val(form.DepartmentId)>
					`DepartmentId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DepartmentId#">,
				</cfif>
				`Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mmm/yyyy')#">,
				`DateRequired` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.DateRequired,'dd/mmm/yyyy')#">,
				`DateIssued` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.DateIssued,'dd/mmm/yyyy')#">,
				`Ref` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ref#">,
				`Note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Note#">,
				<cfif val(form.WorkOrderId)>
					`WorkOrderId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkOrderId#">,
				</cfif>
				`CreatedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.UserInfo.UserId#">,
				`Currency` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Currency#">,
				`Type` = <cfqueryparam cfsqltype="cf_sql_varchar" value="SI">
				<cfif mrid neq 0>
					WHERE MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#mrid#">
				</cfif>
			</cfquery>

			<cfif mrid eq 0>
				<cfset mrid = rt.GENERATED_KEY/>
			</cfif>

				<!--- upload attachments --->
				<cfparam name="form.Attachments" default=""/>
				<cfif form.Attachments neq "">
					<cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>
					<cfset s_path = form.AttachmentsSource & "/" & form.Attachments />
					<cfset d_path = form.AttachmentsDestination & "/whs_mr/" & mrid & "/" />
					<cfset f.Move('whs_mr', MRId,'a',s_path,d_path)/>
				</cfif>
				<!---   update Material Requisition from temp data
								int0 - Quantity, int1 - Description, int2 - Unit Price ---->
				<cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
				<cfset itemObj = createobject('component','assetgear.com.awaf.ams.warehouse.Item').Init()/>

				<cfif mr.Type eq "SI">
						<!--- update qor --->
					<cfset qmri = h.GetTempDataToUpdate(mr.MRSIItem)/>
					<cfloop query="qmri">
						<cfif mr.id EQ 0>
							<cfquery>
								INSERT INTO whs_item SET
									QOR = QOR + #qmri.int1#
								WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qmri.int0#"/>
							</cfquery>
						</cfif>
					</cfloop>
					<cfset h.SaveFromTempTable(mr.MRSIItem,
						"whs_mr_item",
						"ItemId,Quantity,UnitPrice",
						"int0,int1,float0",
						"MRItemId","MRId",mrid)/>
				<cfelse> <!--- NI --->
					<!--- create items form wo --->
					<!--- delete non invetory items in work order --->
					<cfquery>
						DELETE FROM work_order_item WHERE WorkOrderId = #val(form.WorkOrderId)#
					</cfquery>
					<cfset qmri = h.GetTempDataToUpdate(mr.ItemFromWO)/>
					<cfloop query="qmri">
						<cfquery result="rt">
							INSERT INTO whs_item SET
								Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qmri.text0#"/>,
								UMId 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemObj.GetUMByCode(qmri.text1).UMId#"/>,
								VPN 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#qmri.text3#"/>,
								Maker 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#qmri.text2#"/>,
								QOR 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#qmri.int0#"/>
						</cfquery>
						<cfset item_id = setCode(rt.GENERATED_KEY)/>
						<cfquery>
							INSERT INTO whs_mr_item SET 
								ItemId 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#item_id#"/>,
								Quantity 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#qmri.int0#"/>,
								MRId 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#mrid#"/>
						</cfquery> 
						<cfif val(form.WorkOrderId)>
							<cfquery>
								INSERT INTO work_order_item SET 
									ItemId = #item_id#,
									WorkOrderId = #val(form.WorkOrderId)#,
									Quantity = #val(qmri.int0)#,
									Status = "Close"
							</cfquery>
						</cfif>
					</cfloop>

					<cfset qmri2 = h.GetTempDataToUpdate(mr.DirectItems)/>
					<cfloop query="qmri2">
						<cfquery>
							UPDATE whs_item SET 
								QOR = QOR + #qmri2.int1#
							WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qmri2.int0#"/>
						</cfquery>
						<cfquery>
							INSERT INTO whs_mr_item SET 
								ItemId 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#qmri2.int0#"/>,
								Quantity 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#qmri2.int1#"/>,
								MRId 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#mrid#"/>
						</cfquery> 
						<cfif val(form.WorkOrderId)>
							<cfquery>
								INSERT INTO work_order_item SET 
									ItemId = #qmri2.int0#,
									WorkOrderId = #val(form.WorkOrderId)#,
									Quantity = #val(qmri2.int1)#,
									Status = "Close"
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
				<!--- update totalvalue in MR --->
				<cfquery>
					UPDATE `whs_mr` SET
						TotalValue = (
							SELECT SUM(UnitPrice*Quantity)
							FROM `whs_mr_item`
							WHERE MRId = #mrid#
						)
					WHERE MRId = #mrid#
				</cfquery>
				<!--- update wo --->
				<cfif val(form.WorkOrderId)>
					<cfquery>
						UPDATE work_order SET 
							MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#mrid#"/>,
							Status2 = "Sent to Manager"
						WHERE WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.WorkOrderId#"/>
					</cfquery>
				<cfelse>
					<!--- send to Manager to sign off--->
					<cfif form.DepartmentId == 16>
						<cfset to_email = application.com.User.GetEmailsInRole("MS")/>
					<cfelse>
						<cfset to_email = application.com.User.GetEmailsInRoleAndDept("MGR", form.DepartmentId)/>
					</cfif>
					<cfif to_email eq "">
						<cfset to_email = "adexfe@live.com"/>
					</cfif>
					<cfset wh_admin = application.com.User.GetEmailsInRole("WH_SUP")/>
					<cfif val(form.WorkOrderId)>
						<cfquery name="qWOC">
							SELECT u.Email, wo.Description FROM work_order wo
							INNER JOIN core_user u ON u.UserId = wo.CreatedByUserId
						</cfquery>
						<cfif listLen(to_email) AND application.LIVE EQ application.MODE>
							<cfmail from="AssetGear <do-not-reply@assetgear.net>" to="adexfe@live.com" cc="#wh_admin#,#qWOC.Email#" subject="Matateria Requisition for WO ###form.WorkOrderId#" type="html">
								Hello,
								<p>
										The following work order requires your attention & approval :
										<br/> Work Order ###form.WorkOrderId# : #qWOC.Description#
								</p>
								<p>
									Kindly login to <a href="#application.site.url#">AssetGear</a>
								</p>
								<p>Thank you<br/>
							</cfmail>
						</cfif>
					</cfif>
				</cfif>
		</cftransaction>

		<cfreturn mrid/>
	</cffunction>


	<cffunction name="SavePO" returntype="numeric" access="public" hint="Save purchase order">
		<cfargument name="po_" hint="po data in struct form" type="struct" required="true"/>

		<cfset po = arguments.po_/>
		<cfset poid = po.id/>

		<cfparam name="po.Currency" default="NGN"/>

		<cftransaction action="begin">
			<cfquery result="rt">
				<cfif poid eq 0>
					INSERT INTO
				<cfelse>
					UPDATE
				</cfif>
					whs_po SET
				<cfif poid eq 0>
					`Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mmm/yyyy')#">,
					`CreatedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.UserInfo.UserId#">,
					</cfif>
					`Ref` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#po.Ref#">,
					`MRId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#po.MRId#">,
					`Currency` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#po.Currency#">
				<cfif poid neq 0>
					WHERE POId = <cfqueryparam cfsqltype="cf_sql_integer" value="#poid#">
				</cfif>
			</cfquery>

			<cfif poId eq 0>
				<cfset poId = rt.GENERATED_KEY/>
			</cfif>

			<!--- upload attachments --->
			<cfparam name="po.Attachments" default=""/>
			<cfif po.Attachments neq "">
				<cfset s_path = po.AttachmentsSource & "/" & po.Attachments />
				<cfset d_path = form.AttachmentsDestination & "/whs_po/" & poId & "/" />
				<cfset application.com.File.Move('whs_po', poId,'a',s_path,d_path)/>
			</cfif>
			<!--- 
				int0 - qty req 
				int1 - qty ordered 
				int2 - mr item id
				int3 - item id
				float0 - unit price
			--->
			<cfset qpo_items = application.com.Helper.GetTempDataToUpdate(po.ItemsFromMR)/>
			<cfloop query="qpo_items">
				<!--- update qoo and qor --->
				<cfquery>
					UPDATE whs_item SET
						QOR = QOR - #qpo_items.int1#,
						QOO = QOO + #qpo_items.int1#
					WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qpo_items.int3#"/>
				</cfquery>
			</cfloop>
			<!--- save into po_items --->
			<cfset application.com.Helper.SaveFromTempTable(po.ItemsFromMR,
				"whs_po_item",
				"ItemId,MRItemId,Quantity,UnitPrice",
				"int3,int2,int1,float0",
				"POItemId","POId",poid)/>

			<cfquery>
				UPDATE whs_mr SET 
					Status = "Ordered"
				WHERE MRId = <cfqueryparam cfsqltype="cf_sql_integer" value="#po.MRId#"/>
			</cfquery>
		</cftransaction>

		<cfreturn poid/>
	</cffunction>

	<cffunction name="SetCode">
   	<cfargument name="id" required="yes" type="numeric"/>

		<cfquery>
			UPDATE whs_item SET 
				Code = #arguments.id#
			WHERE ItemId = #arguments.id#
		</cfquery>

		<cfreturn arguments.id/>
	</cffunction>

   <cffunction name="ReturnMaterialToWarehouse" returntype="void" access="public">
   	<cfargument name="form" required="yes" type="struct"/>

        <!--- throw error --->
      	<cfif !IsNumeric(form.ReturnedToUserId)>
      		<cfthrow detail="Please select the person that returned item(s) below"/>
      	</cfif>
			<cftransaction action="begin">
			   <cfquery result="rt">
			       INSERT INTO whs_return SET
						Date = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mmm/yyyy')#">,
						ReturnedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ReturnedByUserId#">,
						DateReturned = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.DateReturned,'dd/mmm/yyyy')#">,
						IssueId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IssueId#">,
						ReturnedToUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ReturnedToUserId#">,
						Note = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Note#">
			   </cfquery>
			   <cfset form.id = rt.GENERATED_KEY/>
			   <!---  int0 - ItemId, int1 - Quantity ---->
			   <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
			   <cfset qRI = h.GetTempDataToUpdate(form.ItemReturn)/>
			   <!--- return the item back to warehouse ---->
			   <cfloop query="qRI">
			      <!--- TODO check that the item to return is not more than the item issued --->
			      <cfquery>
			      	UPDATE whs_item SET
			            QOH = QOH + #qRI.int1#
			         WHERE ItemId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qRI.int0#"/>
			      </cfquery>
			   </cfloop>
			   <!--- update Material Return from temp data --->
			   <cfset h.SaveFromTempTable(form.ItemReturn,
			      "whs_return_item",
			      "ItemId,Quantity",
			      "int0,int1",
			      "ItemReturnId","ReturnId",form.id)/>
			</cftransaction>

    </cffunction>

	<cffunction name="CloseMR" returntype="void" access="public">
   	<cfargument name="mid" required="yes" type="numeric"/>

		<cftransaction action ="begin">

			<cfquery name="qT">
				UPDATE whs_item SET
					QOR = 0
				WHERE ItemId IN (
					SELECT ItemId FROM whs_mr_item
					WHERE MRItemId = #val(arguments.mid)#
				)
			</cfquery>

			<cfquery>
				UPDATE whs_mr SET Status = "Close" WHERE MRId = #arguments.mid#
			</cfquery>

			<cfquery name="qMr">
				SELECT * FROM whs_mr WHERE MRId = #arguments.mid#
			</cfquery>

			<cfif val(qMr.ServiceRequestId)>
				<cfquery>
					UPDATE service_request SET Status = "Close" WHERE ServiceRequestId = #qMr.ServiceRequestId#
				</cfquery>
			</cfif>

		</cftransaction>

    </cffunction>

</cfcomponent>
