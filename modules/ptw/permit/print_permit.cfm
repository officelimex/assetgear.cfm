<cfoutput>
<cfinclude template="inc_var.cfm"/>
<cfset qP = application.com.Permit.GetPermit(url.id)/>
<cfset qGT = application.com.Permit.GetGasTest(url.id)/>
<cfset qAL = application.com.Asset.GetAssetLocationInWorkOrder(qP.AssetLocationIds)/>
<cfset qL = application.com.WorkOrder.GetLabourers(qP.WorkOrderId)/>

<cfdocument pagetype="a4" format="pdf" margintop="0" marginbottom="0" marginleft="0.1" marginright="0.1" backgroundvisible="yes">
<html>
<head>
<cfset bg = "##f0f2f8"/>
<cfset brd_c = "##d6daeb"/>
<cfset brd_c2 = "##a5a5a5"/>
<cfset wt = ""/>
<cfswitch expression="#qP.WorkType#"> 
	<cfcase value="Cold Work"><cfset wt = "cold.gif"/></cfcase>
    <cfcase value="Hot Work"><cfset wt = "fire.gif"/></cfcase>
    <cfcase value="Electrical Work"><cfset wt = "plug.gif"/></cfcase> 
</cfswitch>
<style type="text/css">	
	body{
	background: url(#application.site.url#assets/img/#wt#) no-repeat fixed center center;
}
	html,body{padding:0; margin:0;font: 11px Tahoma;}
	.tbl-pad-4 td{
	padding: 8px 4px 0px 0px
}
	.tbl{font-size: 8px;} 
	sub{font-size: 4px;}
	.tbl > tr > td{padding: 3px 5px;border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td,.tbl td.bottom{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
	.underline{border-bottom:##9d9fc2 1px dashed; font-style:italic;}
	.sign > tr > td{padding: 5px 0 0px;}
	.pad-left-5	{padding-left:5px !important;}
	.pad-bottom-2	{padding-left:2px !important;}
	.pad-right-3	{padding-right:3px !important;}
	 .v-middle, .v-middle img	{vertical-align:middle;}
	 img{margin-top:1px;}
	 .cbg img{margin:0px;}
	 .bg-white  {background-color:white;}
</style>
<title></title>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="PERMIT TO WORK"/>
<cfset request.letterhead.Id="PTW ## #url.id#"/>
<cfset request.letterhead.noline=true/>
<!---cfset request.letterhead.logosize=40/--->
  <cfinclude template="../../../include/letter_head.cfm"/>
</cfdocumentitem> 
<tr>
<td><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl">
      <tr>
        <td width="25" align="center" valign="middle" class="left cbg">
          <img src="#application.site.url#assets/img/5x/section-1.png" width="25px"/>
        </td>
        <td colspan="4" valign="top">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="10%" nowrap="nowrap">FACILITY/INSTALLATION: </td>
                <td width="90%" class="underline">
                  #replace(valuelist(qAL.Location),',',', ','all')# &mdash; #qP.Asset#
                </td>
                <td nowrap="nowrap" style="padding-left:10px">ZONE CLASSIFICATION: </td>
                <td width="100px" class="underline">
                  #qP.ZoneClass# 
                </td>
              </tr>
            </table>
          </td>
          </tr>
          <tr>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="15%" align="left" >WORK DESCRIPTION:</td>
                <td width="85%" class="underline">#qP.Work#</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="15%" align="left" nowrap="nowrap">EQUIPMENT/TOOL/MATERIAL TO BE USED:</td>
                <td width="85%" class="underline">#qP.EquipmentToUse#&nbsp;</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
              <tr>
                <td width="149" align="left" nowrap="nowrap" >START DATE/TIME:</td>
                <td width="242" align="left" nowrap="nowrap" class="underline" >#DateTimeFormat(qP.StartTime,'dd-mmm-yyyy hh:mm tt')#</td>
                <td width="139" align="right" nowrap="nowrap" class="pad-left-5" >END DATE/TIME:</td>
                <td width="162" align="left" nowrap="nowrap" class="underline" >#Dateformat(qP.EndTime,'dd-mmm-yyyy')# #timeformat(qP.EndTime,'hh:mm tt')#</td>
                <td width="109" align="left" >&nbsp;</td>
                <td width="283" align="right" nowrap="nowrap" >NO. OF WORKERS</td>
                <td width="186" align="center" class="underline"><cfif qP.NumberOfWorkers eq 0>#qL.Recordcount#<cfelse>#qP.NumberOfWorkers#</cfif>&nbsp;</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl-pad-4">
                <tr>
                  <td width="10%" nowrap="nowrap">DEPARTMENT: </td>
                  <td width="36%" class="underline">#ucase(qP.Department)#</td>
                  <td width="15%" align="right" class="pad-left-5">CONTRACTOR:</td>
                  <td width="39%" nowrap="nowrap" class="underline">#qP.Contractor#&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table></td>
        </tr>
      <tr>
        <td rowspan="5" align="center" valign="middle" class="left cbg"><img src="#application.site.url#assets/img/5x/section-2.png" width="25px"/></td>
        <td colspan="2" rowspan="5" valign="top">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="18" colspan="2">REQUIRED DOCUMENTS TO BE ATTACHED</td>
          </tr>
          <cfloop list="#request.required_docs#" index="it">
            <tr>
              <td width="15" align="center" valign="top">
              <cfset chk = getCheck(qP.SafetyRequirement5,it)/>
              <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
              <td><div style="padding-top:1px;">#it#</div></td>
            </tr>
          </cfloop>
        </table><br/>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2" nowrap="nowrap">SAFETY PRECAUTIONS TO BE TAKEN:</td>
      </tr>
      <cfloop list="#request.safety_req#" index="it">
      <tr>
        <td width="15" align="center" valign="top">
        <cfset chk = getCheck(qP.SafetyRequirement1,it)/>
        <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9px" height="9px"></td>
        <td><div style="padding-top:2px;">#it#</div></td>
      </tr>
      </cfloop> 
    </table>
    <br/>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2" nowrap="nowrap">FACILITIES TO BE PREPARED:</td>
      </tr>
      <cfloop list="#request.facility_prepared#" index="it">
        <tr>
          <td width="15" align="center" valign="middle">
          <cfset chk = getCheck(qP.SafetyRequirement3,it)/>
          <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
          <td height="13" valign="middle">#it#</td>
        </tr>
      </cfloop> 
  </table>
    <br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2" nowrap="nowrap">WORK ARE TO BE PREPARED BY:</td>
      </tr>
      <cfloop list="#request.work_prepared#" index="it">
      <tr>
        <td width="15" align="center" valign="middle">
        <cfset chk = getCheck(qP.SafetyRequirement4,it)/>
        <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
        <td height="13" valign="middle">#it#</td>
      </tr>
      </cfloop> 
    </table>   
    </td>
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="18" colspan="2" nowrap="nowrap">PERSONNEL REQUIREMENTS:</td>
      </tr>
      <cfloop list="#request.ppe#" index="it">
        <tr>
          <td width="15" align="center" valign="middle">
            <cfset chk = getCheck(qP.PPE,it)/>
            <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9">
          </td>
          <td height="13" valign="middle" nowrap="nowrap">&nbsp;#it#</td>
        </tr>
      </cfloop>
    </table>
  </td>
  </tr>
</table>
      <br/>
      <br/>
        Additional Precautions: <div class="underline">#qP.AdditionalPrecaution#</div>
        &nbsp;<div class="underline">&nbsp;</div>
        </td>
        </tr>
      <tr>
        <td width="40" align="center" valign="middle" class="bg-white"><img src="#application.site.url#assets/img/5x/section-cbs.png" width="25px"/></td>
        <td valign="top" style="padding-top:8px;">I am satisfied that all the requires safety precautions have been taken:
           all the applicable certificates are issued work can commence safety 
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            <td width="10%" >NAME:</td>
            <td colspan="3" class="underline">&nbsp;#qP.SV#</td>
            </tr>
            <tr>
              <td class="pad-right-3">DATE:</td>
              <td width="35%" nowrap="nowrap" class="underline">&nbsp;#dateformat(qP.SVApprovedDate,'dd/mm/yy')# #timeformat(qP.SVApprovedDate,'hh:mm tt')#</td>
              <td width="16%" class="pad-left-5">DEPT:</td>
              <td width="39%" class="underline">&nbsp;#ucase(qP.SVDepartment)#</td>
            </tr>
            <tr>
              <td colspan="4" valign="middle"> 
                SIGNATURE:
                <cfset fl = application.com.File.GetSignaturePath(qP.SVApprovedByUserId)/>
                <cfif len(fl)>
                  <cfhttp url="#fl#" method="get" result="imageData" />
                  <cfset base64Image = ToBase64(imageData.FileContent) />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="25px"/>
                </cfif>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td align="center" valign="middle" width="12px" class="bg-white"><img src="#application.site.url#assets/img/5x/section-cbra.png" width="25px"/></td>
        <td valign="top" style="padding-top:8px;">
          I authorize that work may be carried out provided the stated precautions have been taken: all applicable certificates issued. Work can therefore commence.
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            <td width="10%" >NAME:</td>
            <td colspan="3" class="underline">&nbsp;#qP.FS#</td>
            </tr>
          <tr>
            <td class="pad-right-3">DATE:</td>
            <td width="35%" nowrap="nowrap" class="underline">&nbsp;#dateformat(qP.FSApprovedDate,'dd/mm/yy')# #timeformat(qP.FSApprovedDate,'hh:mm tt')#</td>
            <td width="16%" class="pad-left-5">&nbsp;DEPT:</td>
            <td width="39%" class="underline">&nbsp;#ucase(qP.FSDepartment)#</td>
          </tr>
          <tr>
            <td colspan="4" height="25px" valign="middle"> 
                SIGNATURE:
                <cfset fl = application.com.File.GetSignaturePath(qP.FSApprovedByUserId)/>
                <cfif len(fl)>
                  <cfhttp url="#fl#" method="get" result="imageData" />
                  <cfset base64Image = ToBase64(imageData.FileContent) />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="25px"/>
                </cfif>
              </td>
            </tr>
          </table></td>
      </tr>

      <tr>
        <td align="center" valign="middle" class="bg-white"><img src="#application.site.url#assets/img/5x/section-cbph.png" width="25px"/></td>
        <td valign="top" style="padding-top:8px;">I confirm that the safety precautions specified will be observed 
          <table class="sign" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            <td width="10%" >NAME:</td>
            <td colspan="3" class="underline">&nbsp;#qP.PA#</td>
            </tr>
            <tr>
              <td class="pad-right-3">DATE:</td>
              <td width="35%" nowrap="nowrap" class="underline">&nbsp;#dateformat(qP.PAApprovedDate,'dd/mm/yy')# #timeformat(qP.PAApprovedDate,'hh:mm tt')#</td>
              <td width="16%" class="pad-left-5">DEPT:</td>
              <td width="39%" class="underline">&nbsp;#ucase(qP.PADepartment)#</td>
            </tr>
            <tr>
              <td colspan="4" valign="middle"> 
                SIGNATURE:
                <cfset fl = application.com.File.GetSignaturePath(qP.PAApprovedByUserId)/>
                <cfif len(fl)>
                  <cfhttp url="#fl#" method="get" result="imageData" />
                  <cfset base64Image = ToBase64(imageData.FileContent) />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="25px"/>
                </cfif>
              </td>
            </tr>
          </table>
        </td>
      </tr>

      <tr>
        <td valign="top" colspan="2" class="bg-white">
          <div style="text-align:center;padding:2px 0 5px 0;"><u>CERTIFICATES REQUIRED FOR THIS PERMIT</u></div>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <cfloop list="#request.certificate#" index="it">
              <tr>
                <td width="15" align="center" valign="middle">
                <cfset chk = getCheck(qP.certificate,it)/>
                <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9" height="9"></td>
                <td height="13" valign="middle" nowrap="nowrap">
                  <table style="padding-top:4px">
                    <tr>
                      <td nowrap="nowrap">#it# No:.</td>
                      <td>&nbsp;<div class="underline"></div></td>
                    </tr>
                  </table>
                </td>
              </tr>
            </cfloop>
          </table>  
        </td>
      </tr>
      <tr>
        <td align="center" valign="middle" class="left cbg bottom">
          <img src="#application.site.url#assets/img/5x/section-3.png" width="25px"/>
        </td>
        <td valign="top" >
          <div style="padding-top:3px;padding-bottom:4px">VALIDITY & RENEWAL OF PERMIT: Maximum renewal is 7 days</div>
          <cfquery name="qRev">
            SELECT 
              r.*,
              CONCAT(u.Surname,' ',u.OtherNames) AS Name
            FROM ptw_permit_revalidated r
            INNER JOIN core_user u ON u.UserId = r.ValidatedByUserId
            WHERE r.PermitId = <cfqueryparam value="#qP.PermitId#" cfsqltype="cf_sql_integer">
            ORDER BY r.Date ASC 
          </cfquery>
          <table class="tbl" border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
              <td class="left" width="1px">Name</td>
              <cfloop query="qRev">
                <td>#qRev.Name#</td>
              </cfloop>
              <cfloop from="1" to="#7-qRev.recordCount#" index="iii">
                <td>&nbsp;</td>
              </cfloop>
            </tr>
            <tr>
              <td class="left" width="1px">Date</td>
              <cfloop query="qRev">
                <td>#dateformat(qRev.Date,'dd/mm/yy')#</td>
              </cfloop>
              <cfloop from="1" to="#7-qRev.recordCount#" index="iii">
                <td>&nbsp;</td>
              </cfloop>
            </tr>
            <tr>
              <td class="left">Time</td>
              <cfloop query="qRev">
                <td>#timeFormat(qRev.Date,'hh:mm tt')#</td>
              </cfloop> 
              <cfloop from="1" to="#7-qRev.recordCount#" index="iii">
                <td>&nbsp;</td>
              </cfloop>
            </tr>
            <tr>
              <td class="left bottom">Sign</td> 
              <cfloop query="qRev">
                <td class="bottom">
                  <cfset fl = application.com.File.GetSignaturePath(qRev.ValidatedByUserId)/>
                  <cfif len(fl)>
                    <cfhttp url="#fl#" method="get" result="imageData" />
                    <cfset base64Image = ToBase64(imageData.FileContent) />
                    &nbsp;<img src="data:image/png;base64,#base64Image#" height="25px"/>
                  </cfif>
                </td>
              </cfloop>
              <cfloop from="1" to="#7-qRev.recordCount#" index="iii">
                <td>&nbsp;</td>
              </cfloop>
            </tr>
          </table>
          <div style="padding-top:5px;padding-bottom:3px">This PTW is Valid for 7 Consecutive days for the specified work</div>
        </td>
        <td class="cbg" width="25px">
          <img src="#application.site.url#assets/img/5x/section-cbph.png" width="25px"/>
        </td>
        <td class="" valign="top" colspan="2">
          <div style="padding:3px 0 4px 0;">HANDOVER OF WORK</div>
          <table cellpadding="0" cellspacing="0" border="0" width="100%" class="tbl">
            <tr>
              <td class="left">From</td>
              <td>Sign</td>
              <td>To</td>
              <td>Sign</td>
              <td>Date</td>
            </tr>
            <tr>
              <td class="left">&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td class="left">&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td class="left bottom">&nbsp;</td>
              <td class="bottom">&nbsp;</td>
              <td class="bottom">&nbsp;</td>
              <td class="bottom">&nbsp;</td>
              <td class="bottom">&nbsp;</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td align="center" valign="middle" class="left cbg bottom">
          <img src="#application.site.url#assets/img/5x/section-4.png" width="25px"/>
        </td>
        <td class="bottom" valign="top">
          <div style="padding-top:3px;padding-bottom:3px">HANDBACK OF WORK</div>
          <table>
            <cfset safelyList="The Job is completed and worksite cleared,The job is suspended/not completed"/>
            <cfset i=0/>
            <cfloop list="#safelyList#" index="it">
              <cfset i++/>
              <tr>
                <td width="15" align="center" valign="top">
                <cfset chk = 0/>
                <cfif i == 1 & qP.Completed == "Yes">
                  <cfset chk = 1/>
                </cfif>
                <cfif i == 2 & qP.Completed == "No">
                  <cfset chk = 1/>
                </cfif>
                <img src="#application.site.url#assets/img/ptw_checkbox_#chk#.png" width="9px" height="9px"></td>
                <td><div style="padding-top:2px;">#it#</div></td>
              </tr>
            </cfloop>
            <tr>
              <td colspan="2">
                <table style="padding-bottom:5px;">
                  <tr>
                    <td nowrap="nowrap">If not, state reasons</td>
                    <td class="underline">&nbsp;#qP.PAComment#</td>
                  </tr>
                </table>
                <table style="padding-bottom:5px;">
                  <tr>
                    <td nowrap="nowrap">NAME:</td>
                    <td class="underline" width="20%" nowrap="nowrap">&nbsp;#qP.PAC#</td>
                    <td nowrap="nowrap">&nbsp;&nbsp;DEPT:</td>
                    <td class="underline">&nbsp;#ucase(qP.PADepartment)#</td>
                  </tr>
                </table>
                <div style="font-size:3px;">&nbsp;</div>
                <table>
                  <tr>
                    <td nowrap="nowrap">SIGNATURE:</td>
                    <td class="underline" width="100px">&nbsp;
                      <cfset fl = application.com.File.GetSignaturePath(qP.PACloseByUserId)/>
                      <cfif len(fl)>
                        <cfhttp url="#fl#" method="get" result="imageData" />
                        <cfset base64Image = ToBase64(imageData.FileContent) />
                        <div style="position: relative;">
                          <img style="left:0px;bottom:-1px;position: absolute;z-index: 1000;" src="data:image/png;base64,#base64Image#" height="20px"/> 
                        </div>
                      </cfif>
                    </td>
                    <td nowrap="nowrap">&nbsp;DATE:</td>
                    <td nowrap="nowrap"  width="20%" class="underline">&nbsp;#dateformat(qP.PACloseDate,'dd/mm/yy')# #timeformat(qP.PACloseDate,'hh:mm tt')#</td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>

        </td>
        <td class="bottom cbg">
          <img src="#application.site.url#assets/img/5x/section-cbs.png" width="25px"/>
        </td>
        <td class="bottom" valign="middle" colspan="2">
          <div style="padding:3px 0 2px 0;">WORK ACCEPTANCE AND CLOSURE</div>
          <div style="padding-bottom:6px;">Job accepted as stated and PTW Closed</div>
          <table style="padding-bottom:6px;">
            <tr>
              <td nowrap="nowrap">NAME</td>
              <td>&nbsp;#qP.SVC#<div class="underline"></div></td>
              <td nowrap="nowrap">&nbsp;&nbsp;DEPT.</td>
              <td nowrap="nowrap">&nbsp;#qP.SVCDepartment#<div class="underline"></div></td>
            </tr>
          </table>
          <div style="font-size:3px;">&nbsp;</div>
          <table>
            <tr>
              <td nowrap="nowrap">SIGNATURE:
              </td>
              <td class="underline" width="100px"> &nbsp;
                <cfset fl = application.com.File.GetSignaturePath(qP.SVCloseByUserId)/>
                <cfif len(fl)>
                  <cfhttp url="#fl#" method="get" result="imageData" />
                  <cfset base64Image = ToBase64(imageData.FileContent) />
                  <div style="position: relative;">
                    <img style="left:0px;bottom:-1px;position: absolute;z-index: 1000;" src="data:image/png;base64,#base64Image#" height="20px"/> 
                  </div>
                </cfif>
              </td>
              <td nowrap="nowrap">&nbsp;&nbsp;DATE</td>
              <td nowrap="nowrap">&nbsp;#DateTimeFormat(qP.SVCloseDate,'dd/mm/yyyy hh:mm tt')#<div class="underline"></div></td>
            </tr>
          </table>
        </td>
      </tr>
      
    </table>
  </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table></td>
</tr></table>
<!---<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid gray; padding-left:15px;">
  <tr>
  <td>
  </td>
    <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
</tr></table></td></tr>
</cfdocumentitem>
</table>--->
</body>
</html>
</cfdocument>

</cfoutput>

<cffunction name="getCheck" access="private" returntype="string">
	<cfargument name="lst1" type="string" required="yes"/>
    <cfargument name="vl" type="string" required="yes"/>
    
	<cfset var chk = 0/>
    <cfif ListFindNoCase(arguments.lst1,arguments.vl)>
        <cfset chk=1/>
    </cfif>	
    
    <cfreturn chk/>
</cffunction>

<cffunction name="getSignature" access="private" returntype="string" hint="Get user signatire">
	<cfargument name="uid" hint="user id" required="yes" type="string"/>
    
    <cfquery name="qS1" cachedwithin="#CreateTime(1,0,0)#">
        SELECT * FROM `file`
        WHERE `Table` = 'core_user'
            AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.uid)#"/>
        LIMIT 0,1
    </cfquery>
    
    <cfreturn qS1.File/>
</cffunction>