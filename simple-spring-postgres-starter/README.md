# Simple Spring with Postgresql Docker starter


## Prepare configuration files

```
cd simple-spring-postgres-starter
cp db/.env_sample db/.env
cp app/.env_sample db/.env
cp app/.env_ecs_sample db/.env_ecs
cp docker-compose-ecs.sample.yml docker-compose-ecs.yml
cp ecs-params.sample.yml ecs-params.yml
```


## Local

### Create volumes

```
docker volume create spring-data
docker volume create postgres-data
```

### Deploy

```

# Prepare
cd app
./prepare.sh

# Up
cd ../
docker compose up -d --build

# Down
docker compose down

```

### Backup and restore volumes

[Backup/Restore a dockerized PostgreSQL database - stack overflow](https://stackoverflow.com/questions/24718706/backup-restore-a-dockerized-postgresql-database)

#### Backup
```
docker exec -t simple-spring-postgres-starter-postgres-db-1 pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

```

#### Restore

```
docker compose run -d postgres-db
```

```
cat your_dump.sql | docker exec -i your_postgres_container_name psql -U postgres
docker rm -f your_postgres_container_name
```

## AWS (ECS) Overview

### Create file systems

#### References

 - [Walkthrough: Create an Amazon EFS file system and mount it on an Amazon EC2 instance using the AWS CLI](https://docs.aws.amazon.com/efs/latest/ug/wt1-getting-started.html)


```

After successful login to the EC2 instance....

# Make a mount point
mkdir ~/efs-mount-point

# Mount the efs file system
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${your_file_system_id}.efs.ap-northeast-1.amazonaws.com:/   ~/efs-mount-point  

# Create the directory
sudo mkdir -p ~/efs-mount-point/var/lib/postgresql/data/

# Change permission
sudo chmod 766 ~/efs-mount-point/var/lib/postgresql/data/

```

### Build and push images

#### References

 - [Docker basics for Amazon ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html)

 - [Leverage multi-CPU architecture support](https://docs.docker.com/desktop/multi-arch/)

 - [Is there a way to use docker manifest-list to build multi-arch images in ECR?](https://stackoverflow.com/questions/58605523/is-there-a-way-to-use-docker-manifest-list-to-build-multi-arch-images-in-ecr)


#### Spring

```
cd app
./prepare.sh

# Create a repository for the image on ecs
aws ecr create-repository --repository-name spring-hello-repository --region ap-northeast-1

# Login
aws ecr get-login-password | docker login --username AWS --password-stdin ${your_registry_id}.dkr.ecr.ap-northeast-1.amazonaws.com

# Build image
docker buildx build --platform linux/amd64,linux/arm64 -t ${your_repository_uri} --push .

# Inspect
docker buildx imagetools inspect ${your_repository_uri}:latest

```

#### Postgres

```
cd db

# Create a repository for the image on ecs
aws ecr create-repository --repository-name postgres-hello-repository --region ap-northeast-1

# Login
aws ecr get-login-password | docker login --username AWS --password-stdin ${your_registry_id}.dkr.ecr.ap-northeast-1.amazonaws.com

# Build image
docker buildx build --build-arg DB_LANG=ja_JP --platform linux/amd64,linux/arm64 -t ${your_repository_uri} --push .

# Inspect
docker buildx imagetools inspect ${your_repository_uri}:latest

```

### Create cluster

#### References

- [Tutorial: Creating a cluster with a Fargate task using the Amazon ECS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cli-tutorial-fargate.html)

```

# Configure
ecs-cli configure --cluster spring-hello-cluster --default-launch-type FARGATE --config-name spring-hello-cfg --region ap-northeast-1

# Create cluster
ecs-cli up --cluster-config spring-hello-cfg --ecs-profile default

# Check the security group id
aws ec2 describe-security-groups --filters Name=vpc-id,Values=${your_vpc_id} --region ap-northeast-1

# Set security group
aws ec2 authorize-security-group-ingress --group-id ${your_security_group_id} --protocol tcp --port 8080 --cidr 0.0.0.0/0 --region ap-northeast-1

```

### Deploy

#### References

- [Tutorial: Creating a cluster with a Fargate task using the Amazon ECS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cli-tutorial-fargate.html)



Before you begin, 

fill in the following fields in `docker-compose-ecs.yml`:

 - `${your_spring_image_path}`
 - `${your_postgres_image_path}`


fill in the following fields in `ecs-params.yml`:

 - `${your_spring_image_path}`
 - `${your_postgres_image_path}`
 - `${your_file_system_id}`
 - `${your_subnet_id}`s
 - `${your_security_group_id}`


```

# Deploy 
ecs-cli compose --file docker-compose-ecs.yml --project-name spring-hello service up --create-log-groups --cluster-config spring-hello-cfg --ecs-profile default

# Check the processes
ecs-cli compose --file docker-compose-ecs.yml --project-name spring-hello service ps --cluster-config spring-hello-cfg --ecs-profile default

# Check logs
ecs-cli logs --task-id ${your_task_id} --follow --cluster-config spring-hello-cfs --ecs-profile default

# Down the cluster
ecs-cli compose --file docker-compose-ecs.yml --project-name spring-hello service down --cluster-config spring-hello-cfg --ecs-profile default

```


### Delete images


#### References

- [Deleting an image](https://docs.aws.amazon.com/AmazonECR/latest/userguide/delete_image.html)

```
# List the existing images
aws ecr list-images --repository-name postgres-hello-repository

# Delete image(s)
aws ecr batch-delete-image --repository-name postgres-hello-repository --image-ids imageTag=latest
```

### Load balancer, HTTPS

 - [AWS Certificate Manager](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)
 - [AWS Elastic Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)


## Other Useful links

 - [How can I cache Maven dependencies and plugins in a Docker Multi Stage Build Layer? - stack overflow](https://stackoverflow.com/questions/47969389/how-can-i-cache-maven-dependencies-and-plugins-in-a-docker-multi-stage-build-lay)

 - [Alpine Linux で ユーザー/グループ を 追加/削除/一覧 する 方法](https://garafu.blogspot.com/2019/07/operate-user-group-on-alpine.html)

 - [Is it possible to specify the schema when connecting to postgres with JDBC? - stack overflow](https://stackoverflow.com/questions/4168689/is-it-possible-to-specify-the-schema-when-connecting-to-postgres-with-jdbc)

 - [Creating a Docker image with a preloaded database](https://cadu.dev/creating-a-docker-image-with-database-preloaded/)

 - [fargate hostname set awsvpc](https://stackoverflow.com/questions/65383842/fargate-hostname-set-awsvpc)