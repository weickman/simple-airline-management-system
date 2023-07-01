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
	locID integer,
    loc_type varchar(5),
    primary key (locID)
) ENGINE=InnoDB;

drop table if exists route;
create table route (
	routeID integer,
    primary key (routeID)
) ENGINE=InnoDB;

drop table if exists airline;
create table airline (
	airlineID integer,
    revenue integer,
    primary key (airlineID)
) ENGINE=InnoDB;

drop table if exists airplane;
create table airplane (
	airlineID integer,
	tail_num integer,
    speed integer,
    seat_capacity integer,
    locationID integer,
    primary key (airlineID, tail_num),
    foreign key (airlineID) references airline(airlineID),
    foreign key (locationID) references  location(locID)
) ENGINE=InnoDB;

drop table if exists prop;
create table prop (
	airlineID integer,
	tail_num integer,
    num_props integer,
    skids boolean,
    primary key (airlineID, tail_num),
    foreign key (airlineID) references airplane(airlineID),
    foreign key (tail_num) references airplane(tail_num)
) ENGINE=InnoDB;

drop table if exists jet;
create table jet (
	airlineID integer,
	tail_num integer,
    num_engines integer,
    primary key (airlineID, tail_num),
    foreign key (airlineID) references airplane(airlineID),
    foreign key (tail_num) references airplane(tail_num)
) ENGINE=InnoDB;

drop table if exists flight;
create table flight (
	flightID integer,
    route integer,
    cost integer,
    airline integer,
    airplane integer,
    progress integer,
    flight_status integer,
    next_time integer,
    primary key (flightID),
    unique key (airline, airplane),
    foreign key (route) references route(routeID),
    foreign key (airline) references airplane(airlineID),
    foreign key (airplane) references airplane(tail_num)
) ENGINE=InnoDB;

drop table if exists routes_contain;
create table routes_contain (
	leg integer,
    route integer,
    sequence_number integer,
    primary key (leg, route, sequence_number)
) ENGINE=InnoDB;

drop table if exists person;
create table person (
	personID integer,
    fname integer,
    lname integer,
    current_location integer,
    primary key (personID),
    foreign key (current_location) references location(locID)
) ENGINE=InnoDB;

drop table if exists pilot;
create table pilot (
	personID integer,
    taxID integer,
    experience integer,
    current_flight integer,
    has_jet_license boolean,
    has_prop_license boolean,
    has_test_license boolean,
    primary key (personID),
    unique key (taxID),
    foreign key (personID) references person(personID)
) ENGINE=InnoDB;

drop table if exists passenger;
create table passenger (
	personID integer,
    miles integer,
    primary key (personID),
    foreign key (personID) references person(personID)
) ENGINE=InnoDB;

drop table if exists vacation;
create table vacation (
	personID integer,
    destination_airport integer,
    stop_number integer,
    primary key (personID, destination_airport, stop_number),
    foreign key (personID) references person(personID)
) ENGINE=InnoDB;

drop table if exists airport;
create table airport (
	airportID integer,
    full_name integer,
    city integer,
    state integer,
    country integer,
    locationID integer,
    primary key (airportID),
    unique key (locationID),
    foreign key (locationID) references location(locID)
) ENGINE=InnoDB;

drop table if exists leg;
create table leg (
	legID integer,
    distance integer,
    start_airport integer,
    end_airport integer,
    primary key (legID),
    foreign key (start_airport) references airport(airportID),
    foreign key (end_airport) references airport(airportID)
) ENGINE=InnoDB;