# Olympics

*The Olympic Games (French: Jeux olympiques d'été), also known as the Games of the Olympiad, and often referred to as the Summer Olympics, is a major international multi-sport event normally held once every four years. The inaugural Games took place in 1896 in Athens, Greece, and the most recent edition was held in 2021 in Tokyo, Japan. ( source wikipedia).*

*This is a sql analysis of the Olympic dataset downloaded from [Kaggle.](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results) This dataset however doesn't contain the data from the recent 2021 Tokyo Olympic. Moreover, the conclusions made using this analysis is completely based on the dataset. No further validation was done.*

*This readme file only contains the basic visualised output of the analysis. Full analysis was done in postgres database and the SQL code is in 'olympic_analysis.sql' file. The SQL queries and their output (in table form, like SQL) can also be seen in the 'Result_Visualisation.ipynb' file.*


## 1.Top Four Athletes With The Most Gold Medals And Their Countries.
![one](https://github.com/Kaushal-Dhungel/Olympic-SQL-Analysis/blob/main/output/1.png)

*- Michael Fred Phelps ( from USA) is the player with the most gold medals in Olympics. The second player in the list is Raymond Clarence who is also from the USA*

## 2. Top 10 Countries With The Most Olympic Golds.
![two](https://github.com/Kaushal-Dhungel/Olympic-SQL-Analysis/blob/main/output/2.png)

*- USA tops the list with highest golds, followed by Russia and Germany. Interestengly, USA also tops the list of both silver and bronze medal counts. China is nowhere near the top 10 but in recent 3-4 olympics she has been giving a really good competition to the USA. Goes on to show how much progress China has made in the recent years.*

## 3. Top Ten Olympics With The Most Participating Countries.
![three](https://github.com/Kaushal-Dhungel/Olympic-SQL-Analysis/blob/main/output/3.png)

*- The number of participating coutries has increased with time. Almost all countries are taking part in the recent olympics. Sports uniting the world.*

## 4. Gold Medals By Age.
![four](https://github.com/Kaushal-Dhungel/Olympic-SQL-Analysis/blob/main/output/4.png)

*- We can see in the above given visualisation that most of the gold medals are won by athletes in the age range of 20-30. Moreover 22,23,24 and 25 are the ages where 1000+ gold medals were won.*

## 5. Gold Medals By Height.
![six](https://github.com/Kaushal-Dhungel/Olympic-SQL-Analysis/blob/main/output/5.png)

*- Athletes with 180 cm have won the most gold medals. Also we can see that medal count is higher for the height range of (167-190)cm. This could be because most people belong to this height range.*

## 6. Cities That Have Hosted The Most Summer Olympics.
![five](https://github.com/Kaushal-Dhungel/Olympic-SQL-Analysis/blob/main/output/6.png)

*- London and Athina have hosted the most olympics (thrice each).*

## 7. Countries With The Most Medals But Zero Gold
![seven](https://github.com/Kaushal-Dhungel/Olympic-SQL-Analysis/blob/main/output/7.png)

*- Ghana has won the most silver and/or bronze medals (23) but no any gold yet. Similarly, Paraguay and Iceland have 17 medals without any golds.*
*(Ghana has only won 1 silver and 4 bronze medals, the above result differed because in 1992 Barcelona Olympic, Ghana Football Team won Bronze, and since all the members got the medal, the result differed.)*


Have a great day. :blush: :heart: :)