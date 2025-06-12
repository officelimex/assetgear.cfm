<cfoutput>
  <cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="attributes.pk" />
    <cfparam name="attributes.table" />
    <cfparam name="attributes.limit" default="50"/>

    <cfquery name="qLogs" dbtype="sql">
      SELECT 
        CONCAT(u.Surname," ",u.OtherNames) User,
        l.URL, l.Type, l.`Key`, l.Title, l.IP, l.Browser, l.Description, l.TimeCreated
      FROM core_log l
      INNER JOIN core_user u ON u.UserId = l.UserId
      WHERE `Table` = <cfqueryparam value="#attributes.table#" cfsqltype="cf_sql_varchar">
        AND `Key` = <cfqueryparam value="#attributes.pk#" cfsqltype="cf_sql_integer"/>
      ORDER BY TimeCreated DESC
      LIMIT <cfqueryparam value="#attributes.limit#" cfsqltype="cf_sql_integer">
    </cfquery>

    <table class="table table-bordered table-striped">
      <thead>
        <tr>
          <th>User</th>
          <th>Event</th>
          <th>Info</th>
        </tr>
      </thead>
      <tbody>
      <cfoutput query="qLogs">
        <tr>
          <td>#htmlEditFormat(User)# #htmlEditFormat(Title)# on #dateTimeFormat(TimeCreated, "yyyy-mm-dd HH:mm:ss")#</td>
          <td>
            #htmlEditFormat(qLogs.URL)#<br/>
            #htmlEditFormat(IP)#
          </td>
          <td>
            <a href="javascript:void(0);" class="desc-toggle btn btn-mini btn-info">Show</a>
            <div class="desc-content" style="display:none; margin-top:5px;">
              <cftry>
                <cfset parsed = deserializeJSON(Description)>
                <cfif structKeyExists(parsed, "COLUMNS") AND structKeyExists(parsed, "DATA")>
                  <!--- Find non-empty columns --->
                  <cfset columnCount = arrayLen(parsed.COLUMNS)>
                  <cfset nonEmptyColumnIndexes = []>
                  <cfloop from="1" to="#columnCount#" index="i">
                    <cfset hasData = false>
                    <cfloop array="#parsed.DATA#" index="row">
                      <cfif len(trim(row[i]))>
                        <cfset hasData = true>
                        <cfbreak>
                      </cfif>
                    </cfloop>
                    <cfif hasData>
                      <cfset arrayAppend(nonEmptyColumnIndexes, i)>
                    </cfif>
                  </cfloop>
          
                  <!--- Render table only with columns that have data --->
                  <table class="table table-bordered table-condensed" style="font-size: 11px;">
                    <thead>
                      <tr>
                        <cfloop array="#nonEmptyColumnIndexes#" index="i">
                          <th>#htmlEditFormat(parsed.COLUMNS[i])#</th>
                        </cfloop>
                      </tr>
                    </thead>
                    <tbody>
                      <cfloop array="#parsed.DATA#" index="row">
                        <tr>
                          <cfloop array="#nonEmptyColumnIndexes#" index="i">
                            <td>#htmlEditFormat(row[i])#</td>
                          </cfloop>
                        </tr>
                      </cfloop>
                    </tbody>
                  </table>
                <cfelse>
                  <pre>#htmlEditFormat(Description)#</pre>
                </cfif>
              <cfcatch>
                <pre>#htmlEditFormat(Description)#</pre>
              </cfcatch>
              </cftry>
            </div>
          </td>
        </tr>
      </cfoutput>
      </tbody>
    </table>
    <script>
      window.addEvent('domready', function() {
        $$('.desc-toggle').each(function(toggleBtn) {
          toggleBtn.addEvent('click', function() {
            var desc = toggleBtn.getNext('.desc-content');
            if (desc.getStyle('display') == 'none') {
              desc.setStyle('display', 'block');
              toggleBtn.set('text', 'Hide');
            } else {
              desc.setStyle('display', 'none');
              toggleBtn.set('text', 'Show');
            }
          });
        });
      });
    </script>
  <cfelse>
    
  </cfif>
  </cfoutput>