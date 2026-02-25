# JKN Obstetric Fraud Detection

## Background

Indonesia’s National Health Insurance (JKN) relies on administrative claims data to reimburse hospitals for delivery care.
However, claims data are designed for payment, not clinical verification. As a result, clinically implausible delivery patterns may occur but remain undetected in routine monitoring.

This project reconstructs longitudinal delivery histories of insured mothers in order to identify biologically implausible birth intervals and abnormal provider patterns.

---

## Research Question

Can administrative claims data be used to detect hospitals producing statistically and biologically implausible delivery patterns?

---

## Data Source

Administrative claims data from the Indonesian National Health Insurance (JKN), including:

* Inpatient INA-CBG claims (hospital deliveries)
* Outpatient non-capitation claims (antenatal and follow-up care)
* Referral records
* Audit verification outcomes (when available)

The data represent routine operational data, not clinical registry data.

---

## Core Method

### 1. Patient Linking

Patients are linked longitudinally using anonymized participant identifiers to reconstruct individual maternal histories.

### 2. Delivery Sequence Construction

Each mother’s delivery events are ordered chronologically to create a delivery sequence:

Mother → Delivery 1 → Delivery 2 → Delivery 3 → ...

### 3. Inter-delivery Interval

For each consecutive delivery:

```
interval = discharge_date(current_delivery) - discharge_date(previous_delivery)
```

Clinically impossible intervals are defined as:

* < 150 days (biologically implausible)
* 150–210 days (extremely improbable)
* 210–240 days (clinically suspicious)

### 4. Provider Pattern Detection

Hospitals are flagged when they produce:

* High proportion of short birth intervals
* Repeated impossible deliveries from the same patients
* Concentration of events in specific providers

---

## Output

The system produces:

* flagged patients
* flagged hospitals
* monitoring indicators for verification teams
* downloadable audit lists for field investigators

---

## Purpose

This is not intended to accuse providers of fraud.
The objective is early detection of abnormal utilization patterns requiring medical verification.

The system functions as a clinical plausibility screening tool within health insurance governance.

---

## Status

Active research prototype using SQL-based reconstruction in BigQuery.
