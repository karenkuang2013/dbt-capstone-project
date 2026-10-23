-- tests/assert_comment_bodies_not_blank.sql
-- Fails if any comment body contains only whitespace or is empty
{{ config(severity="warn") }}

select 
    comment_id,
    comment_body
from {{ ref('silver_airport_comments') }}
where comment_body is not null 
  and trim(comment_body) = ''