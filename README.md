# 🌾 Crop Climate Analytics — AWS + Snowflake + Power BI

An end-to-end data pipeline that ingests multi-year agricultural climate data into the cloud, models it in Snowflake, and visualizes rainfall, temperature, and humidity patterns across crops, seasons, and regions in Power BI.

---

## 📌 Project Overview

Agricultural yield is heavily influenced by climate conditions — rainfall, temperature, and humidity — but that influence varies a lot depending on *when* (year/season) and *where* (location) you're looking. This project builds a cloud data pipeline to bring raw seasonal crop-climate data into Snowflake, enrich it with derived groupings, and surface the patterns through interactive Power BI dashboards.

The dataset covers **16 years (2004–2019)** of records across **11 locations**, **13 crop types**, and **3 growing seasons**, capturing rainfall, temperature, humidity, soil type, irrigation method, yield, and price.

---

## 🏗️ Architecture

```
        ┌───────────────┐
        │  Raw CSV Data │
        └───────┬───────┘
                │  upload
                ▼
        ┌───────────────┐
        │   AWS S3      │   (data lake / staging storage)
        │    Bucket     │
        └───────┬───────┘
                │  IAM Role (secure access)
                ▼
        ┌───────────────────────────┐
        │        Snowflake          │
        │  Storage Integration ──►  │  connects Snowflake to S3
        │  External Stage       ──► │  points to bucket location
        │  COPY INTO             ──►│  loads data into tables
        └──────────┬────────────────┘
                   │  transform (SQL)
                   ▼
        ┌───────────────────────────┐
        │   Derived Columns         │
        │  • Year Group (Y1/Y2/Y3)  │
        │  • Rainfall Group         │
        │    (Low / Medium / High)  │
        └──────────┬────────────────┘
                   │
                   ▼
        ┌───────────────────────────┐
        │        Power BI           │
        │  Rainfall / Temperature / │
        │  Humidity analysis by     │
        │  Year, Crop, Season, Loc  │
        └───────────────────────────┘
```

---

## 🔧 Tech Stack

| Layer | Tool | Purpose |
|---|---|---|
| Storage | **AWS S3** | Landing zone for raw CSV data |
| Access Control | **AWS IAM Role** | Secure, credential-free access from Snowflake to S3 |
| Data Warehouse | **Snowflake** | Storage integration, staging, and SQL-based transformation |
| Visualization | **Power BI** | Interactive dashboards and climate-yield analysis |

---

## 🚀 Pipeline Steps

### 1. Data Ingestion (AWS S3)
- Created an **S3 bucket** to act as the raw data landing zone.
- Created an **IAM Role** with the necessary S3 read permissions, allowing Snowflake to securely access the bucket without hardcoding credentials.

### 2. Snowflake Integration
- Created a **Storage Integration object** in Snowflake, linking it to the S3 bucket via the IAM role.
- Created an **external Stage** pointing to the S3 bucket using the integration.
- Used **`COPY INTO`** to load the raw CSV data from the S3 stage into a Snowflake table.

### 3. Data Transformation (SQL, in Snowflake)
- **Year Group column** — bucketed the 16 years of data into three groups (`Y1`, `Y2`, `Y3`) to enable trend comparison across broader time periods rather than year-by-year noise.
- **Rainfall Group column** — categorized rainfall values into `Low`, `Medium`, and `High` bands to simplify rainfall-vs-yield analysis.

### 4. Analysis & Visualization (Power BI)
Connected Power BI to Snowflake and built out analysis across three core climate dimensions, each broken down by **Year, Crop Type, Season, and Location**:

- 🌧️ **Rainfall Analysis** — average rainfall trends by year, crop, season, and location
- 🌡️ **Temperature Analysis** — average temperature trends by year, crop, season, and location
- 💧 **Humidity Analysis** — average humidity trends by year, crop, season, and location

---

## 📊 Dataset

| Column | Description |
|---|---|
| `Year` | Year of record (2004–2019) |
| `Location` | District/region (e.g. Mangalore, Kodagu, Mysuru, Hassan, etc.) |
| `Area` | Cultivated area |
| `Rainfall` | Rainfall recorded (mm) |
| `Temperature` | Average temperature (°C) |
| `Soil type` | Soil classification |
| `Irrigation` | Irrigation method (Drip / Basin / Spray) |
| `yeilds` | Crop yield |
| `Humidity` | Humidity (%) |
| `Crops` | Crop type (Coconut, Paddy, Coffee, Cashew, etc.) |
| `price` | Market price |
| `Season` | Growing season (Kharif / Rabi / Zaid) |

---

## 📈 Key Analyses

- Compared **average rainfall, temperature, and humidity** across the three time-based year groups (Y1/Y2/Y3) to observe long-term climate shifts.
- Broke down each climate metric by **crop type** to identify which crops are grown under which climate conditions.
- Analyzed variation across the three **seasons** (Kharif, Rabi, Zaid) to understand seasonal climate patterns.
- Compared climate metrics across **locations** to highlight regional differences.
- Used the **Rainfall Group** (Low/Medium/High) to simplify and segment rainfall-driven insights.

---

## 🗂️ Repository Structure

```
├── data/
│   └── data_season.csv        # Raw dataset
├── sql/
│   └── snowflake_setup.sql     # Storage integration, stage, COPY INTO, derived columns
├── powerbi/
│   └── crop_climate_dashboard.pbix
└── README.md
```

---

## ▶️ How to Reproduce

1. Upload the raw dataset to an **S3 bucket**.
2. Create an **IAM Role** granting Snowflake access to that bucket.
3. In Snowflake, create a **Storage Integration**, **Stage**, and run **`COPY INTO`** to load the data.
4. Run the transformation SQL to generate the `Year Group` and `Rainfall Group` columns.
5. Connect Power BI to Snowflake and load the transformed table.
6. Build/refresh the rainfall, temperature, and humidity visuals by year, crop, season, and location.

---

## 🙌 Notes

This project was built as a hands-on exercise in cloud data engineering — moving data from raw storage (S3) into a cloud warehouse (Snowflake) and turning it into decision-ready dashboards (Power BI). Feel free to fork it, plug in your own dataset, or extend the analysis with yield/price correlation.
