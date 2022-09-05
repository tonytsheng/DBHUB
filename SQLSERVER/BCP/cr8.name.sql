-- nconst (string) - alphanumeric unique identifier of the name/person
-- primaryName (string)– name by which the person is most often credited
-- birthYear – in YYYY format
-- deathYear – in YYYY format if applicable, else '\N'
-- primaryProfession (array of strings)– the top-3 professions of the person
-- knownForTitles (array of tconsts) – titles the person is known for

use fly1
go
create table imdb_name
(
	nconst varchar(100)
	, primary_name varchar(100)
	, birthyear varchar(4)
	, deathyear varchar(4)
)
go

