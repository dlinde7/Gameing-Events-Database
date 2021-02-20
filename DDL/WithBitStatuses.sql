-- ****************** SqlDBM: MySQL ******************;
-- ***************************************************;



-- ************************************** `access`
CREATE TABLE `access`
(
 `id`                          bigint NOT NULL ,
 `password`                    binary NOT NULL ,
 `securityKey`                 nvarchar(120) NOT NULL ,
 `dateCreated`                 datetime NOT NULL ,
 `userId`                      bigint NOT NULL ,
 `addedBy`                     bigint NOT NULL ,
 `addedByDatetime`             datetime NOT NULL ,
 `lastUpdatedBy`               bigint NOT NULL ,
 `lastUpdatedByDatetime`       datetime NOT NULL ,
 `emailVerifiedStatus`         bit NOT NULL ,           -- 1: Yes, 2: No
 `contactNumberVerifiedStatus` bit NOT NULL ,           -- 1: Yes, 2: No
 `adminPrivilagesStatus`       bit NOT NULL ,           -- 1: Yes, 2: No
 `isActiveStatus`              bit NOT NULL ,           -- 1: Yes, 2: No
 `emailAddress`                nvarchar(120) NOT NULL ,
 `contactNumber`               varchar(40) NOT NULL ,

PRIMARY KEY (`id`),
KEY `fkUserId` (`userId`),
);





-- ************************************** `accountType`
CREATE TABLE `accountType`
(
 `id`                    bigint NOT NULL ,
 `name`                  nvarchar(120) NOT NULL ,
 `description`           nvarchar(4000) NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`)
);



-- ************************************** `addressDetails`
CREATE TABLE `addressDetails`
(
 `id`                    bigint NOT NULL ,
 `addressline`           nvarchar(120) NOT NULL ,
 `cityId`                bigint NULL ,
 `userId`                bigint NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedBYDatetime` datetime NOT NULL ,
 `isActiveStatus`        bit NOT NULL ,           -- 1: Yes, 2: No

PRIMARY KEY (`id`),
KEY `fkCityId` (`cityId`),
CONSTRAINT `FK_CITY_ID_ADDRESSDETAILS` FOREIGN KEY `fkCityId` (`cityId`) REFERENCES `cities` (`id`),
KEY `fkUserId` (`userId`),
CONSTRAINT `FK_USER_ID_ADDRESSDETAILS` FOREIGN KEY `fkUserId` (`userId`) REFERENCES `users` (`id`)
);



-- ************************************** `cities`
CREATE TABLE `cities`
(
 `id`                    bigint NOT NULL ,
 `name`                  nvarchar(120) NOT NULL ,
 `province`              nvarchar(120) NOT NULL ,
 `tmstamp`               datetime NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`)
);



-- ************************************** `eventRegistrations`
CREATE TABLE `eventRegistrations`
(
 `id`                    bigint NOT NULL ,
 `tmstamp`               datetime NOT NULL ,
 `eventId`               bigint NOT NULL ,
 `userTeamId`            bigint NOT NULL ,
 `placement`             int NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,
 `isQualifiedStatus`     bit NOT NULL ,           -- 1: yes, 2: no
 `isVerifiedStatus`      bit NOT NULL ,           -- 1: yes, 2: no

PRIMARY KEY (`id`),
KEY `fkEventId` (`eventId`),
CONSTRAINT `FK_EVENT_ID` FOREIGN KEY `fkEventId` (`eventId`) REFERENCES `events` (`id`),
KEY `fkUserTeamId` (`userTeamId`),
CONSTRAINT `FK_USER_TEAM_ID` FOREIGN KEY `fkUserTeamId` (`userTeamId`) REFERENCES `userTeams` (`id`)
);



-- ************************************** `events`
CREATE TABLE `events`
(
 `id`                    bigint NOT NULL ,
 `name`                  nvarchar(240) NOT NULL ,
 `description`           nvarchar(240) NOT NULL ,
 `startDate`             datetime NOT NULL ,
 `endDate`               datetime NOT NULL ,
 `gameId`                bigint NOT NULL ,
 `teamCount`             int NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,
 `eventStatus`           bit NOT NULL ,           -- 1: active, 2: completed, 3: upcoming, 4: delayed
 `venueID`               bigint NOT NULL ,

PRIMARY KEY (`id`),
KEY `fkGameId` (`gameId`),
CONSTRAINT `FK_GAMER_ID` FOREIGN KEY `fkGameId` (`gameId`) REFERENCES `games` (`id`),
KEY `fkVenueId` (`venueID`),
CONSTRAINT `FK_VENUE_ID` FOREIGN KEY `fkVenueId` (`venueID`) REFERENCES `venues` (`id`)
);



-- ************************************** `games`
CREATE TABLE `games`
(
 `id`                    bigint NOT NULL ,
 `name`                  nvarchar(120) NOT NULL ,
 `description`           nvarchar(4000) NOT NULL ,
 `releasedate`           date NOT NULL ,
 `version`               nvarchar(20) NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`)
);



-- ************************************** `matches`
CREATE TABLE `matches`
(
 `id`                    bigint NOT NULL ,
 `team1Id`               bigint NOT NULL ,
 `team2Id`               bigint NOT NULL ,
 `winnerId`              bigint NULL ,
 `team1Score`            int NULL ,
 `team2Score`            int NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`),
KEY `fkTeam1Id` (`team1Id`),
CONSTRAINT `FK_TEAM_1_ID` FOREIGN KEY `fkTeam1Id` (`team1Id`) REFERENCES `eventRegistrations` (`id`),
KEY `fkTeam2Id` (`team2Id`),
CONSTRAINT `FK_TEAM_2_ID` FOREIGN KEY `fkTeam2Id` (`team2Id`) REFERENCES `eventRegistrations` (`id`),
KEY `fkWinnerId` (`winnerId`),
CONSTRAINT `FK_WINNER_ID` FOREIGN KEY `fkWinnerId` (`winnerId`) REFERENCES `eventRegistrations` (`id`)
);



-- ************************************** `social`
CREATE TABLE `social`
(
 `id`                    bigint NOT NULL ,
 `handle`                nvarchar(120) NOT NULL ,
 `socialNetworkId`       bigint NOT NULL ,
 `link`                  nvarchar(120) NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,
 `userId`                bigint NOT NULL ,

PRIMARY KEY (`id`),
KEY `fkSocialNetworkId` (`socialNetworkId`),
CONSTRAINT `FK_SOCIAL_NETWORK_ID_SOCIAL` FOREIGN KEY `fkSocialNetworkId` (`socialNetworkId`) REFERENCES `socialNetworks` (`id`),
KEY `fkUserId` (`userId`),
CONSTRAINT `FK_USER_ID_SOCIAL` FOREIGN KEY `fkUserId` (`userId`) REFERENCES `users` (`id`)
);



-- ************************************** `socialNetworks`
CREATE TABLE `socialNetworks`
(
 `id`                    bigint NOT NULL ,
 `name`                  nvarchar(120) NOT NULL ,
 `baseUrl`               nvarchar(120) NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`)
);



-- ************************************** `statuses`
CREATE TABLE `statuses`
(
 `id`                    bigint NOT NULL ,
 `name`                  nvarchar(40) NOT NULL ,
 `description`           nvarchar(2000) NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`)
);



-- ************************************** `teamGames`
CREATE TABLE `teamGames`
(
 `id`                    bigint NOT NULL ,
 `gameId`                bigint NOT NULL ,
 `teamId`                bigint NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`),
KEY `fkGameId` (`gameId`),
CONSTRAINT `FK_GAME_ID_TEAMGAMES` FOREIGN KEY `fkGameId` (`gameId`) REFERENCES `games` (`id`),
KEY `fkTeamId` (`teamId`),
CONSTRAINT `FK_TEAM_ID_TEAMGAMES` FOREIGN KEY `fkTeamId` (`teamId`) REFERENCES `teams` (`id`)
);



-- ************************************** `teams`
CREATE TABLE `teams`
(
 `id`                          bigint NOT NULL ,
 `slogan`                      nvarchar(200) NOT NULL ,
 `name`                        nvarchar(120) NOT NULL ,
 `logo`                        binary(4000) NOT NULL ,
 `tmstamp`                     datetime NOT NULL ,
 `addedBy`                     bigint NOT NULL ,
 `addedByDatetime`             datetime NOT NULL ,
 `lastUpdatedBy`               bigint NOT NULL ,
 `lastUpdatedByDatetime`       datetime NOT NULL ,
 `receieveNotificationsStatus` bit NOT NULL ,           -- 1: Yes, 2: No

PRIMARY KEY (`id`)
);



-- ************************************** `users`
CREATE TABLE `users`
(
 `id`                    bigint NOT NULL ,
 `firstName`             nvarchar(120) NOT NULL ,
 `lastName`              nvarchar(120) NOT NULL ,
 `dateOfBirth`           date NOT NULL ,
 `username`              nvarchar(120) NOT NULL ,
 `tmstamp`               datetime NOT NULL ,
 `accountTypeId`         bigint NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDateTime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,

PRIMARY KEY (`id`),
KEY `fkAccountTypeId` (`accountTypeId`),
CONSTRAINT `FK_ACCOUNT_TYPE_ID_USERS` FOREIGN KEY `fkAccountTypeId` (`accountTypeId`) REFERENCES `accountType` (`id`)
);



-- ************************************** `userTeams`
CREATE TABLE `userTeams`
(
 `id`                    bigint NOT NULL ,
 `userId`                bigint NOT NULL ,
 `teamId`                bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NULL ,
 `addedByDateTime`       datetime NULL ,
 `addedBy`               bigint NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `isActive`              bit NOT NULL ,           -- 1: Yes, 2: No
 `editPrivilagesStatus`  bit NOT NULL ,           -- 1: Yes, 2: No
 `teamCaptainStatus`     bit NOT NULL ,           -- 1: Yes, 2: No

PRIMARY KEY (`id`),
KEY `fkUserId` (`userId`),
CONSTRAINT `FK_USER_ID_USERTEAMS` FOREIGN KEY `fkUserId` (`userId`) REFERENCES `users` (`id`),
KEY `fkTeamId` (`teamId`),
CONSTRAINT `FK_TEAM_ID_USERTEAMS` FOREIGN KEY `fkTeamId` (`teamId`) REFERENCES `teams` (`id`)
);



-- ************************************** `venues`
CREATE TABLE `venues`
(
 `id`                    bigint NOT NULL ,
 `name`                  nvarchar(120) NOT NULL ,
 `addresss`              nvarchar(400) NULL ,
 `website`               nvarchar(120) NULL ,
 `cityId`                bigint NOT NULL ,
 `addedBy`               bigint NOT NULL ,
 `addedByDatetime`       datetime NOT NULL ,
 `lastUpdatedBy`         bigint NOT NULL ,
 `lastUpdatedByDatetime` datetime NOT NULL ,
 `isActiveStatus`        bit NOT NULL ,           -- 1: Yes, 2: No

PRIMARY KEY (`id`),
KEY `fkCityId` (`cityId`),
CONSTRAINT `FK_CITY_ID_VENUES` FOREIGN KEY `fkCityId` (`cityId`) REFERENCES `cities` (`id`)
);

