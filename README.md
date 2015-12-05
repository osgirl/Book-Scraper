# OSU Barnes and Noble Book-Scraper
A web scraper which scrapes the Ohio State University Barnes and Noble textbook site (see here: http://ohiostate.bncollege.com/webapp/wcs/stores/servlet/TBWizardView?catalogId=10001&langId=-1&storeId=33552). The scraper will populate .csv files with all of the books needed for all of the courses at OSU. These .csv files can then be uploaded to a database (more explanation on this process later). 

## Code structure
The code is split into 4 logical sections: the controller, connection, data structures, and logger. The code for the controller, data structures, and logger are located in the root folder and is stored inside the 'scrape.rb', 'data_strucutres.rb', and 'scrapeLogger.rb' files respectively. The connection code is stored in the 'connection' folder.
### Controller
When executing the program, this is the file you will be executing. The process is as follows:
1. Parse command line arguments. The possible command line arguments are 
..* [-r|--reset]: Prompt deletion of scraped books and restart scraping process at the beginning. If supplied, the .csv, .lock, and .dat files are deleted and the scraping process starts from the beginning
..* [-f|--force]: Force deletion of scraped books if the -r argument is provided. Otherwise, nothing.
..* [-u|--upload]: Upload the scraped books to the server specified in upload.ps1. Only compatible with windows!
..* [-p|--persistent]: Enable Persistent Scraping (restart the scraper on connection or socket errors)
2. Begin scraping
..* If the last.dat file exists, begin scraping from where the last scraping session left off. Do not modify this file manually as it is automatically generated and could reset your scraping progress if you don't know what you're doing!
..* If the last.dat file does not exist, generate a last.dat file and begin scraping from the beginning.
3. Create a backend connection with the OSU B&N site and grab the id values of the semester, department, course, and sections.
4. Create a visual connection with the OSU B&N site and select the sections of a specific course. Submit the form and scrape the books into a .csv file.
..* Important note: If there are more than 10 sections for a course, it will scrape 10 sections at a time. Also, it is limited to 100 sections per course.
5. If the --upload argument is provided, after scraping an entire department, the .csv file generated for that department is uploaded to the database designated in the upload.ps1 PowerShell script. 
6. Repeate process 3-5 until all courses have been scraped or an error/interrupt occurs.
7. ON CONNECTION LOSS: The scraper will wait 5 seconds and retry the connection. If it fails again, it will throw an error.
8. ON ERROR: If the --persistent argument is provided, the program will reload the scraper starting at step 2. Otherwise, the program will terminate.
9. ON INTERRUPT: Usually caused by 'ctrl + c'. The scraper will terminate and can be resumed at a later time.

## Generated Files

## Use cases

## Final Notes
* As it sits, this scraping process can take up to 2 weeks to complete depending on processing speed, internet speed, internet connection stability, and other miscellaneous factors. 
* The uploading process only works for windows sql server using a PowerShell script. This can be modified to work with Unix/OSX by changing the PowerShell script into a bash script and modifying the system call in the scrape.rb file. But for our use cases, we needed a powershell script for windows server 2012.
