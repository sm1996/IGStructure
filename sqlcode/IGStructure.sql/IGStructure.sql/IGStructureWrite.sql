create database instagram
go

use instagram
go

--checking if objects already exist and creating blank state

if object_id('interaction.dm') is not null
	drop table interaction.dm
go

if object_id('interaction.postview') is not null
	drop table interaction.postview
go

if object_id('interaction.postlike') is not null
	drop table interaction.postlike
go

if object_id('interaction.postcomment') is not null
	drop table interaction.postcomment
go

if object_id('post.hashtag') is not null
	drop table post.hashtag
go

if object_id('post.info') is not null
	drop table post.info
go

if object_id('userinfo.userrelations') is not null
	drop table userinfo.userrelations
go

if object_id('userinfo.userprofile') is not null
	drop table userinfo.userprofile
go

if schema_id('post') is not null
	drop schema post
go

if schema_id('interaction') is not null
	drop schema interaction
go

if schema_id('userinfo') is not null
	drop schema userinfo
go

--creating schemas and tables

create schema userinfo
go

create schema post
go

create schema interaction
go

--user tables

create table userinfo.userprofile
(
handle varchar(30) not null primary key,
email varchar(100) not null,
password varchar (50) not null,
privacy bit not null,
bio varchar(150) null
)
go

create table userinfo.userrelations
(
relationid bigint identity primary key,
subjectuser varchar(30) not null
	constraint fk_suhandle foreign key(subjectuser)
	references userinfo.userprofile(handle),
objectuser varchar(30) not null
	constraint fk_ouhandle foreign key(objectuser)
	references userinfo.userprofile(handle),
follow bit not null,
block bit not null,
)
go

--post tables

/*

Post types:

1.Photo
2.Video
3.Carousel

*/

create table post.info
(
postid bigint identity primary key,
handle varchar(30) not null
	constraint fk_handle foreign key (handle)
	references userinfo.userprofile(handle),
posttype tinyint not null,
timestamp datetime not null,
caption varchar(2200) null,
)
go

create table post.hashtag
(
hashtagid bigint identity primary key,
postid bigint not null
	constraint fk_postid foreign key(postid)
	references post.info(postid),
hashtag varchar(2200) null
)
go

--interaction tables

create table interaction.dm
(
messageid bigint identity primary key,
sender varchar(30) not null
	constraint fk_sender foreign key(sender)
	references userinfo.userprofile(handle),
recipient varchar(30) not null
	constraint fk_recipient foreign key(recipient)
	references userinfo.userprofile(handle),
timestamp datetime not null,
postid bigint null
	constraint fk_dm_postid foreign key(postid)
	references post.info(postid),
messagetext varchar(8000) null
)
go

create table interaction.postview
(
activityid bigint identity primary key,
viewer varchar(30) not null
	constraint fk_viewer foreign key(viewer)
	references userinfo.userprofile(handle),
postid bigint not null
	constraint fk_pv_postid foreign key(postid)
	references post.info(postid),
timestamp datetime not null,
endviewtimestamp datetime not null
)
go

create table interaction.postlike
(
activityid bigint identity primary key,
liker varchar(30) not null
	constraint fk_liker foreign key(liker)
	references userinfo.userprofile(handle),
postid bigint not null
	constraint fk_pl_postid foreign key(postid)
	references post.info(postid),
timestamp datetime not null
)
go

create table interaction.postcomment
(
activityid bigint identity primary key,
commenter varchar(30) not null
	constraint fk_commenter foreign key(commenter)
	references userinfo.userprofile(handle),
postid bigint not null
	constraint fk_pc_postid foreign key(postid)
	references post.info(postid),
timestamp datetime not null
)
go

--adding sample data

--user profiles

insert into userinfo.userprofile
(handle, email, password, privacy, bio)
values
('shamama','smuhit@gmail.com','SM1234',1,null),
('kate','katehudson@gmail.com','KH34',0,'kate'),
('aarronhere','aarronw@googlemail.com','AWS4*',1,null),
('ahodge1995','akaash@yahoomail.com','AJL1234',1,'akaash'),
('ifrah','iwade@yandex.com','89IH974',1,null),
('verity_c','v.cross@gmail.com','VBC30!',1,null),
('karl.aguilar','karl.aguilar@hotmail.com','KA1974',1,null),
('rread','reyaread@gmail.com','Rreadpw%',0,null),
('anja-vincent','a_vincent@gmail.com','AV1994*',0,null),
('cara_123','caraweaver123@googlemail.com','CW45&',0,null)
go

--user relations

insert into userinfo.userrelations
(subjectuser,objectuser,follow,block)
values
('shamama','kate',1,0),
('shamama','ifrah',1,0),
('shamama','cara_123',1,0),
('shamama','rread',0,1),
('shamama','ahodge1995',1,0),
('shamama','anja-vincent',1,0),
('anja-vincent','kate',1,0),
('anja-vincent','karl.aguilar',1,0),
('anja-vincent','rread',1,0),
('anja-vincent','cara_123',0,1),
('ifrah','aarronhere',1,0)
go

--posts

insert into post.info
(handle,posttype,timestamp,caption)
values
('shamama',1,'2017-02-28 21:31:07.111',null),
('kate',3,'2017-03-20 07:07:37.111','Cake'),
('ahodge1995',2,'2017-04-01 06:35:08.111','The shard!!'),
('karl.aguilar',2,'2017-06-30 23:32:16.111',null),
('aarronhere',1,'2017-08-28 10:25:01.111','At the Tate'),
('rread',3,'2017-11-01 16:59:02.111',null),
('anja-vincent',1,'2018-01-05 07:58:18.111','sketch'),
('cara_123',3,'2018-05-17 22:00:32.111',null),
('verity_c',2,'2018-06-02 22:57:39.111',null),
('ifrah',1,'2018-07-29 23:18:42.111',':)'),
('shamama',1,'2018-11-27 05:57:29.111',null),
('cara_123',2,'2019-01-16 13:33:27.111',null),
('anja-vincent',1,'2019-03-24 06:05:41.111','barbados')
