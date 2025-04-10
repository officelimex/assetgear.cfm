<cfparam name="request.letterhead.noline" default="false" type="boolean"/>
<cfparam name="request.letterhead.logosize" default="100" type="numeric"/>
<cfparam name="request.letterhead.titlesize" default="13" type="numeric"/>
<cfparam name="request.letterhead.date" default=""/>
<cfparam name="request.letterhead.qrcode" default="#request.letterhead.id#"/>
<cfparam name="request.letterhead.top" default="0"/>

<cfoutput>
	<tr>
		<td class="noline">
			<table width="100%" border="0">
				<tr>
					<td width="#request.letterhead.logosize#+15" rowspan="2" align="left" valign="top" class="noline">
						<img src="#application.site.url#assets/img/client_logo.png" width="#request.letterhead.logosize#">
					</td>
					<td valign="middle" style=""></td>
					<td align="right" valign="top" style="font-family: Tahoma;" class="noline">
						<div style="font-size:#request.letterhead.titlesize+2#px;">
							<span style="font-weight: bold;">OVADE GAS PLANT</span>
							&nbsp;&nbsp;
							<span style="color:##dddddd;">|</span>
							&nbsp;&nbsp;
							<span style="font-size:#request.letterhead.titlesize#px;">#request.letterhead.title#</span>
						</div>
						<div style="font-size:#request.letterhead.titlesize-3#px;margin-top:5px;">
							<cfif request.letterhead.date neq "">
								<span>#request.letterhead.date#</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</cfif>
							<span style="font-size:#request.letterhead.titlesize+1#px;">#request.letterhead.id#</span>
						</div>
					</td>
					<cfif request.letterhead.qrcode neq "">
						<cfscript>
							f = new assetgear.com.awaf.util.file();
							base64String = f.createQRCode('https://officelime.com/?!=#request.letterhead.id#', 59);
						</cfscript>
						<td width="10px"></td>
						<td width="10px">
							<img src="data:image/png;base64,#base64String#">
						</td>
					</cfif>
				</tr>
				<cfif request.letterhead.top neq "0"></cfif>
					<tr>
						<td colspan="4" style="font-size:#request.letterhead.top#px">&nbsp;</td>
					</tr>
				<cfif !request.letterhead.noline>
					<tr>
						<td colspan="2" style="font-size:3px"><div style="border-top:##f0f2f8 1px solid; margin-top:1px;">&nbsp;</div></td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>

</cfoutput>
