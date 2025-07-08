# Terraform Project: Deploy a Secure, Scalable Azure Environment

This project uses **Terraform** to provision a secure and scalable Azure environment tailored for a small organization. It incorporates key principles of **Zero Trust**, **least privilege**, and **infrastructure as code** to ensure proper network segmentation, access control, and environment separation.

---

## 🔍 Overview

The infrastructure is designed for a small organization with the following structure:

- 👥 25 users
- 🏢 5 Departments:
  - HR
  - IT
  - Accounts
  - Finance
  - Marketing
- 🌐 2 Virtual Networks:
  - **Dev**
  - **Prod**
- 📶 5 Subnets:
  - One subnet per department
  - Each with custom **NSG (Network Security Group)** rules
- 💻 1 Virtual Machine (VM) each for:
  - HR Department
  - IT Department

---

## 🎯 Project Goals

- ✅ **Secure networking and subnet isolation**
- ✅ **Environment separation** using Terraform **Workspaces** (Dev & Prod)
- ✅ **Role-Based Access Control (RBAC)** by department
- ✅ Implementation of **Zero Trust** architecture and **Least Privilege Access**

---

## 🎓 Learning Purpose

This project was created as part of my journey to **learn Terraform fundamentals** and to **prepare for the HashiCorp Certified: Terraform Associate (003) certification**. It focuses on applying real-world scenarios such as environment separation, RBAC, and Zero Trust to reinforce both conceptual understanding and hands-on skills.

