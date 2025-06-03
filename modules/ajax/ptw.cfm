<cfoutput>

	<cfset hse_email = application.com.User.GetEmailsInRoleAndDept("SV,SUP,MGR", application.department.hse)/> <!--- hse department --->
	<cfset opr_email = application.com.User.GetEmailsInRoleAndDept("SV,SUP", application.department.operations)/> <!--- operations department --->
	<cfset lpg_email = application.com.User.GetEmailsInRoleAndDept("SV,SUP", application.department.lpg)/> <!--- operations department --->

    <cfswitch expression="#url.cmd#">    
    	
        <!---getPermit--->
        <cfcase value="getPermit">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                <cfif url.cid neq "" >
               		WHERE d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                    <cfif structkeyexists(url,'keyword')>
                        AND  (#url.Field# LIKE "%#url.keyword#%")
                    </cfif>
                <cfelse>
                    <cfif structkeyexists(url,'keyword')>
                        WHERE  #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfif>

                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                <cfif url.cid neq "" >
                    WHERE d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#"/>
                    <cfif structkeyexists(url,'keyword')>
                        AND  (#url.Field# LIKE "%#url.keyword#%")
                    </cfif>
                <cfelse>
                    <cfif structkeyexists(url,'keyword')>
                        WHERE  #url.Field# LIKE "%#url.keyword#%"
                    </cfif>
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",#serializeJSON(q.Status)#]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!--- get un approved permit--->
        <cfcase value="GetUnApprovedPermit">
        		<cfset start = (url.page * url.perpage) - (url.perpage)/>
						<cfparam name="url.did" default="0"/>
            <cfquery name="q">
							#application.com.Permit.PERMIT_SQL#
							WHERE 1 = 1 
								<cfif url.did>
									AND d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.did#"/>
								</cfif>
								AND p.Status NOT IN ('Approved','Closed')
							<cfif structkeyexists(url,'keyword')>
								AND (#url.Field# LIKE "%#url.keyword#%")
							</cfif>
							ORDER BY #url.sort# #url.sortOrder#
							LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
								WHERE 1 = 1 
								<cfif url.did>
									AND d.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.did#"/>
								</cfif>
                	AND p.Status NOT IN ('Approved','Closed')
									<cfif structkeyexists(url,'keyword')>
                  AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
							"page": #url.page#,
							"rows":[
								<cfloop query="q">
       			 			[#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
									<cfswitch expression="#q.Status#">
										<!--- <cfcase value="Open">#serializeJSON('<span class="label label-info">Sent to Supervisor</span>')#</cfcase> --->
										<cfcase value="Sent to Operations,Sent to Admin">
											#serializeJSON('<span class="label label-warning">#q.Status#</span>')#
										</cfcase>
										<cfcase value="Sent to Supervisor">
											#serializeJSON('<span class="label label-info">#q.Status#</span>')#
										</cfcase>
										<cfdefaultcase>
											#serializeJSON('<span class="label label-secondary">#q.Status#</span>')#
										</cfdefaultcase>
									</cfswitch>,
									"#q.Status#"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!--- get approved permit--->
        <cfcase value="GetApprovedPermitByFS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
								WHERE p.Status = "Approved"
                <cfif structkeyexists(url,'keyword')>
                	AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>

            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status = "Approved"
								<cfif structkeyexists(url,'keyword')>
									AND (#url.Field# LIKE "%#url.keyword#%")
								</cfif>
            </cfquery>

            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 		[#q.PermitId#,#q.JHAId#,#serializeJSON(q.WorkOrderId & ': ' & q.Work)#,#serializeJSON(q.PA)#,"#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#","#DateFormat(q.CurrentValidity,'dd-mmm-yyyy')#",
                  #serializeJSON('<span class="label label-success">#q.Status#</span>')#,
                 "#q.Status#"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---getPermit To Approve For PS--->
        <cfcase value="getPermitToApproveForPS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status IN ('WFPSTA')
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status IN ('WFPSTA')
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
                 <cfswitch expression="#q.Status#">
                 	<cfcase value="WFPSTA">"Waiting for you to Approve Permit"</cfcase>
                 </cfswitch>]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---getPermit To Approve For HSE--->
        <cfcase value="getPermitToApproveForHSE">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status = "WFHTS"
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE (FSApprovedByUserId <> 0 OR FSApprovedByUserId IS NOT NULL)
                    AND (SVApprovedByUserId = 0 OR SVApprovedByUserId IS NULL)
								<cfif structkeyexists(url,'keyword')>
									AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#","Waiting for you to Sign permit"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>

        <!---getPermit To Approve For FS--->
        <cfcase value="getPermitToApproveForFS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status = "WFFSTA"
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status = "WFFSTA"
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
                 <cfswitch expression="#q.Status#">
                 	<cfcase value="WFFSTA">"Wating for you to Sign Permt"</cfcase>
                 </cfswitch>]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---Get Closed Permit--->
        <cfcase value="GetClosedPermit">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status = 'Closed'
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status = 'Closed'
								<cfif structkeyexists(url,'keyword')>
                  AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",
							#serializeJSON('<span class="label label-info">Closed</span>')#
                 ]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---get Permit To Close By PS--->
        <cfcase value="getPermitToCloseByPS">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE (`Completed` <> "" OR `Completed` IS NOT NULL)
                	AND (SVCloseByUserId = 0 OR SVCloseByUserId IS NULL)
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE (`Completed` <> "" OR `Completed` IS NOT NULL)
                	AND (SVCloseByUserId = 0 OR SVCloseByUserId IS NULL)
				<cfif structkeyexists(url,'keyword')>
                    AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#",#serializeJSON(q.Status)#,
                 <cfswitch expression="#q.Completed#">
                 	<cfcase value="no">#serializeJSON('<span class="label label-info">NO</span>')#</cfcase>
                    <cfcase value="yes">#serializeJSON('<span class="label label-success">YES</span>')#</cfcase>
                    <cfdefaultcase>""</cfdefaultcase>
                 </cfswitch>
                 ]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
         
        <!--- get Permit To Revalidate --->
        <cfcase value="getPermitToRevalidate">
        	<cfset start = (url.page * url.perpage) - (url.perpage)/>
            <cfquery name="q">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status = "SFR"
                <cfif structkeyexists(url,'keyword')>
                	AND  (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
                ORDER BY #url.sort# #url.sortOrder#
                LIMIT #start#,#url.perpage#
            </cfquery>
           
            <cfquery name="qT">
                #application.com.Permit.PERMIT_COUNT_SQL#
                WHERE p.Status = "SFR"
								<cfif structkeyexists(url,'keyword')>
                  AND (#url.Field# LIKE "%#url.keyword#%")
                </cfif>
            </cfquery>
            
            <cfoutput>
            {"total": #qT.c#,
                "page": #url.page#,
                "rows":[<cfloop query="q">
       			 [#q.PermitId#,#q.JHAId#,#serializeJSON(q.Work)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#","#DateFormat(q.EndTime,'dd-mmm-yyyy')#","Waiting for you to revalidate"]
                  <cfif q.recordcount neq q.currentrow>,</cfif>
                </cfloop>]}
            </cfoutput>
        </cfcase>
        
        <!---getJHA--->
        <cfcase  value="getJHAByUsers">
					<cfparam name="url.status" default=""/>
					<cfparam name="url.d" default="0"/>
					<cfset start = (url.page * url.perpage) - (url.perpage)/>
					<cfparam name="url.cid" default=""/>
					<cfquery name="q">
						#application.com.Permit.JHA_SQL#
						WHERE 1=1
						<cfif structkeyexists(url,'keyword')>
							AND  (#url.Field# LIKE "%#url.keyword#%")
						</cfif>
						<cfif url.d NEQ 0>
							AND wo.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.d#"/>
						</cfif>
						<cfif url.status NEQ "">
							AND j.Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.status#"/>
						</cfif>

						ORDER BY #url.sort# #url.sortOrder#
						LIMIT #start#,#url.perpage#
					</cfquery>
            
					<cfquery name="qT">
						#application.com.Permit.JHA_COUNT_SQL# 
						WHERE 1=1          
						<cfif structkeyexists(url,'keyword')>
							AND  (#url.Field# LIKE "%#url.keyword#%")
						</cfif>
						<cfif url.status NEQ "">
							AND j.Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.status#"/>
						</cfif>
					</cfquery>
					<cfoutput>
					{"total": #qT.c#,
						"page": #url.page#,
						"rows":[<cfloop query="q">
							[#q.JHAId#,#serializeJSON(q.WorkDescription)#,#serializeJSON(q.EquipmentToUse)#, "#DateFormat(q.Date,'dd-mmm-yyyy')#",#serializeJSON(q.PreparedBy)#,#serializeJSON(q.ReviewedBy)#,
								<cfswitch expression="#q.Status#">  
									<cfcase value="Draft">#serializeJSON('<span class="label">#q.Status#</span>')#</cfcase>
									<cfcase value="Approved">#serializeJSON('<span class="label label-success">#q.Status#</span>')#</cfcase>
									<cfdefaultcase>#serializeJSON('<span class="label label-info">#q.Status#</span>')#</cfdefaultcase>
								</cfswitch>,
								"#q.Status#",#q.DepartmentId#
							]
							<cfif q.recordcount neq q.currentrow>,</cfif>
						</cfloop>]}
					</cfoutput>    

        </cfcase>
        
				<!---Save JHA--->  
        <cfcase value="saveJHA">
					<cfset form.PreparedByUserId = request.userinfo.userId/>
        	<cfset id_ = application.com.Permit.saveJHA(form)/>
					<cfif form.id eq 0>
						JHA ###id_# was successfully saved, and sent to Suvervisor for review
					</cfif>
					<cfset form.id = id_/>
					<cfset SendToSv(10)/>
        </cfcase>  
        
        <!---SavePermit--->
        <cfcase value="SavePermit">
					<cfset savePermit()/>
					Permit #form.id# was successfully save 
        </cfcase>
        
				<cfcase value="sendBackToCreator">
					<cfset qJ = application.com.Permit.GetJHA(form.id)/>
					<cfset application.com.Permit.updateJHAStatus(form.id, "Draft")/>
					<cfset application.com.Helper.LogComment(form.id, form.pmt, "jha") />
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#qJ.PreparedByEmail#"
							cc="#request.userinfo.email#,#hse_email#" 
							subject="JHA ###form.id# Needs review" type="html">
							Hello
							<p>
								Your attention is needed on JHA ###form.id# for #qJ.WorkDescription#.
								=============================<br/>
								#form.pmt#
							</p>
							Thank you
						</cfmail>
					</cfif>
					Your Permit was sent back to the creator
				</cfcase>

				
				<cfcase value="SendBackToSupervisor">
					<cfset qJ = application.com.Permit.GetJHA(form.id)/>
					<cfset application.com.Permit.updateJHAStatus(form.id, "Sent to Supervisor")/>
					<cfset application.com.Helper.LogComment(form.id, form.pmt, "jha") />
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#qJ.ReviewedByEmail#"
							cc="#request.userinfo.email#,#qJ.PreparedByEmail#" 
							subject="JHA ###form.id# Needs review" type="html">
							Hello
							<p>
								Your attention is needed on JHA ###form.id# for #qJ.WorkDescription#
								=============================<br/>
								#form.pmt#
							</p>
							Thank you
						</cfmail>
					</cfif>
					Your Permit was sent back to the Supervisor
				</cfcase>

				<cfcase value="sendJHAToSupervisorO">
					<cfset SendToSv(10)/>
					Your Permit was sent to your Supervisour
				</cfcase>

				<cfcase value="sendJHAToSupervisorA">
					<cfset SendToSv(17)/>
					Your Permit was sent to your Supervisour
				</cfcase>

				<cfcase value="sendJHAToHSE">
					<cfquery>
						UPDATE ptw_jha SET 
							ReviewedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
							ReviewedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userId#"/>,
							Status = 'Sent to HSE'
						WHERE JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
					</cfquery>
					<cfset qJ = application.com.Permit.GetJHA(form.id)/>
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#hse_email#"
							cc="#request.userinfo.email#,#qJ.PreparedByEmail#" 
							subject="JHA ###form.id# Needs approval" type="html">
							Hello
							<p>
								JHA ###form.id# for #qJ.WorkDescription# on #qJ.Asset# was sent to you for approval.
							</p>
							Thank you
						</cfmail>
					</cfif>
					Your JHA was sent to the HSE
				</cfcase>

				<cfcase value="HSEApproveJHA">
					<cfquery>
						UPDATE ptw_jha SET 
							HSEDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
							HSEUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userId#"/>,
							Status = 'Approved'
						WHERE JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
					</cfquery>
					<cfset qJ = application.com.Permit.GetJHA(form.id)/>
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#qJ.PreparedByEmail#"
							cc="#request.userinfo.email#,#qJ.ReviewedByEmail#" 
							subject="JHA ###form.id# Approved" type="html">
							Hello
							<p>
								JHA ###form.id# for #qJ.WorkDescription# on #qJ.Asset# was sent to you for approval.<br/>
								Continue to your Permit to Work documentation.
							</p>
							Thank you
						</cfmail>
					</cfif>
					Your Permit was sent to the HSE
				</cfcase>
								
        <cfcase value="SendPermitToSupervisor">
					<cfset savePermit()/>
					<cfset qP = application.com.Permit.GetPermit(form.id)/>
					<cfquery>
						UPDATE `ptw_permit` SET
							`Status` = "Sent to Supervisor"
						WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
					</cfquery>
					<cfset to_email = application.com.User.GetEmailsInRoleAndDept("SV", request.userInfo.DepartmentId)/>
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#to_email#"
							cc="#request.userinfo.email#" 
							subject="Permit ###form.id# Needs approval" type="html">
							Hello
							<p>
								Permit ###form.id# for #qP.Work# on #qP.Asset# was sent to you for approval.
							</p>
							Thank you
						</cfmail>
					</cfif>
					Your Permit was sent to Supervisor
				</cfcase>
				
				<cfcase value="SendPermitToFacilityManager">
					<cfset savePermit()/>
					<cfset qP = application.com.Permit.GetPermit(form.id)/>
					<cfquery>
						UPDATE `ptw_permit` SET
							`Status` = "Sent to #url.user#",
							SVApprovedByUserId = #request.userinfo.userId#,
							SVApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>
						WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
					</cfquery>
					<cfset to_email = application.com.User.GetEmailsInRoleAndDept("SV", request.userInfo.DepartmentId)/>
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#to_email#"
							cc="#request.userinfo.email#" 
							subject="Permit ###form.id# Needs approval" type="html">
							Hello
							<p>
								Permit ###form.id# for "#qP.Work#" on #qP.Asset# was sent to you for approval.
							</p>
							Thank you
						</cfmail>
					</cfif>
					Your Permit was sent to Facility Manager (#url.user#)
				</cfcase>

				<cfcase value="FSApprovePermit">
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<cfquery>
						UPDATE `ptw_permit` SET
							`Status` = "Approved",
							FSApprovedByUserId = #request.userinfo.userId#,
							FSApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>
						WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
					</cfquery>
					<cfif application.live EQ application.mode>
						<cfset base_email = application.com.User.GetEmailsInRoleAndDept("SUP", request.userinfo.departmentId)/> 
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#qP.PAEmail#"
							cc="#hse_email#,#base_email#"
							subject="Permit ###url.id# Approved" type="html">
							Hello
							<p>
								Permit ###url.id# for "#qP.Work#" on #qP.Asset# has been approved.
							</p>
							Thank you
						</cfmail>
					</cfif>
					Permit ###url.id# has now been approved
				</cfcase>

				<cfcase value="PAClosePermit">
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<cfset _ststus = "Approved"/>
					<cfif qP.Status EQ _ststus>
						<cfif val(qP.SVCloseByUserId)>
							<cfset _ststus = "Closed"/>
						</cfif>
					</cfif>
					<cfquery>
						UPDATE `ptw_permit` SET
							`Status` = "#_ststus#",
							Completed = <cfqueryparam cfsqltype="cf_sql_char" value="#url.completed#"/>,
							PACloseByUserId = #request.userinfo.userId#,
							PACloseDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>
						WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
					</cfquery>
					<cfset application.com.Helper.logComment(url.id, form.pmt, "permit") />
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#qP.SVEmail#"
							cc="#hse_email#,#opr_email#"
							subject="Permit ###url.id# Closed" type="html">
							Hello
							<p>
								Permit ###url.id# for "#qP.Work#" has been closed by #request.userinfo.surname# #request.userinfo.otherNames#.
							</p>
							Kindly login to AssetGear to verify and close out the Permit
							<p>Thank you</p>
						</cfmail>
					</cfif>
					Permit ###url.id# has been sent to your supervisor 
				</cfcase>

				<cfcase value="RevalidatePermit">
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<!--- check if you can revalidate permit --->
 					<cfif now() GT qP.EndTime>
						<cfthrow message="You cannot revalidate a permit that has already expired" type="PermitError">
					</cfif>
					<cfquery name="qPreV">
						SELECT `Date` FROM ptw_permit_revalidated WHERE PermitId = #val(url.id)# ORDER BY Date DESC LIMIT 1
					</cfquery>
					
					<cfif dateFormat(qPreV.Date, "yyyy-mm-dd") EQ dateFormat(now(), "yyyy-mm-dd")>
						<cfthrow message="Permit has already been revalidated for today" type="PermitError">
					</cfif>
					<cfset application.com.Helper.logComment(url.id, form.pmt, "permit") />
					<cftransaction>
						<cfquery>
							INSERT INTO ptw_permit_revalidated SET 
								PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>,
								ValidatedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userId#"/>,
								`Date` = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
								StartTime = "09:00",
								EndTime = "17:00",
								Comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pmt#"/>
						</cfquery>
						<cfquery>
							UPDATE `ptw_permit` SET
								Revalidate = 'y',
								CurrentValidity = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>
							WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
						</cfquery>
  					<cfif application.live EQ application.mode>
							<cfmail 
								from="AssetGear <do-not-reply@assetgear.net>"
								to="#qP.PAEmail#"
								cc="#hse_email#,#opr_email#"
								subject="Permit ###url.id# Revalidated" type="html">
								Hello
								<p>
									Permit ###url.id# for "#qP.Work#" has been revalidated by #request.userinfo.surname# #request.userinfo.otherNames# for another 24hrs.
								</p>
								Thank you
							</cfmail>
						</cfif>
					</cftransaction>
					Permit ###url.id# was successfully revalidated
					
				</cfcase>

				<cfcase value="SVClosePermit">
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<cfset _ststus = "Approved"/>
					<cfif qP.Status EQ _ststus>
						<cfif val(qP.PACloseByUserId)>
							<cfset _ststus = "Closed"/>
						</cfif>
					</cfif>
					<cfquery>
						UPDATE `ptw_permit` SET
							`Status` = "#_ststus#",
							SVCloseByUserId = #request.userinfo.userId#,
							SVCloseDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>
						WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
					</cfquery>
					<cfset application.com.Helper.logComment(url.id, form.pmt, "permit") />
					<cfif application.live EQ application.mode>
						<cfmail 
							from="AssetGear <do-not-reply@assetgear.net>" 
							to="#qP.PAEmail#"
							cc="#hse_email#"
							subject="Permit ###url.id# Closed" type="html">
							Hello
							<p>
								Permit ###url.id# for "#qP.Work#" has been closed by #request.userinfo.surname# #request.userinfo.otherNames#.
							</p>
							Thank you
						</cfmail>
					</cfif>
					Permit ###url.id# Closed 
				</cfcase>
        <!--- send back to PA from PS/hse --->
        <cfcase value="SendBackToPA">
					<cfquery>
						UPDATE ptw_permit SET 
							`Status` = "STPSTA"
						WHERE PermitId = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer"/>
					</cfquery>
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<cfset application.com.Notice.SendBackMail("Review: Permit ##" & url.id, qp.PAApprovedByUserId, form.msg)/>
        </cfcase> 
        
        <cfcase value="AsForPermitEstension">
					<cfquery>
						UPDATE ptw_permit SET 
							Revalidate = "y", `Status` = "SFR"
						WHERE PermitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
					</cfquery>
					<cfset qP = application.com.Permit.GetPermit(url.id)/>
					<!--- Clear previous alert --->
					<cfset application.com.Notice.CloseNoticeByModule(url.id,'ptw')/>
					<!--- send alert to PS to extend permit ---->
					<cfset application.com.Notice.SendNotice(request.userinfo.userid, 0, 0, 0, 'ptw', 'PTW ###url.id# "#qP.Work#" need to be extended for another 24 hours', url.id,'PS')/>--->
            
      	</cfcase>
   </cfswitch>
</cfoutput>

<cffunction name="SendToSv">
	<cfargument name="did" required="yes"/>
	<cfset to_email = application.com.User.GetEmailsInRoleAndDept("SV", did)/>
	<cfset application.com.Permit.updateJHAStatus(form.id, "Sent to Supervisor")/>
	<cfset qJ = application.com.Permit.GetJHA(form.id)/>
	<cfif application.live EQ application.mode>
		<cfmail 
			from="AssetGear <do-not-reply@assetgear.net>" 
			to="#to_email#" 
			cc="#request.userinfo.email#,#hse_email#" 
			bcc="adexfe@live.com"
			subject="JHA ###form.id# Needs approval" type="html">
			Hello
			<p>
				JHA ###form.id# for #qJ.WorkDescription# on #qJ.Asset# was sent to you for approval.
			</p>
			Thank you
		</cfmail>
	</cfif>
</cffunction>

<cffunction name="SavePermit">
	<cfset form.id = val(form.id)/>
	<cfparam name="form.SafetyRequirement1" default=""/>
	<cfparam name="form.SafetyRequirement2" default=""/>
	<cfparam name="form.SafetyRequirement3" default=""/>
	<cfparam name="form.SafetyRequirement4" default=""/>
	<cfparam name="form.SafetyRequirement5" default=""/>
	<cfparam name="form.Certificate" default=""/>
	<cfparam name="form.HotWork" default=""/>
	<cfparam name="form.Precaution" default=""/>
	<cfparam name="form.PPE" default=""/>
	<cfparam name="form.ConfinedSpace" default=""/>
	<cfparam name="form.GasFree" default=""/>
	<cfparam name="form.WorkType" default=""/>
	<cfparam name="form.ZoneClass" default=""/>
	
	<!--- check if JHA  from your department first --->
	<cfset qJ = application.com.Permit.GetJHA(form.JHAId)/>
	<cfif !qJ.recordcount>
		<cfthrow message="JHA #form.JHAId# does not exist">
	</cfif>
	<cfif qJ.Status neq "Approved">
		<cfthrow message="Sorry! JHA #form.JHAId# is not approved yet">
	</cfif>
<!--- 	<cfif qJ.DepartmentId neq request.userinfo.departmentId>
		<cfthrow message="Sorry! you don't have permission to create Permit with JHA #form.JHAId#">
	</cfif> --->
	
	<!--- check if user has other permit opened --->
	<cfif form.id eq 0>
		<cfquery name="qCheck">
			SELECT PermitId FROM ptw_permit 
			WHERE PAApprovedByUserId = #val(request.userinfo.userid)#
				AND Status <> "Closed"
		</cfquery>
		<cfif qCheck.recordcount gt 5>
			<cfthrow message="Sorry! You already have 3 opened Permits. To create a permit close Permits ## #valuelist(qCheck.PermitId)#">
		</cfif>
	</cfif>
	
	<cfquery result="rt">
			<cfif form.id eq 0>
				INSERT INTO
			<cfelse>
				UPDATE 
			</cfif>
			ptw_permit SET
				JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.JHAId#"/>,
				NumberOfWorkers = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.NumberOfWorkers)#"/>,
				Date = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'yyyy-mmm-dd')#"/>,
				StartTime =<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.StartTime,'yyyy/mm/dd')# #TimeFormat(form.StartTime,'HH:MM')#"/>,
				EndTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.EndTime,'yyyy/mm/dd')# #TimeFormat(form.EndTime,'HH:MM')#"/>,
				Contractor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Contractor#"/>,
				SafetyRequirement1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement1#"/>,
				SafetyRequirement2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement2#"/>,
				SafetyRequirement3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement3#"/>,
				SafetyRequirement4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement4#"/>,
				SafetyRequirement5=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SafetyRequirement5#"/>,
				Certificate =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Certificate#"/>,
				PPE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PPE#"/>,
				AdditionalPrecaution=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AdditionalPrecaution#"/>,
				Precaution = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Precaution#"/>,
				ZoneClass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ZoneClass#"/>,
				WorkType = <cfqueryparam cfsqltype="cf_sql_char" value="#form.WorkType#"/>
				<cfif form.id eq 0> 
					,PAApprovedByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userInfo.UserId#"/>,
					PAApprovedDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
					`Status` = 'Open' 
				</cfif>
				<cfif form.id neq 0>
					WHERE Permitid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
				</cfif> 
	</cfquery>
	
	<cfif form.id eq 0>
		<cfset form.id = rt.GENERATED_KEY/>
	</cfif>
	
	<cfset f = CreateObject("component","assetgear.com.awaf.util.file").init()/>
	
	<!--- upload attachments --->
	<cfparam name="form.Attachments" default=""/>
	<cfif form.Attachments neq "">
		<cfset s_path = form.AttachmentsSource & "/" & form.Attachments />            
		<cfset d_path = form.AttachmentsDestination & "/ptw_permit/" & form.id & "/" /> 
		<cfset f.Move('ptw_permit',form.id,'a',s_path,d_path)/>
	</cfif>

</cffunction>