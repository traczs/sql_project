create or replace function p1(CustName char) returns table (venname char(10), tdate date, amnt DECIMAL(10,2))as $$
	begin
		return query SELECT Vname, T_Date, Amount 
		FROM vendor NATURAL JOIN transaction NATURAL JOIN customer
		WHERE Cname = CustName;
	end;
$$ language plpgsql;
