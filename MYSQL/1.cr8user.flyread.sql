drop user flyread;
CREATE USER 'flyread'@'%' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS'; 
grant all on fly1.* to flyread;
