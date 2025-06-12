component {

	public helper function Init() {
		return this;
	}

	public void function UpdateCustomFields(required string tbl, numeric cf_count=8, string cf_prefix="CustomField") {
		for (var i = 1; i <= cf_count; i++) {
			var cfvlu = form["#cf_prefix##i#"];
			var cfid = form["#cf_prefix##i#_id"];
			var cffld = form["#cf_prefix##i#_label"];

			switch (cffld) {
				case "{Custom field}":
					break;
				default:
					cfid = form["CustomField#i#_id"];
					cffld = form["CustomField#i#_label"];

					if (cfid == 0) {
						queryExecute("
							INSERT INTO custom_field (Table, PK, Field, Value)
							VALUES (:tbl, :pk, :field, :value)
						", {
							tbl: { value: tbl, cfsqltype: "cf_sql_varchar" },
							pk: { value: form.id, cfsqltype: "cf_sql_integer" },
							field: { value: cffld, cfsqltype: "cf_sql_varchar" },
							value: { value: cfvlu, cfsqltype: "cf_sql_varchar" }
						});
					} else if (cffld == "") {
						queryExecute("
							DELETE FROM custom_field
							WHERE CustomFieldId = :cfid
						", {
							cfid: { value: cfid, cfsqltype: "cf_sql_integer" }
						});
					} else {
						queryExecute("
							UPDATE custom_field SET
								Field = :field,
								Value = :value
							WHERE CustomFieldId = :cfid
						", {
							field: { value: cffld, cfsqltype: "cf_sql_varchar" },
							value: { value: cfvlu, cfsqltype: "cf_sql_varchar" },
							cfid: { value: cfid, cfsqltype: "cf_sql_integer" }
						});
					}
			}
		}
	}

	public void function SaveFromTempTable(
		required string sid,
		required string tbl,
		required string fld_des,
		required string fld_src,
		required string pk_field,
		required string fk_field,
		required numeric fk_value
	) {
		var llen = listLen(fld_des);
		transaction {
			var qTemp = queryExecute("
				SELECT * FROM temp_data WHERE Session = :sid
			", { sid: { value: sid, cfsqltype: "cf_sql_varchar" } });

			for (var row in qTemp) {
				switch (row.Flag) {
					case "d":
						queryExecute("
							DELETE FROM #tbl# WHERE #pk_field# = :pk
						", { pk: { value: row.PK, cfsqltype: "cf_sql_integer" } });
						break;

					case "u":
						var isInsert = (row.PK == "");
						var sql = isInsert ? "INSERT INTO #tbl# SET " : "UPDATE #tbl# SET ";
						if (fk_field != "") {
							sql &= "`#fk_field#` = :fk, ";
						}

						var params = {};
						if (fk_field != "") {
							params["fk"] = { value: fk_value, cfsqltype: "cf_sql_integer" };
						}

						var i = 0;
						for (var fld_d in listToArray(fld_des)) {
							i++;
							var fld_s = listGetAt(fld_src, i);
							var ttype = left(fld_s, len(fld_s) - 1);
							var val = evaluate(fld_s);
							var key = "f" & i;

							sql &= "`#fld_d#` = :#key#";
							if (i < llen) sql &= ", ";

							switch (ttype) {
								case "int":
									params[key] = { value: val(val), cfsqltype: "cf_sql_integer" };
									break;
								case "float":
									params[key] = { value: val(val), cfsqltype: "cf_sql_decimal" };
									break;
								case "date":
									params[key] = { value: val, cfsqltype: "cf_sql_date" };
									break;
								default:
									if (listFindNoCase("text1,text2,text3,text4,text5,text6", val) && len(val) == 5) {
										val = "";
									}
									params[key] = { value: val, cfsqltype: "cf_sql_varchar" };
							}
						}

						if (!isInsert) {
							sql &= " WHERE #pk_field# = :pk";
							params["pk"] = { value: row.PK, cfsqltype: "cf_sql_integer" };
						}

						queryExecute(sql, params);
						break;

					default:
						if (row.Flag == "n" || val(row.PK) == 0) {
							var sql = "INSERT INTO #tbl# SET ";
							var params = {};
							if (fk_field != "") {
								sql &= "`#fk_field#` = :fk, ";
								params["fk"] = { value: fk_value, cfsqltype: "cf_sql_integer" };
							}

							var i = 0;
							for (var fld_d in listToArray(fld_des)) {
								i++;
								var fld_s = listGetAt(fld_src, i);
								var ttype = left(fld_s, len(fld_s) - 1);
								var val = evaluate(fld_s);
								var key = "f" & i;

								sql &= "`#fld_d#` = :#key#";
								if (i < llen) sql &= ", ";

								switch (ttype) {
									case "int":
										params[key] = { value: val(val), cfsqltype: "cf_sql_integer" };
										break;
									case "float":
										params[key] = { value: val(val), cfsqltype: "cf_sql_decimal" };
										break;
									case "date":
										params[key] = { value: val, cfsqltype: "cf_sql_date" };
										break;
									default:
										if (listFindNoCase("text1,text2,text3,text4,text5,text6", val) && len(val) == 5) {
											val = "";
										}
										params[key] = { value: val, cfsqltype: "cf_sql_varchar" };
								}
							}
							queryExecute(sql, params);
						}
				}
			}

			queryExecute("
				DELETE FROM temp_data WHERE Session = :sid
			", { sid: { value: sid, cfsqltype: "cf_sql_varchar" } });
		}
		objectCacheClear();
	}

	public query function GetTempDate(required string sid) {
		return queryExecute("
			SELECT * FROM temp_data WHERE Session = :sid
		", { sid: { value: sid, cfsqltype: "cf_sql_varchar" } });
	}

	public query function GetTempDataToUpdate(required string sid) {
		return queryExecute("
			SELECT * FROM temp_data WHERE Session = :sid AND Flag <> 'd'
		", { sid: { value: sid, cfsqltype: "cf_sql_varchar" } });
	}

	public query function GetTempDataToDelete(required string sid) {
		return queryExecute("
			SELECT * FROM temp_data WHERE Session = :sid AND Flag = 'd'
		", { sid: { value: sid, cfsqltype: "cf_sql_varchar" } });
	}

	public void function FlagTempDataToDelete(required string sid) {
		queryExecute("
			UPDATE temp_data SET Flag = 'd' WHERE Session = :sid
		", { sid: { value: sid, cfsqltype: "cf_sql_varchar" } });
	}

	public void function UpdateStatus(required string key, required numeric value, required string status, required string table) {
		queryExecute("
			UPDATE #table# SET Status = :status WHERE #key# = :val
		", {
			status: { value: status, cfsqltype: "cf_sql_varchar" },
			val: { value: value, cfsqltype: "cf_sql_integer" }
		});
	}

	public boolean function LogComment(required numeric key, required string comment, required string model="wo") {
		queryExecute("
			INSERT INTO core_comment (PK, CommentByUserId, Comments, Table)
			VALUES (:pk, :uid, :comment, :model)
		", {
			pk: { value: key, cfsqltype: "cf_sql_varchar" },
			uid: { value: request.userInfo.userId, cfsqltype: "cf_sql_integer" },
			comment: { value: comment, cfsqltype: "cf_sql_varchar" },
			model: { value: model, cfsqltype: "cf_sql_varchar" }
		});
		return true;
	}

	public void function LogActivity(required string tbl, required string key, required string event, string url="", string info="", string type="I") {
		var browserInfo = cgi.http_user_agent;
		var ipAddress = cgi.remote_addr;
		var currentURL = cgi.script_name & cgi.path_info & cgi.query_string;

		queryExecute("
			INSERT INTO core_log (
				UserId, URL, Type, `Key`, Title, IP, Browser, Description, `Table`
			) VALUES (
				:userId, :url, :type, :key, :event, :ip, :browser, :info, :table
			)
		", {
			userId:   { value: request.userInfo.userId, cfsqltype: "cf_sql_integer" },
			url:      { value: currentURL, cfsqltype: "cf_sql_varchar" },
			type:     { value: arguments.type, cfsqltype: "cf_sql_varchar" },
			key:      { value: arguments.key, cfsqltype: "cf_sql_varchar" },
			event:    { value: arguments.event, cfsqltype: "cf_sql_varchar" },
			ip:       { value: ipAddress, cfsqltype: "cf_sql_varchar" },
			browser:  { value: browserInfo, cfsqltype: "cf_sql_varchar" },
			info:     { value: arguments.info, cfsqltype: "cf_sql_longvarchar" },
			table:    { value: arguments.tbl, cfsqltype: "cf_sql_varchar" }
		});
	}
}