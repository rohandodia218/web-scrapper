The above R sript can be copied into the editor and executed directly. The script does the following :

1) as you execute the script.  it would first ask for a input in the range of 2000-2019 from the user.

2)given the inupt, it goes to function "getlinks" to traverse all the pages in given volumes and obtain 
  all articles that were published after the given input year upto the current year

3)thes links are provided as arguments to various functions to get the attributes
	1.DOI of article
  	2.abstract
	3.keywords
 	4.Authors
 	5.Email
                 6.Pub_Date
                 7.content_type
                 8.Title
                 9.Full text includes 1)background/introduction para 2)results para 3)Discussion para 4)conclusions para

4) We  have a create a data frame df with the above mentioned 9 attributes and write into file using write.table into .txt file 
  this can be found inside folder "text file"

5) Downloads all the articles from the crawled links using getdocs function and saves it as "article's DOI".html 
  this can be found inside htmldocs

There are over 6336 articles spanning from years 2000 to 2019  in ou journal.So, We have documented our project by taking the year 2015 as input and the  number of artiels from 2105 -2019 which has around 1140 articles .