# OSU Barnes and Noble Book-Scraper
A web scraper which scrapes the Ohio State University Barnes and Noble textbook site (see here: http://ohiostate.bncollege.com/webapp/wcs/stores/servlet/TBWizardView?catalogId=10001&langId=-1&storeId=33552). The scraper will populate .csv files with all of the books needed for all of the courses at OSU. These .csv files can then be uploaded to a database (more explanation on this process later). 

## Prerequisites
To run the book scraper, you will need three pieces of software installed on your machine:

* [Ruby](https://www.ruby-lang.org/en/downloads/)
	* Scraper is written in ruby... So yea. You need it.
* Git
	* For cloning and version control
* [Mozilla Firefox](https://www.mozilla.org/en-US/firefox/new/?product=firefox-3.6.8)
	* The scraper will be opening Firefox windows to do the visual scraping. Information on this is provided below.

## Cloning and Setup
The first step to running the Book-Scraper after installing the prerequisite software is to clone the directory onto your local machine (or server). If you are unfamiliar with this process, it is very straightforward. Open up a terminal prompt of some sort ([git-cmd](https://git-scm.com/download/win) for windows is preferred for full functionality). Run the following:

```bash
git clone https://github.com/N8Stewart/Book-Scraper &lt;location&gt;
```
where location is the the folder where you want the files to be cloned. If left blank, it will default to a folder called 'Book-Scraper'.
<br>
Once cloned, the next step is to install the bundled software. Run the following:
```bash
bundle install
```
All the setup is now complete! You can move onto running the scraper.

## Running the Scraper
To run the scraper, it is very easy. Just run the following command in the terminal:
```bash
ruby scrape.rb
```
See below, in Code Structure > Controller, for more information on the command line arguments available for the scraping process.

## Code structure
The code is split into 4 logical sections: the controller, connection, data structures, and logger. The code for the controller, data structures, and logger are located in the root folder and is stored inside the 'scrape.rb', 'data_strucutres.rb', and 'scrapeLogger.rb' files respectively. The connection code is stored in the 'connection' folder.

### Controller
When executing the program, this is the file you will be executing. The process is as follows:

1. Parse command line arguments. The possible command line arguments are 
	* [-r|--reset]: Prompt deletion of scraped books and restart scraping process at the beginning. If supplied, the .csv, .lock, and .dat files are deleted and the scraping process starts from the beginning
	* [-f|--force]: Force deletion of scraped books if the -r argument is provided. Otherwise, nothing.
	* [-u|--upload]: Upload the scraped books to the server specified in upload.ps1. Only compatible with windows!
	* [-p|--persistent]: Enable Persistent Scraping (restart the scraper on connection or socket errors)
2. Begin scraping
	* If the last.dat file exists, begin scraping from where the last scraping session left off. Do not modify this file manually as it is automatically generated and could reset your scraping progress if you don't know what you're doing!
	* If the last.dat file does not exist, generate a last.dat file and begin scraping from the beginning.
3. Create a backend connection with the OSU B&amp;N site and grab the id values of the semester, department, course, and sections.
4. Create a visual connection with the OSU B&amp;N site and select the sections of a specific course. Submit the form and scrape the books into a .csv file.
	* Important note: If there are more than 10 sections for a course, it will scrape 10 sections at a time. Also, it is limited to 100 sections per course.
5. If the --upload argument is provided, after scraping an entire department, the .csv file generated for that department is uploaded to the database designated in the upload.ps1 PowerShell script. 
6. Repeat process 3-5 until all courses have been scraped or an error/interrupt occurs.

* ON CONNECTION LOSS: The scraper will wait 5 seconds and retry the connection. If it fails again, it will throw an error.
* ON ERROR: If the --persistent argument is provided, the program will reload the scraper starting at step 2. Otherwise, the program will terminate.
* ON INTERRUPT: Usually caused by 'ctrl + c'. The scraper will terminate and can be resumed at a later time.

### Connection
The connection class is composed of a base connection class and two abstractions, 'visualConnection.rb' and 'backendConnection.rb'. Inside the connection folder also resides the 'parameters.rb' file which stores various utility methods for interacting with the Mechanize and Capybara connections.

#### Connection
This file is important more for common data storage and initialization than anything else. It stores the hardcoded website URL's as well as instance variables for the connection, session and page. 

#### Backend Connection
Utilizes the [Mechanize gem](https://github.com/sparklemotion/mechanize) to parse the backend of the B&amp;N site. Useful to grab the id values of the term, department, course, and section of each individual course available on the site.

#### Visual Connection
Utilizes the [Capybara Gem](https://github.com/jnicklas/capybara) to select the dropdown boxes on the site and submit a form. Capybara then is able to scrape the webpage for any books present on the summary page of the B&amp;N site. Capybara is needed because the site is dynamic, using JavaScript to change the dropdown values whenever an option is chosen.

#### Parameters
Stores and validates connection parameters (term, dept, course, and section). The parameters class also saves, loads, and parses the last.dat file which is important to save state in the case that a connection/socket issue arises.

### Data Structures
Internal data structures to store frequently used data. The only notable structure used is the 'Book' class. If more information is needed (or less is wanted) this is the class to modify. It stores the ISBN, title, author, publisher, edition, and image of the book as well as what course the book is associated with. It also contains methods to output the book to the .csv file with variable delimiter provided by the caller.

### Logger
Very simplistic form of logging. This is where the log file name 'scraper.log' is defined and can be changed if necessary. Essentially, text is passed into the 'append' function and it is appended to the end of the logfile. 

## Generated Files
During the scraping process, several files are generated and renamed in peculiar ways. This section is here to explain the intricacies of this process. 
<br>
When the scraper is first started, the 'last.dat' file (which tracks the most recent scraped course and section) is created as well as the 'scraper.log' file which timestamps specific actions. 
<br>
When a department is in progress of being scraped, a 'semester_id'.'deparment_name'.csv.lock file is created to store any books scraped. Once the department has been fully scraped, this file is renamed to 'semester_id'.'deparment_name'.csv. These files are stored in the 'data' directory and are removed using the '--reset' command line argument.

## Final Notes
* As it sits, this scraping process can take up to 2 weeks to complete depending on processing speed, internet speed, internet connection stability, and other miscellaneous factors. 
* The uploading process only works for windows sql server using a PowerShell script. This can be modified to work with Unix/OSX by changing the PowerShell script into a bash script and modifying the system call in the scrape.rb file. But for our use cases, we needed a PowerShell script for windows server 2012.
