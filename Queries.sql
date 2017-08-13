use lead_gen_business;
-- 1. What query would you run to get the total revenue for March of 2012?
SELECT SUM(amount) 
FROM billing 
WHERE charged_datetime LIKE '2012-03%'
;

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
SELECT SUM(amount) 
FROM billing 
WHERE client_id = 2
; 

-- 3. What query would you run to get all the sites that client=10 owns?
SELECT domain_name
FROM sites
WHERE client_id =10
; 

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1? What about for client=20?
SELECT client_id, count(site_id) ,
CONCAT( LEFT(created_datetime, 4 ), '-', SUBSTRING(created_datetime, 6,2) ) as yearmonth
FROM sites 
WHERE client_id in (1,10)
GROUP BY yearmonth
ORDER BY client_id, yearmonth
; 

-- 5. What query would you run to get the total # of leads generated for each of the sites between January 1, 2011 to February 15, 2011?
SELECT COUNT(leads_id)
FROM leads 
LEFT JOIN sites ON leads.site_id = sites.site_id
WHERE registered_datetime >= '2011-01-01' AND registered_datetime < '2011-02-16'
; 

-- 6. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients between January 1, 2011 to December 31, 2011?
SELECT CONCAT (clients.last_name, ', ', clients.first_name) AS 'Client Name'
    , IFNULL((leads_id), 0) as LeadsForClient
-- SELECT * 
FROM leads 
LEFT JOIN sites ON leads.site_id = sites.site_id
LEFT JOIN clients ON sites.client_id = clients.client_id
WHERE registered_datetime >= '2011-01-01' AND registered_datetime < '2012-01-01'
GROUP BY clients.client_id
ORDER BY clients.last_name, clients.first_name
; 

-- 7. What query would you run to get a list of client names and the total # of leads we've generated for each client each month between months 1 - 6 of Year 2011?
SELECT 
	CONCAT (clients.last_name, ', ', clients.first_name) AS 'Client Name'
    , IFNULL((leads_id), 0) as LeadsForClient
    , CONCAT( LEFT(created_datetime, 4 ), '-', SUBSTRING(created_datetime, 6,2) ) as yearmonth
FROM leads 
RIGHT JOIN sites ON leads.site_id = sites.site_id
RIGHT JOIN clients ON sites.client_id = clients.client_id
WHERE registered_datetime >= '2011-01-01' AND registered_datetime < '2011-07-01'
GROUP BY clients.client_id, yearmonth
ORDER BY clients.last_name, clients.first_name
; 

-- 8. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients' sites between January 1, 2011 to December 31, 2011? 
-- Order this query by client id.  
SELECT 
	CONCAT (clients.last_name, ', ', clients.first_name) AS 'Client Name'
    , IFNULL((leads_id), 0) as LeadsForClient
FROM leads 
RIGHT JOIN sites ON leads.site_id = sites.site_id
RIGHT JOIN clients ON sites.client_id = clients.client_id
WHERE registered_datetime >= '2011-01-01' AND registered_datetime < '2012-01-01'
GROUP BY clients.client_id
ORDER BY clients.last_name, clients.first_name;
;

-- Come up with a second query that shows all the clients, the site name(s), and the total number of leads generated from each site for all time.
SELECT 
	CONCAT (clients.last_name, ', ', clients.first_name) AS 'Client Name'
    , sites.domain_name
    , IFNULL((leads_id), 0) as LeadsForClient
FROM leads 
RIGHT JOIN sites ON leads.site_id = sites.site_id
RIGHT JOIN clients ON sites.client_id = clients.client_id
GROUP BY clients.client_id, sites.domain_name
ORDER BY clients.last_name, clients.first_name, sites.domain_name
;
 
-- 9. Write a single query that retrieves total revenue collected from each client for each month of the year. Order it by client id.
SELECT 
	CONCAT (clients.last_name, ', ', clients.first_name) AS 'Client Name'
    , sites.domain_name
    , CONCAT( LEFT(created_datetime, 4 ), '-', SUBSTRING(created_datetime, 6,2) ) as yearmonth
    , SUM(billing.amount)
-- SELECT * 
FROM billing
RIGHT JOIN clients ON billing.client_id = clients.client_id
LEFT JOIN sites ON  sites.client_id = clients.client_id
GROUP BY sites.site_id, yearmonth
ORDER BY clients.last_name, clients.first_name, sites.domain_name, yearmonth
; 
-- 10. Write a single query that retrieves all the sites that each client owns. 
-- Group the results so that each row shows a new client. 
-- It will become clearer when you add a new field called 'sites' that has all the sites that the client owns. (HINT: use GROUP_CONCAT)
SELECT 
  CONCAT (clients.last_name, ', ', clients.first_name) AS 'Client Name', 
  GROUP_CONCAT(sites.domain_name)
FROM sites
LEFT JOIN clients on clients.client_id = sites.client_id
GROUP BY clients.client_id
ORDER BY clients.last_name, clients.first_name
;








