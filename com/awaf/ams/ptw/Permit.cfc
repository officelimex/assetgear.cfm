<cfcomponent>

	<cffunction name="init" access="public" returntype="Permit">

		<cfset this.PERMIT_SQL = '
			SELECT 
				p.*,
				j.EquipmentToUse, j.WorkOrderId,
				wo.WorkOrderId, wo.Description Work, wo.AssetLocationIds, wo.DepartmentId WODepartmentId,
				d.Name Department, d.DepartmentId,
				a.Description Asset,
				CONCAT(pa.Surname," ",pa.OtherNames) PA, pa.UnitId PAUnitId, pa.Email PAEmail,
				pac.Name PACompany, pad.Name PADepartment,
				CONCAT(fs.Surname," ",fs.OtherNames) FS, 
				fsd.Name FSDepartment,
				CONCAT(sv.Surname," ",sv.OtherNames) SV, sv.UnitId SVUnitId, sv.Email SVEmail,
				svd.Name SVDepartment,
				CONCAT(pa2.Surname," ",pa2.OtherNames) PAC,
				CONCAT(svc.Surname," ",svc.OtherNames) SVC, svcd.Name SVCDepartment
			FROM 
				`ptw_permit` p
			INNER JOIN ptw_jha j ON j.JHAId = p.JHAId
			INNER JOIN `work_order` wo ON wo.WorkOrderId = j.WorkOrderId
			INNER JOIN `asset` a ON a.AssetId = wo.AssetId
			
			LEFT JOIN `core_department` d 	ON d.DepartmentId 		= wo.DepartmentId
			LEFT JOIN core_user pa 					ON pa.UserId 					= p.PAApprovedByUserId
			LEFT JOIN core_department pad 	ON pad.DepartmentId 	= pa.DepartmentId
			LEFT JOIN core_company pac 			ON pac.CompanyId 			= pa.CompanyId
			LEFT JOIN core_user fs 					ON fs.UserId 					= p.FSApprovedByUserId
			LEFT JOIN core_department fsd 	ON fsd.DepartmentId 	= fs.DepartmentId
			LEFT JOIN core_user sv 					ON sv.UserId 					= p.SVApprovedByUserId
			LEFT JOIN core_department svd 	ON svd.DepartmentId 	= sv.DepartmentId
			LEFT JOIN core_user pa2 				ON pa2.UserId 				= p.PACloseByUserId
			LEFT JOIN core_user svc 				ON svc.UserId 				= p.SVCloseByUserId
			LEFT JOIN core_department svcd 	ON svcd.DepartmentId 	= svc.DepartmentId
		'/>

		<cfset this.PERMIT_COUNT_SQL = '
			SELECT 
				COUNT(p.PermitId) C
			FROM 
				`ptw_permit` p
			INNER JOIN ptw_jha j 						ON j.JHAId 				= p.JHAId
			LEFT 	JOIN core_user pa 				ON pa.UserId 			= p.PAApprovedByUserId
			INNER JOIN `work_order` wo 			ON wo.WorkOrderId = j.WorkOrderId
			INNER JOIN `asset` a 						ON a.AssetId 			= wo.AssetId
			LEFT 	JOIN `core_department` d 	ON d.DepartmentId = wo.DepartmentId
		'/>

		<cfset this.JHA_SQL = '
			SELECT 
				j.*,
				CONCAT(c.Surname," ",c.OtherNames) PreparedBy,
				wo.Description WorkDescription, wo.DepartmentId,
				CONCAT(u1.Surname," ",u1.OtherNames) PreparedBy, u1.Email PreparedByEmail,
				u1.DepartmentId,
				CONCAT(u2.Surname," ",u2.OtherNames) ReviewedBy, u2.Email ReviewedByEmail,
				CONCAT(u3.Surname," ",u3.OtherNames) HSEBy, u3.Email HSEEmail,
				p.PermitId,
				a.Description Asset
			FROM 
				ptw_jha j
			INNER JOIN core_user c 		ON c.UserId 					= j.PreparedByUserId 
			INNER JOIN work_order wo 	ON wo.WorkOrderId 		= j.WorkOrderId 
			-- INNER JOIN core_department d ON d.DepartmentId = wo.DepartmentId
			INNER JOIN asset a 				ON a.AssetId 					= wo.AssetId
			INNER JOIN core_user u1 	ON j.PreparedByUserId = u1.UserId
			LEFT JOIN core_user u2 		ON j.ReviewedByUserId = u2.UserId
			LEFT JOIN core_user u3 		ON j.HSEUserId 				= u3.UserId
			LEFT JOIN ptw_permit p 		ON p.JHAId 						= j.JHAId
		'/>
        
		<cfset this.JHA_COUNT_SQL = '
			SELECT 
				COUNT(j.JHAId) c
			FROM
				ptw_jha j
			INNER JOIN core_user c ON c.UserId = j.PreparedByUserId
			INNER JOIN work_order wo ON wo.WorkOrderId = j.WorkOrderId
			INNER JOIN asset a ON a.AssetId = wo.AssetId
			INNER JOIN ptw_permit p ON p.JHAId = j.JHAId
		'/>	

		<cfset this.JHA_LIST_SQL = '
			SELECT 
				jl.*
			FROM ptw_jha_list jl
		'/>	

		<cfset this.GAS_TEST_SQL = '
			SELECT 
				g.*
			FROM ptw_gas_test g
		'/>	
        
		<cfreturn this/>
	</cffunction> 

	<cffunction name="UpdateJHAStatus">
		<cfargument name="jhaid" required="yes"/>
		<cfargument name="status" required="yes"/>
	
		<cfquery>
			UPDATE ptw_jha SET
				`Status` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#"/>
			WHERE JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.jhaid#"/>
		</cfquery>
	</cffunction>

	<cffunction name="GetPermit" access="public" returntype="query">
		<cfargument name="pid" hint="permit id" type="numeric" required="true"/>

		<cfquery name="qPt">
			#this.PERMIT_SQL#
			WHERE p.PermitId = <cfqueryparam value="#arguments.pid#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>

		<cfreturn qPt/>
	</cffunction>
	 
	<cffunction name="GetGasTest" access="public" returntype="query">
		<cfargument name="pid" hint="permit id" type="numeric" required="true"/>

		<cfquery name="qGt">
			#this.GAS_TEST_SQL#
			WHERE g.PermitId = <cfqueryparam value="#arguments.pid#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>

		<cfreturn qGt/>
	</cffunction>
    
	<cffunction name="GetJHA" access="public" returntype="query">
		<cfargument name="jid" hint="JHA id" type="numeric" required="true"/>

		<cfquery name="qJ">
			#this.JHA_SQL#
			WHERE j.JHAId = <cfqueryparam value="#val(arguments.jid)#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>

		<cfreturn qJ/>
	</cffunction>

	<cffunction name="GetJHAList" access="public" returntype="query">
		<cfargument name="jid" hint="JHA id" type="numeric" required="true"/>

		<cfquery name="qJl">
			#this.JHA_LIST_SQL#
			WHERE jl.JHAId = <cfqueryparam value="#arguments.jid#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>

		<cfreturn qJl/>
	</cffunction>
    
    <cffunction name="saveJHA" access="public" returntype="numeric" hint="save job hazard analysis">
    	<cfargument name="jd" hint="struct holding the jha data" required="yes" type="struct"/>
        
        <cfset jha = arguments.jd/>
        
        <cftransaction action="begin">
            <cfquery result="rt">
							<cfif jha.id eq 0>
								INSERT INTO
							<cfelse>
								UPDATE 
							</cfif>
								ptw_jha SET
								<cfif jha.id eq 0>
									Date = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'yyyy-mmm-dd')#"/>,
									PreparedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#jha.PreparedByUserId#"/>,
									WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#jha.WorkOrderId#"/>,
								</cfif>
								EquipmentToUse = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jha.EquipmentToUse#"/>     
							<cfif jha.id neq 0>
								WHERE JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#jha.id#">
							</cfif> 
            </cfquery>
            
            <cfset _id = jha.Id/>
            <cfif jha.id eq 0>
            	<cfset _id = rt.GENERATED_KEY/>
            </cfif>
            
            <cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>
            
            <!--- upload attachments --->
            <cfparam name="jha.Attachments" default=""/>
            <cfif jha.Attachments neq "">
							<cfset s_path = jha.AttachmentsSource & "/" & jha.Attachments />            
							<cfset d_path = jha.AttachmentsDestination & "/ptw_jha/" & _id & "/" /> 
							<cfset f.Move('ptw_jha',_id,'a',s_path,d_path)/>
            </cfif>
            
            <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/>
            <cfset h.SaveFromTempTable(jha.JHAList,
							"ptw_jha_list",
							"JobSequence,Hazard,Whom,Severity,Likelihood,Risk,ControlMeasure,RecoveryPlan,ActionParties",
							"text0,text1,text2,text3,text4,text5,text6,text7,text8",
							"JHAListId","JHAId", _id)
						/>	
            
       </cftransaction>
        
        <cfreturn _id/>
    </cffunction>

</cfcomponent>