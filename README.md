# Hostit
A storage solution cross-platform app

>**with Spring Boot & Flutter**

<p align="center">
<img src="https://github.com/haroldraj/linkedin_clone/blob/main/assets//logo-spring-boot.png" alt="Spring Boot" width="20%" height="20%"/>
    <img src="https://github.com/haroldraj/song_lyrics/blob/dev/assets/images/flutter-logo.png" alt="Flutter" width="20%" height="20%"/> 
</p>

# Contributors
- Loique Darios
- Franck Patrick ESSI
- Harold Rajaonarison

## Introduction

This project aims to create a highly scalable and available cloud storage platform designed for non-technical users. The infrastructure consists of a Kubernetes cluster (K3s), a TrueNAS storage solution, MinIO for object storage, Spring Boot services, NGINX as a reverse proxy, and a Flutter frontend application.

# Features
- Authentication & registration
- Drag and drop  & filepicker to upload file
- Download file
- Fetch all files
- Search file by name
- View file in browser new tab
- Sort file list by column name (ascending and descending)


# Application

## Microservice architectures
Each service have his own database

![Signup](screenshoots/signup.png)
![Login](screenshoots/login.png)
![LoginError](screenshoots/login_error.png)
![Home](screenshoots/home.png)
![FileSearch](screenshoots/file_search.png)
![Logout](screenshoots/logout.png)



  

# Infrastructure
In dev, we only use docker-compose to run the full backend. And flutter sdk for the frontend

## K3s Kubernetes Cluster

### Introduction to K3s

K3s is a lightweight, certified Kubernetes distribution designed for production workloads in resource-constrained environments.

### Cluster Configuration

#### Hardware Specifications

- **Nodes**: 3 Debian virtual machines
- **CPU**: 2 vCPU per node
- **RAM**: 4 GB per node
- **Storage**: 20 GB per node

#### Installing K3s

1. **First Node (Master)**:
   ```sh
   curl -sfL https://get.k3s.io | sh -
   ```
   This command installs K3s and creates a single-node cluster.

2. **Adding Worker Nodes**:
   ```sh
   curl -sfL https://get.k3s.io | K3S_URL=https://<server_ip>:6443 K3S_TOKEN=<node_token> sh -
   ```
   Replace `<server_ip>` with the server node's IP address and `<node_token>` with the token generated during the initial setup.

### High Availability

K3s automatically configures necessary network components, including the CNI plugin (Flannel by default), for pod networking. In case of a node failure, pods can restart on other nodes due to Kubernetes' self-healing and failover capabilities.

## Persistent Storage with TrueNAS

### Introduction to TrueNAS

TrueNAS is an open-source storage solution based on FreeBSD, supporting various storage protocols such as NFS, SMB, and iSCSI.

### Hardware Configuration for TrueNAS Server

- **CPU**: 4 vCPU
- **RAM**: 8 GB
- **Storage Disks**: 2x 1 TB in RAID 1

### Storage Configuration in TrueNAS

1. **Creating storage pools and volumes**
2. **Setting up NFS shares**

### Integration with K3s

Using the NFS Provisioner, Kubernetes can dynamically provision persistent volumes from TrueNAS NFS shares.

### Scaling Storage

Additional volumes or storage disks can be added to TrueNAS to increase storage capacity.

## Deploying MinIO

### Introduction to MinIO

MinIO is an open-source object storage server compatible with Amazon S3, providing a distributed, scalable, and highly available storage solution.

### Deployment on K3s

Deploy MinIO using a Kubernetes manifest.

#### Kubernetes Manifest Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: minio
spec:
  replicas: 4
  selector:
    matchLabels:
      app: minio
  template:
    metadata:
      labels:
        app: minio
    spec:
      containers:
      - name: minio
        image: minio/minio
        args:
        - server
        - /data
        env:
        - name: MINIO_ACCESS_KEY
          valueFrom:
            secretKeyRef:
              name: minio-secret
              key: accesskey
        - name: MINIO_SECRET_KEY
          valueFrom:
            secretKeyRef:
              name: minio-secret
              key: secretkey
        volumeMounts:
        - name: storage
          mountPath: /data
      volumes:
      - name: storage
        nfs:
          server: <truenas_ip>
          path: /mnt/storage
```

### High Availability and Scaling

In distributed mode, MinIO replicates data across multiple nodes, ensuring fault tolerance and data availability. To scale MinIO, adjust the replica count in the Kubernetes manifest.

## Deploying Spring Boot Services

### Introduction to Services

The Spring Boot services handle various functionalities such as user management, file management, and file synchronization.

### Creating Docker Images

Build Docker images for these services and push them to a container registry.

#### Dockerfile Example

```dockerfile
FROM openjdk:11-jre-slim
COPY target/myapp.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

### Deployment on Kubernetes

Deploy services as Deployments or StatefulSets.

#### Kubernetes Manifest Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: <docker_registry>/myapp:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: prod
```

### High Availability and Scaling

Deploy multiple replicas across different nodes using anti-affinity strategies. Adjust the replica count in the Kubernetes manifests to scale services.

## Setting Up NGINX

### Role of NGINX

NGINX acts as a reverse proxy and load balancer for MinIO and Spring Boot services.

### Configuring NGINX

Use a Kubernetes ConfigMap to manage the NGINX configuration.

#### ConfigMap Example

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    http {
      upstream minio {
        server minio:9000;
      }
      upstream myapp {
        server myapp:8080;
      }
      server {
        listen 80;
        location /minio {
          proxy_pass http://minio;
        }
        location / {
          proxy_pass http://myapp;
        }
      }
    }
```

### Deployment on Kubernetes

#### Kubernetes Manifest Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-config
```

### High Availability and Scaling

Deploy multiple NGINX replicas, with a Kubernetes LoadBalancer service to expose NGINX externally. Adjust the replica count in the Kubernetes manifest to scale NGINX.

## Implementing Auto-Scaling

### Horizontal Pod Autoscaler (HPA)

Configure HPA for MinIO and Spring Boot services.

#### HPA Manifest Example

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

### Cluster Autoscaler

Configure the Cluster Autoscaler to automatically add or remove worker nodes based on resource demand.

## Backup and Restore Strategy

### Backup Solution

Use Velero to back up and restore Kubernetes resources.

#### Example Backup with Velero

```sh
velero backup create mybackup --include-namespaces default
```

### Restore Procedure

Restore the system from Velero backups.

#### Example Restore with Velero

```sh
velero restore create --from-backup mybackup
```

### Complete Backup

Include MinIO data, Spring Boot service configurations, persistent volumes, etc. in the backup strategy.

## Docker Compose Setup

### Docker Compose File

```yaml
version: '3.7'

x-minio-common: &minio-common
  build:
    context: .
    dockerfile: Dockerfile.minio
  expose:
    - "9000"
    - "9001"
  healthcheck:
    test: ["CMD", "mc", "ready", "local"]
    interval: 5s
    timeout: 5s
    retries: 5

services:
  minio1:
    <<: *minio-common
    hostname: minio1
    volumes:
      - data1-1:/data1
      - data1-2:/data2

  minio2:
    <<: *minio-common
    hostname: minio2
    volumes:
      - data2-1:/data1
      - data2-2:/data2

  minio3:
    <<: *minio-common
    hostname: minio3
    volumes:
      - data3-1:/data1
      - data3-2:/data2

  minio4:
    <<: *minio-common
    hostname: minio4
    volumes:
      - data4-1:/data1
     

 - data4-2:/data2

  nginx:
    image: nginx:1.19.2-alpine
    hostname: nginx
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - "9000:9000"
      - "9001:9001"
    depends_on:
      - minio1
      - minio2
      - minio3
      - minio4
       
  db-user:
    container_name: hostit-db-user
    image: mariadb:latest
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: root
      MARIADB_DATABASE: hostit_user
    volumes:
      - data-mariadb-user:/var/lib/mysql
  
  db-storage:
    container_name: hostit-db-storage
    image: mariadb:latest
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: root
      MARIADB_DATABASE: hostit_storage
    volumes:
      - data-mariadb-storage:/var/lib/mysql
  
  api-user:
    container_name: hostit-api-user
    image: haroldraj/hostit-user:1.1.0
    environment:
      SPRING_DATASOURCE_URL: jdbc:mariadb://db-user:3306/hostit_user
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root
      MINIO_HOST_IP_ADDRESS: 192.168.129.101
    depends_on:
      - db-user
    ports:
      - "8002:8002"
  
  api-storage:
    container_name: hostit-api-storage
    image: haroldraj/hostit-storage:1.1.0
    environment:
      SPRING_DATASOURCE_URL: jdbc:mariadb://db-storage:3306/hostit_storage
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root
    ports:
      - "8001:8001"
    depends_on:
      - nginx
      - api-user
      - db-storage

volumes:
  data1-1:
  data1-2:
  data2-1:
  data2-2:
  data3-1:
  data3-2:
  data4-1:
  data4-2:
  data-mariadb-storage:
  data-mariadb-user:
```

### Explanation

- **MinIO Services**: Four MinIO instances are defined, each with its own data volumes. These instances work together to provide a distributed object storage solution.
- **NGINX**: Acts as a reverse proxy, forwarding requests to the appropriate MinIO instance. The configuration file `nginx.conf` is mounted from the host.
- **MariaDB Instances**: Two separate MariaDB instances for user data and storage data, each with its own database and persistent storage.
- **Spring Boot Services**: Two Spring Boot services (`api-user` and `api-storage`) are configured to connect to their respective databases and MinIO. These services are built as Docker images and deployed as containers.

### Running the Setup

1. **Build and Start Containers**:
   ```sh
   docker-compose up -d
   ```

2. **Check Logs**:
   ```sh
   docker-compose logs -f
   ```

3. **Verify Health**:
   Ensure all services are up and running, and health checks are passing.

    
