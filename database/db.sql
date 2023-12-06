CREATE DATABASE quarterback;
USE quarterback;
CREATE TABLE country (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	PRIMARY KEY (ID)
) CREATE TABLE city (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	countryID int,
	PRIMARY KEY (ID),
	constraint `cr_city_country_fk` FOREIGN KEY (countryID) REFERENCES country(ID) ON DELETE restrict
) CREATE TABLE district (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	cityID int,
	PRIMARY KEY (ID),
	constraint `cr_district_city_fk` FOREIGN KEY (cityID) REFERENCES city(ID) ON DELETE restrict
) CREATE TABLE file (
	ID int not null unique auto_increment,
	path varchar(255) not null,
	storageType varchar(50) not null default "local",
	type varchar(50) not null,
	PRIMARY KEY (ID)
) CREATE TABLE user (
	ID int not null unique auto_increment,
	email varchar(255) not null unique,
	password varchar(255) not null,
	districtID int,
	name varchar(50),
	lastName varchar(50),
	username varchar(50) not null unique,
	avatarID int,
	PRIMARY KEY (ID),
	constraint `cr_user_avatar_fk` FOREIGN KEY (avatarID) REFERENCES file(ID) ON DELETE
	set null,
		index (email, username)
) CREATE TABLE court (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	districtID int,
	coordinate point not null,
	address varchar(255),
	PRIMARY KEY (ID),
	constraint `cr_court_district_fk` FOREIGN KEY (districtID) REFERENCES district(ID) ON DELETE restrict spatial index `spatial` (`coordinate`)
) CREATE TABLE court_file (
	courtID int,
	fileID int,
	constraint `cr_court_file_court_fk` FOREIGN KEY (courtID) REFERENCES court(ID) ON DELETE cascade,
	constraint `cr_court_file_file_fk` FOREIGN KEY (fileID) REFERENCES file(ID) ON DELETE cascade
) CREATE TABLE team (
	ID int not null unique auto_increment,
	name varchar(50) not null unique,
	description text,
	districtID int,
	avatarID int,
	PRIMARY KEY (ID),
	constraint `cr_team_avatar_fk` FOREIGN KEY (avatarID) REFERENCES file(ID) ON DELETE
	set null,
		constraint `cr_team_district_fk` FOREIGN KEY (districtID) REFERENCES district(ID) ON DELETE restrict
) CREATE TABLE team_player (
	teamID int not null,
	playerID int not null,
	isAdmin bool default 0,
	constraint `cr_team_player_team_fk` FOREIGN KEY (teamID) REFERENCES team(id) ON DELETE cascade,
	constraint `cr_team_player_player_fk` FOREIGN KEY (playerID) REFERENCES user(id) ON DELETE cascade
) CREATE TABLE badge (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	description varchar(255),
	assetID int,
	PRIMARY KEY (ID),
	constraint `cr_badge_asset_fk` FOREIGN KEY (assetID) REFERENCES file(id) ON DELETE restrict
) CREATE TABLE team_badge (
	teamID int not null,
	badgeID int not null,
	constraint `cr_team_badge_team_fk` FOREIGN KEY (teamID) REFERENCES team(id) ON DELETE cascade,
	constraint `cr_team_badge_badge_fk` FOREIGN KEY (badgeID) REFERENCES badge(id) ON DELETE restrict,
) CREATE TABLE game (
	ID int not null unique auto_increment,
	courtID int not null,
	startedAt datetime,
	endedAt datetime,
	homeScore int,
	awayScore int,
	homeTeamId int,
	awayTeamId int,
	PRIMARY KEY (ID),
	constraint `cr_game_court_fk` FOREIGN KEY (courtID) REFERENCES court(ID) ON DELETE restrict,
	constraint `cr_game_home_fk` FOREIGN KEY (homeTeamId) REFERENCES team(ID) ON DELETE restrict,
	constraint `cr_game_away_fk` FOREIGN KEY (awayTeamId) REFERENCES team(ID) ON DELETE restrict
) CREATE TABLE game_player (
	gameID int not null,
	playerID int not null,
	isHomeSide bool default 0,
	isCancelled bool default 0,
	constraint `cr_game_player_game_fk` FOREIGN KEY (gameID) REFERENCES game(ID) ON DELETE cascade,
	constraint `cr_game_player_player_fk` FOREIGN KEY (playerID) REFERENCES user(ID) ON DELETE cascade
) CREATE TABLE game_file (
	gameID int,
	fileID int,
	constraint `cr_game_file_game_fk` FOREIGN KEY (gameID) REFERENCES game(ID) ON DELETE cascade,
	constraint `cr_game_file_file_fk` FOREIGN KEY (fileID) REFERENCES file(ID) ON DELETE cascade
) CREATE TABLE comment (
	ID int not null unique auto_increment,
	senderID int,
	receiverID int,
	content text,
	isHidden bool default 0,
	PRIMARY KEY (ID),
	constraint `cr_comment_sender_fk` FOREIGN KEY (senderID) REFERENCES user(ID) ON DELETE cascade,
	constraint `cr_comment_receiver_fk` FOREIGN KEY (receiverID) REFERENCES user(ID) ON DELETE cascade
) CREATE TABLE follower (
	followerID int,
	followingID int,
	constraint `cr_follower_follower_fk` FOREIGN KEY (followerID) REFERENCES user(ID) ON DELETE cascade,
	constraint `cr_follower_following_fk` FOREIGN KEY (followingID) REFERENCES user(ID) ON DELETE cascade
) CREATE TABLE report (
	ID int not null unique auto_increment,
	reporterID int,
	reportedID int,
	reportType varchar(10),
	content text,
	PRIMARY KEY (ID),
	constraint `cr_report_reporter_fk` FOREIGN KEY (reporterID) REFERENCES user(ID) ON DELETE restrict,
	constraint `cr_report_reported_fk` FOREIGN KEY (reportedID) REFERENCES user(ID) ON DELETE restrict
) CREATE TABLE block (
	blockerID int,
	blockedID int,
	constraint `cr_block_blocker_fk` FOREIGN KEY (blockerID) REFERENCES user(ID) ON DELETE cascade,
	constraint `cr_block_blocked_fk` FOREIGN KEY (blockedID) REFERENCES user(ID) ON DELETE cascade
)
/*  
 create view user_points as ... 
 create view team_points as ...
 */