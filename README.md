OpenSpecimen
============

An Open Source Biobanking Informatics Platform 
Developed by Krishagni Solutions (India)


Introduction
------------
OpenSpecimen (formerly known as caTissue Plus) is a Free & Open Source biobank/biospecimen management software. At the heart of OpenSpecimen is that “biospecimens without high quality data is of no value”. OpenSpecimen is used across the globe in some of the most respected biobanks of various sizes and diseases. OpenSpecimen streamlines management of biospecimens across collection, consent, QC, request and distribution. Finally, OpenSpecimen is highly configurable and customizable. E.g., adding a custom field or form can be done in minutes by a non-IT person. 

Krishagni Solutions (India) actively develops newer versions of OpenSpecimen as well provides professional support. Support includes phone/email, data migration, customizations, integrations, training, and so forth. 

For more details visit: www.openspecimen.org

Features
---------
 * Planned and unplanned biospecimen collections
 * Storage and Inventory management
 * Role based user authentication and authorization
 * Participants and informed consents
 * Path reports
 * Clinical and pathology annotations
 * Specimen request and distribution 
 * Shipping and tracking
 * Track specimen lifecycle events
 * Reports: Data query, Pivot table, Export as CSV, Scheduled reports
 * Custom fields and forms
 * Complete audit trial
 * Bulk Operation to upload CSV data
 * Token based specimen label generation
 * Barcode printing
 * REST APIs
 * Integration with clinical databases
 * Integration with instruments
 * Real time notifications
 
 Upcoming features
 ------------------
 * Patient family relationships (family pedigree)
 * Invoicing
 * Tissue Microarray
 * Highly configurable user interface
 * Mobile and tablet apps

Build Instructions
-------------------
Pre-Requisite Software:
IntelliJ IDEA or IntelliJ Community Edition
- Node Version Manager (Latest)
- Node 16+
- Java JDK 17 (Also Tested Against OpenJDK 21.0.2)
- Apache Tomcat 10.0+
  - Tomcat 10 requires migration from JavaEE to Jakarta, to do so you will need to use Tomcat's built in migration tool before attempting to run any compiled binary.
- NPM (Included with Node)
- bower
- grunt
- vue/@cli
- gifsicle@1.0.3
- optipng-bin

Getting started:
1) If you are on a Windows Device you will need to install NodeJS, Chocolatey, VisualStudio, BASH and GIT
2) For all other users, install IntelliJ IDEA
3) Launch IntelliJ and select "Import from VCS", input the URL provided from GitHub's clone context menu at the top of the repository.
4) Open a terminal and run the script "build_intelliJ" the script will step through the process of installing all dependancies and compile OpenSpecimen for you.

Manually Compiling:
Forenote: This method is more difficult and does the same thing that the provided script does.
1) Run the following commands in order:
 - `cd www`
 - `npm install vue/@cli`
 - `npm install bower`
 - `npm install gifsicle@1.0.3`
 - `npm install optipng-bin`
 - `npm install`
 - `npm audit`
 - `grunt build`
 - `cd ..`
If grunt build runs successfully at this point you are ready for step 2 of this process.
2) Build OpenSpecimen
- `gradle clean`
- `gradle deploy`

Migration:
This is a single step process, once you have finished the build process above you will need to locate your tomcat install and navigate to the bin directory.
Inside of the bin directory, you will find a migration tool to utilize it simply run the tool and provide the path to your newly compiled OpenSpecimen.war file, and an output directory for the migrated OpenSpecimen.war

Congratulations, you have just updated to the latest OpenSpecimen Version.

Online Resources
----------------
Website: http://www.openspecimen.org
Forums: http://forums.openspecimen.org
Help: http://help.openspecimen.org
Email: mailto:contact@openspecimen.org

License
--------
OpenSpecimen is released under BSD 3 Style license. 
https://github.com/krishagni/openspecimen/blob/trunk/LICENSE.md

Contact Information for Krishagni
-------------------
Project Lead: Srikanth Adiga
Email: srikanth.adiga@openspecimen.org


**Please note I am not associated with Krishagni, I have only built this repository to be a resource for those who wish to build the community edition after I encountered several issues doing so by myself using the confluence board.
I only wish to provide this as a resource to make OpenSpecimen more accessible to other researchers. **
