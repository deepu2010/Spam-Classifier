reviews = load 'ProjectText' as (productid, userid, profilename, helpfulness, score, time, summary, review);
grpd = group reviews by time;
perday = foreach grpd generate group, COUNT(reviews) as reviewc, 1 as indexTogroup;
grpdperday = group perday by indexTogroup;
perdayAVG = foreach grpdperday generate AVG(perday.reviewc) as avgvalue;
grpdbyNR = group reviews by userid;
peruser = foreach grpdbyNR generate group, COUNT(reviews) as reviewn, reviews.userid;
outlieruser = filter peruser BY reviewn > perdayAVG.avgvalue;
joino = JOIN outlieruser BY group, reviews BY userid;
timespam = FOREACH joino GENERATE review;
store timespam into 'timesuspect.txt';