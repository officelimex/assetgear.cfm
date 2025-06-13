<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

	<cfparam name="Attributes.TagName" type="string" default="TextArea"/> 
	<cfparam name="Attributes.name" type="string"/>
	<cfparam name="Attributes.Label" type="string" default="#Attributes.name#"/>
	<cfparam name="Attributes.value" type="string" default=""/>
	<cfparam name="Attributes.class" type="string" default="input-large"/>
	<cfparam name="Attributes.required" type="boolean" default="false"/>
	<cfparam name="Attributes.Help" type="string" default=""/>
	<cfparam name="Attributes.rows" type="numeric" default="3"/>
	<cfparam name="Attributes.style" type="string" default=""/>
	<cfparam name="Attributes.IsEditor" type="boolean" default="no"/>
	<cfparam name="Attributes.ShowLabel" type="boolean" default="yes"/>
	<cfparam name="Attributes.Id" type="string" default="#request.form.formid##Attributes.name#"/>

	<cfassociate basetag="cf_form" /> 

	<cfset dd = ""/>
	<cfset tagId = "_" & createUniqueID() & createUniqueID()/>

	<cfif Attributes.IsEditor>
<!--- 			<script>
					<cfset dd= "_#CreateUUID()#"/>
						CKEDITOR.replaceAll('#dd#');
							var editor = CKEDITOR.instances['WorkDetails'], _txteditor = $$('.#dd#')[0];
							editor.on( 'key', function( e ) {
									_txteditor.set('text',e.editor.getData());
							});
							editor.on( 'blur', function( e ) {
									_txteditor.set('text',e.editor.getData());
							});
			</script> --->
			<script>
				<cfset dd = "_#tagId#"/>
				CKEDITOR.replaceAll('#dd#');
				var editor_#tagId# = CKEDITOR.instances['#Attributes.Id#'], _txteditor_#tagId# = $$('.#dd#')[0];
				editor_#tagId#.on( 'key', function( e ) {
					_txteditor_#tagId#.set('text',e.editor.getData());
				});
				editor_#tagId#.on( 'blur', function( e ) {
					_txteditor_#tagId#.set('text',e.editor.getData());
				});
			</script>
	</cfif>
    
 	<div class="control-group">
    <cfset req = ""/>
    <cfset i = "x"/>
    
    <cfif Attributes.ShowLabel>
			<label for="#Attributes.Id#" class="control-label">#Attributes.Label#    
			<cfif Attributes.required>
					<cfset req = "required"/><i class="red">*</i>
			</cfif></label>
			<cfset i = ""/>
    </cfif>
	<div class="controls#i#">

	<textarea type="text" id="#Attributes.Id#" <cfif Attributes.style neq "">style="#Attributes.style#"</cfif> name="#Attributes.name#" rows="#Attributes.rows#" class="#Attributes.class# #dd# #req#">#Attributes.value#</textarea>
    <cfif Attributes.Help neq ""><p class="help-block">#Attributes.Help#</p></cfif>
<cfelse>
 </div></div>  
</cfif> 
</cfoutput>