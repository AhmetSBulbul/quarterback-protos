CREATE TABLE country (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	primary key (ID),
	index (name)
);
CREATE TABLE city (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	countryID int,
	primary key (ID),
	constraint `cr_city_country_fk` foreign key(countryID) references country(ID) on delete restrict
);
CREATE TABLE district (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	cityID int,
	primary key (ID),
	constraint `cr_district_city_fk` foreign key (cityID) references city(ID) on delete restrict
);
create table file (
	ID int not null unique auto_increment,
	path varchar(255) not null,
	storageType varchar(50) not null default "local",
	type varchar(50) not null,
	primary key (ID)
);
create table user (
	ID int not null unique auto_increment,
	email varchar(255) not null unique,
	password varchar(255) not null,
	districtID int,
	name varchar(50),
	lastName varchar(50),
	username varchar(50) not null unique,
	avatarID int,
	primary key (ID),
	constraint `cr_user_avatar_fk` foreign key (avatarID) references file(ID) on delete
	set null,
		index (email, username)
);
create table court (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	districtID int,
	coordinate point not null,
	address varchar(255),
	primary key (ID),
	constraint `cr_court_district_fk` foreign key (districtID) references district(ID) on delete restrict,
	spatial index (coordinate)
);
create table court_file (
	courtID int,
	fileID int,
	constraint `cr_court_file_court_fk` foreign key (courtID) references court(ID) on delete cascade,
	constraint `cr_court_file_file_fk` foreign key (fileID) references file(ID) on delete cascade
);
create table team (
	ID int not null unique auto_increment,
	name varchar(50) not null unique,
	description text,
	districtID int,
	avatarID int,
	primary key (ID),
	constraint `cr_team_avatar_fk` foreign key (avatarID) references file(ID) on delete
	set null,
		constraint `cr_team_district_fk` foreign key (districtID) references district(ID) on delete restrict
);
create table team_player (
	teamID int not null,
	playerID int not null,
	isAdmin bool default 0,
	constraint `cr_team_player_team_fk` foreign key (teamID) references team(id) on delete cascade,
	constraint `cr_team_player_player_fk` foreign key (playerID) references user(id) on delete cascade
);
create table badge (
	ID int not null unique auto_increment,
	name varchar(50) not null,
	description varchar(255),
	assetID int,
	primary key (ID),
	constraint `cr_badge_asset_fk` foreign key (assetID) references file(id) on delete restrict
);
create table team_badge (
	teamID int not null,
	badgeID int not null,
	constraint `cr_team_badge_team_fk` foreign key (teamID) references team(id) on delete cascade,
	constraint `cr_team_badge_badge_fk` foreign key (badgeID) references badge(id) on delete restrict
);
create table game (
	ID int not null unique auto_increment,
	courtID int not null,
	startedAt datetime,
	endedAt datetime,
	homeScore int,
	awayScore int,
	homeTeamId int,
	awayTeamId int,
	primary key (ID),
	constraint `cr_game_court_fk` foreign key (courtID) references court(ID) on delete restrict,
	constraint `cr_game_home_fk` foreign key (homeTeamId) references team(ID) on delete restrict,
	constraint `cr_game_away_fk` foreign key (awayTeamId) references team(ID) on delete restrict
);
create table game_player (
	gameID int not null,
	playerID int not null,
	isHomeSide bool default 0,
	isCancelled bool default 0,
	constraint `cr_game_player_game_fk` foreign key (gameID) references game(ID) on delete cascade,
	constraint `cr_game_player_player_fk` foreign key (playerID) references user(ID) on delete cascade
);
create table game_file (
	gameID int,
	fileID int,
	constraint `cr_game_file_game_fk` foreign key (gameID) references game(ID) on delete cascade,
	constraint `cr_game_file_file_fk` foreign key (fileID) references file(ID) on delete cascade
);
create table comment (
	ID int not null unique auto_increment,
	senderID int,
	receiverID int,
	content text,
	isHidden bool default 0,
	primary key (ID),
	constraint `cr_comment_sender_fk` foreign key (senderID) references user(ID) on delete cascade,
	constraint `cr_comment_receiver_fk` foreign key (receiverID) references user(ID) on delete cascade
);
create table follower (
	followerID int,
	followingID int,
	constraint `cr_follower_follower_fk` foreign key (followerID) references user(ID) on delete cascade,
	constraint `cr_follower_following_fk` foreign key (followingID) references user(ID) on delete cascade
);
create table report (
	ID int not null unique auto_increment,
	reporterID int,
	reportedID int,
	reportType varchar(10),
	content text,
	primary key (ID),
	constraint `cr_report_reporter_fk` foreign key (reporterID) references user(ID) on delete restrict,
	constraint `cr_report_reported_fk` foreign key (reportedID) references user(ID) on delete restrict
);
create table block (
	blockerID int,
	blockedID int,
	constraint `cr_block_blocker_fk` foreign key (blockerID) references user(ID) on delete cascade,
	constraint `cr_block_blocked_fk` foreign key (blockedID) references user(ID) on delete cascade
);