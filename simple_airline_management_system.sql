-- CS4400: Introduction to Database Systems: Friday, May 26, 2023
-- Simple Airline Management System Course Project Database TEMPLATE (v0)

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'flight_tracking';
drop database if exists flight_tracking;
create database if not exists flight_tracking;
use flight_tracking;

-- TEAM 1: ADAM, NIKOS, WILL, ROHAN, KRISHNAV

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

/* CHANGES MADE HERE THAT WE SHOULD CHANGE IN THE DOC:
- Since there are only three types of piloting licenses, made three booleans in the pilot table instead of having a licenses table
- Supports table is not needed - added those attributes to flight
- Location doesn't need the airplane/airport id, removing that and adding a boolean either plane or port
*/	

-- loc_type is either "plane" or "port". Could also be an integer?
drop table if exists location;
create table location (
	locID char(8),
    primary key (locID)
) ENGINE=InnoDB;

drop table if exists route;
create table route (
	routeID varchar(20),
    primary key (routeID)
) ENGINE=InnoDB;

drop table if exists airline;
create table airline (
	airlineID varchar(20),
    revenue float not null,
    primary key (airlineID)
) ENGINE=InnoDB;
 
drop table if exists airplane;
create table airplane (
	airlineID varchar(20),
	tail_num char(6),
    speed integer not null,
    seat_capacity integer check (seat_capacity > 0),
    locationID char(8) not null,
    primary key (airlineID, tail_num),
    unique key (tail_num),
    foreign key (airlineID) references airline(airlineID) on delete restrict on update cascade,
    foreign key (locationID) references  location(locID) on delete cascade on update restrict
) ENGINE=InnoDB;

drop table if exists prop;
create table prop (
	airlineID varchar(20),
	tail_num char(6),
    num_props integer check (num_props > 0),
    skids boolean not null,
    primary key (airlineID, tail_num),
    foreign key (airlineID) references airplane(airlineID) on delete restrict on update cascade,
    foreign key (tail_num) references airplane(tail_num) on update restrict on delete cascade
) ENGINE=InnoDB;

drop table if exists jet;
create table jet (
	airlineID varchar(20),
	tail_num char(6),
    num_engines integer check (num_engines > 0),
    primary key (airlineID, tail_num),
    foreign key (airlineID) references airplane(airlineID) on delete restrict on update cascade,
    foreign key (tail_num) references airplane(tail_num) on update restrict on delete cascade
) ENGINE=InnoDB;

drop table if exists flight;
create table flight (
	flightID char(5),
    route varchar(20),
    cost float,
    airline varchar(20),
    airplane char(6),
    progress integer,
    flight_status char(9),
    next_time time,
    primary key (flightID),
    unique key (airline, airplane),
    foreign key (route) references route(routeID) on update restrict on delete restrict,
    foreign key (airline) references airplane(airlineID) on delete restrict on update cascade,
    foreign key (airplane) references airplane(tail_num) on update restrict on delete cascade
) ENGINE=InnoDB;

drop table if exists person;
create table person (
	personID integer,
    fname varchar(100) not null,
    lname varchar(100),
    current_location char(8),
    primary key (personID),
    foreign key (current_location) references location(locID) on delete restrict on update restrict
) ENGINE=InnoDB;

drop table if exists pilot;
create table pilot (
	personID integer,
    taxID char(11),
    experience integer,
    current_flight char(5),
    has_jet_license boolean,
    has_prop_license boolean,
    has_test_license boolean,
    primary key (personID),
    unique key (taxID),
    foreign key (personID) references person(personID) on delete cascade on update cascade,
    foreign key (current_flight) references flight(flightID) on delete set null on update cascade
) ENGINE=InnoDB;

drop table if exists passenger;
create table passenger (
	personID integer,
    miles integer not null,
    funds float check (funds >= 0),
    primary key (personID),
    foreign key (personID) references person(personID) on update restrict on delete cascade
) ENGINE=InnoDB;

drop table if exists airport;
create table airport (
	airportID char(3),
    full_name varchar(100) not null,
    city varchar(50) not null,
    state varchar(50) not null,
    country char(3) not null,
    locationID char(8) not null,
    primary key (airportID),
    unique key (locationID),
    foreign key (locationID) references location(locID) on delete restrict on update restrict
) ENGINE=InnoDB;

drop table if exists leg;
create table leg (
	legID varchar(6),
    distance integer check (distance > 0),
    start_airport char(3) not null,
    end_airport char(3) not null,
    primary key (legID),
    foreign key (start_airport) references airport(airportID) on update restrict on delete restrict,
    foreign key (end_airport) references airport(airportID) on update restrict on delete restrict
) ENGINE=InnoDB;

drop table if exists vacation;
create table vacation (
	personID integer,
    destination_airport char(3),
    stop_number integer check (stop_number > 0),
    primary key (personID, destination_airport, stop_number),
    foreign key (personID) references person(personID) on update restrict on delete cascade,
    foreign key (destination_airport) references airport(airportID) on update restrict on delete restrict
) ENGINE=InnoDB;

drop table if exists routes_contain;
create table routes_contain (
	leg varchar(6),
    route varchar(20),
    sequence_number integer check (sequence_number > 0),
    primary key (leg, route),
    foreign key (leg) references leg(legID) on delete restrict on update restrict,
    foreign key (route) references route(routeID) on delete restrict on update restrict
) ENGINE=InnoDB;
