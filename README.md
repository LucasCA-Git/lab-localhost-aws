# Local AWS Platform with LocalStack

Mini plataforma AWS local utilizando LocalStack + Terraform para simular serviços AWS localmente.

---

# Objetivo

Este projeto tem como objetivo criar um ambiente AWS local para:

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
