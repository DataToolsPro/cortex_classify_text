SELECT    
  *,    
  CONCAT('Full Name: ', "Full name", ', Twitter Followers: ', CAST(ZEROIFNULL("Followers") AS STRING), ', Bio: ', IFNULL("Bio",'I am a twitter user')) as "SearchString",

  -- CORTEX FUNCTION TO CATEGORIZE AND CLASSIFY MY TWITTER FOLLOWERS
  SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
    "SearchString",
    [
      {
        'label': 'company',
        'description': 'Account is a company and not an individual person first name and last name based on the Full Name and Bio and Bio is descriptive of a product or service offered by the Full Name.',
        'examples': ['Full Name: Acme Co, Twitter Followers: 67720, Bio: Acme co will boost website traffic to 1000%', 'Full Name: Salesforce AppProvider, Twitter Followers: 67720, Bio: Get experts to solve business problems fast and improve your Salesforce Customer. Experience']
      },
      {
        'label': 'targetuser',
        'description': 'Account is a target user based on their Full Name being a person name and the Bio describes themselves as being involved with technology like salesforce, data or analytics',
        'examples': ['Full Name: Bob Smith, Twitter Followers: 201, Bio: 2x Salesforce Certified | Trailhead 6x Ranger']
      },
      {
        'label': 'influencer',
        'description': 'Account has tens of thousands of Twitter Followers or more and the Bio self describes themself as an influencer being involved with technology like salesforce, data or analytics',
        'examples': ['Full Name: Nance Woo, Twitter Followers: 60000, Bio: #BusinessIntelligence, #NetSuite #ILOVEBEER']
      },
      {
        'label': 'unknowntype',
        'description': 'Account does not have relevant Full Name or the Bio does not describe themselves as being involved with technology like salesforce, data or analytics',
        'examples': ['Full Name: Tony Montana, Twitter Followers: 66, Bio: MEMENTO MORI: YOU COULD LEAVE LIFE RIGHT NOW LET THAT DETERMINE WHAT YOU DO AND SAY AND THINK https://t.co/4DiOVENXCx']
      }
    ],
    {
      'task_description': 'Return a classification of Account based on the descriptions and examples in the SearchString text.'
    }
  ) AS classification_result
FROM MARKETING.PRESPECTS.TWEETFOLLOWERS 
WHERE country_code IN ('US','CA') 
  AND "segment" = 'salesforceadms' 
LIMIT 20;
