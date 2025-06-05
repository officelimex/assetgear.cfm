  <form id="mergeForm" class="form-horizontal">
    <div class="control-group">
      <label class="control-label">Merge ICNs From:</label>
      <div class="controls">
        <div class="row-fluid">
          <div class="span4">
            <input type="text" id="item1" name="item1" placeholder="ICN" />
          </div>
          <div class="span1" style="text-algin:right;">
            <label>to:</label>
          </div>
          <div class="span4">
            <input type="text" id="item2" name="item2" placeholder="ICN" />
          </div>
          <div class="span3">
            <button type="button" class="btn btn-primary" onclick="fetchItemDetails()">Search</button>
          </div>
        </div>
      </div>
    </div>
    <hr/>
    <div id="itemAttributes" style="margin-top: 30px;"></div>
    <button type="submit" class="btn btn-danger" style="display:none;" id="mergeButton">Merge Now</button>
  </form>

<script>
  window.addEvent('domready', function () {
    function fetchItemDetails() {
      const icn1 = $('item1').value;
      const icn2 = $('item2').value;

      if (!icn1 || !icn2) {
        alert('Enter both item codes.');
        return;
      }

      new Request.JSON({
        url: 'modules/ajax/warehouse.cfm?cmd=getICNsForMerge',
        method: 'GET',
        data: { item1: icn1, item2: icn2 },
        onSuccess: function (response) {
          console.log(response);

          if (!response.success) {
            alert(response.error);
            return;
          }
          renderAttributes({
            item1: response.data[icn1],
            item2: response.data[icn2]
          });
        }
      }).send();
    }

    function renderAttributes(data) {
  const container = $('itemAttributes');
  container.empty();

  const fields = [
    'Code', 'Description', 'VPN', 'Reference',
    'UnitPrice', 'MinimumInStore', 'MaximumInStore',
    'Maker', 'ShelfLocation'  
  ];

  const sumFields = ['QOR', 'QOO', 'QOH'];

  const displayLabels = {
    Code: 'ICN',
    ShelfLocation: 'Shelf Location'
  };

  const table = new Element('table', {
    class: 'table table-bordered table-striped',
    styles: { tableLayout: 'fixed', width: '100%' }
  });

  const tbody = new Element('tbody');

  // Standard Fields with radio option
  fields.forEach(field => {
    const val1 = data.item1[field];
    const val2 = data.item2[field];

    const isEmpty1 = (val1 === '' || val1 === null || val1 === 0);
    const isEmpty2 = (val2 === '' || val2 === null || val2 === 0);
    if (isEmpty1 && isEmpty2) return;

    const row = new Element('tr');

    const labelCell = new Element('td', {
      html: displayLabels[field] || field,
      styles: { fontWeight: 'bold', width: '20%' }
    });

    const item1Cell = new Element('td', {
      html: `<label><input type="radio" name="${field}" value="${val1}" checked> ${val1}</label>`,
      styles: { wordWrap: 'break-word', whiteSpace: 'normal' }
    });

    const item2Cell = new Element('td', {
      html: `<label><input type="radio" name="${field}" value="${val2}"> ${val2}</label>`,
      styles: { wordWrap: 'break-word', whiteSpace: 'normal' }
    });

    row.adopt(labelCell, item1Cell, item2Cell);
    tbody.adopt(row);
  });

  // Sum Fields with dual checkboxes
  sumFields.forEach(field => {
    const val1 = parseFloat(data.item1[field]) || 0;
    const val2 = parseFloat(data.item2[field]) || 0;
    const summed = val1 + val2;

    if (summed === 0) return;

    const row = new Element('tr');

    const labelCell = new Element('td', {
      html: field,
      styles: { fontWeight: 'bold' }
    });

    const item1Cell = new Element('td', {
      html: `
        <label><input type="checkbox" name="${field}_item1" value="${val1}" checked> ${val1}</label>
      `,
      styles: { wordWrap: 'break-word' }
    });

    const item2Cell = new Element('td', {
      html: `
        <label><input type="checkbox" name="${field}_item2" value="${val2}" checked> ${val2}</label>
      `,
      styles: { wordWrap: 'break-word' }
    });

    row.adopt(labelCell, item1Cell, item2Cell);
    tbody.adopt(row);
  });

  table.adopt(tbody);

  const wrapper = new Element('div', {
    class: 'table-wrapper',
    styles: { overflowX: 'auto' }
  });

  wrapper.adopt(table);
  container.adopt(wrapper);

  $('mergeButton').show();
}


    $('mergeForm').addEvent('submit', function (e) {
      e.preventDefault();
      
      if (!confirm('Are you sure you want to merge the above ICN? You will not be able to reverse this process again')) {
        return;
      }

      const data = this.toQueryString();

      new Request.JSON({
        url: 'modules/ajax/warehouse.cfm?cmd=mergeItems',
        method: 'post',
        data: data,
        onSuccess: function (response) {
          
          if (response.success) {
            alert('Items merged successfully.');
            $('mergeForm').reset(); 
            $('itemAttributes').empty(); 
            $('mergeButton').hide(); 
          } else {
            alert('Merge failed: ' + response.message);
          }
        }
      }).send();
    });

    window.fetchItemDetails = fetchItemDetails;
  });
</script>



