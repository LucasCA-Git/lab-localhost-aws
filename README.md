# Local AWS Platform with LocalStack

Mini plataforma AWS local utilizando LocalStack + Terraform para simular serviços AWS localmente.

---

# Objetivo

Este projeto tem como objetivo criar um ambiente AWS local para:

- desenvolvimento
- testes
- aprendizado
- onboarding de desenvolvedores
- simulação de arquitetura cloud
- pipelines DevOps

Tudo rodando localmente utilizando:

- Docker
- LocalStack
- Terraform

---

# Guia para Desenvolvedores

## O que é o LocalStack?

LocalStack é uma ferramenta que simula os principais serviços da AWS localmente, rodando via Docker. Com ele você desenvolve, testa e valida integrações com AWS sem precisar de conta, sem custo e sem afetar ambientes reais.

Documentação oficial: https://docs.localstack.cloud

---

## Instalação

### Docker (obrigatório)

```bash
# Arch Linux
sudo pacman -S docker docker-compose

# Ubuntu/Debian
sudo apt install docker.io docker-compose
```

### Token LocalStack

Crie sua conta e obtenha o token em:
https://app.localstack.cloud/sign-up

---

## Serviços simulados neste projeto

| Serviço | Suporte |
|---|---|
| S3 | ✅ Completo |
| SQS | ✅ Completo |
| ECS | ✅ Completo |
| ECR | ✅ Completo |
| IAM | ✅ Completo |
| Secrets Manager | ✅ Completo |
| EventBridge | ✅ Completo |
| CloudWatch Logs | ✅ Completo |
| Glue | ⚠️ Parcial |

---

## ECS no LocalStack — Passo a Passo

Documentação oficial: https://docs.localstack.cloud/aws/services/ecs/

> Pré-requisito: instalar o `awslocal`
> ```bash
> pip install awscli-local
> ```

### 1. Criar o cluster

```bash
awslocal ecs create-cluster --cluster-name mycluster
```

### 2. Criar a task definition

Crie um arquivo `task_definition.json`:

```json
{
  "containerDefinitions": [
    {
      "name": "server",
      "image": "ubuntu",
      "cpu": 10,
      "memory": 10,
      "command": ["sh", "-c", "while true; do echo running; sleep 1; done"],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "myloggroup",
          "awslogs-stream-prefix": "myprefix",
          "awslogs-region": "us-east-1"
        }
      }
    }
  ],
  "family": "myfamily"
}
```

Registre a task definition:

```bash
awslocal ecs register-task-definition --cli-input-json file://task_definition.json
```

### 3. Criar o serviço

```bash
awslocal ecs create-service \
  --service-name myservice \
  --cluster mycluster \
  --task-definition myfamily \
  --desired-count 1
```

### 4. Verificar o container rodando

```bash
docker ps
```

Você verá um container criado pelo LocalStack com a imagem definida na task.

### 5. Ver os logs

```bash
awslocal logs filter-log-events \
  --log-group-name myloggroup \
  --query 'events[].message'
```

> **Nota:** Por padrão o LocalStack usa Fargate como launch type, utilizando o Docker Engine local para rodar os containers — sem necessidade de criar instâncias EC2.

---

# Serviços AWS Simulados

| Serviço | Status |
|---|---|
| S3 | ✅ |
| SQS | ✅ |
| ECS | ✅ |
| ECR | ✅ |
| IAM | ✅ |
| Secrets Manager | ✅ |
| EventBridge | ✅ |
| CloudWatch Logs | ✅ |
| Glue | ⚠️ Parcial |
| Athena | ⚠️ Futuro |
| OpenSearch | ❌ Não suportado no LocalStack |
| DocumentDB | ❌ Não suportado no LocalStack |

---

# Arquitetura

```txt
Developer
   ↓
Terraform
   ↓
LocalStack
   ↓
AWS Services Mockados
```

---

# Estrutura do Projeto

```txt
localstack-aws/
├── infra/
│   ├── environments/
│   │   └── local/
│   │       ├── main.tf
│   │       ├── provider.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       └── terraform.tfvars
│   │
│   └── modules/
│       ├── ecs/
│       ├── ecr/
│       ├── s3/
│       ├── sqs/
│       ├── iam/
│       ├── logs/
│       ├── secrets/
│       ├── eventbridge/
│       └── glue/
│
├── docker-compose.yml
├── .env
├── .env.example
├── infra_up.py
├── infra_destroy.py
├── README.md
└── volume/
```

---

# Requisitos

## Instalar Docker

### Linux Arch

```bash
sudo pacman -S docker docker-compose
```

### Ubuntu/Debian

```bash
sudo apt install docker.io docker-compose
```

---

## Instalar Terraform

Site oficial:

https://developer.hashicorp.com/terraform/install

### Linux Arch

```bash
sudo pacman -S terraform
```

### Ubuntu/Debian

```bash
sudo apt install terraform
```

---

## Instalar Python

### Linux Arch

```bash
sudo pacman -S python
```

### Ubuntu/Debian

```bash
sudo apt install python3
```

---

# Configuração

## 1. Clonar projeto

```bash
git clone <repo>
cd localstack-aws
```

---

## 2. Criar arquivo `.env`

Copie:

```bash
cp .env.example .env
```

---

## 3. Adicionar token do LocalStack

Edite:

```bash
nano .env
```

Adicione:

```env
TOKEN_LOCALSTACK=SEU_TOKEN_LOCALSTACK
```

---

# Docker Compose

O ambiente utiliza:

- LocalStack
- Docker socket
- persistência local

---

## Serviços habilitados

```yaml
SERVICES=s3,sqs,ecs,ecr,iam,logs,secretsmanager,events,glue,cloudwatch,sts
```

---

# Como subir a infraestrutura

## Executar script principal

```bash
python infra_up.py
```

---

# O script executa automaticamente

- docker compose up
- terraform init
- terraform plan
- terraform apply

---

# Como destruir infraestrutura

## Executar script destroy

```bash
python infra_destroy.py
```

---

# O script destroy executa

- workaround automático do Glue
- terraform destroy
- remoção opcional do LocalStack

---

# Workaround Glue

O LocalStack possui incompatibilidade parcial com:

```txt
aws_glue_catalog_database
```

Por isso o script executa automaticamente:

```bash
terraform state rm module.glue.aws_glue_catalog_database.datalake
```

antes do destroy.

Isso evita falhas do provider AWS.

---

# Comandos úteis

## Ver buckets S3

```bash
awslocal s3 ls
```

---

## Ver filas SQS

```bash
awslocal sqs list-queues
```

---

## Ver clusters ECS

```bash
awslocal ecs list-clusters
```

---

## Ver repositories ECR

```bash
awslocal ecr describe-repositories
```

---

## Ver secrets

```bash
awslocal secretsmanager list-secrets
```

---

# Instalar awslocal

```bash
pip install awscli-local
```

---

# ECS

Atualmente o ECS utiliza:

- ECS Cluster
- ECS Service
- ECS Task Definition

Inicialmente utilizando:

```txt
nginx:latest
```

como container de teste.

---

# ECR

Repositories criados:

- api-flask
- api-node
- worker

---

# Buckets S3

Buckets criados:

- empresa-data-lake-raw
- empresa-data-lake-silver
- empresa-athena-results

---

# Filas SQS

Fila criada:

- s3-event-notification-queue

---

# EventBridge

Evento criado:

- daily-job

---

# Secrets Manager

Secret criado:

- mongo-uri

---

# CloudWatch Logs

Log Group criado:

```txt
/ecs/empresa
```

---

# Serviços parcialmente suportados

Alguns serviços AWS possuem suporte limitado no LocalStack.

## Glue

Problemas conhecidos:

- incompatibilidade Terraform Provider
- refresh state inconsistente
- catalog ID inválido

Uso recomendado:

- apenas desenvolvimento simples
- evitar produção local complexa

---

# Serviços não suportados

## OpenSearch

Não suportado adequadamente no LocalStack.

Recomendação:

- utilizar container Docker real
- ou AWS real

---

## DocumentDB

Não suportado adequadamente no LocalStack.

Recomendação:

- MongoDB container
- ou AWS real

---

# Recomendações arquiteturais

## Melhor uso do LocalStack

Ideal para:

- S3
- SQS
- ECS
- IAM
- EventBridge
- Secrets
- testes locais

---

## Melhor uso AWS real

Ideal para:

- Glue
- Athena
- OpenSearch
- DocumentDB
- serviços analytics complexos

---

# Persistência

O projeto utiliza persistência local:

```yaml
PERSISTENCE=1
```

Dados ficam armazenados em:

```txt
./volume
```

---

# Reset completo

Remover tudo:

```bash
docker compose down -v
rm -rf volume
```

---

# Limpeza Docker

Limpar cache e imagens:

```bash
docker system prune -a
```

---

# Fluxo recomendado

## Subir ambiente

```bash
python infra_up.py
```

---

## Desenvolver

- APIs
- Workers
- Pipelines
- Containers ECS

---

## Validar recursos AWS

```bash
awslocal s3 ls
```

---

## Destruir ambiente

```bash
python infra_destroy.py
```

---

# Roadmap Futuro

## Próximas implementações

- ECS containers reais
- Push ECR automático
- Flask API
- Workers Python
- Lambda
- SNS
- Athena
- CI/CD
- GitHub Actions
- observabilidade
- métricas
- healthchecks
- platform CLI

---

# Melhorias futuras

## CLI própria

Exemplo:

```bash
platform up
platform down
platform logs
platform reset
```

---

# Observações finais

Este projeto NÃO pretende substituir a AWS real.

O objetivo é:

- acelerar desenvolvimento
- reduzir custo
- facilitar onboarding
- validar arquitetura localmente

---

# `.gitignore`

```gitignore
.env
.terraform/
terraform.tfstate
terraform.tfstate.backup
```

---

