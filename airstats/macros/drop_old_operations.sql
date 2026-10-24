{% macro drop_old_relations(dryrun=True) %}

  {% if execute %}
    {# 1. Get all active models, seeds, and snapshots from your current dbt project graph #}
    {% set current_models = [] %}
    {% for node in graph.nodes.values() | selectattr("resource_type", "in", ["model", "seed", "snapshot"]) %}
      {% do current_models.append(node.name | upper) %}
    {% endfor %}
  {% endif %}

  {# 2. Query Snowflake's Information Schema to find existing relations in your target database/schema #}
  {% set cleanup_query %}
    select
        case when table_type = 'BASE TABLE' then 'TABLE' else table_type end as relation_type,
        table_name
    from {{ target.database }}.information_schema.tables
    where table_schema = '{{ target.schema | upper }}'
      and table_name not in ('{{ current_models | join("', '") }}')
  {% endset %}

  {% set results = run_query(cleanup_query) %}

  {# 3. Loop through orphan objects and drop them #}
  {% if results and results.rows %}
    {% for row in results.rows %}
        {% set drop_statement = "DROP " ~ row[0] ~ " IF EXISTS " ~ target.database ~ "." ~ target.schema ~ "." ~ row[1] ~ ";" %}
        
        {% if dryrun %}
            {{ log("DRY RUN: " ~ drop_statement, info=True) }}
        {% else %}
            {{ log("EXECUTING: " ~ drop_statement, info=True) }}
            {% do run_query(drop_statement) %}
        {% endif %}
    {% endfor %}
  {% else %}
    {{ log("No orphan relations found to drop.", info=True) }}
  {% endif %}

{% endmacro %}
