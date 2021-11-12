# query where _doc contains a json doc
# converted using DMS
# and mongo as a source
# and postgresql as a target

# note to get the single row from _id, using a like and not an equal to the literal
# because the literal did not work

# pull back the _doc column as well and scroll through all the blank spaces

select _id, _doc from sample_airbnb."listingsAndReviews" where _id like '{ \"_id\" : \"10006546\" }%';
