{{
  config(
    materialized = 'incremental',
    unique_key = 'elementary_test_results_id',
    on_schema_change = 'append_new_columns',
    full_refresh=elementary.get_config_var('elementary_full_refresh'),
    post_hook='{{ init_created_at() }}{{ elementary.backfill_result_rows() }}',
    meta={"timestamp_column": "detected_at"},
  )
}}

-- depends_on: {{ ref('elementary_test_results') }}
{{ elementary.empty_table([
    ('elementary_test_results_id', 'long_string'),
    ('result_row', 'long_string'),
    ('detected_at','timestamp'),
]) }}
