SELECT *
FROM [Portfolio Project]..Nashville

----STANDARIZE DATE FORMAT

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM [Portfolio Project]..Nashville

UPDATE [Portfolio Project]..Nashville
SET SaleDate = CONVERT(Date, SaleDate)

Alter Table Nashville
Add SaleDateconverted Date;

UPDATE [Portfolio Project]..Nashville
SET SaleDateconverted = CONVERT(Date, SaleDate)


SELECT SaleDateconverted, CONVERT(Date, SaleDate)
FROM [Portfolio Project]..Nashville

--Populate Property Address Data

SELECT *
FROM [Portfolio Project]..Nashville
--WHERE PropertyAddress is not null
Order By 1,2

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project]..Nashville a
Join [Portfolio Project]..Nashville b
On  a.ParcelID = b.ParcelID
And a.UniqueID <> b.UniqueID 
--WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project]..Nashville a
Join [Portfolio Project]..Nashville b
On  a.ParcelID = b.ParcelID
And a.UniqueID <> b.UniqueID 
WHERE a.PropertyAddress is null

SELECT*
FROM [Portfolio Project]..Nashville	

----Breaking Out Address Into Individual Column (Address, City, State)

SELECT *
FROM [Portfolio Project]..Nashville	

SELECT Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
From [Portfolio Project]..Nashville
Order By 2

Alter Table [Portfolio Project]..Nashville	
Add PropertySplitAddress nvarchar(255);

UPDATE [Portfolio Project]..Nashville
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table [Portfolio Project]..Nashville	
Add PropertyCityAddress nvarchar(255);

UPDATE [Portfolio Project]..Nashville
SET PropertyCityAddress = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) 


SELECT OwnerAddress, Parsename(Replace(OwnerAddress, ',', '.'), 3),
Parsename(Replace(OwnerAddress, ',', '.'), 2) 
FROM [Portfolio Project]..Nashville	

Alter Table [Portfolio Project]..Nashville	
Add OwnerSplitAddress nvarchar(255);

UPDATE [Portfolio Project]..Nashville	
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.'), 3)

Alter Table [Portfolio Project]..Nashville	
Add OwnerCityAddress nvarchar(255);

UPDATE [Portfolio Project]..Nashville	
SET OwnerCityAddress = Parsename(Replace(OwnerAddress, ',', '.'), 2)

SELECT *
From [Portfolio Project]..Nashville

----Changing 'Y' and 'N' Into 'Yes' and 'No' in SoldAsVacant Column
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
     WHEN SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END
FROM [Portfolio Project]..Nashville

UPDATE [Portfolio Project]..Nashville
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
     WHEN SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END


----REMOVE Duplicates
WITH ROWNUMCTE As (
SELECT *,
ROW_NUMBER() OVER(
Partition By ParcelID,
             PropertyAddress,
			 SaleDate,
			 SalePrice,
			 LegalReference
			 Order By 
			 UniqueID) row_num
From [Portfolio Project]..Nashville
)
DELETE 
FROM ROWNUMCTE
WHERE row_num > 1

------DELETE UNUSED COLUMN 

Select *
FROM [Portfolio Project]..Nashville


Alter Table [Portfolio Project]..Nashville
Drop Column SaleDate, PropertyAddress, OwnerAddress, TaxDistrict