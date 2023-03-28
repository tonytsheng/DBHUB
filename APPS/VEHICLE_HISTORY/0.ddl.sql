create database tyler;
use tyler;
create table make (make_id int not null auto_increment, make_name char(30), model_name char(30), primary key (make_id));
create table color (color_id int not null auto_increment, color_name char(30), primary key (color_id));
create table status (status_id int not null auto_increment, status_name char(30), primary key (status_id));
create table purchase (purchase_id int not null auto_increment
	, year char(4)
	, make_name char(30)
	, model_name char(30)
        , color_name char(30)	
        , status char(30)	
	, purchase_date date
	, primary key (purchase_id));
