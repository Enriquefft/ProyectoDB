set search_path to proyecto_1m, public;

-- b-tree on expression
--create index delivery_sells_year       on delivery_sells(EXTRACT (YEAR FROM date_time));
--create index local_sells_year          on local_sells(EXTRACT (YEAR FROM date_time));
---- btree
--create index delivary_sells_id         on delivery_sells(id);
--create index local_sells_id            on local_sells(id);
--create index company_delivery_sells_id on company_delivery_sells(sell_id);
--create index company_local_sells_id    on company_local_sells(sell_id);
--create index company_info_ruc          on companies_info(ruc);
--



--drop index delivery_sells_year on delivery_sells(EXTRACT (YEAR FROM date_time));
--drop index local_sells_year on local_sells(EXTRACT (YEAR FROM date_time));
--drop index delivary_sells_id on delivery_sells(id);
--drop index local_sells_id on local_sells(id);
--drop index company_delivery_sells_id on company_delivery_sells(sell_id);
--drop index company_local_sells_id on company_local_sells(sell_id);
--drop index company_info_ruc on companies_info(ruc);


create index delivery_customers_sell_id on delivery_customers(sell_id);
create index delivery_sell_unit_id      on delivery_sell_unit(sell_id);
create index delivery_sells_address     on delivery_sells(address);
