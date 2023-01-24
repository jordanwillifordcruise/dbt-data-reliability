import json
from pathlib import Path

import pytest
from dbt.version import __version__
from packaging import version

from elementary.clients.dbt.dbt_runner import DbtRunner

dbt_version = version.parse(__version__)
INTEG_TESTS_DIR = str(Path(__file__).parent.parent)


def test_artifacts_on_run_end(dbt_target: str):
    dbt_runner = DbtRunner(
        project_dir=INTEG_TESTS_DIR,
        target=dbt_target,
    )
    dbt_runner.run("one")
    first_generated_at = get_generated_at(dbt_runner)
    dbt_runner.run("one", vars={"one_owner": "ele"})
    second_generated_at = get_generated_at(dbt_runner)
    assert first_generated_at != second_generated_at


@pytest.mark.skipif(
    dbt_version < version.parse("1.4.0"),
    reason="Cached artifacts are only supported from dbt v1.4.0+.",
)
def test_cache_artifacts(dbt_target: str):
    dbt_runner = DbtRunner(
        project_dir=INTEG_TESTS_DIR,
        target=dbt_target,
    )
    dbt_runner.run("one")
    first_generated_at = get_generated_at(dbt_runner)
    dbt_runner.run("one")
    second_generated_at = get_generated_at(dbt_runner)
    assert first_generated_at == second_generated_at


def get_generated_at(dbt_runner: DbtRunner) -> str:
    return json.loads(
        dbt_runner.run_operation(
            "read_table", macro_args={"table": "dbt_models", "where": "alias = 'one'"}
        )[0]
    )
