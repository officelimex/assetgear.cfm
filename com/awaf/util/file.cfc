<cfcomponent>
	
	<cffunction name="Init" access="public" returntype="File">
		
		<cfreturn this/>
	</cffunction>
    
	<cffunction name="Move" access="public" returntype="void">
		<cfargument name="table" type="string" required="yes">
		<cfargument name="pk" type="numeric" required="yes">
		<cfargument name="type" type="string" required="yes">
		<cfargument name="source" type="string" required="yes">
		<cfargument name="destination" type="string" required="yes">
		<cfargument name="createdby" type="numeric" required="yes" default="#request.userinfo.userid#"/>
 		
		<cfif DirectoryExists(arguments.source)>
				<cfdirectory action="list" name="qL" directory="#arguments.source#"/>
				<cfif qL.recordcount>
						<cfif !DirectoryExists(arguments.destination)>
								<cfdirectory action="create" directory="#arguments.destination#"/>
						</cfif>
				</cfif>
				<cfloop query="qL">
						<cffile action="move" source="#qL.directory#\#ql.Name#" destination="#arguments.destination##ql.Name#" nameconflict="overwrite" />
						<cfquery>
								INSERT INTO `file` SET
								`File` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ql.Name#"/>,
								`PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pk#"/>,
								`Size` = <cfqueryparam cfsqltype="cf_sql_bigint" value="#ql.Size#"/>,
								`Table` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table#"/>,
								`Type` = <cfqueryparam cfsqltype="cf_sql_char" maxlength="1" value="#arguments.type#"/>,
								`CreatedByUserId` = #arguments.createdby#
						</cfquery>
				</cfloop>
				<!--- delete temp directory --->
				<cfdirectory action="delete" directory="#arguments.source#"/>
		</cfif>
	
	</cffunction>

	<cffunction name="GetSignaturePath" access="public" returntype="string" hint="Get user signature path">
		<cfargument name="uid" hint="user id" required="no" type="string"/>

		<cfquery name="qS1" cachedwithin="#CreateTime(1,0,0)#">
			SELECT * FROM `file`
			WHERE `Table` = 'core_user'
				AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.uid)#"/>
			LIMIT 0,1
		</cfquery>

		<cfset p = ""/>
		<cfif qS1.recordcount>
			<cfset p = s3generatePresignedUrl("#application.s3.bucket#doc/photo/core_user/#arguments.uid#/#qS1.File#")/>
		</cfif>

		<cfreturn p/>
	</cffunction>

	<cffunction name="GetPotoPaths" access="public" returntype="array" hint="Get user signature path">
		<cfargument name="uid" hint="user id" required="yes" type="string"/>
		<cfargument name="model" hint="table" required="yes" type="string"/>

		<cfquery name="qS1" cachedwithin="#CreateTime(1,0,0)#">
			SELECT * FROM `file`
			WHERE `Table` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.model)#"/>
				AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.uid)#"/>
		</cfquery>

		<cfset ex_list = arrayNew()/>
		<cfloop query="qS1">
			<cfset p = s3generatePresignedUrl("#application.s3.bucket#doc/photo/core_user/#arguments.uid#/#qS1.File#")/>
			<cfset ex_list = arrayAppend(ex_list, p)/>
		</cfloop>

		<cfreturn ex_list/>
	</cffunction>

	<cffunction name="GetDocPaths" access="public" returntype="array" hint="get doc path">
		<cfargument name="uid" hint="user id" required="yes" type="string"/>
		<cfargument name="model" hint="table" required="yes" type="string"/>

		<cfquery name="qS1" cachedwithin="#CreateTime(1,0,0)#">
			SELECT 
				* 
			FROM `file`
			WHERE `Table` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.model)#"/>
				AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.uid)#"/>
		</cfquery>

		<cfset ex_list = arrayNew()/>
		<cfloop query="qS1">
			<cfset p = s3generatePresignedUrl("#application.s3.bucket#doc/photo/core_user/#arguments.uid#/#qS1.File#")/>
			<cfset ex_list = arrayAppend(ex_list, p)/>
		</cfloop>

		<cfreturn ex_list/>
	</cffunction>

	<cffunction name="createQRCode" access="public" returntype="any">
		<cfargument name="content" required="yes" type="string"/>
		<cfargument name="size" required="yes" type="numeric"/>
		<cfargument name="color" required="no" default="000000" type="string"/>
		<cfargument name="logo" required="no" type="string" />

		<cfif arguments.color == "">
			<cfset arguments.color = "000000"/>
		</cfif>
		<cfscript>
			zxing = new assetgear.com.google.zxing();
			base64String = zxing.createQRBinary(
				content         = arguments.content,
				size            = arguments.size,
				margin          = 0,
				fgColorHex 			= "#arguments.color#",
				errorCorrection = "L",
				logoPath 				= "#arguments.logo#"
			);
		</cfscript>

		<cfreturn base64String/>
	</cffunction>


</cfcomponent>

