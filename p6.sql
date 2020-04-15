create or replace function p6() returns void as $$
	declare 
		v1 cursor for select vno, vbalance, vname from vendor;
		vnum char(3);
		bal decimal(10,2);
		newBalance decimal(10,2);
		amt_charged decimal(10,2);
		v_name char(20);
	begin
		open v1;
		loop
			fetch v1 into vnum,bal,v_name;
			exit when not found;
				amt_charged = bal * .04;
				newBalance = bal - amt_charged;
				UPDATE vendor 
				SET vbalance = newBalance
				WHERE vnum = vno;
				raise notice 'Name: %, Fee:$%, New Balance:$%',v_name, amt_charged, newBalance;
		end loop;
		close v1;
	end;
$$ language plpgsql;
