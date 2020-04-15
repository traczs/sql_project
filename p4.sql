create or replace function p4() returns void as $$
	declare 
		c1 cursor for select account, cname from customer;
		c2 cursor for select account, t_date from vendor natural join transaction;
		acct char(5);
		cust_name char(10);
		maxDate date;
		r_amt decimal(10,2);
		r_vname char(10);
		date1 date;
		acct2 char(5);

	begin
		maxDate = '0001-01-01';
		open c1;
		loop
			fetch c1 into acct, cust_name;
			exit when not found;
			open c2;
			loop
				fetch c2 into acct2, date1;
				exit when not found;
				if(date1 > maxDate and acct=acct2) then
					maxDate = date1;
				end if;
			end loop;
			close c2;
			
			if(maxDate = '0001-01-01') then
				raise notice '%  %  no transaction', acct, cust_name;
			else 
				SELECT amount, Vname into r_amt,r_vname
				FROM  vendor natural join transaction
				WHERE maxDate = t_date and account=acct;
				
				raise notice'% % $%   %', acct, cust_name, r_amt,r_vname;
			end if;
			maxDate = '0001-01-01';
		end loop;
		close c1;
	end;
$$ language plpgsql;
