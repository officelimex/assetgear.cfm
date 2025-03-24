<cfoutput> 
<cfset qJ = application.com.Permit.GetJHA(url.id)/>
<cfdocument pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0.1" marginright="0.1" orientation="landscape">
<html>
<head>
<cfset bg = "##d7f6d4"/>
<cfset brd_c = "##b8f0b4"/>
<cfset brd_c2 = "##7ce272"/>
<style type="text/css">	
	html,body{padding:0; margin:0;font: 10px Tahoma;}
	.ths{font-size:7px;}
	.ths th, .ths td{padding:3px; font-weight:normal;}
	.ths th{text-align:left; background-color:#bg#;}
	.ths td{font-size:7px; padding:2px; border-bottom:1px solid #bg#; vertical-align:top;}
	.head_section td{font-size: 11px;padding:5px;}
	.head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
	.head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.head_section td.bottom{border-bottom:#brd_c# 1px solid;}
	.sub_head{font-size:11px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
	.content{padding:5px;}
	.underline{border-bottom:solid 1px ##333;
	padding: 0px; font-style:italic;}
	.left-pad5{}
	.t td{
	padding: 10px 5px 0px;
}
	.c-space{padding: 0px 5px;}
	.boxb{font-size:11px;line-height:16px;
	border: solid 1px ##333;font-style:italic;
	padding: 8px 9px 22px; margin-bottom:5px;
}
.schar{font:"Courier New", Courier, monospace;}
.mk{
	color: ##F30;
	font-weight: bold;
}
.sig{ 
	background:url(../../../doc/photo/core_user/1/8.png);
	<!---background-size:80px 60px;--->
	background-repeat:no-repeat;
}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="JOB HAZARD ANALYSIS"/>
<cfset request.letterhead.Id="JHA ## #url.id#"/>
<cfset request.letterhead.logosize=70/>
<cfset request.letterhead.titlesize=9/> 
<cfset request.letterhead.date="Date: #Dateformat(qJ.Date,'dd/mm/yyyy')#"/>
<cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem> 
<tr>
  <td><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:8px;">
    <tr>
      <td colspan="2">Work Description: &nbsp;&nbsp;<em>#qJ.WorkDescription# on #qJ.Asset#</em></td>
      </tr>
    <tr>
      <td colspan="2" height="3"></td>
      </tr>
    <tr>
      <td width="90%">Equipment/Tools to be used:&nbsp;&nbsp; <em>#qj.EquipmentToUse#</em></td>
      <td width="10%" nowrap>WorkOrder ##: <strong>#qJ.WorkOrderId#</strong>&nbsp;&nbsp;&nbsp;&nbsp;, Permit ##: <strong>#qJ.PermitId#</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
      </tr>
  </table></td>
</tr>
<tr>
  <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="ths">
    <tr>
      <th>&nbsp;</th>
      <th nowrap="nowrap">Job Sequence</th>
      <th>Hazard</th>
      <th align="center">Who may be Harmed</th>
      <th align="center">Severity</th>
      <th>Likelihood</th> 
      <th>Risk Rating</th>
      <th>Control Measures</th>
      <th>Recovery Plan</th>
      <th>Action Parties</th>
    </tr>
    <cfset qJL = application.com.Permit.GetJHAList(url.id)/>
    <cfloop query="qJL">
      <tr>
        <td valign="top" width="1px">#qJL.CurrentRow#.</td>
        <td valign="top">#qJL.JobSequence#</td>
        <td valign="top">#qJL.Hazard#</td>
        <td align="left" valign="top" >#qJL.Whom#</td>
        <td align="left" valign="top" >#qJL.Severity#</td>
        <td valign="top">#qJL.Likelihood#</td>
        <td valign="top">#qJL.Risk#</td>
        <td valign="top">#qJL.ControlMeasure#</td>
        <td valign="top">#qJL.RecoveryPlan#</td>
        <td valign="top">#qJL.ActionParties#</td>
      </tr>
    </cfloop>
  </table></td>
</tr>
<cfdocumentitem type="footer">
 <tr>
  <td>

    <table>
      <tr>
        <td weight="33%">
          <table style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
            <tr>
              <td align="right">
                Signature:
              </td>
              <td  nowrap="nowrap" width="100px">
                <cfset fl = application.com.File.GetSignaturePath(qJ.PreparedByUserId)/>
                <cfif len(fl)>
                  <cfhttp url="#fl#" method="get" result="imageData" />
                  <cfset base64Image = ToBase64(imageData.FileContent) />
                  &nbsp;&nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="20px"/>#DateTimeFormat(qJ.Date,'dd-mmm-yyyy')#
                </cfif>
              </td>
            </tr>
            <tr>
              <td align="right" nowrap="nowrap">
                Prepared By:
              </td>
              <td nowrap="nowrap">
                #qJ.PreparedBy# 
              </td>
            </tr>
          </table>           
        </td>

        <td weight="33%" align="center">
          <table style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
            <tr>
              <td align="right">
                Signature:
              </td>
              <td  nowrap="nowrap" width="100px">
                <cfset fl = application.com.File.GetSignaturePath(qJ.ReviewedByUserId)/>
                <cfif len(fl)>
                  <cfhttp url="#fl#" method="get" result="imageData" />
                  <cfset base64Image = ToBase64(imageData.FileContent) />
                  &nbsp;&nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="20px"/>#DateTimeFormat(qJ.ReviewedDate,'dd-mmm-yyyy')#
                </cfif>
              </td>
            </tr>
            <tr>
              <td align="right" nowrap="nowrap">
                Reviewed By:
              </td>
              <td nowrap="nowrap">
                #qJ.ReviewedBy# 
              </td>
            </tr>
          </table>           
        </td>

        <td weight="33%">
          <table style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
            <tr>
              <td align="right">
                Signature:
              </td>
              <td  nowrap="nowrap" width="100px">
                <cfset fl = application.com.File.GetSignaturePath(qJ.HSEUserId)/>
                <cfif len(fl)>
                  <cfhttp url="#fl#" method="get" result="imageData" />
                  <cfset base64Image = ToBase64(imageData.FileContent) />
                  &nbsp;&nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="20px"/>#DateTimeFormat(qJ.HSEDate,'dd-mmm-yyyy')#
                </cfif>
              </td>
            </tr>
            <tr>
              <td align="right" nowrap="nowrap">
                HSE:
              </td>
              <td nowrap="nowrap">
                #qJ.HSEBy# 
              </td>
            </tr>
          </table>           
        </td>
      </tr>
    </table>


  </td>
 </tr> 
<tr><td >
 
  <table width="100%" border="0" style="font:7px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
<tr>
  <td width="75%" nowrap="nowrap">
 
  </td>
    <td width="25%" align="right" nowrap="nowrap">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
</tr></table></td></tr>
</cfdocumentitem>
</table>
</body>
</html>
</cfdocument>

</cfoutput>