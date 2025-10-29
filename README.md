# 🧑‍💻 AWS DevOps Internship Projects

This repository contains **six end-to-end AWS DevOps projects** completed during my internship at **FortuneCloud India**.  
Each project demonstrates real-world implementation of AWS services, CI/CD automation, monitoring, containerization, and data pipeline management.

---

## 🚀 Project 1 — AWS CloudWatch Dashboards for Monitoring

### **Overview**
Designed and implemented a **real-time monitoring and alerting solution** using **Amazon CloudWatch** to track performance metrics of EC2, S3, and network resources.

### **Architecture**
- **Services Used:** CloudWatch, EC2, SNS, IAM, S3  
- **Workflow:**
  1. Enabled detailed EC2 monitoring and log collection.
  2. Configured CloudWatch dashboards for CPU, Memory, and Disk I/O.
  3. Created alarms to trigger SNS notifications when thresholds exceed limits.
  4. Managed permissions using IAM roles.

### **Deliverables**
- Real-time dashboards and alerting system.  
- Optimized monitoring configuration for AWS infrastructure.

### **Outcome**
Improved system visibility, proactive issue detection, and reduced downtime.

---

## ⚙️ Project 2 — Data Ingestion from S3 to RDS with Fallback to AWS Glue

### **Overview**
Built an **automated ETL pipeline** that ingests structured/unstructured data from **S3** to **RDS (MySQL)** using Python, with a **fallback mechanism to AWS Glue** for error recovery.

### **Architecture**
- **Services Used:** S3, RDS (MySQL), AWS Glue, IAM, Lambda, CloudWatch  
- **Workflow:**
  1. Upload CSV/JSON files to S3.
  2. Lambda triggers ingestion to RDS via PyMySQL.
  3. In case of failure, AWS Glue ETL job processes data automatically.
  4. Logs stored in CloudWatch for tracking and audit.

### **Deliverables**
- Automated ingestion with Glue fallback.  
- Fault-tolerant and serverless architecture.

### **Outcome**
Reliable data processing, zero manual intervention, and improved data quality.

---

## 🧰 Project 3 — Automated CI/CD Pipeline using Jenkins

### **Overview**
Developed a **Continuous Integration and Continuous Deployment (CI/CD)** pipeline using Jenkins to automate build, test, and deploy processes from GitHub to AWS EC2.

### **Architecture**
- **Services Used:** Jenkins, EC2, GitHub, Docker, S3, IAM  
- **Workflow:**
  1. Jenkins fetches code from GitHub repository.  
  2. Executes build and testing stages automatically.  
  3. Deploys artifact to EC2 instance.  
  4. Stores backup artifacts in S3.

### **Deliverables**
- Jenkinsfile for automated build and deployment.  
- Fully automated CI/CD process.

### **Outcome**
Reduced deployment time by 80% and ensured consistent code delivery.

---

## 🐳 Project 4 — Dockerized Flask Web Application Deployment on EC2

### **Overview**
Deployed a **Flask web application** in a **Docker container** on AWS EC2, enabling environment consistency, easy scaling, and fast deployment.

### **Architecture**
- **Services Used:** Docker, Flask, EC2, Git, Nginx (optional)  
- **Workflow:**
  1. Built Flask app (`app.py`) with MySQL integration using PyMySQL.  
  2. Created Dockerfile and containerized the application.  
  3. Deployed Docker container to EC2 instance.  
  4. Configured security groups for HTTP access.

### **Deliverables**
- Dockerfile and docker-compose setup.  
- Containerized Flask app accessible via EC2 public IP.

### **Outcome**
Portable, scalable, and consistent deployment process across environments.

---

## 🧾 Project 5 — Automated Jenkins Job with Log Management

### **Overview**
Configured an **automated Jenkins job scheduler** integrated with **AWS CloudWatch Logs** for centralized build log monitoring and alerting.

### **Architecture**
- **Services Used:** Jenkins, CloudWatch, EC2, S3, IAM  
- **Workflow:**
  1. Created periodic jobs using Jenkins cron triggers.  
  2. Logs automatically pushed to CloudWatch Logs for centralized view.  
  3. Backup logs archived to S3.  
  4. Alerts configured for build failures.

### **Deliverables**
- Centralized logging mechanism.  
- Automated job scheduling and alert notifications.

### **Outcome**
Enhanced log visibility, faster debugging, and improved reliability of Jenkins jobs.

---

## ☁️ Project 6 — AWS Glue-Based Data Backup and Recovery System

### **Overview**
Implemented a **data backup and recovery solution** using AWS Glue, S3, and RDS to automate ETL jobs and ensure consistent data retention.

### **Architecture**
- **Services Used:** AWS Glue, S3, RDS, CloudWatch, IAM  
- **Workflow:**
  1. AWS Glue crawlers detect schema from S3 data.  
  2. ETL jobs transform, clean, and reload data to S3.  
  3. Glue jobs triggered by CloudWatch Events.  
  4. Backup verification using RDS snapshots and Glue catalog.

### **Deliverables**
- Glue ETL scripts for data transformation.  
- Automated backup and validation jobs.

### **Outcome**
Reduced data loss risk, ensured data integrity, and improved operational efficiency.

---

## 🧠 Skills Demonstrated

- AWS Services: EC2, S3, RDS, CloudWatch, IAM, Glue, Lambda  
- DevOps Tools: Jenkins, Docker, GitHub, CI/CD  
- Scripting: Python, Bash  
- Infrastructure Monitoring and Automation  
- Cloud Security & IAM Role Management  

---

## 📂 Repository Structure

