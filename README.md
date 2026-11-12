# 🏥 Hospital Readmission Risk & Cost Analytics

**Which diabetic patients will be readmitted within 30 days, and how many should a hospital enrol in a follow-up programme to save the most money?**

An end-to-end analytics project: **Python** cleaning and feature engineering → **SQL** business analysis → **machine learning** risk model → **cost-benefit decision model** → **Power BI** dashboard with a live savings simulator.

`Python` `Pandas` `Scikit-learn` `MySQL` `SQL window functions` `Power BI` `DAX`

---

## 🧭 Quick navigation

| Section | Open |
|---|---|
| 📊 Dashboard: Overview | [View](dashboard_overview.png) |
| 🔍 Dashboard: Risk Drivers | [View](dashboard_risk_drivers.png) |
| 💰 Dashboard: Savings Simulator | [View](dashboard_simulator.png) |
| 📄 Full dashboard (PDF) | [View](Hospital_Readmission_Dashboard.pdf) |
| 📁 Power BI file | [Hospital_Readmission.pbix](Hospital_Readmission.pbix) |
| 1️⃣ Data exploration | [01_explore.ipynb](01_explore.ipynb) |
| 2️⃣ Data cleaning | [02_cleaning.ipynb](02_cleaning.ipynb) |
| 3️⃣ Feature engineering | [03_features.ipynb](03_features.ipynb) |
| 4️⃣ Load data into MySQL | [04_load_to_mysql.ipynb](04_load_to_mysql.ipynb) |
| 🗄️ SQL: create table | [01_create_schema.sql](01_create_schema.sql) |
| 🗄️ SQL: business queries | [02_analysis_queries.sql](02_analysis_queries.sql) |
| 5️⃣ ML model | [05_model.ipynb](05_model.ipynb) |
| 6️⃣ Business case | [06_business_case.ipynb](06_business_case.ipynb) |

---

## 📌 Business problem
Unplanned 30-day readmissions are costly for hospitals and often signal that a patient was discharged without enough follow-up care. A **care-transition programme** (follow-up call, early clinic visit, medication review) can prevent some of them, but it costs money for every patient enrolled.

- Enrol **too few** → preventable readmissions are missed
- Enrol **too many** → money is spent on patients who would have been fine

**Goal:** find who is at risk, why, and the enrolment level that maximises net savings.

---

## 📊 Key results

| Area | Finding |
|---|---|
| Scale | **99,340** hospital visits from **69,987** diabetic patients across 130 US hospitals |
| Problem size | **11.4%** 30-day readmission rate, **11,314** readmissions, about **$172M** estimated cost |
| Prior admissions | 3+ prior admissions → **26.4%** readmitted vs **8.6%** with none (**3.1×**) |
| Concentration | **8.8%** of patients account for **52%** of all readmissions |
| Discharge destination | Patients sent to rehab / long-term care are readmitted at **2.17×** the average |
| Care gap | **83%** of patients were never HbA1c-tested, and they had the highest readmission rate |
| Model | Random Forest, test **ROC-AUC 0.661**, **PR-AUC 0.178** (≈2× the 0.09 baseline) |
| Risk ranking | Top 10% of predicted risk readmitted at **20.6%** (**2.3×** average); top 30% capture **51%** of readmissions |
| ML vs simple rule | Same workload: model catches **37.7%** of readmissions vs **34.2%** for a hand-made rule |
| **Recommendation** | Enrol the **top 9%** riskiest patients → about **$149K net savings per 10,000 discharges**. Enrolling everyone would **lose $2.27M** |

---

## 🖥️ Power BI dashboard
*Click any image to open it full size.*

**Page 1: Executive overview.** Headline KPIs and risk by discharge destination, prior admissions and age.
[![Overview](dashboard_overview.png)](dashboard_overview.png)

**Page 2: Risk drivers.** Age × prior-admission heatmap, diagnosis, HbA1c care gap, length of stay, specialty ranking.
[![Risk drivers](dashboard_risk_drivers.png)](dashboard_risk_drivers.png)

**Page 3: Savings simulator and care-manager worklist.** What-if sliders for programme cost, effectiveness and enrolment update net savings live, alongside a prioritised list of high-risk patients.
[![Simulator](dashboard_simulator.png)](dashboard_simulator.png)

---

## 🔄 Project workflow

| Step | File | What it does |
|---|---|---|
| 1. Explore | [01_explore.ipynb](01_explore.ipynb) | Data size, grain (one row = one visit, not one patient), target, missing values |
| 2. Clean | [02_cleaning.ipynb](02_cleaning.ipynb) | `?` → missing; removed 2,423 visits ending in death/hospice; dropped `weight` (97% missing); created 0/1 target |
| 3. Features | [03_features.ipynb](03_features.ipynb) | Grouped 715 ICD-9 codes into 9 categories; readable discharge/admission groups; prior-visit and medication features; visit number per patient |
| 4. SQL | [04_load_to_mysql.ipynb](04_load_to_mysql.ipynb), [01_create_schema.sql](01_create_schema.sql), [02_analysis_queries.sql](02_analysis_queries.sql) | Loaded data into MySQL; 9 business queries using CTEs, window functions (`RANK`, `LAG`, `OVER/PARTITION BY`), pivots and lift vs baseline |
| 5. Model | [05_model.ipynb](05_model.ipynb) | Compared Logistic Regression, Random Forest and Gradient Boosting with 5-fold CV; deciles, rule comparison, feature importance |
| 6. Business case | [06_business_case.ipynb](06_business_case.ipynb) | Net-savings model, sensitivity analysis, fairness audit, risk tiers |
| 7. Dashboard | [Hospital_Readmission.pbix](Hospital_Readmission.pbix), [PDF](Hospital_Readmission_Dashboard.pdf) | 3-page Power BI report with DAX measures and what-if parameters |

---

## 🧠 Key methodology decisions
- **One encounter per patient for modelling.** The same patient never appears in both train and test, which prevents data leakage.
- **PR-AUC over accuracy.** Only about 9% of patients are readmitted; a model that always says "no" would be 91% accurate and useless.
- **Model benchmarked against a simple rule.** ML is only worth using if it beats common sense at the same workload.
- **Decision, not just prediction.** Risk scores are turned into an enrolment recommendation with a cost model.
- **Race excluded from model inputs**, then audited for fairness anyway.

---

## 💰 Business case

**Net savings = readmissions prevented × $15,200 − patients enrolled × $500**

Assumptions: average readmission cost $15,200 (AHRQ), programme cost $500 per patient, 20% of enrolled readmissions prevented.

[![Savings curve](savings_curve.png)](savings_curve.png)

**Sensitivity (net savings per 10,000 discharges):**

| Effectiveness \ Cost per patient | $250 | $500 | $1,000 |
|---|---|---|---|
| 10% | $74,668 | $3,200 | $0 |
| 20% | $698,335 | **$149,336** | $6,401 |
| 30% | $1,732,062 | $642,492 | $91,842 |

The value depends heavily on the programme's real cost and effectiveness, so the recommendation is to **pilot first and measure effectiveness**.

---

## ⚖️ Fairness check
Race was not a model input. When flagging the top 9% as high risk, flag rates were similar across groups (about 7–10%). However, African American and Caucasian patients had the same actual readmission rate (9.1%) while the model caught **15.7%** vs **23.5%** of their readmissions. The model should therefore be used as **decision support alongside clinical judgement**, with catch rates monitored by group.

---

## ⚠️ Limitations
- Data is from 1999–2008 US hospitals; rates and costs differ today and in other health systems.
- No lab values, vital signs or social factors, which limits model accuracy (published studies on this dataset report similar AUCs).
- Programme cost and effectiveness are assumptions, hence the sensitivity analysis.
- Readmissions to a different hospital are not captured.

---

## ▶️ How to run
1. Download `diabetic_data.csv` from [Kaggle](https://www.kaggle.com/datasets/brandao/diabetes) or the [UCI repository](https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008).
2. Create this folder layout on your computer and put the CSV in `data/raw/`:
   ```
   project/
   ├── data/raw/diabetic_data.csv
   └── notebooks/   ← put the .ipynb files here
   ```
3. Install the libraries: `pip install -r requirements.txt`
4. Run the notebooks in order (`01` → `06`). Before notebook 04, run [01_create_schema.sql](01_create_schema.sql) in MySQL Workbench; the notebook asks for your MySQL password when it runs.
5. Open [Hospital_Readmission.pbix](Hospital_Readmission.pbix) in Power BI Desktop.

## 📚 Data source
Strack, B. et al. (2014). *Impact of HbA1c Measurement on Hospital Readmission Rates: Analysis of 70,000 Clinical Database Patient Records.* BioMed Research International. Dataset: UCI Machine Learning Repository, "Diabetes 130-US Hospitals for Years 1999–2008".

---
**Author:** Mahathi Gonella · [GitHub](https://github.com/gmahathi808) · [LinkedIn](https://www.linkedin.com/in/gonella-mahathi-6307612b2/)
