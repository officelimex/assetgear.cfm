<cfoutput>
	<cfif ThisTag.ExecutionMode EQ "Start">

		<cfparam name="Attributes.TagName" type="string" default="Label"/>  
		<cfparam name="Attributes.name" type="string" default=""/>
		<cfparam name="Attributes.value" type="string" default=""/>
		<cfparam name="Attributes.hideOnBlank" type="boolean" default="false"/>
		<cfparam name="Attributes.class" type="string" default=""/>
		
		<cfif not Attributes.hideOnBlank OR len(trim(Attributes.value)) GT 0>
			<div class="control-group" style="margin-bottom:2px;">
				<label class="control-label">#Attributes.name#:</label>
				<div class="controls" style="padding-top:5px; color:##666666;">
				 <div class="#Attributes.class#">
					#replace(Attributes.value,chr(10),'<br/>','all')#
				 </div>	
				</div>
			</div>
		</cfif>
	<cfelse>
				
	</cfif> 
</cfoutput>