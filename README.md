# JKN Obstetric Fraud Detection

This repository contains the full analytical pipeline for detecting potential fraud and anomaly patterns in obstetric (persalinan) claims within the Indonesian National Health Insurance (JKN) system.

The project is designed for:

- Internal BPJS Kesehatan research
- Health services evaluation
- Academic publication

---

# Study Objective

To identify abnormal provider behavior patterns in obstetric claims using:

- Caesarean section rate anomalies
- Cohort-based utilization analysis
- Sequence of care reconstruction
- Supervised and unsupervised fraud modeling

---

# Data Architecture

Data source: BPJS Kesehatan claims database (BigQuery)

Pipeline:

Raw → Staging → Mart → Analytic Dataset → R Modeling → Publication Output

All transformation logic is version controlled.

---

# Repository Structure

01_sql  
Contains all BigQuery SQL scripts used to construct staging, mart, and analytic datasets.

03_R  
Contains data cleaning, feature engineering, modeling, and evaluation scripts.

04_outputs  
Stores generated figures, tables, and model objects.

05_publication  
Contains manuscript and supplementary material (RMarkdown).

---

# Reproducibility

This project uses:

- R
- renv (for dependency management)
- BigQuery SQL

To restore environment:
