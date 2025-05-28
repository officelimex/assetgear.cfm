component  {

    remote string function deleteItem(required numeric id) {

        // check item in issue
        query name="local.qI" {
            echo('SELECT * FROM whs_issue_item WHERE ItemId=#arguments.id#');
        }
        query name="local.qI2" {
            echo('SELECT * FROM whs_mr_item WHERE ItemId=#arguments.id#');
        }
        query name="local.qI3" {
            echo('SELECT * FROM work_order_item WHERE ItemId=#arguments.id#');
        }
        query name="local.qI4" {
            echo('SELECT * FROM whs_material_received_item WHERE ItemId=#arguments.id#');
        }


        var message = "Item #arguments.id# Deleted";
        if ((local.qI.recordcount) or (local.qI2.recordcount ) or (local.qI3.recordcount) or (local.qI4.recordcount))   {
            query {
                echo('UPDATE whs_item SET `Status` = "Deleted" WHERE ItemId=#arguments.id#');
            }
        }
        else    {
            // its dave to delete item
            query {
                echo('DELETE FROM whs_item WHERE ItemId=#arguments.id#');
            }
        }

        return message;
      }
		
		remote string function closeMR(required numeric id)	{

			queryExecute(
					"UPDATE whs_mr SET Status = ?, ClosedByUserId = ?, ClosedDate = ? WHERE MRId = ?",
					["Closed", request.userinfo.userId, dateTimeFormat(now(), "yyyy-mm-dd HH:MM"), arguments.id]
			);

			queryExecute('UPDATE whs_mr_item SET `Status`="Closed" WHERE MRId=#arguments.id#')

			return "MR #arguments.id# now Closed";
		}

    remote string function declineMR(required numeric id) {

        // check item in issue

        query name="local.qI" {
            echo('SELECT * FROM whs_mr WHERE MRId=#arguments.id#');
        }
        query {
            echo('UPDATE whs_mr SET `Status`="Declined" WHERE MRId=#arguments.id#');
        }
        if(qI.WorkOrderId neq ""){
          query {
              echo('UPDATE work_order SET `Status`="Closed" WHERE WorkOrderId=#qI.WorkOrderId#');
          }
        }
        if(qI.ServiceRequestId neq ""){
          query {
              echo('UPDATE service_request SET `Status`="Declined" WHERE ServiceRequestId=#qI.ServiceRequestId#');
          }
        }


        return "MR #arguments.id# Declined";
    }
}
