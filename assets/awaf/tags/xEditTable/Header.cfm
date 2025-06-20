<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
	<cfparam name="Attributes.TagName" type="string" default="Header"/>
	<cfparam name="Attributes.title" type="string" default=""/>
	<cfparam name="Attributes.name" type="string" default=""/>
	<cfparam name="Attributes.size" type="numeric" default="3"/><!--- as in span[?]---> 
	<cfparam name="Attributes.type" type="string" default="text"/><!--- text, date --->
	<cfparam name="Attributes.hint" type="string" default=""/> 
	<cfparam name="Attributes.rows" type="numeric" default="1"/> <!--- if its more than 1, then its a textarea --->
	<cfparam name="Attributes.disabled" type="boolean" default="false"/><!--- disable the column --->
	<cfparam name="Attributes.OnSelect" type="string" default=""/><!--- e --->
	<cfparam name="Attributes.required" type="boolean" default="true"/>
 	
    <cfassociate basetag="cf_Headers"/>
    
 	{'title': '#Attributes.title#', 'size': #Attributes.size#, 'type': '#Attributes.type#',
	 hint:'#Attributes.hint#', 'rows': #Attributes.rows#, disabled: #Attributes.disabled#, required: #Attributes.required#
	 <!---<cfif Attributes.OnSelect neq ""> , 'onSelect' : "#Attributes.OnSelect#"</cfif>--->
<cfelse>},
</cfif> 
</cfoutput>
