
<!---- 	
	define this in the env.cfm file 
	=================================
	variables.appName = "app"
	variables.companyName = "App"
	variables.domain = "app.com"
--->

component {

	include "env.cfm"; 
	this.name = "#variables.appName#_ams";
	this.applicationTimeout = createTimeSpan(1, 0, 0, 0);
	this.clientmanagement = "yes";
	this.ClientStorage = "cookie";
	this.sessionmanagement = "yes";
	this.sessiontimeout = createTimeSpan(0, 5, 0, 0);
	this.setClientCookies = "yes";
	this.datasource = variables.datasources["dsn"];
	this.pdf.type = "classic";

	this.s3 = variables.aws.s3

	this.mappings["/s3"] = this.s3.bucket;
	this.mappings["/assetgear"] = getDirectoryFromPath(getCurrentTemplatePath());

	this.mail = variables.aws.mail

	function onApplicationStart() {
		application.appName = variables.appName;
		application.domain = variables.domain;
		application.companyName = variables.companyName;
		application.companyAddress = "";
		application.site.url = variables.site.url;
		application.s3.bucket = variables.aws.s3.bucket;

		application.LIVE = 0
		application.DEV = 1

		application.mode = variables.mode;
	
		// Save the most used components(CFC) into an application variable
		setApplication()
		application.Module = application.com.Module.SetupModuleIds();
		application.AppModuleId = 'app_module';

		System = createObject("java", "java.lang.System");
		System.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
	}

	function onApplicationEnd(required applicationScope) {}

	function onRequestStart(required string requestname) {

		if (application.mode EQ application.DEV) {
			setApplication()
		}
		lock type="exclusive" scope="session" timeout="10" {
			param name="session.IsLogin" default="false" type="boolean";
			param name="session.Userinfo" default="";
			param name="session.loginType" default="guest";
			param name="session.Delegate" default="";
		}

		lock type="readonly" scope="session" timeout="40" {
			request.IsLogin = session.IsLogin;
			request.UserInfo = session.UserInfo;
			request.loginType = session.loginType;
			request.Delegate = session.Delegate;
		}

		param name="request.IsHost" default="false" type="boolean";
		param name="request.IsWarehouseMan" default="false" type="boolean";
		param name="request.IsMS" default="false" type="boolean";
		param name="request.IsAdmin" default="false" type="boolean";
		param name="request.IsHSE" default="false" type="boolean";
		param name="request.IsPS" default="false" type="boolean";
		param name="request.IsSV" default="false" type="boolean";
		param name="request.IsSup" default="false" type="boolean";
		param name="request.IsFS" default="false" type="boolean";

		if (isDefined("request.userinfo.role")) {
			switch (request.userinfo.role) {
				case "HT":
					request.IsHost = true;
					break;
				case "SUP":
					request.IsSup = true;
					break;
				case "IT":
					request.IsIT = true;
					break;
				case "SV":
					request.IsSV = true;
					break;
			}

			switch (request.userinfo.role) {
				case "SUP":
				case "SV":
					switch (request.userinfo.department) {
						case "Admin":
							request.IsAdmin = true;
							break;
						case "HSE":
							request.IsHSE = true;
							break;
						case "Warehouse":
							request.IsWarehouseMan = true;
							break;
						case "Maintenance":
							request.IsMtnc = true;
							break;
					}
					break;
				case "WH":
				case "WH_SV":
				case "WH_SUP":
					request.IsWarehouseMan = true;
				break
			}
		}
		// Delegated role
		param name="request.IsPSDelegated" default="false" type="boolean";
		param name="request.IsFSDelegated" default="false" type="boolean";

		if (isQuery(request.Delegate) && request.Delegate.Recordcount) {
			// TODO: check date too
			switch (request.delegate.role) {
				case "PS":
					request.IsPSDelegated = true;
					break;
				case "FS":
					request.IsFSDelegated = true;
					break;
			}
		}

		if (
				!request.IsLogin &&
				listContainsNoCase(
					'update_spare_parts.cfm,register.cfm,login.cfm,forget.cfm,error.cfm,clear.cfm,shedule_wo.cfm,pwd.cfm,backup.cfm,backup2.cfm,update_spare_parts.cfm,due_for_order.cfm,sync.cfc,expire_alert.cfm,reminder.cfm',
					listLast(cgi.SCRIPT_NAME, '/')
				) eq 0
		) {
			location(url="login.cfm", addtoken="no");
		}
	}

	function setApplication()	{
		application.com.Module = createObject('component', 'assetgear.com.awaf.Module').init();
		application.com.Asset = createObject('component', 'assetgear.com.awaf.ams.maintenance.Asset').init();
		application.com.PMTask = createObject('component', 'assetgear.com.awaf.ams.maintenance.PMTask').init();
		application.com.Item = createObject('component', 'assetgear.com.awaf.ams.warehouse.Item').init();
		application.com.Transaction = createObject('component', 'assetgear.com.awaf.ams.warehouse.Transaction').init();
		application.com.WorkOrder = createObject('component', 'assetgear.com.awaf.ams.maintenance.WorkOrder').init();
		application.com.Permit = createObject('component', 'assetgear.com.awaf.ams.ptw.Permit').init();
		application.com.User = createObject('component', 'assetgear.com.awaf.User').init();
		application.com.Notice = createObject('component', 'assetgear.com.awaf.ams.Notice').init();
		application.com.Incident = createObject('component', 'assetgear.com.awaf.ams.maintenance.Incident').init();
		application.com.File = createObject('component', 'assetgear.com.awaf.util.file').init();
	}

}