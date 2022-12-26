# Alcohol licenses in Kraków
## About


### Done:
* Downloading lists of alcohol licences from BIP. (`vendor/crawler`)
* Extracting data from PDF to XLSX files. (`vendor/extractor`)
* Importing data from XLSX/XLS files
* Importing SIMC streets

### WIP:
* Cleaning data - renaming streets to the SIMC convention.
* Cleaning data - renaming building addresses to the processable form.

### TODO:
* Assigning geolocation to addresses.
* Selecting list of licenses in specific region (PostGIS Area).
* Generate JSON and publish it in the Kaggle.

### Backlog:
* Interactive map.
* Search options by business and category types, year, etc.
* Some statistics.

## Prerequisites
* ruby (see `ruby_version`, install via rbenv, rvm or whatever you want)
* bundler
* python (for pdf importer, see `vendor/extractor/Pipfile`)

## Setup
```
rake db:create
rake db:migrate
rake db:seed
```

## Tasks
```
rake import_csv_files                   # Import reports from csv
rake import_simc_streets                # Import TERC SIMC streets from csv
rake import_spreadsheet                 # Import data from XLSX and XLS files
rake transform_location                 # Transform location, correct street and extract building number
```

## Paths
XLSX / XLS files as well as downloaded pdfs and SIMC streets are in `vendor/data/*`

## For developers
* ERD Diagram: [erd.pdf](erd.pdf)
* Specs, coding style: Look ma, no hands.
