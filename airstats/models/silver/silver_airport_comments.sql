{{ config(
    materialized='incremental',
    unique_key='comment_id',
    incremental_strategy='merge'
) }}
with comments as (
    select 
       comment_id,
       airport_ident,
       comment_timestamp,
       case when member_nickname is null then '__UNKNOWN__'
       else member_nickname end as member_nickname,
       comment_subject,
       comment_body,
       current_timestamp as loaded_at
    from {{ref('src_airport_comments')}}
)
select * from comments
where comment_body is not null
 {% if is_incremental() %}
    -- This filter only applies on subsequent runs, pulling records newer than the target max
    and loaded_at >= (SELECT MAX(loaded_at) FROM {{ this }})
{% endif %}