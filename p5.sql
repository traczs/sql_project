create or replace function p5() returns table(v_number char(3),v_name char(20),v_balance decimal(10,2)) as $$
	declare
		v1 cursor for select vno from vendor;
		v2 cursor for select vno, amount from transaction;
		final_amt decimal(10,2);
		vend1 char(5);
		vend2 char(5);
		amt decimal(10,2);
		
	begin
		open v1;
		loop
			final_amt = 0;
			fetch v1 into vend1;
			exit when not found;
			open v2;
			loop
				fetch v2 into vend2, amt;
				exit when not found;
				if(vend1 = vend2) then
					final_amt = amt + final_amt;
				end if;
			end loop;
			close v2;
			
			UPDATE vendor
			SET vbalance = vbalance + final_amt
			WHERE vno = vend1; 
		end loop;
		close v1;
		
		return query SELECT vno, vname, vbalance
			FROM vendor;
	end;
$$ language plpgsql;
