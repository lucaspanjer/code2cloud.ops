alter table products add column allows_unconfirmed TINYINT(4) not null default 0;

alter table products add column isactive TINYINT(4) not null default 1;

delete from `milestones` where product_id not in (1, 2, 5, 12, 14, 15, 16, 25, 26);
delete from `components` where product_id not in (1, 2, 5, 12, 14, 15, 16, 25, 26);

delete from DATABASECHANGELOG where ID = 'createSavedTaskQueryTable';
delete from DATABASECHANGELOG where ID = 'createCfTaskTypeTable';
delete from DATABASECHANGELOG where ID = 'allowNullEsitmate-task2769';
delete from DATABASECHANGELOG where ID = 'insertTaskTypes';

insert into fielddefs (name, type, custom, description, sortkey, enter_bug, buglist) values ('cf_tasktype', 2, 1, 'Task', 70, 1, 1);

alter table bugs change  cf_tasktop_sprint cf_iteration VARCHAR(255);

update fielddefs set name = 'cf_iteration' where name = 'cf_tasktop_sprint';

alter table cf_tasktop_sprint rename to cf_iteration;

alter table bugs add column cf_tasktype VARCHAR(20) not null default 'Task';

update bugs set cf_iteration = '---' where cf_iteration is null;