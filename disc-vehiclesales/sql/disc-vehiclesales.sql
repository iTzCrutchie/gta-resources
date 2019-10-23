create table disc_vehiclesales_stored_vehicles
(
    id bigint unsigned auto_increment,
    plate text not null,
    props longtext not null,
    job text not null,
    name text not null,
    state int not null,
    constraint id
        unique (id)
);

alter table disc_vehiclesales_stored_vehicles
    add primary key (id);

