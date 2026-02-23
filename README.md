# JKN Obstetric Fraud Detection

## Background

Indonesia's National Health Insurance (JKN) covers nearly the entire population.
Obstetric services are among the most frequently claimed benefits and have significant financial impact.

However, administrative claim data may contain:

* biologically implausible delivery intervals
* repeated deliveries within short periods
* facility-level anomalies

This project aims to detect abnormal patterns using national claims data.

## Objectives

1. Identify impossible biological delivery intervals
2. Detect high-risk facilities
3. Build audit dashboard for stakeholders
4. Provide feedback for healthcare providers and health offices

## Data Source

BPJS Kesehatan administrative claims data (de-identified).

No individual patient data is publicly shared in this repository.

## Methods

* BigQuery SQL (data engineering)
* Survival analysis (RCT completion)
* Multilevel modeling (facility variation)
* Anomaly detection
* Shiny dashboard audit tool

## Project Structure

* `sql/` : data mart & anomaly queries
* `r/` : statistical modeling
* `dashboard/` : Shiny audit system
* `manuscript/` : research paper
* `docs/` : documentation
* `output/` : figures and tables

## Author

Health Financing Analyst — Indonesia
