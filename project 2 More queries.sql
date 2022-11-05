-- select all the data from table

select * from nashvillehousing;

select * from nashvillehousing
where landuse = 'single family';

-- Which properties sold are for single families find the uniqueid,propertyaddress,saledate and ownername

Select uniqueid, propertyaddress, saledate, ownername
from nashvillehousing 
where landuse = 'single family'
	order by uniqueid;
	
-- Create New Tables

	-- create a property sale table
	
Create table sales AS
select uniqueid, landuse, propertyaddress, Saledate, saleprice
from nashvillehousing;
	
	-- NEW OWNERS table
	
	Create table Owner AS
select uniqueid, Ownername, OwnerAddress
from nashvillehousing;

Select * from owner;

ALTER TABLE nashvillehousing
ADD primary key(uniqueid);


ALTER TABLE sales
ADD FOREIGN KEY(uniqueid)
REFERENCES nashvillehousing(uniqueid)
ON DELETE SET NULL;

ALTER TABLE owner
ADD FOREIGN KEY(uniqueid)
REFERENCES nashvillehousing(uniqueid)
ON DELETE SET NULL;


UPDATE nashvillehousing SET propertyaddress = 0 WHERE propertyaddress IS NULL;

-- Find the property address, sale price ,sale date for propertie with owner name SKAGGS, BROCK A. & DENISE.

Select s.PropertyAddress, s.UniqueID, o.ownername, o.owneraddress, s.saleprice, s.saledate
from sales as S
join owner o
		on s.uniqueid = o.uniqueid
where o.ownername = "SKAGGS, BROCK A. & DENISE"
order by uniqueid;

-- General queries

select ownername from nashvillehousing
where propertyaddress =0;

select uniqueid, ownername, landuse, propertyaddress,saleprice, owneraddress  from nashvillehousing
where saleprice between 300000 and 750000 and ownername<> ''
order by landuse ASC;








