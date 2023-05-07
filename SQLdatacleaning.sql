--Cleaning data in SQL
 select *
 From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$

 --Standardize date format
 Select SaleDate, CONVERT(Date, SaleDate) 
  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$

  Update BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
SET SaleDate = CONVERT(Date, SaleDate)

Alter Table BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$  
Add SaleDateconverted Date;

  Update BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
SET SaleDate = CONVERT(Date, SaleDate)

--after updataion
	Select SaleDateconverted,CONVERT(Date,SaleDateconverted)
	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$


	  --Populate Property address data

	 Select *
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
--Where Propertyaddress is null 
order by ParcelID 



	 Select *
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$ a
		  join BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$ b
		  on a.ParcelID=b.ParcelID
		  and a.[F1]<>b.[F1]


		   Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$ a
		  join BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$ b
		  on a.ParcelID=b.ParcelID
		  and a.[F1]<>b.[F1]
		  where a.PropertyAddress is null
		  
		  Update a 
		  SET PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
		  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$ a
		  join BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$ b
		  on a.ParcelID=b.ParcelID
		  and a.[F1]<>b.[F1]

		  --Breaking out address into separate columns

		  
	 Select PropertyAddress
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
--Where Propertyaddress is null 
--order by ParcelID  
Select
SUBSTRING(PropertyAddress ,1,CHARINDEX(' ',PropertyAddress)-1) as Address,
Substring (PropertyAddress, CHARINDEX(' ',PropertyAddress) +1, len (PropertyAddress)) as Address
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$

		  Alter Table BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$  
Add Propertysplitaddr varchar(255);

  Update BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
SET Propertysplitaddr = SUBSTRING(PropertyAddress ,1,CHARINDEX(' ',PropertyAddress)-1)

		  Alter Table BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$  
Add Propertysplitcity varchar(255);

  Update BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
SET Propertysplitcity = Substring (PropertyAddress, CHARINDEX(' ',PropertyAddress) +1, len (PropertyAddress))

Select *
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$

Select
PARSENAME(Replace (PropertyAddress,' ','.'),3),
PARSENAME(Replace (PropertyAddress,' ','.'),2),
PARSENAME(Replace (PropertyAddress,' ','.'),1)
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$

		  --Change Y AND  N to Yes and no in Sold as vacant 

		  Select Distinct(SoldAsVacant) , COUNT(SoldAsVacant) as total
		  	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
				  Group by SoldAsVacant
				  Order by SoldAsVacant --Total counts of yes and no

Select SoldAsVacant ,
 Case
 when SoldAsVacant = 'Yes' then 'Y'
 when SoldAsVacant = 'No' then 'N'
 Else SoldAsVacant
 End
  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$

  Update BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
  Set SoldAsVacant = Case
 when SoldAsVacant = 'Yes' then 'Y'
 when SoldAsVacant = 'No' then 'N'
 Else SoldAsVacant
 End

   --Remove duplicates
   With RownumCTE As(
 Select *,
 ROW_NUMBER() over(
 Partition by parcelID ,PropertyAddress,SalePrice,SaleDate,LegalReference
 Order by
 F1
 ) row_num
   From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
  -- order by ParcelID
   ) --deleted
   Select * 
   From RownumCTE
   where row_num > 1
   --Order by PropertyAddress

   --Delete unused columns

   Select *
	 	  From BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
Alter table BalaProtfolioproject.dbo.Nashville_housing_data_housing_data_2013_201$
Drop column PropertyAddress

  
  		  

