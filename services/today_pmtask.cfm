<cfset today = DateFormat(now(), "yyyy-mm-dd")>
<cfoutput>
	<cfquery name="qTodayWorkOrders">
			SELECT 
				wo.WorkOrderId, 
				wo.UnitId, 
				wo.DateOpened,
				wo.AssetId,
				a.Description AS AssetDescription
			FROM work_order wo
			LEFT JOIN asset a ON wo.AssetId = a.AssetId
			WHERE  wo.DateOpened = <cfqueryparam value="#today#" cfsqltype="CF_SQL_DATE">
					-- AND wo.UnitId IS NULL
	</cfquery>
	<cfdump var="#qTodayWorkOrders#"/>
	<cfloop query="qTodayWorkOrders">
			<cfquery name="qUnitUsers">
				SELECT 
					u.UserId, u.Surname, u.OtherNames, u.Email,l.Role
				FROM 
					core_user u
				INNER JOIN core_login l ON u.UserId = l.UserId
				WHERE 
					<cfif val(qTodayWorkOrders.UnitId)>
						u.UnitId = <cfqueryparam value="#qTodayWorkOrders.UnitId#" cfsqltype="CF_SQL_INTEGER"> AND
					</cfif>
					u.Email IS NOT NULL AND u.Email <> ''
			</cfquery>

			<cfset emailSubject = "New Work Order Opened Today - WO##" & qTodayWorkOrders.WorkOrderId>
			
			<cfsavecontent variable="emailBody">
					<h2 style="color: ##333; margin-bottom: 20px;">Work Order Notification</h2>
					<p style="color: ##666; margin-bottom: 25px;">A new work order has been opened today for your unit.</p>
					
					<div style="background-color: ##f8f9fa; border-radius: 8px; padding: 20px; margin-bottom: 25px;">
							<div style="margin-bottom: 15px;">
									<strong style="color: ##555; display: inline-block; width: 120px;">Work Order ID:</strong>
									<span style="color: ##333;">#qTodayWorkOrders.WorkOrderId#</span>
							</div>
							<div style="margin-bottom: 15px;">
									<strong style="color: ##555; display: inline-block; width: 120px;">Asset:</strong>
									<span style="color: ##333;">#qTodayWorkOrders.AssetDescription#</span>
							</div>
							<div style="margin-bottom: 15px;">
									<strong style="color: ##555; display: inline-block; width: 120px;">Date Opened:</strong>
									<span style="color: ##333;">#DateFormat(qTodayWorkOrders.DateOpened, "dd-mmm-yyyy")#</span>
							</div>
					</div>
					
					<p style="color: ##666; margin-bottom: 10px;">Please log in to the system to view more details.</p>
					<p style="color: ##999; font-size: 0.9em;">This is an automated message. Please do not reply to this email.</p>
			</cfsavecontent>

			<!--- Send email to each user in the unit --->
			<cfloop query="qUnitUsers">
					<!--- Add special note for supervisors --->
					<cfset userEmailBody = emailBody>
					<cfif qUnitUsers.Role EQ "SV">
						<cfset userEmailBody = userEmailBody & "<p><strong>Note for Supervisor:</strong> As a supervisor, please ensure this work order is properly assigned and monitored.</p>">
					</cfif>
 					<cfmail 
						from="AssetGear <do-not-reply@assetgear.net>" 
						to="#qUnitUsers.Email#"
						subject="#emailSubject#" 
						type="html">
							#userEmailBody#
					</cfmail>
					
			</cfloop>
	</cfloop>
</cfoutput>