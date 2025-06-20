<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

	<cfparam name="Attributes.TagName" type="string" default="Button"/>
	<cfparam name="Attributes.Value" type="string" default="Save"/> 
	<cfparam name="Attributes.class" type="string" default="btn-primary"/>
	<cfparam name="Attributes.icon" type="string" default="icon-ok icon-white"/><!--- --->
	<cfparam name="Attributes.onClick" type="string" default=""/> 
	<!--- for new form --->
	<cfparam name="Attributes.IsNewForm" type="boolean" default="false"/> 
	<!--- end ----> 
	<cfparam name="Attributes.NewWindowURL" default=""/>
	<!--- for saving data --->
	<cfparam name="Attributes.IsSave" type="boolean" default="false"/> 
	<cfparam name="Attributes.prompt" type="string" default=""/> 
	<cfparam name="Attributes.condition" default="1"/> 
	<cfparam name="Attributes.warning" default="" type="string"/> 
	<!--- end ----> 
	<cfparam name="Attributes.executeURL" type="string" default=""/> <!--- execute command on a url --->
	<cfassociate basetag="cf_Window" />  
	<cfset windowTagData = getBaseTagData("cf_Window") /> 
	<!--- <cfdump  var="#windowTagData.Attributes#"/> --->
			var pmt = "";
			<!--- _w.addButton(new Element('a',{ --->
			win_#windowTagData.Attributes.id#.addButton(new Element('a',{
					html: 
		<cfif Attributes.icon eq "">
			'#Attributes.Value#',
		<cfelse>
			'<i class="#Attributes.icon#"></i> #Attributes.Value#',
		</cfif>
		<cfif Attributes.condition == 1>
			'class' : "btn #attributes.class#",
		<cfelse>
			'class' : ["btn #attributes.class#", !(#Attributes.condition#) && "hide"].filter(Boolean).join(" "),
		</cfif>
		styles : {
			'margin-left':'10px'
		},
		events:{
				click:function(e)	{
					<cfif len(trim(Attributes.warning))>
						if (!confirm('#Attributes.warning#')) {
							return;
						}
					</cfif>
					<cfif Attributes.prompt != "">
						pmt = prompt("#Attributes.prompt#", "");
						if(pmt=="")	{
							return;
						}
					</cfif>
					<cfif Attributes.IsSave> 
							<cfif Attributes.IsNewForm>
								var frm = '#request.grid.renderTo#0frm'; 
							<cfelse>
								var frm = '#request.grid.renderTo#'+d[0]+'frm'; 
							</cfif> 
							
							new Form.Validator.Inline($(frm), { 								   
								onFormValidate: function(passed, form, event) {
									if (passed) {
										$(frm).set('send', {
											onRequest: function(){e.target.disabled=true },
											onFailure: function(r){showError(r);},
											onSuccess: function(r){
													if(r.trim()==''){r='Your data was saved successfully. Please refresh to see change.'}
													var an = new aNotify();
													an.alert('Successful!',r);  
													// _w.close();
													win_#windowTagData.Attributes.id#.close()
													tr.highlight('##FF0'); 
											},
											onComplete: function(){e.target.disabled=false;}
										}).send();
									}
							}}).validate();
					</cfif> 
					<cfif len(Attributes.onClick)>
							#Attributes.onClick#                        
					</cfif>
					<cfif len(Attributes.NewWindowURL)>
						<cfset nid = "_" & left(createUUID(),6)/>
						<cfif find('?',Attributes.NewWindowURL)>
							window.open(#Attributes.NewWindowURL#+'&id='+d[0],'#nid#'+d[0],'',false);
						<cfelse>
							window.open(#Attributes.NewWindowURL#+'?id='+d[0],'#nid#'+d[0],'',false);
						</cfif> 
					</cfif>
					
					<cfif Attributes.executeURL neq ""> 
						new Request({
						<cfif find('?',Attributes.executeURL)>
							url: #Attributes.executeURL#+'&id='+d[0],
						<cfelse>
							url: #Attributes.executeURL#+'?id='+d[0],
						</cfif> 
							method: 'post',
							data: function() {
								var frm = '#request.grid.renderTo#'+d[0]+'frm'; 
								var formData = $(frm).toQueryString();  // ✅ Use explicit form reference
								formData += '&pmt=' + encodeURIComponent(pmt); // ✅ Add dynamic value
								return formData;
							}(),
							onRequest: function()	{e.target.disabled=true;},
							onSuccess: function(r)	{
									var an = new aNotify();
									an.alert('Successful!',r);	
									// _w.close();
									win_#windowTagData.Attributes.id#.close()
									tr.highlight('##FF0'); 					
							},
							onFailure:function(e)	{
									showError(e);
									e.target.disabled=false;
							}
						}).send();
					</cfif>  
				}.bind(_g) 
			}       
		<cfelse>
			}));
		</cfif> 
</cfoutput>