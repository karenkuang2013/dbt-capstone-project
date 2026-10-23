with runways as (
    select 
       runway_id,
       airport_ident,
       runway_length_ft,
       runway_width_ft,
       case when runway_surface is null then '__UNKNOWN__'
       else runway_surface end runway_surface,
       runway_lighted,
       runway_closed
    from {{ref('src_runways')}}
)
select * from runways




