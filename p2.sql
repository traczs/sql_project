create or replace function p2(VendName char) returns table (acct char(5), cust char(20), prov char(3))as $$
	begin
		return query SELECT Account, Cname, Province
		FROM vendor NATURAL JOIN transaction NATURAL JOIN customer
		WHERE Vname = VendName;
	end;
$$ language plpgsql;
