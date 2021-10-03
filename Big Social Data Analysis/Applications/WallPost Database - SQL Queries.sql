-- 1) Setup Azure student server and SQL Database

-- 2) Create database tables using script provided

-- 3) Executte all queries presentted in lecture slides

-- SELECT: All posts from data
SELECT * FROM wallpost;

-- SELECT: Retrieve only selective columns
SELECT Name, WallId, PostCreatedDate, PostType FROM WALLPOST;

-- ORDER: Retrieve data in ascending order
SELECT * FROM WALLPOST ORDER BY postcreateddate;

-- ORDER: Retrieve data in descending order
SELECT * FROM WALLPOST ORDER BY postcreateddate DESC;

-- ORDER: Apply order by on multiple columns in one query
SELECT * FROM WALLPOST ORDER BY postcreateddate,
postupdateddate desc;

-- AGGREGATE: Select the earliest and latest post in the data.
SELECT Min(PostCreatedDate) FROM WALLPOST;
SELECT Max(PostCreatedDate) FROM WALLPOST;

-- AGGREGATE: Count number of likes in data
SELECT Count(*) FROM WALLPOSTLIKE;

-- AGGREGATE: Apply condition within count
SELECT count(case when reactiontype<>'LIKE' then 1 end) FROM WALLPOSTLIKE;

-- AGGREGATE: Combine Data using Group BY keyword in the query
SELECT PostType FROM WALLPOST Group By PostType;

-- AGGREGATE: Count how many post types there are in the data and how many posts each type of post is having in database
SELECT PostType, Count(*) FROM WALLPOST Group By PostType;
SELECT PostType, StatusType, Count(*) FROM WALLPOST Group By PostType, StatusType;

-- HAVING: Retrieve those users who posted minimum 2 posts and present the most active poster at the top
SELECT fromid, count(*) FROM wallpost 
GROUP BY fromid HAVING count(*) > 2 ORDER BY count(*) DESC;

-- JOIN: Join WallPost and WallPostLike table to fetch all the reaction along with the Id of the person who posted
SELECT WALLPOST.FROMID, WALLPOST.POSTTYPE, WALLPOSTLIKE.REACTIONTYPE 
FROM WALLPOST, WALLPOSTLIKE 
WHERE WALLPOST.POSTDBID = WALLPOSTLIKE.POSTDBID;

-- JOIN: Alternate Syntax
SELECT WALLPOST.FROMID, WALLPOST.POSTTYPE, WALLPOSTLIKE.REACTIONTYPE 
FROM WALLPOST 
JOIN WALLPOSTLIKE ON WALLPOST.POSTDBID = WALLPOSTLIKE.POSTDBID;

-- QUESTION: What post types are present there in the data?
SELECT PostType FROM WALLPOST GROUP BY PostType;

-- QUESTION: How many posts are there per type, present them in the descending order by number of posts?
SELECT PostType, Count(*) TotalPosts FROM WALLPOST 
GROUP BY PostType ORDER BY TotalPosts DESC;

-- QUESTION: What post types have most reactions?
SELECT PostType, Count(*) TotalLikes FROM WALLPOST wp, WALLPOSTLIKE wpl 
WHERE wp.PostDBId = wpl.PostDBId
GROUP BY PostType ORDER BY TotalLikes DESC;

-- QUESTION: What are kind of reactions on each post type?
SELECT PostType, ReactionType, Count(*) TotalLikes FROM WALLPOST wp, WALLPOSTLIKE wpl
WHERE wp.PostDBId = wpl.PostDBId
GROUP BY PostType, ReactionType Order By TotalLikes desc;

-- QUESTION: Number of posts per month?
SELECT DatePart(MM, PostCreatedDate), Count(*) FROM WALLPOST
GROUP BY DatePart(MM, PostCreatedDate);

-- QUESTION: How is distribution of posts according to week day?
SELECT DatePart(weekday, PostCreatedDate), Count(*) FROM WALLPOST
GROUP BY DatePart(weekday, PostCreatedDate);

-- QUESTION: What are number of posts each month?
SELECT CAST(DatePart(YYYY, PostCreatedDate) as NVarchar) + '-' + CAST(DatePart(MONTH, PostCreatedDate) as NVarchar) MonthYear, Count(*) FROM WALLPOST
GROUP BY CAST(DatePart(YYYY, PostCreatedDate) as NVarchar) + '-' + CAST(DatePart(MONTH, PostCreatedDate) as NVarchar)
Order by MonthYear desc;

-- QUESTION: How are comments distributed per month?
SELECT CAST(DatePart(YYYY, CommentCreatedTime) as NVarchar) + '-' + CAST(DatePart(MONTH, CommentCreatedTime) as NVarchar) MonthYear, Count(*) FROM WALLPOST WP, WALLPOSTCOMMENT WPC
WHERE WP.POSTDBID = WPC.POSTDBID
GROUP BY CAST(DatePart(YYYY, CommentCreatedTime) as NVarchar) + '-' + CAST(DatePart(MONTH, CommentCreatedTime) as NVarchar)
Order by MonthYear desc;

-- QUESTION: Who posted most on this wall?
SELECT FromId, count(*) FROM WALLPOST GROUP BY FROMID HAVING Count(*) > 2 order by count(*) desc;

-- QUESTION: Retrieve users who reacted actively, with minimum 15 reactions?
SELECT wpl.FromId, count(*) FROM WALLPOST WP, WALLPOSTLIKE wpl
WHERE WP.POSTDBID = wpl.POSTDBID GROUP BY wpl.FROMID
HAVING Count(*) > 15 order by count(*) desc;

-- QUESTION: Are there any users who reacted SAD minimum twice?
SELECT wpl.FromId, count(*) FROM WALLPOST WP, WALLPOSTLIKE wpl 
WHERE WP.POSTDBID = wpl.POSTDBID AND ReactionType = 'SAD' 
GROUP BY wpl.FROMID
HAVING Count(*) > 1 order by count(*) desc;

-- QUESTION: Posts that have no reactions?
SELECT WP.POSTDBID, WP.FROMID, WP.POSTTYPE, WP.POSTTEXT FROM WALLPOST wp LEFT JOIN WALLPOSTLIKE WPL ON wp.POSTDBID = WPL.POSTDBID
WHERE WPL.POSTDBID IS NULL;

-- QUESTION: Posts that have no Comments?
SELECT WP.POSTDBID, WP.FROMID, WP.POSTTYPE, WP.POSTTEXT FROM WALLPOST wp LEFT JOIN WALLPOSTCOMMENT WPC ON wp.POSTDBID = WPC.POSTDBID
WHERE WPC.POSTDBID IS NULL;

-- QUESTION: Are there any particular words present in the Post/Comment text?
SELECT * FROM wallpost WHERE PostText LIKE '%crazy%';
SELECT * FROM WallPostComment WHERE Commenttext LIKE '%crazy%';

-- 4) Generate atleast 5 more reports apart from what are presented in lecture 
-- 5) Run query and note obvious missing data patterns 

-- QUESTION: How is distribution of comments according to week day?

select DatePart(weekday, CommentCreatedTime), Count(*) TotalComments from WallPostComment
group by DatePart(weekday, CommentCreatedTime) order by TotalComments desc;

-- QUESTION: What is the top 5 Commentators?

select FromName, count(FromName) TotalComment from WallPostComment
group by FromName order by TotalComment desc 
offset 0 rows fetch first 5 rows only;

-- QUESTION: What is the top 5 Commentators/PostTypes?

select wp.PostType, wpc.FromName, count(wpc.FromName) TotalComment  from WallPost wp, WallPostComment wpc
WHERE wp.PostDBId = wpc.PostDBId
group by wp.PostType, wpc.FromName 
order by TotalComment desc 
offset 0 rows fetch first 5 rows only;

-- QUESTION: What is the top 5 Commentators/PostReactions?

select wpl.ReactionType, wpc.FromName, count(wpc.FromName) TotalComment from WallPostLike wpl, WallPostComment wpc
WHERE wpl.PostDBId = wpc.PostDBId
group by wpl.ReactionType, wpc.FromName
order by TotalComment desc 
offset 0 rows fetch first 5 rows only;

-- QUESTION: Are there any particular words present in the Post/Comment text?
SELECT * FROM WallPostComment WHERE Commenttext LIKE '%fantastic%';