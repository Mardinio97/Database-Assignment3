drop database if exists blood_donation;

create database blood_donation;

use blood_donation;

ALTER DATABASE blood_donation  CHARACTER SET utf8;

create table if not exists donor /*creating a doner table*/
(
    donor_id    int(100)                not null auto_increment,
    name        varchar(250),
    city        varchar(250),
    email       varchar(250) unique,
    mob_number  varchar(250)            not null,
    blood_group enum ('A','B','AB','O') NOT NULL,

    primary key (donor_id)

);

SELECT * FROM donor;
CREATE INDEX index_name ON donor (mob_number);



create table `donation`
(
    id               int(100) auto_increment,
    donor_id         int(100)                                                        not null,
    donor_mob_number varchar(250)                                                    not null,
    receivedAt       timestamp default now(),
    amount_Liter     INTEGER(20)                                                     not null,

    status           enum ('Processing','sent','Saved','sent and arrived at clinic') NOT NULL,
    foreign key (donor_id) references donor (donor_id),
    primary key (id)

);

ALTER TABLE `donation`
    auto_increment = 1000;

create table bloodGroup
(
    id   int(10) auto_increment not null,
    name varchar(100)           not null,
    primary key (id),
    unique key (name)
);

insert into bloodGroup(name) value ('A');
insert into bloodGroup(name) value ('B');
insert into bloodGroup(name) value ('AB');
insert into bloodGroup(name) value ('O');

create table blood
(
    id            BIGINT(50) auto_increment not null,
    blood_group   varchar(250)              not null,
    quantity      BIGINT(50)                not null,
    blood_type_id int(10)                   not null,

    stock         int(10),
    foreign key (blood_type_id) references bloodGroup (id),

    primary key (id)


);

insert into blood (blood_group, quantity, blood_type_id, stock)
VALUES ('A', 0, 1, 0);
insert into blood (blood_group, quantity, blood_type_id, stock)
VALUES ('B', 0, 2, 0);
insert into blood (blood_group, quantity, blood_type_id, stock)
VALUES ('AB', 0, 3, 0);
insert into blood (blood_group, quantity, blood_type_id, stock)
VALUES ('O', 0, 4, 0);

ALTER TABLE blood
    auto_increment = 100;



create table blood_donation
(

    blood_Bag_Id    BIGINT(10) auto_increment not null,
    donation_number int(100),


    foreign key (donation_number) references `donation` (id) on delete cascade on update cascade,
    primary key (blood_Bag_Id)


) AUTO_INCREMENT = 10;
CREATE INDEX blood_donation ON blood_donation (blood_Bag_Id);

create table transfusion
(

    transfusion_id     BIGINT(10) auto_increment not null,
    receiver_id        BIGINT(10)                not null,
    transfusion_Bag_Id BIGINT(10)                not null,
    blood_donor_id     int(100)                  not null,


    foreign key (transfusion_Bag_Id) references blood_donation (blood_Bag_Id) on delete cascade,
    foreign key (blood_donor_id) references donor (donor_id) on delete cascade,
    primary key (transfusion_id)


) AUTO_INCREMENT = 1;


create table transfusion_log
(
    id             int(10)    not null auto_increment,
    stamp_time     timestamp  not null default now(),
    blood_id       int(100)   not null,
    transfusion_id BIGINT(10) not null,


    foreign key (blood_id) references donor (donor_id) on delete cascade on update cascade,
    foreign key (transfusion_id) references transfusion (transfusion_id) on delete cascade,


    primary key (id)
);

create table blood_log
(
    id         int(10)    not null auto_increment,
    donor_id   int(100)   not null,
    log_Bag_Id BIGINT(10) not null,
    primary key (id),
    foreign key (log_Bag_Id) references blood_donation (blood_Bag_Id) on delete cascade,
    foreign key (donor_id) references donor (donor_id) on delete cascade

);
select * from donation;

drop trigger if exists after_donor_inserted;

DELIMITER //

CREATE TRIGGER after_donor_inserted
    AFTER insert
    ON donor
    FOR EACH ROW
BEGIN
    declare item_count int;
    set item_count = (select quantity from blood where blood.blood_group = NEW.blood_group);

    if (NEW.blood_group = 'A') then
        update blood set quantity = item_count + 1 where id = 1;
    elseif (NEW.blood_group = 'B') then
        update blood set quantity = item_count + 1 where id = 2;
    elseif (NEW.blood_group = 'AB') then
        update blood set quantity = item_count + 1 where id = 3;
    elseif (NEW.blood_group = 'O') then
        update blood set quantity = item_count + 1 where id = 4;
    end if;


END//

DELIMITER ;

drop procedure if exists add_donor;

DELIMITER //

CREATE PROCEDURE add_donor(in first varchar(250), in last varchar(250), in ema varchar(250), in mob varchar(250), in gro varchar(250))
BEGIN


    insert into donor(name, city, email, mob_number, blood_group) VALUES (first,last,ema,mob,gro);
    select last_insert_id() as donorID;



END //

DELIMITER ;
;
call add_donor  (' Liore', 'Gruju', 'sdsaae0@dt.gov', '48040323', 4);


call add_donor  ('Shoshana Lissimore', 'Grugan', 'slsadsaae0@dot.gov', '4844243253', 1);

call add_donor  ('Shoshana Lissimore', 'Grujugan', 'slissimore0@dot.gov', '4822457953', 1);

call add_donor  ('Daria Agg', 'Bunobogu', 'dagag1@clickbank.net', '18014187941', 3);

call add_donor  ('Briant Noriega', 'Colón', 'bnoriega2@behance.net', '7012597457', 2);

call add_donor  ('Lou Tonks', 'Thành Phố Nam Định', 'ltonks3@ftc.gov', '5353916054', 4);

call add_donor  ('Belle Marlen', 'Cibungur', 'bmarlen4@guardian.co.uk', '4833537826', 4);

call add_donor  ('Philippa Lowless', 'Shangqing', 'plowless5@sun.com', '8999147919', 1);

call add_donor  ('Bartholomeus Fishby', 'Enonkoski', 'bfishby6@symantec.com', '8844041293', 2);

call add_donor  ('Tressa Mayell', 'Sinilian First', 'tmayell7@naver.com', '9157917110', 3);

call add_donor  ('Dominica Brim', 'Nicola Town', 'dbrim8@ovh.net', '4497734339', 2);

call add_donor  ('Chiarra Colerick', 'Kuczbork-Osada', 'ccolerick9@constantcontact.com', '4996329729', 1);

call add_donor  ('Raychel Carus', 'Pszczew', 'rcarusa@virginia.edu', '8273420013', 1);

call add_donor  ('Anne-corinne Blown', 'Terjan', 'ablownb@discovery.com', '6786852000', 4);

call add_donor  ('Ninon Charker', 'Cereté', 'ncharkerc@elpais.com', '3626398606', 1);

call add_donor  ('Hulda Oyley', 'Sumuran', 'hoyleyd@cbc.ca', '7572422614', 4);

call add_donor  ('Maggee Sindall', 'Arapongas', 'msindalle@dailymotion.com', '7242754972', 3);

call add_donor  ('Xever Rosenblatt', 'Zbiroh', 'xrosenblattf@army.mil', '4846235495', 4);

call add_donor  ('Ophelie Jindacek', 'Czerniejewo', 'ojindacekg@etsy.com', '3427477686', 1);

call add_donor  ('Noreen Gelsthorpe', 'Selianítika', 'ngelsthorpeh@ft.com', '8656314537', 1);

call add_donor  ('Freddie Cromie', 'Gominhães', 'fcromiei@ehow.com', '3162817908', 4);

call add_donor  ('Netta Melbert', 'Krujë', 'nmelbertj@dmoz.org', '2414250590', 3);

call add_donor  ('Lita Sowersby', 'Nantes', 'lsowersbyk@berkeley.edu', '2826500683', 2);

call add_donor  ('Arthur Asals', 'Zakhim', 'aasalsl@dailymail.co.uk', '4387646552', 4);

call add_donor  ('Joby Cornill', 'Huangban', 'jcornillm@histats.com', '4392157012', 2);

call add_donor  ('Shell Pareman', 'Tarariras', 'sparemann@cbc.ca', '2829385578', 1);

call add_donor  ('Karlen Labrone', 'Chennevières-sur-Marne', 'klabroneo@discovery.com', '8862108675', 1);

call add_donor  ('Hugues Jendrassik', 'Gaigeturi', 'hjendrassikp@usda.gov', '8374856753', 4);

call add_donor  ('Gayler Karus', 'Sacramento', 'gkarusq@flickr.com', '3532856179', 3);

call add_donor  ('Morgan Cowwell', 'Krajan', 'mcowwellr@behance.net', '8603544242', 2);

call add_donor  ('Karlik Balle', 'Jianggu', 'kballes@fc2.com', '9924348214', 1);

call add_donor  ('Gaby Edlin', 'Oemofa', 'gedlint@spotify.com', '3003837171', 1);

call add_donor  ('Eric St Clair', 'Stockholm', 'estu@admin.ch', '1965299738', 4);

call add_donor  ('Kati Dobbyn', 'Hostos', 'kdobbynv@illinois.edu', '3829245946', 3);

call add_donor  ('Sherwin Fearenside', 'Longsheng', 'sfearensidew@digg.com', '9795325091', 1);

call add_donor  ('Gilli Waeland', 'Victoria', 'gwaelandx@marriott.com', '7868888074', 2);

call add_donor  ('Cello Fosher', 'Cayenne', 'cfoshery@mediafire.com', '6152415183', 3);

call add_donor  ('Sallyann Matejovsky', 'Banān', 'smatejovskyz@whitehouse.gov', '8627248968', 3);

call add_donor  ('Jillana Ible', 'Andres Bonifacio', 'jible10@a8.net', '2939148641', 1);

call add_donor  ('Garwood Grindle', 'Barvinkove', 'ggrindle11@homestead.com', '5064532650', 3);

call add_donor  ('Aymer Zannelli', 'Santo Domingo Oeste', 'azannelli12@psu.edu', '8206952640', 2);

call add_donor  ('Clay Mordacai', 'Siheyuan', 'cmordacai13@samsung.com', '2063289754', 1);

call add_donor  ('Tuesday Snipe', 'Mach', 'tsnipe14@ovh.net', '1297972536', 2);

call add_donor  ('Zebulen Collman', 'Bendilmuning', 'zcollman15@china.com.cn', '9261821846', 2);

call add_donor  ('Brietta Pittson', 'Pacaembu', 'bpittson16@tumblr.com', '9471375955', 2);

call add_donor  ('Daisi Trappe', 'Smiltene', 'dtrappe17@fda.gov', '5222853880', 3);

call add_donor  ('Adella Davage', 'Bradenton', 'adavage18@issuu.com', '9412060018', 1);

call add_donor  ('Jennine Botte', 'Wiesbaden', 'jbotte19@ning.com', '3986714479', 1);

call add_donor  ('Lin Lyndon', 'Sindangsari', 'llyndon1a@imdb.com', '7334485219', 3);

call add_donor  ('Carolann Pedrol', 'Usuki', 'cpedrol1b@pinterest.com', '8242813067', 2);

call add_donor  ('Andrei Broadbridge', 'Nihaona', 'abroadbridge1c@amazonaws.com', '2036614889', 3);


drop procedure if exists add_donation;

DELIMITER //

CREATE PROCEDURE add_donation(in donor_mob_number varchar(250), in amount INTEGER(20), in stat int(10))
BEGIN
    DECLARE d_id INTEGER;
    DECLARE bag_id INTEGER;
    select donor_id into d_id from donor where mob_number = donor_mob_number;

    insert into donation (donor_id, donor_mob_number, receivedAt, amount_Liter, status)
    values (d_id, donor_mob_number, now(), amount, stat);

    insert into blood_donation(donation_number) value (last_insert_id());

    insert into blood_log(donor_id, log_Bag_Id)
    VALUES (d_id, (SELECT blood_Bag_Id FROM blood_donation ORDER BY blood_Bag_Id DESC LIMIT 1));


END //

DELIMITER ;


drop procedure if exists check_transfusion;

DELIMITER //

CREATE PROCEDURE check_transfusion(in tran INTEGER(20))
BEGIN


    select donor_id,
           name,
           mob_number,
           blood_group,
           t.transfusion_id,
           t.receiver_id,
           t.transfusion_Bag_Id,
           bd.donation_number
    from donor
             join transfusion t on donor.donor_id = t.blood_donor_id
             join blood_donation bd on t.transfusion_Bag_Id = bd.blood_Bag_Id
             join transfusion t2 on donor.donor_id = t2.blood_donor_id
    where t2.transfusion_id = tran;


END //

DELIMITER ;



drop view if exists total_donations;

CREATE VIEW total_donations
AS
select count(*) count
from donation;



drop procedure if exists add_transfusion;

DELIMITER //

CREATE PROCEDURE add_transfusion(in donationSerialNumber INTEGER(20))
BEGIN
    DECLARE d_id INTEGER;
    DECLARE bag_id INTEGER;
    DECLARE reciver_rand DECIMAL;
    set reciver_rand = (SELECT CAST((SELECT RAND() * (10000 - 1000) + 10000) AS decimal));
    select d.donor_id
    into d_id
    from blood_donation
             join donation d on d.id = blood_donation.donation_number
    where donation_number = donationSerialNumber;

    select blood_Bag_Id
    into bag_id
    from blood_donation
             join donation d on d.id = blood_donation.donation_number
    where donation_number = donationSerialNumber;

    insert into transfusion(receiver_id, transfusion_Bag_Id, blood_donor_id) VALUES (reciver_rand, bag_id, d_id);

    insert into transfusion_log(stamp_time, blood_id, transfusion_id) VALUES (now(), d_id, last_insert_id());

    select reciver_rand;


END //

DELIMITER ;




call add_donation('3427477686', 3, 2); /**/
call add_donation('8862108675', 2, 1);
call add_donation('1965299738', 1, 3);




drop trigger if exists after_transfusion_inserted;

DELIMITER $$

CREATE TRIGGER after_transfusion_inserted
    after insert
    ON transfusion
    FOR EACH ROW

BEGIN
    declare donor_group varchar(50);
    declare item_coun2t int;

    set donor_group = (select blood_group
                       from donor
                                join transfusion t on donor.donor_id = t.blood_donor_id
                       where transfusion_id =
                             (SELECT transfusion_id FROM transfusion ORDER BY transfusion_id DESC LIMIT 1));

    set item_coun2t = (select quantity from blood where blood_group = donor_group);

    if (donor_group = 'A') then
        update blood set quantity = item_coun2t - 1 where id = 1;
    elseif (donor_group = 'B') then
        update blood set quantity = item_coun2t - 1 where id = 2;
    elseif (donor_group = 'AB') then
        update blood set quantity = item_coun2t - 1 where id = 3;
    elseif (donor_group = 'O') then
        update blood set quantity = item_coun2t - 1 where id = 4;
    end if;
END $$
DELIMITER ;

insert into transfusion(receiver_id, transfusion_Bag_Id, blood_donor_id)
VALUES ('564564', 12, 31);




drop procedure if exists check_donations_for_user;

DELIMITER //

CREATE PROCEDURE check_donations_for_user(in donorMobNumber varchar(250))
BEGIN

    select d.name, d.city, d.blood_group, count(*) as number_of_donations
    FROM donation
             join donor d on donation.donor_id = d.donor_id

    where donor_mob_number = donorMobNumber
    GROUP BY d.donor_id;

END //

DELIMITER ;

call check_donations_for_user('3427477686');
call add_transfusion(1002);
call check_transfusion(2);
;
