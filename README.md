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
- [ ] Add and Impement the following roles:  
  - [ ] Supervisor  
  - [ ] Superintendent  
  - [ ] Field Manager  
- 
 
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
