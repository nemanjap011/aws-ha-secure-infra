# 🛠️ AWS Highly Available and Secure 3-Tier Infrastructure (Terraform)

This project builds a **highly available**, **secure**, and **production-grade 3-tier infrastructure** on AWS using Terraform. It follows **modular architecture best practices** and simulates what you’d build in a real-world cloud environment.

---

## 🧱 Architecture Diagram

![Architecture Diagram](https://raw.githubusercontent.com/yourusername/aws-ha-secure-infra/main/diagram.png)

> *(Replace with your actual image URL after uploading it to your repo)*

---

## 🧭 Architecture Overview

- **Public Layer**: ALB in 2 public subnets (2 AZs)
- **Web/App Layer**: EC2 Auto Scaling Group in 2 private subnets (2 AZs)
- **Database Layer**: RDS (MySQL) in Multi-AZ across private subnets
- **NAT Gateway**: For private subnet egress
- **Security**: Proper SGs, IAM, private resources, no hardcoded credentials
- **Monitoring**: VPC Flow Logs, CloudWatch log group, optional alarm

---

## 🚀 How to Deploy

1. **Clone this repo**
   ```bash
   git clone https://github.com/yourusername/aws-ha-secure-infra.git
   cd aws-ha-secure-infra
