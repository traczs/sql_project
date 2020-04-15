create or replace function p7() returns table(customerName char(20), customerBalance decimal(10,2)) as $$
	declare
		c1 cursor for select account, cname, cbalance, crlimit from customer;
		acc char(3);
		cn char(20);
		cb decimal(10,2);
		cl integer;
		fee decimal(10,2);
	begin
		open c1;
		loop
			fee = 0;
			fetch c1 into acc, cn, cb, cl;
			exit when not found;
			if(cb > cl) then
				fee = (cb - cl) * .1;
				UPDATE customer
				SET cbalance = cbalance - fee
				WHERE acc = account;
			end if;
		end loop;
		close c1;
		
		return query SELECT cname, cbalance
			FROM customer;
	end;
$$ language plpgsql;
