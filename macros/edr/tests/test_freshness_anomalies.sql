-- TODO: Anomaly direction should be here?
-- TODO: Move exception if there is no timestamp to here

{% test freshness_anomalies(model, timestamp_column, where_expression, anomaly_sensitivity, anomaly_direction, min_training_set_size, time_bucket, days_back, backfill_days) %}
  {{ elementary.test_table_anomalies(
      model=model,
      table_anomalies=["freshness"],
      freshness_column=none,
      timestamp_column=timestamp_column,
      where_expression=where_expression,
      anomaly_sensitivity=anomaly_sensitivity,
      min_training_set_size=min_training_set_size,
      time_bucket=time_bucket,
      days_back=days_back,
      backfill_days=backfill_days
    )
  }}
{% endtest %}
