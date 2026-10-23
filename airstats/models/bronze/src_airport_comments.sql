{{ config(materialized='ephemeral') }}
with comments as (
    select 
       id as comment_id,
       airport_ident,
       comment_date as comment_timestamp,
       member_nickname,
       subject as comment_subject,
       body	as comment_body
    from {{source('airstats','raw_airport_comments')}}
)
select * from comments