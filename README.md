
---

#  Pricing & Snapshot Dashboard (Capstone Project)

This repository presents part of the **Capstone Project for the MSc Business Analytics at the University of Birmingham**.
The project was delivered for a **Media Agency** client. To protect confidentiality, the client’s real name and identifying details have been removed. All datasets provided here are synthetic and only mimic the structure of the original data.

 [Full Report (PDF)]: 

---

## 🎯 Project Overview

* **Objective:** Design dashboards in Power BI to support pricing decisions and monthly commercial performance reviews.
* **Scope:** Development of a **Snapshot dashboard** (Year-to-Date KPIs, service mix, client concentration) and a **Pricing dashboard** (dynamic cost allocation, labour markups, blended rate guardrails).
* **Tools & Languages:** Power BI (DAX, Power Query M), R (clustering & complexity analysis).

---

##  Methodology

* **Data Preparation:**

  * Reconciled timesheet and payrate data to reconstruct project-level costs.
  * Removed duplicates and invalid project IDs.
  * All transformations documented in Power BI (M code).

* **Snapshot Dashboard:**

  * Tracks revenue, cost, gross profit, and margin across months.
  * Highlights service mix, project demand, and client revenue distribution.
  * Identifies client concentration risks.

* **Pricing Model & Dashboard:**

  * **Fixed Cost Allocation (DAR):** Distributes overheads systematically by service demand.
  * **Labour Markups:** Combines *complexity* (from R k-means clustering) and *urgency* (based on workload vs deadline).
  * **Blended Rate Adjustment (BRA):** Ensures quoted rates stay within market benchmark bounds (£75–£105/hr).
  * Implemented fully in **DAX**, with results audited for transparency.

---

## 📈 Example Outputs

**Snapshot Dashboard (synthetic data):**
![](outputs/Snapshot%20Dashboard.png)

---

## 🗂 Repository Structure

```
pricing-snapshot-dashboard/
│── powerbi/
│   ├─ dax/                 # DAX measures for complexity label assigning
│   └─ m/                   # Power Query M code for preprocessing
│── r-scripts/              # R clustering for complexity analysis
│── outputs/                # Dashboard snapshots (with anonymised/synthetic data)
│── Final Report.pdf         # Full academic report (confidential data removed)
│── README.md               # Project documentation (this file)
│── LICENSE
```

---

##  Skills Demonstrated

* **Business Intelligence:** Dashboard development in Power BI (DAX, Power Query).
* **Data Analytics in R:** K-means clustering with validation (Silhouette, Davies–Bouldin).
* **Pricing Analytics:** Dynamic cost allocation, risk-based markups, guardrail-based blended rates.
* **Data Modelling:** Star schema design and systematic reconciliation of project-level financials.
* **Business Acumen:** Linking unit economics with client contribution to inform pricing and strategy.

---

##  Disclaimer

* The original client’s name and all sensitive data have been removed.
* All datasets provided are **synthetic** and created for demonstration purposes.
* The dashboards and models demonstrate methodology and technical skills only.

---


