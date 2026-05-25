import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent
TERRAFORM_DIR = ROOT_DIR / "infra/environments/local"


def run(command, cwd=None):
    print(f"\nExecutando: {command}\n")

    process = subprocess.run(
        command,
        cwd=cwd,
        shell=True
    )

    if process.returncode != 0:
        print(f"\nErro ao executar: {command}")
        sys.exit(process.returncode)


def main():
    print("\n===================================")
    print("SUBINDO LOCALSTACK")
    print("===================================\n")

    run("docker compose up -d", cwd=ROOT_DIR)

    print("\nAguardando LocalStack iniciar...\n")

    run("sleep 10")

    print("\n===================================")
    print("TERRAFORM INIT")
    print("===================================\n")

    run("terraform init", cwd=TERRAFORM_DIR)

    print("\n===================================")
    print("TERRAFORM PLAN")
    print("===================================\n")

    run("terraform plan", cwd=TERRAFORM_DIR)

    print("\n===================================")
    print("TERRAFORM APPLY")
    print("===================================\n")

    run("terraform apply -auto-approve", cwd=TERRAFORM_DIR)

    print("\n===================================")
    print("INFRAESTRUTURA CRIADA")
    print("===================================\n")


if __name__ == "__main__":
    main()