with airports as (
    select 
       airport_ident,
       airport_type,
       airport_name,
       airport_lat,
       airport_long,
       continent,
       iso_country,
       iso_region
    from {{ref('src_airports')}}
)
select * from airports