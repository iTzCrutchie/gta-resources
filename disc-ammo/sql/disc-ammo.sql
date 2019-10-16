create table disc_ammo
(
    id bigint unsigned auto_increment,
    owner text not null,
    hash text not null,
    count int default 0 not null,
    constraint id
        unique (id)
);

alter table disc_ammo
    add primary key (id);


INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_pistol', 'Pistol Ammo', -10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_pistol_large', 'Pistol Ammo Large', -10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_rifle', 'Rifle Ammo', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_rifle_large', 'Rifle Ammo Large', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_shotgun', 'Shotgun Shells', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_shotgun_large', 'Shotgun Shells Large', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_smg', 'SMG Ammo', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_smg_large', 'SMG Ammo Large', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_snp', 'Sinper Ammo', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES ('disc_ammo_snp_large', 'Sinper Ammo Large', 10, 0, 1);
