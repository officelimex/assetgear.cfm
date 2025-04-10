<cfquery name="getYears">
  SELECT DISTINCT Year FROM count_due ORDER BY Year DESC
</cfquery>

<cfquery name="getMonths">
  SELECT DISTINCT Month FROM count_due ORDER BY Month ASC
</cfquery>

<cfoutput>
  <h4>Count Due List</h4>
  <table class="table table-condensed table-hover table-striped">
    <tr>
      <td>
        <label for="count_due_month">Month:</label>
        <select id="count_due_month">
          <option value="">-- Select Month --</option>
          <cfloop query="getMonths">
            <option value="#getMonths.Month#">#DateFormat(CreateDate(2000, getMonths.Month, 1), "mmmm")#</option>
          </cfloop>
        </select>      
      </td>
      <td>
        <label for="count_due_year">Year:</label>
        <select id="count_due_year">
          <option value="">-- Select Year --</option>
          <cfloop query="getYears">
            <option value="#getYears.Year#">#getYears.Year#</option>
          </cfloop>
        </select>    
      </td>
      <td style="vertical-align: bottom; padding-bottom:12px;padding-left:10px"><button onclick="count_due_loadCountDue()">Filter</button></td>
    </tr>
  </table>

  <table class="table">
    <thead>
      <tr>
        <th>S/N</th>
        <th>Item Description</th>
        <th>QOH</th>
        <th>New Qty</th>
        <th>Shelf Location</th>
      </tr>
    </thead>
    <tbody id="count_due_countDueTable">
      <tr><td colspan="4" style="text-align: center !important;"><small>Select a Month and Year to Load Data</small></td></tr>
    </tbody>
  </table>

  <script>
    function count_due_loadCountDue() {
      var month = document.getElementById("count_due_month").value;
      var year = document.getElementById("count_due_year").value;

      if (!month || !year) {
        alert("Please select both Month and Year.");
        return;
      }

      fetch(`modules/warehouse/material/count_due_data.cfm?month=${month}&year=${year}`)
        .then(response => response.text())
        .then(data => {
          document.getElementById("count_due_countDueTable").innerHTML = data;
        })
        .catch(error => console.error("Error loading data:", error));
    }
  </script>
</cfoutput>
