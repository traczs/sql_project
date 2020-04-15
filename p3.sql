create or replace function p3(acct char, cust char, prov char, balance decimal, climit integer) returns table (acct1 char(5), cust1 char(20), prov1 char(3), balance1 DECIMAL(10,2), climit1 integer)as $$
	begin
		insert into customer values (acct, cust, prov, 0.00, climit);
		return query SELECT *
		FROM customer;
	end;
$$ language plpgsql;
