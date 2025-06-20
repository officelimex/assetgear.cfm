<cfoutput>
<cfset qWO = application.com.WorkOrder.GetWorkOrder(url.id)/>
<cfset util = application.com.File/>
<cfquery name="qF" >
	SELECT * FROM failure_report_integration 
	WHERE `PK` = <cfqueryparam cfsqltype="cf_sql_int" value="#url.id#" /> AND `IntegrateTable` = "Work Order"
</cfquery>
<cfset tsum2 = tsum = tsum3 = 0/>

<cfdocument name="print_out" saveasname="WO_#qWO.WorkOrderId#" overwrite="true" pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4">
<html>
<head>
<cfset bg = "##f0f2f8"/>
<cfset brd_c = "##d6daeb"/>
<cfset brd_c2 = "##5364a9"/>
<style type="text/css">
	html,body{padding:0; margin:0;font: 12px Tahoma;}
	.head_section td{font-size: 11px;padding:5px;}
	.head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
	.head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.head_section td.bottom{border-bottom:#brd_c# 1px solid;}
	.sub_head{font-size:11px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
	.content{font-size:11px;padding:5px;}
	.tbl{
	font-size: 11px;
}
	.tbl th{font-weight: normal;background-color:#bg#;border-top:#brd_c2# 2px solid;border-right:#brd_c# 1px solid; text-align:left; padding:4px;}
	.tbl th.left{border-left:#brd_c# 1px solid;}
	.tbl td{
	padding: 3px 5px;
border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
	.gray{color:gray;}
	th{text-align:left !important;}
  .small {font-size: 10px; color:##0c0c0c; padding-top:4px;}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<!--- check if the work order has parts, if then change it to w/m order --->
<cfset qWOI = application.com.WorkOrder.GetWorkOrderItems(url.id)/>
<cfset request.letterhead.title="WORK ORDER"/>
<CFIF qWOI.recordcount>
	<cfset request.letterhead.title="WORK/MATERIAL ORDER"/>
</CFIF>
<cfswitch expression="#qWO.Status#">
	<cfcase value="open"><cfset sts = "<span style='color:green;'>OPEN</span>"/></cfcase>
  <cfcase value="close"><cfset sts = "<span style='color:red;'>CLOSE</span>"/></cfcase>
  <cfcase value="Suspended"><cfset sts = "<span style='color:red;'>SUSPENDED</span>"/></cfcase>
  <cfdefaultcase><cfset sts = "<span style='color:gray;'>AWAITING PARTS</span>"/></cfdefaultcase>
</cfswitch>
<cfset request.letterhead.Id="W.O. ## #url.id#"/>
<cfset request.letterhead.date = "Date : #dateformat(qWO.DateOpened,'dd/mm/yyyy')#&nbsp;&nbsp;&nbsp;Status: #sts#"/>
<cfset company = ""/>
<cfinclude template="../../../include/letter_head#company#.cfm"/>
</cfdocumentitem>
<tr>
<td><table width="100%" border="0">
  <tr>
    <td valign="top" width="60%" align="center"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="head_section">
      <tr>
        <td width="13%" valign="top" class="left">Asset</td>
        <td width="87%" valign="top" class="right">#qWO.Asset#</td>
      </tr>
      <tr>
        <td valign="top" class="left">Category</td>
        <td valign="top" class="right">#qWO.AssetCategory#&nbsp;</td>
      </tr>
      <tr>
        <td valign="top" class="left bottom">Location</td>
        <td valign="top" class="right bottom">
<!---        <cfset qAL = application.com.Asset.GetAssetLocationInWorkOrder(qWO.AssetLocationIds)/>
        #replace(ValueList(qAL.Location),',',', ','all')#--->
		<cfset qAL = application.com.Asset.GetAssetByAssetLocationIds(qWO.AssetLocationIds)/>
        #qAL.Location#<cfif qAL.ParentLocation neq ""> @ #qAL.ParentLocation# </cfif>  #qAL.LocDescription#
        </td>
      </tr>
    </table></td>
    <td valign="top" width="40%" align="center"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="head_section">
      <tr>
        <td width="22%" valign="top" nowrap="nowrap" class="left">Department</td>
        <td width="78%" valign="top" class="right" nowrap><span class="right bottom">#qWO.Department#&nbsp;<cfif qWO.Unit neq ""><span class="gray">(#qWO.Unit#)</span></cfif></span></td>
      </tr>
      <tr>
        <td valign="top" class="left bottom">W.O. Type</td>
        <td valign="top" class="right bottom">#qWO.JobClass#</td>
      </tr>
      <tr>
        <td valign="top" class="left bottom">Priority</td>
        <td valign="top" class="right bottom">#qWO.Priority#</td>
      </tr>
      <cfif val(qWO.MRId)>
          <tr>
            <td valign="top" class="left bottom">M. R ##</td>
            <td valign="top" class="right bottom"><cfif qWO.MRId neq 0>#qWO.MRId#</cfif>&nbsp;</td>
          </tr>
      </cfif>
      <cfloop query="qF" > 
          <tr>
            <td valign="top" class="left bottom">Failure R.##</td>
            <td valign="top" class="right bottom"><a style="text-decoration:none" href="http://localhost:888/assetgear/modules/maintenance/asset/print_failure_report.cfm?id=#qF.AssetFailureReportId#" target="_blank">#qF.AssetFailureReportId#&nbsp;</a></td>
          </tr>
      </cfloop>
    </table></td>
  </tr>
</table><BR/><BR/></td>
</tr>
<tr>
  <td>
  <div class="sub_head">SCOPE OF WORK</div>
  <div class="content">
  <cfif qWO.Description eq qWO.WorkDetails>
  #qWO.WorkDetails#
  <cfelse>
  <p>#qWO.Description#<p>
  #qWO.WorkDetails#
  </cfif>
  </div><br/><br/><br/>
</td>
</tr>

<cfquery name="qMN" dbtype="query">
  SELECT 
    *
  FROM qWOI 
  WHERE ItemId <> ''
</cfquery>
<cfif qMN.recordcount>
  <tr>
    <td>
    <div class="sub_head">MATERIALS NEEDED</div>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left small" width="1px">S/N</th>
        <th>ICN</th>
        <th>Description</th>
        <th>VPN</th>
        <th align="right">Qty</th>
        <th>UOM</th>
      </tr>
      <cfset nstock =false/>
      <cfloop query="qMN">
      <tr <cfif qMN.Currentrow eq qMN.Recordcount> class="bottom" </cfif>>
        <td valign="top" class="left">#qMN.Currentrow#</td>
        <td valign="top" class="left">#qMN.Code#</td>
        <td valign="top">
          #replace(qMN.Item,chr(10),'<br/>','all')#
          <cfif qMN.Purpose NEQ "">
            <div class="small">For: #qMN.Purpose#</div>
          </cfif>
        </td>
        <td valign="top">#qMN.VPN#&nbsp;</td>
        <td align="right" valign="top">#qMN.Quantity#</td>
        <td valign="top">#qMN.UM#&nbsp;</td>
      </tr>
      </cfloop>
    </table><br><br>

    </td>
  </tr> 
</cfif>

<tr><td></td></tr>

<cfquery name="qOO" dbtype="query">
  SELECT 
    *
  FROM qWOI 
  WHERE ItemId = ''
</cfquery>

<cfif qOO.recordcount>
  <tr>
    <td>
    <div class="sub_head">MATERIAL REQUEST</div>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left small" width="1px">S/N</th>
        <th>Description</th>
        <th align="right">Qty</th>
        <th>UOM</th>
        <th>OEM</th>
        <th>Part/Serial/Model No.</th>
      </tr>
      <cfset nstock =false/>
      <cfloop query="qOO">
      <tr <cfif qOO.Currentrow eq qOO.Recordcount> class="bottom" </cfif>>
        <td valign="top" class="left">#qOO.Currentrow#</td>
        <td valign="top">
          #replace(qOO.Description,chr(10),'<br/>','all')#
        </td>
        <td valign="top" align="right">#qOO.Quantity#</td>
        <td valign="top">#qOO.UOM#&nbsp;</td>
        <td valign="top">#qOO.OEM#&nbsp;</td>
        <td valign="top" class="small">#qOO.Others#&nbsp;</td>
      </tr>
      </cfloop>

    </table>
    <br><br>

    </td>
  </tr> 
</cfif>

<tr>
  <td>
  <cfset qL = application.com.WorkOrder.GetLabourers(url.id)/>
<cfif qL.recordcount>
<div class="sub_head">MAN POWER</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
  <tr>
      <th class="left"  width="1">S/N</th>
      <th>Staff</th>
      <th>Function</th>
      <th class="a-right">Hours</th>
      </tr>

    <cfloop query="qL">
      <tr <cfif qL.Currentrow eq qL.Recordcount> class="bottom" </cfif>>
        <td valign="top" class="left">#qL.Currentrow#</td>
        <td valign="top">#qL.Labourer#</td>
        <td valign="top">#qL.Function#</td>
        <td align="right" valign="top">#qL.Hours#</td>
        </tr>
    </cfloop>
    </table><br>
</cfif><br/>
</td>
</tr>
<cfset c1="Naira"/><cfset c2="Kobo"/>
  <cfset qWOC = application.com.WorkOrder.getContractors(url.id)/>
  <cfif qWOC.recordcount>
<tr>
  <td>

  <div class="sub_head">CONTRACTORS</div>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
    <tr>
      <th class="left" width="1px">S/N</th>
      <th>Company/Individual</th>
      <th>Work scope</th>
      <th class="a-right">Cost</th>
    </tr>
    <cfset tsum3 = 0/>
    <cfloop query="qWOC">
    <tr <cfif qWOC.Currentrow eq qWOC.Recordcount> class="bottom" </cfif>>
      <td valign="top" class="left">#qWOC.Currentrow#</td>
      <td valign="top">#qWOC.Contractor#</td>
      <td valign="top">#qWOC.Description#</td>
      <td align="right" class="cbg" valign="top"> <cfset tsum3 = tsum3 + qWOC.Cost/>#Numberformat(qWOC.Cost,'9,999.99')#</td>
    </tr>
    </cfloop>
    <tr class="bottom">
      <td colspan="3" valign="top" class="no-bottom">&nbsp;</td>
      <td align="right" class="cbg" valign="top">#NumberFormat(tsum3, '9,999.99')#</td>
    </tr>
  </table>

  </td>
</tr>
  </cfif>

<cfset gtotal =0/>
<cfif gtotal gt 0>
<tr>
  <td><br/>
  <div style="text-align:right; text-decoration:underline; font-style:italic;font-size:11px;">
    
    GRAND TOTAL: <cfif qWOC.Currency == "USD">$<cfset c1="Dollar"/><cfset c2="Cent"/></cfif>#NumberFormat(gtotal,'9,999.99')#</div>
  <div style="text-align:center; font-style:italic; padding-top:8px; font-size:11px;">AMOUNT IN WORDS:
  <CFSET num = CreateObject("component","assetgear.com.adexfe.util.Finance.NumberToWords").init(NumberFormat(gtotal,'999.99'),'#c1#','#c2#')/>
  #ucase(num.Convert())# ONLY
  </div></td>
</tr>
</cfif>
<cfif qWO.Status neq "open">
<tr>
  <td>

  <BR/>
  <cfif len(qWO.WorkDone)>
    <div class="sub_head">WORK DONE</div>
    <div class="content">
      #replace(qWO.WorkDone,chr(10),'<br/>','all')#
    </div>
  </cfif>
    </td>
</tr>
</cfif>
<tr>
  <td>&nbsp;</td>
</tr>
<cfdocumentitem type="footer">
<tr><td ><table width="100%" border="0" style="font:9px Tahoma;">
  <tr>
    <td width="33%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="13%" align="right"><br/>
          <br/>
          <br/>
        </td>
        <td width="87%" rowspan="2" valign="bottom">
        <!--- CreatedByUserId --->
          <cfif qWO.WorkClassId == 12>
            <cfset fl = util.GetSignaturePath(qWO.CreatedByUserId)/>
            <cfset _dc = qWO.DateOpened/>
            <cfset _sname = qWO.CreatedBy/>
            <cfset _pos = "Superintendent"/>
          <cfelse>
            <cfset fl = util.GetSignaturePath(qWO.SupervisedByUserId)/>
            <cfset _dc = qWO.SupervisedApprovedDate/>
            <cfset _sname = qWO.SupervisedBy/>
            <cfset _pos = "Supervisor"/>
          </cfif>
          <cfif len(fl)>
            <cfhttp url="#fl#" method="get" result="imageData" />
            <cfset base64Image = ToBase64(imageData.Filecontent) />
            &nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="30"> 
            <span style="font-size:7px;">#dateformat(_dc, 'dd/mm/yyyy')#</span>
          <cfelse>
            ....................................................  
          </cfif>
		    </td>
      </tr>
      <tr>
        <td align="right" nowrap="nowrap">Sign / Date:</td>
        </tr>
      <tr>
        <td align="left" colspan="2">
			<sup style="font-size:7px;">
        &nbsp;&nbsp;#_pos#: #_sname# (
          <cfif qWO.Unit EQ "">
            #qWO.Department#
          <cfelse>
            #qWO.Unit#
          </cfif>
        )
      </sup>
		</td>
      </tr>
    </table></td>
    <td width="33%" align="center" style="padding-bottom:15px;">
    <cfif ((gtotal) neq 0 || qWO.WHApprovedDate != "")>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="nopadding">
          <td width="53%" align="right"><br/>
            <br/>
            <br/></td>
          <td width="47%" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td align="right">Sign / Date:</td>
          <td nowrap>
            <cfif qWO.WHApprovedDate != "">
            <cfset fl = util.GetSignaturePath(qWO.WHUserId)/>
            <cfif len(fl)>
              <cfhttp url="#fl#" method="get" result="imageData" />
              <cfset base64Image = ToBase64(imageData.Filecontent) />
              &nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="30"> 
              <span style="font-size:7px;">#dateformat(qWO.SupervisedApprovedDate, 'dd/mm/yyyy')#</span>
            </cfif>
            <cfelse>
              ....................................................  
            </cfif>
          </td>
        </tr>
        <tr>
          <td align="center" colspan="2">
            <sup style="font-size:7px;">Warehouse: #qWO.WHPerson#</sup>
          </td>
        </tr>
      </table>
    </cfif>
    </td>
    <td width="33%" align="center" style="padding-bottom:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr class="nopadding">
        <td width="53%" align="right"><br/>
          <br/>
          <br/></td>
        <td width="47%" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td align="right">Sign / Date:</td>
        <td>
          <cfif qWO.WorkClassId == 12>
            <cfif qWO.FSApprovedDate != "">
            <cfset fl = util.GetSignaturePath(qWO.FSUserId)/>
            <cfif len(fl)>
              <cfhttp url="#fl#" method="get" result="imageData" />
              <cfset base64Image = ToBase64(imageData.FileContent) />
              &nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="30"> 
              <span style="font-size:7px;">#dateformat(qWO.FSApprovedDate, 'dd/mm/yyyy')#</span>
            </cfif>
            <cfelse>
              ....................................................  
            </cfif>
          <cfelse>
            <cfif qWO.SupApprovedDate != "">
            <cfset fl = util.GetSignaturePath(qWO.SupUserId)/>
            <cfif len(fl)>
              <cfhttp url="#fl#" method="get" result="imageData" />
              <cfset base64Image = ToBase64(imageData.FileContent) />
              &nbsp;&nbsp;&nbsp;<img src="data:image/png;base64,#base64Image#" height="30"> 
              <span style="font-size:7px;">#dateformat(qWO.SupApprovedDate, 'dd/mm/yyyy')#</span>
            </cfif>
            <cfelse>
              ....................................................  
            </cfif>          
          </cfif>
        </td>
      </tr>
      <tr>
        <td align="center" colspan="2">
          <sup style="font-size:7px;">
            #qWO.Department#
            <cfif qWO.WorkClassId == 12>
               Mgr: #qWO.ManagerName#
            <cfelse>
              Superintendent: #qWO.SupName#
            </cfif>
          </sup>
        </td>
      </tr>
    </table></td>
  </tr>
</table>
  <table width="100%" border="0" style="font:9px Tahoma; border-top:1px solid ##ECF4CF; padding-left:15px;">
<tr>
  <td nowrap="nowrap">
  <cfif qWO.CreatedByUserId neq 0>
    <cfset cb = application.com.User.getUser(val(qWO.CreatedByUserId))/>
    <cfif cb.UserName neq "">
				Created by #cb.UserName#
<!--- 				<cfset fl = util.GetSignaturePath(qWO.CreatedByUserId)/>
        &nbsp;&nbsp;&nbsp;<img src="#fl#" height="30"> <span style="font-size:7px;">#dateformat(qWO.DateOpened,'dd/mm/yyyy')#</span> --->
		<cfelse>
				System Generated
		</cfif>
  </cfif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<cfif qWO.Status eq "close">
  <cfif qWO.SupervisedBy eq qWO.ClosedBy>
    Supervised and Closed by #qWO.SupervisedBy# on #dateformat(qWO.DateClosed,'dd-mmm-yyyy')#
  <cfelse>
    Supervised by #qWO.SupervisedBy# and Closed by #qWO.ClosedBy# on #dateformat(qWO.DateClosed,'dd-mmm-yyyy')#
  </cfif>
</cfif>
  </td>
    <td align="right">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
</tr></table></td></tr>
</cfdocumentitem>
</table>


</body>
</html>
</cfdocument>

<cfpdf action="merge" name="mergedPdf">
  <cfpdfparam source="print_out">
<!---   <cfquery name="qf">
    SELECT `file`, size FROM `file` 
    WHERE Pk = #url.id# AND `Table` = "work_order" 
  </cfquery> --->
  
<!---   <cfset qf = util.GetDocPaths(url.id, "work_order")/>
  <cfdump  var="#qf#"> --->
<!---   <cfloop array="#qf#" index="i">
    <cfset filePath = qf[i]/>
    <cfif findNoCase(".pdf", filePath)>
      <cfif fileExists(filePath)>
        <cfpdfparam source="#filePath#">
      <cfelse>
        <!--- dont do anything ---> 
      </cfif>
    </cfif>
  </cfloop> --->
</cfpdf>
<cfheader name="Content-Disposition" value="inline; filename=WO_#url.id#.pdf">
<cfcontent type="application/pdf" variable="#ToBinary( mergedPdf )#" reset="true">


</cfoutput>
