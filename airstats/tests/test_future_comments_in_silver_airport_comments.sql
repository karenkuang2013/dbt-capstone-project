-- tests/assert_no_future_comments.sql
-- Fails if any comment timestamp is ahead of the current system time
{{ config(severity="warn") }}

select 
    comment_id,
    comment_timestamp,
    loaded_at
from {{ ref('silver_airport_comments') }}
where comment_timestamp > current_timestamp