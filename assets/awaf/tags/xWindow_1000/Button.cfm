<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

	<cfparam name="Attributes.TagName" type="string" default="Button"/>
	<cfparam name="Attributes.Value" type="string" default="Save"/> 
	<cfparam name="Attributes.class" type="string" default="btn-primary"/>
	<cfparam name="Attributes.icon" type="string" default="icon-ok icon-white"/><!--- --->
	<cfparam name="Attributes.onClick" type="string" default=""/> 
	<!--- <cfparam name="Attributes.condition" type="string" default=""/>  --->
	<!--- for new form 
	<cfparam name="Attributes.IsNewForm" type="boolean" default="false"/> --->
	<!--- end  
	<cfparam name="Attributes.NewWindowURL" default=""/>---->
	<!--- for saving data --->		
	<cfparam name="Attributes.IsSave" type="boolean" default="false"/> 
	<!--- end ----> 
	<!---<cfparam name="Attributes.executeURL" type="string" default=""/>  execuite command on a url --->
    
  <cfassociate basetag="cf_Window" /> 
	<cfset windowTagData = getBaseTagData("cf_Window") /> 

      <!--- _w.addButton(new Element('a',{ --->
      win_#windowTagData.Attributes.id#.addButton(new Element('a',{
      html: 
			<cfif Attributes.icon eq "">
				'#Attributes.Value#',
			<cfelse>
				'<i class="#Attributes.icon#"></i> #Attributes.Value#',
			</cfif>
			'class' : 'btn #Attributes.class#',
			<!--- 'class' : 'btn #Attributes.class# hide', --->
			styles : {
				'margin-left':'10px'
			},
			events:{
					click:function(e)	{
						<cfif Attributes.IsSave> 
							var frm = $$('###request.window.id# form')[0];
							new Form.Validator.Inline(frm, { 								   
								onFormValidate: function(passed, form, event) {
									if (passed) {
										$(frm).set('send', {
												onRequest: function(){e.target.disabled=true },
												onFailure: function(r){showError(r);},
												onSuccess: function(r){
													if(r.trim()==''){r='Your data was saved sucessfuly.'}
													var an = new aNotify();
													an.alert('Successful!',r);  
													// _w.close();
													win_#windowTagData.Attributes.id#.close();
												},
												onComplete: function(){e.target.disabled=false;}
									}).send();
								}
							}}).validate();
						</cfif> 
						<cfif len(Attributes.onClick)>
							#Attributes.onClick#
						</cfif>
							<!---<cfif len(Attributes.NewWindowURL)>
									<cfset nid = "_" & left(createUUID(),6)/>
									<cfif find('?',Attributes.NewWindowURL)>
											window.open(#Attributes.NewWindowURL#+'&id='+d[0],'#nid#'+d[0],'',false);
									<cfelse>
											window.open(#Attributes.NewWindowURL#+'?id='+d[0],'#nid#'+d[0],'',false);
									</cfif> 
							</cfif>--->
							
		<!---<cfif Attributes.executeURL neq ""> 
									new Request({
									<cfif find('?',Attributes.executeURL)>
											url: #Attributes.executeURL#+'&id='+d[0],
									<cfelse>
											url: #Attributes.executeURL#+'?id='+d[0],
									</cfif> 
											method: 'post',
											onRequest: function()	{e.target.disabled=true;},
											onSuccess: function(r)	{
													var an = new aNotify();
													an.alert('Success!',r);	
													_w.close();
													//tr.highlight('##FF0'); 					
											},
											onFailure:function(e)	{
													showError(e);
													e.target.disabled=false;
											}
									}).send();
							</cfif>  --->
					}.bind(win_#windowTagData.Attributes.id#) 
				}       
<cfelse>
 	}));
</cfif> 
</cfoutput>