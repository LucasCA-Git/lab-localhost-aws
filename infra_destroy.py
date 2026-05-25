import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent
TERRAFORM_DIR = ROOT_DIR / "infra/environments/local"


def run(command, cwd=None, ignore_error=False):
    print(f"\nExecutando: {command}\n")

    process = subprocess.run(
        command,
        cwd=cwd,
        shell=True
    )

    if process.returncode != 0 and not ignore_error:
        print(f"\nErro ao executar: {command}")
        sys.exit(process.returncode)


def main():
    print("\n===================================")
    print("DESTRUIÇÃO DE INFRA")
    print("===================================\n")

    confirm = input(
        "Deseja destruir toda infraestrutura Terraform? (yes/no): "
    )

    if confirm.lower() != "yes":
        print("\nOperação cancelada.\n")
        sys.exit(0)

    print("\nRemovendo recursos problemáticos do state...\n")

    run(
        "terraform state rm module.glue.aws_glue_catalog_database.datalake",
        cwd=TERRAFORM_DIR,
        ignore_error=True
    )

    print("\nExecutando Terraform Destroy...\n")

    run(
        "terraform destroy -auto-approve",
        cwd=TERRAFORM_DIR
    )

    docker_confirm = input(
        "\nDeseja remover o LocalStack também? (yes/no): "
    )

    if docker_confirm.lower() == "yes":
        run(
            "docker compose down -v",
            cwd=ROOT_DIR
        )

    print("\n===================================")
    print("INFRAESTRUTURA DESTRUÍDA")
    print("===================================\n")


if __name__ == "__main__":
    main()