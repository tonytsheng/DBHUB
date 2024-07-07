https://docs.aws.amazon.com/redshift/latest/dg/t_Roles.html

https://docs.aws.amazon.com/redshift/latest/dg/t_ddm.html

https://docs.aws.amazon.com/redshift/latest/dg/t_ddm.html#ddm-example

1. create table
2. create users
3. create roles
4. grant role to users
5. create masking policy 
  - example: redact credit card numbers
6. attach masking policy on table to role
ATTACH MASKING POLICY mask_credit_card_partial
ON credit_cards(credit_card)
TO ROLE analytics_role
PRIORITY 10;


