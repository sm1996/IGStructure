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

