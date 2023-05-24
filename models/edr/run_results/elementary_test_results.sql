{{
  config(
    materialized = 'incremental',
    unique_key = 'id',
    on_schema_change = 'append_new_columns',
    full_refresh=elementary.get_config_var('elementary_full_refresh'),
    meta={"timestamp_column": "detected_at"},
    post_hook="{{ init_created_at() }}"
  )
}}

{{ elementary.empty_elementary_test_results() }}