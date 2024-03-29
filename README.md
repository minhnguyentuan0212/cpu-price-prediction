# CPU Performance Prediction

## Overview
This project focuses on predicting the relative performance of CPUs using multiple linear regression analysis. Based on statistical theories and regression analysis, this study constructs a model to estimate CPU performance relative to its specifications.

## Dataset
The dataset includes information on 209 CPU chips, encompassing various attributes like cycle time, minimum and maximum memory, cache size, and minimum and maximum channels, among others. The goal is to predict the CPU's estimated relative performance (ERP) based on these attributes.

## Methodology
- **Data Preprocessing**: Cleaning and transforming data to ensure quality analysis. This includes dealing with missing values and feature extraction.
- **Exploratory Data Analysis (EDA)**: Utilizing descriptive statistics and visualization techniques to understand data distribution and relationships among variables.
- **Regression Analysis**: Implementing multiple linear regression to build a predictive model. The process involves data splitting, model training, and validation.

## Tools and Technologies
- **R Programming**: For statistical analysis and model building.
- **GGplot2 & GGally**: For data visualization.

## Model Evaluation
The model's performance is evaluated using statistical tests, including hypothesis testing for significance of regression coefficients, determination of R-squared and adjusted R-squared values, and validation through mean squared error (MSE) analysis on a test set.

## How to Use
1. **Installation**: Clone this repository and ensure R is installed on your machine.
2. **Data Loading**: Load the dataset using R and preprocess it as described in the report.
3. **Model Training and Evaluation**: Run the regression analysis script to train the model and evaluate its performance.
4. **Prediction**: Use the model to predict the ERP of CPUs based on their specifications.

## Contributing
Contributions to improve the model or extend the analysis are welcome. Please submit a pull request or open an issue for discussion.

## License
This project is licensed under the MIT License - see the LICENSE.md file for details.

## Acknowledgements
- **Instructor**: Prof. Nguyễn Tiến Dũng for guidance and support.
- **Authors**: Nguyễn Tuấn Minh
