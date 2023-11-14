OpenSpecimen
============

An Open Source Biobanking Informatics Platform 
Developed by Krishagni Solutions (India)


Introduction
------------
OpenSpecimen (formerly known as caTissue Plus) is a Free & Open Source biobank/biospecimen management software. At the heart of OpenSpecimen is that “biospecimens without high quality data is of no value”. OpenSpecimen is used across the globe in some of the most respected biobanks of various sizes and diseases. OpenSpecimen streamlines management of biospecimens across collection, consent, QC, request and distribution. Finally, OpenSpecimen is highly configurable and customizable. E.g., adding a custom field or form can be done in minutes by a non-IT person. 

Krishagni Solutions (India) actively develops newer versions of OpenSpecimen as well provides professional support. Support includes phone/email, data migration, customizations, integrations, training, and so forth. 

For more details visit: www.openspecimen.org

**Build Requiements** </br>
Pre-requisite software
- JDK 17 (OpenJDK Recommended)
- Node.JS v16.20.2 (Do not use major versions greater than 16)
- NPM (included with Node.JS)
- Bower 1.8+
  'npm install -g bower'
- Grunt 1.2+
  'npm install -g grunt-cli'
- Gradle 8.4
  See https://gradle.org/install/
  Optionally, you can obtain gradle via chocolatey.
- Vue.JS
  'npm install -g vue-cli'
  
**Additionally Recommended for Windows Devices**</br>
**========================**
- IntelliJ IDEA
- Visual Studio (With Node.JS package)
- Chocolatey a package manager for windows - https://chocolatey.org

**Build Configuration Steps**</br>
**========================**</br>
Forenote: I'm most familiar with Unix based systems and use the file path conventions therein, you will need to provide a more explicit path in windows. </br>
1) Create a new project in IntelliJ IDEA and select the "Get from Version Control" option. 
2) Paste the repository link from above into the version control link as if you were going to use git to clone the repository. 
**Please use the repository at krishagni/openspecimen as I do not intend to update this repository frequently.**
3) Save into a directory of your choice (I recommend ~/Documents/Developer/OpenSpecimen/ for organizational purposes)
4) IntelliJ will clone the git repository into the directory you selected and set itself to utilize the master branch.
5) From the OpenSpeimen project window in IntelliJ IDEA please click commit number at the top of the application.
6) This will open a menu, within this menu click check out tag or revision and check out the latest OpenSpecimen Version or Release Candidate (RC)
**You must check out a revision prior to proceeding further.**
7) Open a terminal through IntelliJ
8) Change to the www directory
- 'cd /www'
9) Install dependancies through npm.
- 'npm install gifsicle@1.0.3' - fixes build failure
- 'npm install'
- Optionally, you may use the audit fix function built into NPM as it does not appear to cause any issues with building at this time.
- 'npm install vue'
- 'grunt build'
10) Copy ~/Developer/OpenSpecimen/ui/src_bk/ to ~/Developer/Openspecimen/ui/src/
- This prevents Vue.JS from encountering a critical error. 
  

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

Contact Information
-------------------
Project Lead: Srikanth Adiga
Email: srikanth.adiga@openspecimen.org
