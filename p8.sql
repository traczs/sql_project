create or replace function p8(trns char, vndr char, acct char, amt decimal) returns void as $$
	declare
		c1 cursor for select account, cname, province, cbalance, crlimit from customer;
		v1 cursor for select vno, vname, city, vbalance from vendor;
		c_a char(5);
		c_b decimal(10,2);
		c_p char(5);
		c_l integer;
		c_n char(20);
		
		v_n char(5);
		v_b decimal(10,2);
		v_name char(20);
		v_c char(20);
		
	begin
		INSERT INTO transaction VALUES
		(trns, vndr, acct, CURRENT_DATE, amt);
		
		open c1;
		loop
			fetch c1 into c_a, c_n, c_p, c_b, c_l;
			exit when not found;
			open v1;
			loop
				fetch v1 into v_n, v_name, v_c, v_b;
				exit when not found;
				if(vndr = v_n and acct = c_a) then
					UPDATE vendor 
					SET vbalance = vbalance + amt
					WHERE vno = v_n;
					
					UPDATE customer
					SET cbalance = cbalance - amt
					WHERE c_a = account;
					
					SELECT account,cname,province,cbalance,crlimit into c_a, c_n, c_p, c_b, c_l
					FROM customer
					where account = acct;
					
					SELECT vno, vname, city, vbalance into v_n, v_name, v_c, v_b
					FROM vendor
					where vno = vndr;
					
					raise notice 'TRANSACTION: % % % % %', trns, vndr, acct, CURRENT_DATE, amt;
					raise notice 'CUSTOMER: % % % % %', c_a, c_n, c_p, c_b, c_l;
					raise notice 'VENDOR: % % % %', v_n, v_name, v_c, v_b;
				end if;
			end loop;
			close v1;
		end loop;
		close c1;
		
	end;
$$ language plpgsql;
