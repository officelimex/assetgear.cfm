<cfoutput>
<cfset qMR = application.com.Transaction.GetMR(url.id)/>
<cfset util = application.com.File/>

<cfdocument pagetype="a4" saveasname="MR_#qMR.MRId#" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4" >
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
	.tbl{font-size: 11px;}
  table.footer_section {
    border: 1px solid #brd_c#; 
    border-collapse: collapse; 
  }
  table.footer_section td, table.footer_section th {
    border: none;
    /* padding: 8px; */
  }

	.tbl th{font-weight: bold;font-size:9px;background-color:#bg#;border-top:#brd_c2# 2px solid;border-right:#brd_c# 1px solid; text-align:left; padding:4px;}
	.tbl th.left{border-left:#brd_c# 1px solid;}
	.tbl>tr>td{
	padding: 3px 5px;
border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
	.tbl td.left{border-left:#brd_c# 1px solid;}
	.tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
	.tbl td.no-right{border-right:none;}
	.tbl td.cbg{background-color:#bg#;}
	.tbl td.no-bottom{border-bottom:none !important;}
	.a-right{text-align:right !important;}
	.nbg{background-color:white !important;}
	.center{text-align:center !important;}
	.um{
	  font-size: 10px;
  }
  .t4 {padding-top:4px;}
</style>
</head>
<body>
<table width="100%">
<cfdocumentitem type = "header">
<cfset request.letterhead.title="MATERIAL REQUISITION"/>
<cfset request.letterhead.Id="MAT ## #url.id#"/>
<!--- <cfset request.letterhead.date="Date: #dateformat(qMR.Date,'dd/mm/yyyy')#"/> --->
<cfinclude template="../../../../include/letter_head.cfm"/>
</cfdocumentitem>
<tr>
  <td><table width="100%" border="0">
    <tr>
      <td valign="top" width="70%" align="left">
      <table width="95%" border="0" cellpadding="0" cellspacing="0" class="head_section">
        <tr>
          <td width="24%" valign="top" class="left">Requisition For</td>
          <td width="76%" valign="top" class="right">
            #ucase(qMR.Note)#
            <cfif qMR.Note eq "">
              <div>#ucase(qMR.WODescription)#</div>
            </cfif>
          </td>
        </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left ">Requisition Type</td>
          <td valign="top" nowrap="nowrap" class="right ">
            <cfif qMR.Currency EQ "USD">International<cfelse>Local</cfif>
          </td>
        </tr>
        <tr>
          <td valign="top" nowrap="nowrap" class="left bottom">Date Issued</td>
          <td valign="top" class="right bottom">#Dateformat(qMR.Date,'dd-mmm-yyyy')#</td>
        </tr> 
        </table>
      </td>
      <td valign="top" width="30%" align="center">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="head_section">
					<cfif qMR.Category neq "r">
						<tr>
		          <td valign="top" nowrap="nowrap" class="left">Work Order ##</td>
		          <td valign="top" class="right">#qMR.WorkOrderId#&nbsp;</td>
		        </tr>
					</cfif>

          <tr>
            <td valign="top" nowrap="nowrap" class="left">Department</td>
            <td valign="top" nowrap="nowrap" class="right">#qMR.Department#</td>
          </tr>
          <tr>
            <td valign="top" nowrap="nowrap" class="left bottom">Date Required</td>
            <td valign="top" class="right bottom"><cfif isdate(qMR.DateRequired)>#Dateformat(qMR.DateRequired,'dd-mmm-yyyy')#</cfif></td>
          </tr> 
        </table>
        </td>
      </tr>
  </table>
  <BR/><BR/></td>
</tr>
<tr>
  <td>
    <cfset service = false/>
    <cfset qMRI = application.com.Transaction.GetMRItems(url.id)/>
    <cfloop query="qMRI">
      <cfif qMRI.ItemId EQ 44143> 
        <cfset service = true/>
      </cfif>
    </cfloop>

    <cfif service>
      <p><b>SCOPE OF WORK</b></p>
      <p>#replace(qMR.WorkDetails,chr(13),'<br/>','all')#</p>
      <br/>
    </cfif>

    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
      <tr>
        <th class="left" width="1px">S/N</th>
        <th class="center" width="1px">QTY</th>
        <th class="center" width="1px">UOM</th>
        <th class="center" width="99%">DESCRIPTION (ICN, VPN)</th>
        <th class="center" width="1px">QOH</th>
        <th class="center" width="1px">QOO</th>
        <th class="center" width="1px">QOR</th>
        <th class="a-right" width="1px">Unit Cost</th>
        <th class="a-right" width="1px">Total<br/> <cfif qMR.Currency eq "NGN">(NGN)<cfelse>(USD)</cfif> </th>
        </tr>
        <cfset gs = 0/>
      <cfloop query="qMRI">
        <tr <cfif qMRI.Currentrow eq qMRI.Recordcount> class="bottom" </cfif>>
          <td valign="top" class="left">#qMRI.Currentrow#</td>
          <td valign="top" align="right">#qMRI.Quantity#</td>
          <td valign="top" >#qMRI.UM#</td>
          <td valign="top">
            <cfif qMRI.ItemVPN neq "">VPN: <b>#qMRI.ItemVPN#</b><br/></cfif>
            [#qMRI.Code#] #replace(qMRI.Description,chr(13),'<br/>','all')#
            <!--- <cfif qMRI.Remark neq "">
              <br/>#qMRI.Remark#
            </cfif> --->
          </td>
          <td align="center" valign="top" >#val(qMRI.QOH)#</td>
          <td align="center" valign="top" >#val(qMRI.QOO)#</td>
          <td align="center" valign="top" >
            <cfif service>0<cfelse>#val(qMRI.QOR)#</cfif>
          </td>
          <td align="right" valign="top">#Numberformat(qMRI.UnitPrice,'9,999.99')#</td>
          <td align="right" valign="top">
            <cfset qu = val(qMRI.Quantity)*val(qMRI.UnitPrice)/>
            #NumberFormat(val(qMRI.Quantity)*val(qMRI.UnitPrice),'9,999.99')#</td>
            <cfset gs = gs + qu/>
          </tr>
        </cfloop>
      <tr  class="bottom">
        <td colspan="8" valign="top" class="no-bottom">&nbsp;</td>
        <td align="right" class="cbg" valign="top">#numberformat(gs,'9,999.99')#</td>
        </tr>

    </table></td>
</tr>
<tr>
  <td>
<cfif gs neq 0>
<div style="text-align:left; font-style:italic; padding-top:8px; font-size:11px;">AMOUNT IN WORDS:
        <CFSET num = CreateObject("component","assetgear.com.adexfe.util.Finance.NumberToWords").init(NumberFormat(gs,'999.99'),'Naira','kobo')/>
        #ucase(num.Convert())# ONLY</div>
</cfif>
  </td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<cfdocumentitem type="footer">
  <style type="text/css">
    .footer_section {
      border: 1px solid #brd_c#; 
      border-collapse: collapse; 
    }
    .footer_section td, table.footer_section th {
      border: none;
      /* padding: 8px; */
    }
  </style>
<tr><td >
<table width="100%" border="0">
  <tr>
    <td width="33%" height="50px" align="center" style="font:8px Tahoma;padding-bottom:5px;padding-top:5px;border-top: 1px solid #brd_c2#;">
      <table >
        <tr>
          <td nowrap="nowrap" align="right">Requested by: </td>
          <td>#qMr.WOCreatedBy#</td>
        </tr>
        <tr>
          <td align="right">Title: </td>
          <td nowrap="nowrap">#qMR.WOCreatorPosition#</td>
        </tr>
        <tr>
          <td valign="bottom" align="right">Signature: </td>
          <td height="27px">
            <div style="top:62px;position: absolute; z-index: 300; ">...................................</div>
            <cfset fl = util.GetSignaturePath(qMR.WOCreatedByUserId)/>
            <cfif len(fl)>
              <cfhttp url="#fl#" method="get" result="imageData" />
              <cfset base64Image = ToBase64(imageData.Filecontent) />
              <div style="position: relative;">
                <img style="left:5px;bottom:-20px;position: absolute;z-index: 1;" src="data:image/png;base64,#base64Image#" height="30"/> 
              </div>
            </cfif>
          </td>
        </tr>
        <tr>
          <td align="right">Date: </td>
          <td>
            <span style="font-size:7px;">#dateformat(qMR.WOCreated, 'dd/mm/yyyy')#</span>
          </td>
        </tr>
      </table>
    </td>
    <td width="33%" align="center" style="font:8px Tahoma;padding-bottom:5px;padding-top:5px;border-top: 1px solid #brd_c2#;border-right: 1px solid #brd_c#;border-left: 1px solid #brd_c#;">
      <cfif qMR.FSUserId NEQ qMR.CreatedByUserId>
      <table>
        <tr>
          <td align="right" class="left">Checked by: </td>
          <td class="right">#qMr.CreatedBy#</td>
        </tr>
        <tr>
          <td align="right">Title: </td>
          <td>#qMR.CreatorPosition#</td>
        </tr>
        <tr>
          <td valign="bottom" align="right">Signature: </td>
          <td height="27px">
            <div style="top:62px;position: absolute; z-index: 300; ">...................................</div>
            <cfset fl = util.GetSignaturePath(qMR.CreatedByUserId)/>
            <cfif len(fl)>
              <cfhttp url="#fl#" method="get" result="imageData" />
              <cfset base64Image = ToBase64(imageData.FileContent) />
              <div style="position: relative;">
                <img style="left:10px;bottom:-20px;position: absolute;z-index: 1;" src="data:image/png;base64,#base64Image#" height="30"/> 
              </div>
            </cfif>
          </td>
        </tr>
        <tr>
          <td align="right">Date: </td>
          <td>
            <span style="font-size:7px;text-align:center;">#dateformat(qMR.Date, 'dd/mm/yyyy')#</span>
          </td>
        </tr>
      </table>
      </cfif>
    </td>
    <td width="33%" align="center" style="font:8px Tahoma;padding-bottom:5px;padding-top:5px;border-top: 1px solid #brd_c2#;">
      <table>
        <tr>
          <td align="right">Approved by: </td>
          <td>#qMr.ManagerName#</td>
        </tr>
        <tr>
          <td align="right">Title: </td>
          <td>#qMr.ManagerPosition#</td>
        </tr>
        <tr>
          <td valign="bottom" align="right">Signature: </td>
          <td height="27px">
            <div style="top:62px;position: absolute; z-index: 300; ">...................................</div>
            <cfset fl = util.GetSignaturePath(qMR.FSUserId)/>
            <cfif len(fl)>
              <cfhttp url="#fl#" method="get" result="imageData" />
              <cfset base64Image = ToBase64(imageData.FileContent) />
              <div style="position: relative;">
                <img style="left:0px;bottom:-20px;position: absolute;z-index: 1;" src="data:image/png;base64,#base64Image#" height="30"/> 
              </div>
            </cfif>
          </td>
        </tr>
        <tr>
          <td align="right">Date: </td>
          <td>
            <span style="font-size:7px;">#dateformat(qMR.FSApprovedDate, 'dd/mm/yyyy')#</span>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<table width="100%" border="0" style="font:8px Tahoma; border-top:1px solid #brd_c#; padding-left:15px;">
<tr>
  <td nowrap="nowrap"> </td>
  <td align="right">Page #cfdocument.currentPagenumber# of #cfdocument.totalpagecount#</td>
</tr>
</table>
</td>
</tr>
</cfdocumentitem>
</table>
</body>
</html>
</cfdocument> 
</cfoutput>
