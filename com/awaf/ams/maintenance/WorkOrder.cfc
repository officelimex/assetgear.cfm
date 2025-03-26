<cfcomponent extends="assetgear.com.awaf.ams.maintenance.PMTask">

	<cffunction name="Init" access="public" returntype="WorkOrder">

 		<cfset this = super.init()/>
 		<cfset this.WORK_ORDER_PM_SQL = '
 			SELECT
 				wo.*,
				pm.PMTaskId, pm.Milestone,
				f.Code Frequency,
				rt.Type ReadingType,
 				a.Description Asset, a.AssetId, a.Class,
 				ac.Name AssetCategory,
 				jc.Class JobClass,
 				d.Name Department,
				ut.Name Unit,
 				CONCAT(cu.Surname," ",cu.OtherNames) ClosedBy,
 				CONCAT(su.Surname," ",su.OtherNames) SupervisedBy,
 				CONCAT(rb.Surname," ",rb.OtherNames) RequestBy
 			FROM
 				work_order wo
 			INNER JOIN `core_department` d ON d.DepartmentId = wo.DepartmentId
			LEFT JOIN `core_unit` ut ON ut.UnitId = wo.UnitId
 			INNER JOIN `asset` a ON a.AssetId = wo.AssetId
 			LEFT JOIN `asset_category` ac ON ac.AssetCategoryId = a.AssetCategoryId
 			INNER JOIN `job_class` jc ON jc.JobClassId = wo.WorkClassId
 			LEFT JOIN `service_request` sr ON sr.ServiceRequestId = wo.ServiceRequestId
 			LEFT JOIN core_user rb ON rb.UserId = sr.RequestByUserId
			INNER JOIN `pm_task` pm ON pm.PMtaskId = wo.PMTaskId
			LEFT JOIN frequency f ON pm.FrequencyId = f.FrequencyId
			LEFT JOIN reading_type rt ON pm.ReadingTypeId = rt.ReadingTypeId
 			
 			LEFT JOIN core_user cu ON cu.UserId = wo.ClosedByUserId
 			LEFT JOIN core_user su ON su.UserId = wo.SupervisedByUserId
 		'/>
 		<cfset this.WORK_ORDER_SQL = '
 			SELECT
 				wo.*,
 				a.Description Asset, a.Class AssetClass,
 				ac.Name AssetCategory,
 				jc.Class JobClass,
 				d.Name Department,
				ut.Name Unit,
 				CONCAT(cu.Surname," ",cu.OtherNames) ClosedBy,
 				CONCAT(su.Surname," ",su.OtherNames) SupervisedBy,
 				CONCAT(sup.Surname," ",sup.OtherNames) SupName,
 				CONCAT(rb.Surname," ",rb.OtherNames) RequestBy,
 				CONCAT(cr.Surname," ",cr.OtherNames) CreatedBy,
 				CONCAT(mgr.Surname," ",mgr.OtherNames) ManagerName,
 				CONCAT(wh.Surname," ",wh.OtherNames) WHPerson
 			FROM
 				work_order wo
 			INNER JOIN `core_department` d ON d.DepartmentId = wo.DepartmentId
			LEFT JOIN `core_unit` ut ON ut.UnitId = wo.UnitId
 			INNER JOIN `asset` a ON a.AssetId = wo.AssetId
 			LEFT JOIN `asset_category` ac ON ac.AssetCategoryId = a.AssetCategoryId
 			INNER JOIN `job_class` jc ON jc.JobClassId = wo.WorkClassId
 			LEFT JOIN `service_request` sr ON sr.ServiceRequestId = wo.ServiceRequestId
 			LEFT JOIN core_user rb ON rb.UserId = sr.RequestByUserId
 			
 			LEFT JOIN core_user cu ON cu.UserId = wo.ClosedByUserId
 			LEFT JOIN core_user su ON su.UserId = wo.SupervisedByUserId

 			LEFT JOIN core_user cr ON cr.UserId = wo.CreatedByUserId
			LEFT JOIN core_user mgr ON mgr.UserId = wo.FSUserId 
      LEFT JOIN core_user wh ON wh.UserId = wo.WHUserId 
      LEFT JOIN core_user sup ON sup.UserId = wo.SupUserId 
 		'/>
    <cfset this.WORK_ORDER_COUNT_SQL = '
 			SELECT
 				COUNT(wo.WorkOrderId) c
 			FROM
 				work_order wo
 			-- INNER JOIN `core_department` d ON d.DepartmentId = wo.DepartmentId
 			INNER JOIN `asset` a ON a.AssetId = wo.AssetId
 			-- LEFT JOIN `asset_category` ac ON ac.AssetCategoryId = a.AssetCategoryId
 			-- INNER JOIN `job_class` jc ON jc.JobClassId = wo.WorkClassId
 			-- users
 			-- LEFT JOIN core_user cu ON cu.UserId = wo.ClosedByUserId
 			-- LEFT JOIN core_user su ON su.UserId = wo.SupervisedByUserId
		'/>
 		<cfset this.WORK_ORDER_ITEM_SQL = '
		    SELECT
					woi.*,
					i.Status,i.Obsolete,i.Status as ItemStatus,i.Code,
					CONVERT(CONCAT("[",i.VPN,"] ",i.Description,"~",i.ItemId) USING utf8) ItemDescription, 
					i.Description Item, i.VPN, i.Maker,
					um.Code UM
		    FROM
		    	work_order_item woi
		    INNER JOIN work_order wo ON woi.WorkOrderId = wo.WorkOrderId
		    LEFT JOIN whs_item i ON woi.ItemId = i.ItemId
		    LEFT JOIN um um ON um.UMId = i.UMId
 		'/>
 		<cfset this.JOB_CLASS_SQL = '
 			SELECT * FROM job_class
 			ORDER BY `Class`
 		'/>
 		<cfset this.LABOUR_SQL = '
 			SELECT
 				l.*,
 				CONCAT(u.Surname," ",u.OtherNames,"~",u.UserId) User,  CONCAT(u.Surname," ",u.OtherNames) Labourer
 			FROM
 				`labour` l
 			INNER JOIN core_user u ON u.UserId = l.UserId
 		'/>
 		<cfset this.SERVICE_REQUEST_SQL = '
 			SELECT
 				sr.*,IF(sr.Category = "m","Mats","Admin") AS Categ,
 				CONCAT(u.Surname," ",u.OtherNames) RequestBy,
 				a.Description Asset,
 				d.Name Department,
				u.DepartmentId,u.CompanyId
 			FROM
 				service_request sr
 			INNER JOIN core_user u ON u.UserId = sr.RequestByUserId
 			LEFT JOIN core_department d ON d.DepartmentId = u.DepartmentId
 			LEFT JOIN `asset` a ON a.AssetId = sr.AssetId
 		'/>

 		<cfset this.SERVICE_REQUEST_COUNT_SQL = '
 			SELECT
 				COUNT(sr.ServiceRequestId) C
 			FROM
 				service_request sr
 			INNER JOIN core_user u ON u.UserId = sr.RequestByUserId
 			INNER JOIN `asset` a ON a.AssetId = sr.AssetId
 		'/>
		<cfreturn this>
	</cffunction>

	<cffunction name="GetWorkOrder" returntype="query" access="public">
		<cfargument name="woid" type="numeric" required="true" hint="Work Order Id"/>

		<cfquery name="qP">
			#this.WORK_ORDER_SQL#
			WHERE wo.WorkOrderId = <cfqueryparam value="#arguments.woid#" cfsqltype="CF_SQL_INTEGER"/>
		</cfquery>

		<cfreturn qP/>
	</cffunction>

	<cffunction name="GetWorkOrderItems" returntype="query" access="public">
		<cfargument name="woid" type="numeric" required="true" hint="Work Order Id"/>

		<cfquery name="qP" cachedwithin="#createTime(1,0,0)#">
			#this.WORK_ORDER_ITEM_SQL#
			WHERE wo.WorkOrderId = <cfqueryparam value="#arguments.woid#" cfsqltype="cf_sql_integer"/>
		</cfquery>

		<cfreturn qP/>
	</cffunction>

	<cffunction name="GetJobClass" returntype="query" access="public">

		<cfquery name="qJ" cachedwithin="#createTime(1,0,0)#">
			#this.JOB_CLASS_SQL#
		</cfquery>

		<cfreturn qJ/>
	</cffunction>

	<cffunction name="GetLastWorkOrder" returntype="query" access="public">
		<cfargument name="pm" type="numeric" required="true" hint="PM Task Id"/>

		<cfquery name="local.qP" cachedwithin="#createTime(0,0,0)#">
			#this.WORK_ORDER_SQL#
			WHERE wo.PMTaskId = #arguments.pm#
			ORDER BY wo.DateOpened DESC
			LIMIT 0,1
		</cfquery>

		<cfreturn local.qP/>
	</cffunction>

	<cffunction name="GetLastClosedWorkOrder" returntype="query" access="public">
		<cfargument name="pm" type="numeric" required="true" hint="PM Task Id"/>

		<cfquery name="local.qP" cachedwithin="#createTime(0,0,0)#">
			#this.WORK_ORDER_SQL#
			WHERE wo.PMTaskId = #arguments.pm#
				AND wo.Status = "Close"
			ORDER BY wo.DateOpened DESC
			LIMIT 0,1
		</cfquery>

		<cfreturn local.qP/>
	</cffunction>

	<cffunction name="GetLastOpenWorkOrder" returntype="query" access="public">
		<cfargument name="pm" type="numeric" required="true" hint="PM Task Id"/>

		<cfquery name="local.qP" cachedwithin="#createTime(0,0,0)#">
			#this.WORK_ORDER_SQL#
			WHERE wo.PMTaskId = #arguments.pm#
				AND wo.Status <> "Close"
			ORDER BY wo.DateOpened DESC
			LIMIT 0,1
		</cfquery>

		<cfreturn local.qP/>
	</cffunction>

	<cffunction name="GetLabourers" returntype="query" access="public">
		<cfargument name="woid" type="numeric" required="true" hint="Work Order Id"/>
		<cfset var qL = ""/>
		<cfquery name="qL" cachedwithin="#createTime(1,0,0)#">
			#this.LABOUR_SQL#
			WHERE l.WorkOrderId = <cfqueryparam value="#arguments.woid#" cfsqltype="CF_SQL_INTEGER"/>
		</cfquery>

		<cfreturn qL/>
	</cffunction>

	<cffunction name="GetContractors" returntype="query" access="public">
		<cfargument name="woid" type="numeric" required="true" hint="Work Order Id"/>
		<cfset var qC = ""/>
		<cfquery name="qC" cachedwithin="#createTime(1,0,0)#">
			SELECT * FROM contract c
			WHERE c.WorkOrderId = <cfqueryparam value="#arguments.woid#" cfsqltype="CF_SQL_INTEGER"/>
		</cfquery>

		<cfreturn qC/>
	</cffunction>

	<cffunction name="GetServiceRequest" returntype="query" access="public">
		<cfargument name="srid" hint="job request id" required="true" type="numeric"/>

		<cfquery name="qSR">
			#this.SERVICE_REQUEST_SQL#
			WHERE sr.ServiceRequestId = <cfqueryparam value="#arguments.srid#" cfsqltype="CF_SQL_INTEGER"/>
		</cfquery>

		<cfreturn qSR/>
	</cffunction>


	<cffunction name="SaveWorkOrder" returntype="numeric" access="public" hint="create new work order">
		<cfargument name="wod" type="struct" required="true" hint="data holding the new work order to be created." />
		<cfargument name="draft" default="false" type="boolean" required="false" />

		<cfset wo = arguments.wod/>

		<cfparam name="wo.AssetLocationIds" default=""/>
		<cfparam name="wo._AssetId" default=""/>
		<cfparam name="AssetLocationIds" default=""/>
		<cfif val(wo._AssetId)>
			<cfset wo.AssetId = wo._assetId/>
			<cfset wo.AssetLocationIds = wo._assetLocId/>
		</cfif>
		<cfif listLen(wo.AssetId) eq 2>
			<cfset wo.AssetLocationIds = listLast(wo.AssetId)/>
			<cfset wo.AssetId = listFirst(wo.AssetId)/>
		</cfif>
		

		<cfparam name="wo.Status" default="Open"/>
    	<cfif wo.Status eq "">
			<cfset wo.Status = "Open"/>
		</cfif>
		<cfparam name="wo.DateOpened" default="#dateformat(now(),'yyyy/mm/dd')#"/>
		<cfparam name="wo.UnitId" default="0"/>
		<cfparam name="wo.DepartmentId" default="0"/>
		<cfparam name="wo.Id" default="0"/>
		<cfparam name="wo.DateClosed" default=""/>
		<cfparam name="wo.PMTaskId" default="0"/>
		<cfparam name="wo.WorkClassId" default="0"/>
		<cfparam name="wo.CreatedByUserId" default="0"/>
		<cfparam name="wo.SupervisedByUserId" default="0"/>
		<cfparam name="wo.ClosedByUserId" default="0"/>
		<cfparam name="wo.ServiceRequestId" default="0"/>
		<cfparam name="wo.WorkDone" default=""/>
		<cfparam name="wo.Workorderitem" default=""/>
		<cfparam name="wo.AssetFailureReportId" default=""/>

		<cfif wo.Status eq "Close" and !IsDate(wo.DateClosed)>
			<cfthrow message="You have to enter date closed in order to close this Work order"/>
		</cfif>
		<cfif IsDate(wo.DateClosed)>
			<cfif wo.DateClosed lt wo.DateOpened>
				<cfthrow message="Date closed can not be less than date work was Opened (#dateformat(wo.DateOpened,'dd-mm-yyyy')#)."/>
			</cfif>
		</cfif> 

		<cftransaction action="begin">
			<!--- update the status of the Service request --->
			<cfif wo.ServiceRequestId neq "">
				<cfquery>
					UPDATE service_request SET
					`Status` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.Status#"/>
					WHERE ServiceRequestId = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.ServiceRequestId#"/>
				</cfquery>
			</cfif>

			<cfquery result="rt">
				<cfif wo.id eq 0>
					INSERT INTO
				<cfelse>
					UPDATE
				</cfif>
					`work_order` SET
					`AssetId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.AssetId#"/>,
				<cfif val(wo.ServiceRequestId)>
					`ServiceRequestId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.ServiceRequestId#"/>,
				</cfif>
				
				<cfif val(wo.AssetFailureReportId)>
					AssetFailureReportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.AssetFailureReportId#"/>,
				</cfif>
			
				`DateOpened`  = <cfqueryparam cfsqltype="cf_sql_date" value="#wo.DateOpened#"/>,
				`Status` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.Status#"/>,
				`Description` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.Description#"/>,
				`SupervisedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.SupervisedByUserId#"/>,
				<cfif val(wo.UnitId)>
					`UnitId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.UnitId#"/>,
				</cfif>
				<cfif val(wo.DepartmentId)>
					`DepartmentId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.DepartmentId#"/>,
				</cfif>
				<cfif IsDate(wo.DateClosed)>
					`DateClosed` = <cfqueryparam cfsqltype="cf_sql_date" value="#wo.DateClosed#"/>,
					`ClosedByUserId`  = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>,
				</cfif>
				<cfif wo.id neq 0>
					`WorkDone` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.WorkDone#"/>,
				<cfelse>
					<!--- if the user is just creating the work order, add the department --->
					<cfif val(wo.CreatedByUserId)>
						<!--- WorkingForId =  <cfqueryparam cfsqltype="cf_sql_int" value="#request.UserInfo.WorkingForId#"/>,--->
						`CreatedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.CreatedByUserId#"/>,
					</cfif>
				</cfif>
								
				<cfif wo.AssetLocationIds eq "">
					<cfif !val(wo.AssetId)>
						<cfabort showerror="Please select an Asset"/>
					</cfif>
					<cfset qAL = application.com.Asset.GetAssetLocationByAsset(wo.AssetId)/>
					`AssetLocationIds` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(qAL.AssetLocationId)#"/>,
				<cfelse>
					`AssetLocationIds` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.AssetLocationIds#"/>,
				</cfif>
			<cfif wo.WorkClassId EQ "">
				<cfabort showerror="Please select a work class"/>
			</cfif>
			<cfif wo.WorkClassId>
				`WorkClassId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.WorkClassId#"/>,
			</cfif>
			<cfif val(wo.PMTaskId)>
				`PMTaskId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(wo.PMTaskId)#"/>,
			</cfif>
				`WorkDetails` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.WorkDetails#"/>
				<cfif wo.id neq 0>
						WHERE `WorkOrderId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.id#"/>
				</cfif>
			</cfquery>

				<!--- save the description and details of the WO to PM if available --->
				<cfif val(wo.PMTaskId) AND len(wo.WorkDetails) GT 10>
					<cfquery>
						UPDATE pm_task SET
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.Description#"/>,
							TaskDetails = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wo.WorkDetails#"/>
						WHERE PMTaskId = <cfqueryparam cfsqltype="cf_sql_integer" value="#wo.PMTaskId#"/>
					</cfquery>
				</cfif>

				<cfset WOId = wo.Id/>
				<cfif wo.Id eq 0>
					<cfset WOId = rt.GENERATED_KEY/>
				</cfif>

				<cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>
				<!--- upload attachments --->
				<cfparam name="wo.Attachments" default=""/>
				<cfif wo.Attachments neq "">
					<cfset s_path = wo.AttachmentsSource & "/" & wo.Attachments />
					<cfset d_path = wo.AttachmentsDestination & "/work_order/" & WOId & "/" />
					<cfset f.Move('work_order',WOId,'a',s_path,d_path)/>
				</cfif>

				<cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
				<!--- associate spares with asset --->
				<cfset qItm1 = h.GetTempDate(wo.WorkOrderItem)/>
				<cfif qItm1.recordcount>
					<cfquery name="qA">
						SELECT ItemIds, AssetId FROM asset
						WHERE AssetId = #val(wo.AssetId)#
					</cfquery>
					<cfset l = createObject("component","assetgear.com.awaf.util.List").Init()/>
					<cfset nlist = listAppend(trim(qA.ItemIds), valueList(qItm1.Int0))/>

					<cfquery>
						UPDATE asset SET
							ItemIds = trim("#l.ListDistinct(nlist)#")
						WHERE AssetId = #qA.AssetId#
					</cfquery>
				</cfif>

				<!--- update Work Order Item from temp data --->
				<cfparam name="wo.WorkOrderItem" default=""/>
				<cfparam name="wo.WorkOrderItem2" default=""/>
				<cfparam name="wo.Contract" default=""/>
				<cfparam name="wo.Labour" default=""/>
				<!---  int1 - Description, int0 - Quantity ---->
				<cfset h.SaveFromTempTable(wo.WorkOrderItem,
						"work_order_item",
						"ItemId,Purpose,Quantity",
						"int0,text0,int1",
						"WorkOrderItemId","WorkOrderId",WOId)/>

				<cfset h.SaveFromTempTable(wo.WorkOrderItem2,
						"work_order_item",
						"Description,Quantity,UOM,OEM,Others",
						"text0,int0,text1,text2,text3",
						"WorkOrderItemId","WorkOrderId",WOId)/>
	
				<!--- check unitprice of spares and make sure there is value --->
				<!--- <cfif IsDate(wo.DateClosed)> --->
					<cfquery name="qsp">
						SELECT UnitPrice FROM work_order_item WHERE ItemId IS NULL AND WorkOrderId = #WOId#
					</cfquery>
					<!--- <cfloop query="qsp">
						<cfif qsp.UnitPrice eq 0>
							<cfthrow message="Kindly supply the unit price for spares used in Part Section B "/>
						</cfif>
					</cfloop> --->
				<!--- </cfif> --->
				<cfset h.SaveFromTempTable(wo.Contract,
						"contract",
						"Contractor,Description",
						"text0,text1",
						"ContractId","WorkOrderId",WOId)/>
				<cfset h.SaveFromTempTable(wo.Labour,
						"labour",
						"UserId,Function,Hours",
						"int0,text0,int1",
						"LabourId","WorkOrderId",WOId)/>

			<cfquery name="qpts">
				SELECT 
					i.Code, i.Description ItemDesc, woi.Description ItemDesc2, i.VPN
				FROM work_order_item woi
				LEFT JOIN whs_item i ON i.ItemId = woi.ItemId
				WHERE WorkOrderId = #WOId#
			</cfquery>

			<cfif qpts.recordcount AND wo.Status EQ "Open">
				<cfset sentTo = "sup"/>
				<cfif wo.WorkClassId EQ 12 AND request.IsSup>
					<cfset sentTo = "warehouse"/>
				</cfif>

				<cfif sentTo EQ "warehouse">
					<cfset _emails = application.com.User.GetEmailsInRole("WH_SUP")/> 
					<cfquery name="qpts">
						UPDATE work_order SET
							Status = "Parts On Hold",
							Status2 = "Sent to Warehouse"
						WHERE WorkOrderId = #WOId#
					</cfquery>
					<cfif application.mode EQ application.LIVE && !arguments.draft>

						<cfmail from="AssetGear <do-not-reply@assetgear.net>" to="#_emails#" subject="Work Order ###WOId#" type="html">
							Hello,
							<p>	
								#wo.Description# has been raised and requires the following materials:
								<ol>
									<cfloop query="#qpts#">
										<li>
											<cfif qpts.Code != "">[#qpts.Code#]</cfif> 
											#qpts.ItemDesc# #qpts.ItemDesc2# 
											<cfif qpts.VPN != "">[#qpts.VPN#]</cfif> 
										</li>
									</cfloop>
								</ol>
							</p>
							<p>Thank you<br/> 
						</cfmail>
					</cfif>
				<cfelse>
					<!--- send to supritendent to approve --->
					<cfset SentToSuperintendent(WOId)/>				
				</cfif>

			</cfif>

 		</cftransaction>

		<cfreturn WOId/>
	</cffunction>

<cfscript>
	public query function getWO(required numeric id) {
		
		var qW = queryExecute("
			SELECT 
				wo.SupervisedByUserId, wo.WorkOrderId, wo.DepartmentId, wo.UnitId,
					wo.Description, wo.Status2,
					wo.SupervisedApprovedDate,
					wo.MRId,
				-- u.Email,
				cb.Email cb_Email
			FROM work_order wo
			-- INNER JOIN core_user u ON u.UserId = wo.SupervisedByUserId
			LEFT  JOIN core_user cb ON cb.UserId = wo.CreatedByUserId
			WHERE WorkOrderId = ? 
		", [arguments.id])

		return qW
	}
</cfscript>


<cffunction name="getUser">
  <cfargument name="dept_id" required="no" type="string">
  <cfargument name="unit_id" required="no" type="string">
  <cfargument name="role" required="yes" type="string">

	<cfset uid = val(arguments.unit_id)/>
	<cfset did = val(arguments.dept_id)/>
	<cfquery name="q" cachedwithin="#createTime(0,0,0)#">
		SELECT 
			u.Email
		FROM core_user  u
		INNER JOIN core_login l ON l.UserId = u.UserId
		WHERE l.Role IN (<cfqueryparam value = "#arguments.role#" CFSQLType = "cf_sql_varchar" list="true"/>)
			<cfif did>
				AND u.DepartmentId = #val(did)#
			</cfif>
			<cfif uid>
				AND u.UnitId = #uid#
			</cfif>
	</cfquery>

	<cfreturn q/>
</cffunction>


	<cffunction name="SentToSuperintendent">
		<cfargument name="id" type="numeric" required="true"/>
	
		<cfset qW = getWO(arguments.id)/>
		<cfset qU = getUser(val(qW.DepartmentId), qW.UnitId, "SUP")/>
	
		<cftransaction>
	
			<cfif qU.Recordcount>
				<cfquery>
					UPDATE work_order SET 
						<cfif request.IsSV>
							SupervisedByUserId = #request.userInfo.UserId#,
							SupervisedApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
						</cfif>
						Status2 = 'Sent to Superintendent'
					WHERE WorkOrderId = #arguments.id#
				</cfquery>
	
				<cfif application.mode EQ application.LIVE>
					<cfset application.com.Notice.SendEmail(
						to			: qU.columnData("Email").toList(),
						cc  		: qW.cb_Email,
						subject	: "Work Order ###qW.WorkOrderId#",
						msg 		: "
							Hello, 
							<p>
								Work Order ###qW.WorkOrderId# has been sent to you for approval <br/>
								==================<br/>
								#qW.Description#<br/>
								==================<br/>
							</p> 
							Thank you
						"
					)/>
				</cfif>
			</cfif>	
		</cftransaction>
	</cffunction>

	<cffunction name="SaveServiceRequest" access="public" returntype="numeric">
		<cfargument name="sr_" hint="struct containing job request data" required="true" type="struct"/>

		<cfset sr = arguments.sr_/>

		<cfquery name="qA">
			SELECT al.AssetId, a.Description FROM asset_location al
			INNER JOIN asset a ON a.AssetId = al.AssetId
			WHERE AssetLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#sr.AssetLocationId#"/>
		</cfquery>

		<!--- check the user who created this sr --->
		<cfset qU = application.com.User.GetUser(sr.RequestByUserId)/>
		<cfset sr.ApprovedByUserId = 0/>
		<cfswitch expression="#qU.Role#">
			<cfcase value="WHS_SUP,WHS_SV,MS,SUP,SV"><cfset sr.ApprovedByUserId = sr.RequestByUserId/></cfcase>
				<cfcase value="SV">
					<cfif qU.DepartmentId eq 7 or qU.DepartmentId eq 15>
							<!--- TODO: send to HOD to approve --->
						<cfelse>
							<cfset sr.ApprovedByUserId = sr.RequestByUserId/>
						</cfif>
				</cfcase>
		</cfswitch>

		<cftransaction action="begin">
			<cfquery result="rt">
				<cfif sr.id eq 0>
					INSERT INTO
				<cfelse>
					UPDATE
				</cfif>
					service_request SET
					<cfif sr.ServiceType eq "MR">
						`DateNeeded` = <cfqueryparam cfsqltype="cf_sql_date" value="#sr.dateneeded#">,
						`ReasonForRequest` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sr.Description#">,
						`Category` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sr.Category#">,
					<cfelse>
						`AssetId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#qA.AssetId#">,
						<!--- TODO: change LocationIds to AssetLocationId ---->
						`LocationIds` = <cfqueryparam value="#sr.AssetLocationId#" cfsqltype="cf_sql_varchar"/>, <!--- this is the asset location ---->
						`Description` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sr.Description#">,
					</cfif>
					`Priority` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sr.Priority#">,
					`Date` = <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Now(),'dd-mmm-yyyy')#">,
					`RequestByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#sr.RequestByUserId#">,
				<cfif val(sr.ApprovedByUserId)>
					`ApprovedByUserId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#sr.ApprovedByUserId#">,
				</cfif>
						`ServiceType` = <cfqueryparam cfsqltype="cf_sql_char" maxlength="2" value="#sr.ServiceType#"/>
				<cfif sr.id neq 0>
					WHERE ServiceRequestId = <cfqueryparam cfsqltype="cf_sql_integer" value="#sr.id#">
				</cfif>
			</cfquery>

			<cfif sr.id eq 0>
				<cfset sr.id = rt.GENERATED_KEY/>
				<cfif sr.ServiceType eq "JR">
					<!--- create new workorder based on the service request --->
					<cfset wo.WorkClassId = 3/> <!--- corrective maintenane --->
					<cfset wo.DepartmentId = 16/> <!--- maintenance department --->
					<cfset wo.WorkDetails = sr.Description/>
					<cfset wo.ServiceRequestId = sr.id/>
					<cfset wo.AssetLocationIds = sr.AssetLocationId/>
					<cfset wo.Description = sr.Description />
					<cfset wo.CreatedByUserId = sr.RequestByUserId />

					<cfset wo.AssetId = qA.AssetId/>
					<cfset woid = SaveWorkOrder(wo)/>
					<cfset _sup_emails = application.com.User.GetEmailsInRoleAndDept("SUP", wo.DepartmentId)/>
					<cfset _sv_emails = application.com.User.GetEmailsInRoleAndDept("SV", wo.DepartmentId)/>
					<cfif listLen(_sv_emails) AND application.LIVE == application.MODE>
						<cfmail from="AssetGear <do-not-reply@assetgear.net>" to="#_sv_emails#" cc="#_sup_emails#" bcc="adexfe@live.com" subject="Job Request ###sr.id#, WO ###woid#" type="html">
							Hello,
							<p>#request.userinfo.User# just created a service request;<br/>
							Asset: #qA.Description#<br/>
							Work scope: #sr.Description#
							</p>
							Thank you
						</cfmail>
					</cfif>
				<cfelse><!--- MR ---->
					<cfif application.LIVE == application.MODE>
						<cfmail from="AssetGear <do-not-reply@assetgear.net>" to="gasplantwarehouse@#application.domain#" bcc="adexfe@live.com" subject="Service Request ###sr.id#" type="html">
							Hello,
							<p>
								#request.userinfo.User# just created a service request;<br/>
								Please visit assetGear for more details
							</p>
							Thank you
						</cfmail>
					</cfif>
				</cfif>
			</cfif>
		</cftransaction>

		<cfreturn sr.id/>
	</cffunction>

</cfcomponent>
