{% macro insert_dicts_to_table(table_name, dict_list) -%}
    {% set insert_dicts_query %}
        insert into {{ table_name }}
            {% set columns = adapter.get_columns_in_relation(table_name) -%}
            ({%- for column in columns -%}
                {{- column.name -}} {{- "," if not loop.last else "" -}}
            {%- endfor -%}) values
            {% for dict in dict_list -%}
                ({%- for column in columns -%}
                    {%- set column_value = get_dict_value_with_default(dict, column.name, none) -%}
                    {%- if column_value is string -%}
                        '{{column_value}}'
                    {%- elif column_value is number -%}
                        {{-column_value-}}
                    {%- elif column_value is mapping or column_value is sequence -%}
                        '{{- tojson(column_value) -}}'
                    {%- else -%}
                        NULL
                    {%- endif -%}
                    {{- "," if not loop.last else "" -}}
                 {%- endfor -%}) {{- "," if not loop.last else "" -}}
            {%- endfor -%}
    {% endset %}
    {% do run_query(insert_dicts_query) %}
{%- endmacro %}

{% macro get_dict_value_with_default(dict, key, default) -%}
    {%- if key in dict -%}
        {{- return(dict[key]) -}}
    {%- elif key.lower() in dict -%}
        {{- return(dict[key.lower()]) -}}
    {%- else -%}
        {{- return(default) -}}
    {% endif %}
{%- endmacro %}