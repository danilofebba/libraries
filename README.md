
## **AWS Command Line Interface**
- [Instalar ou atualizar a versão mais recente da AWS CLI](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html)
- [Configurações de arquivos de configuração e credenciais](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-configure-files.html)

## **Requisitos para Implementação de Replicações Lógicas de Banco de Dados (Change Data Capture):**

- **Environment:** Amazon Web Service (AWS)
- **Database Engine:** Amazon RDS para PostgreSQL 13

## **Implementação de Replicações Lógicas de Banco de Dados (Change Data Capture):**

### **Passo 1:**

Criar um novo grupo de parâmetros para replicação lógica. Através dele será possível aplicar o conceito de *Change Data Capture*.

```bash
aws rds create-db-parameter-group \
    --db-parameter-group-name pgsql-cdc01-pj01 \
    --db-parameter-group-family postgres13 \
    --description "Parameter Group to Logical Replication - CDC" \
    --tags Key="project",Value="01"

aws rds modify-db-parameter-group \
    --db-parameter-group-name pgsql-cdc01-pj01 \
    --parameters "ParameterName=rds.logical_replication,ParameterValue=1,ApplyMethod=pending-reboot"
```

### **Passo 2:**

Se o objetivo for criar uma nova instância de banco de dados para um novo projeto, utilize a linha de comando abaixo com o grupo de parâmetros para replicação lógica do passo 1.

```bash
aws rds create-db-instance \
    --db-instance-identifier pgsql-db01-prod-master-pj01 \
    --engine postgres \
    --engine-version "13.6" \
    --db-parameter-group-name pgsql-cdc01-pj01 \
    --db-instance-class db.t3.micro \
    --storage-type gp2 \
    --allocated-storage 20 \
    --port 5432 \
    --db-name db01_prod_master_pj01 \
    --master-username admin_user \
    --master-user-password "DbIg#*gOasX!" \
    --publicly-accessible \
    --no-multi-az \
    --vpc-security-group-ids sg-0b920c1d22dacaa73 \
    --db-subnet-group-name default \
    --backup-retention-period 0 \
    --no-enable-performance-insights \
    --tags Key="project",Value="01"
```

Se o objetivo for habilitar a replicação lógica para uma instância de banco de dados em produção, utilize a linha de comando abaixo com o grupo de parâmetros para replicação lógica do passo 1. Após executar a linha de comando abaixo na instância de banco de dados em produção, será necessário que ela seja reiniciada para que a modificação seja aplicada.

```bash
aws rds modify-db-instance \
    --db-instance-identifier pgsql-db01-prod-master-pj01 \
    --db-parameter-group-name pgsql-cdc01-pj01
```
A replicação lógica utiliza o plugin [wal2json](https://github.com/eulerto/wal2json)

>[!NOTE]
>
>kjdhkwfhkfh kwdjfhkwjdfh kjfhwkhf
