[![wakatime](https://wakatime.com/badge/user/c78c31fe-9c97-4b21-b865-91bc182f2d42.svg)](https://wakatime.com/@c78c31fe-9c97-4b21-b865-91bc182f2d42)

# AssetGear

## Overview

AssetGear is a web application designed for managing assets and maintenance tasks. It includes features for handling inventory, work orders, permits, user management, and more.

## Features

- Asset Management
- Preventive Maintenance Tasks
- Inventory Management
- Work Order Management
- Permit to Work System
- User Management
- Incident Reporting

## Todo

- [ ] Print JHA should also show attached documents and work order in the exported PDF
- [ ] Print Work Order should also show attached documents in the exported PDF
- [ ] Print PTW should include JHA (if no JHA, include the attachment)
- [ ] Each department has a superintendent that needs to approve a WO
- [ ] Add and Implement the following roles:
  - [ ] Supervisor
  - [ ] Superintendent
  - [ ] Field Manager
- [ ] Users should not be able to view or edit WO not in their department
- [ ] Warehouse Manager, Enable notification
- [ ] Fix warehouse issue for sending WO
- [ ] Add expiration date for warehouse item
- [ ] Warehouse users should not be able to perform another operation - only view - user usr profile

- [ ] Service Request
- [ ] ===============
- [ ] Who created a notification
- [ ] Number of Task each persons are able to close out
- [ ] Service Request to be sent to

- [ ] Work Order
- [ ] ===============
- [ ] Once approved, don't allow supervisor to add new or edit warehouse material
- [ ] Enforce work order to be approved before given issue out of items

- UOM and QOH should show the while issue out

- [*] While viewing the Work Order, change the Spare-parts to Descriptions
- [ ] Add Item Code to everywhere that you have item list -[ ] Add QOO
- [ ] Audit trail on who so ever update the inventor
- [ ] Pagination should show total number of items
- [ ] When new WO is created and it involve materials, it should send a mail to warehouse
- [ ] Show wo created WO without printing -[ ] Merging of item as in Code
- [ ] Add grcode to workorder
- [ ] On the new issue: add item Code to the material list area
- [ ] QOH should show while in work order mode
- [ ] Assign ItemId to Item Code, and allow Admin Overise the Item Code
- [ ] Add money type to Textbox (input box)
- [ ] Warehouse items
- [ ] Sort by the most recent item
- [ ] Remove VPN attached to Item description in warehouse item view
- [ ] Turn Quantity to integer

- [ ] Awaiting Invoice Receipt
- [ ] Unpriced Issue
- [ ] Receive only
- [ ] Invoice already posted

## Bug

- [ ] Search not working use 15626 as a case study
- [ ] System can not issue out partial item on WorkOrder
- [ ] Make the material requisition items all caps
- [ ] Don't make the remark field required field
- [ ] OEM should not be required
- [ ] Don't make price required
- [ ] Date issued should be the current date
- [ ] Add date opened

- [ ] Ability to show more info for editable table text
- [ ] Add uint to MR
- [ ] Make availability partial removeal of items while issuing out
- [ ] VPN and ICN should show on the work order

- Pully hub - remove qor
- Brush:Electric Motor
- Rag: Mini

## New Feature

- [ ] when lpg and operations approves it should also copy their sup

## Update

- [ ] Separate the Name from the Date and Signature
- [ ] Change all colors on borders to company brand

## Wish List

-[ ] Vendor List

## Installation

### Prerequisites

- Lucee 5
- MySQL 8+
- AWS S3 and SES for storage and email services

### Setup

1. Clone the repository to your local machine:

   ```sh
   git clone https://github.com/officelime/assetgear.git
   ```

2. Navigate to the project directory:

   ```sh
   cd assetgear
   ```

3. Configure the environment variables in env.cfm:

   ```cfml
   <cfscript>
     variables.appName = "Short Client name"
     variables.companyName = "Full Client name"
     variables.domain = "clientdomainname.com"
     variables.site.url = "http://localhost/assetgear/"
     variables.datasources["dsn"] = {
       class: 'com.mysql.cj.jdbc.Driver',
       bundleName: 'com.mysql.cj',
       connectionString: 'jdbc:mysql://localhost:3308/assetgear?characterEncoding=UTF-8&verifyServerCertificate=false&serverTimezone=Etc/UTC&autoReconnect=true&useSSL=false&maxReconnects=3',
       username: 'root'
     }

     variables.aws.s3 = {
       bucketName: "your-s3-bucket-name",
       accessKey: "your-aws-access-key",
       secretKey: "your-aws-secret-key",
       region: "your-aws-region"
     }

     variables.aws.mail = {
       smtpServer: "email-smtp.your-region.amazonaws.com",
       smtpPort: 587,
       smtpUsername: "your-smtp-username",
       smtpPassword: "your-smtp-password"
     }
   </cfscript>
   ```

4. Import the database schema from `database/schema.sql` into your MySQL database.

5. Start your Lucee server and navigate to the application URL:
   ```sh
   http://localhost/assetgear/
   ```

## Usage

- Log in with your credentials.
- Navigate through the different modules to manage assets, maintenance tasks, inventory, work orders, permits, users, and incidents.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

## License

This project is licensed under the MIT License.

## Contact

For any inquiries or support, please contact [support@officelime.com](mailto:support@officelime.com).

=========

david.sanni@pesoenergy.com - 2237
victor.george@pesoenergy.com-6773
emmanuel.ofoh@pesoenergy.com-8849
oghale.adiude@pesoenergy.com-6678

automatically use the wo descrioption, department, and unit while createing an mr
