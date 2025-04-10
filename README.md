
# CloudCruiser

**CloudCruiser** is an interactive desktop application developed in **Java Processing**. It visually presents **U.S. domestic flight data** from **January 1st to January 31st, 2022**, making flight trends and delays easy to understand through a variety of charts and maps.

---

## About the Application

CloudCruiser transforms raw flight data into a visual format using:
- **Bar Charts**
- **Line Charts**
- **Pie Charts**
- **Interactive US Map**

CloudCruiser has **four dynamic filters** to explore the flight data:
- **Origin** – Choose the departure airport.
- **Destination** – Select the arrival airport.
- **Date** – Select a time frame for the data.
- **Late Toggle** – Show delayed flights only.

---

## Required Libraries

To run CloudCruiser, make sure you have the following **Processing libraries** installed:

> You can install these libraries via the Processing IDE Library Manager.

- [`peasycam`](http://mrfeinberg.com/peasycam/)
- [`sound`](https://processing.org/reference/libraries/sound/index.html)
- [`gifAnimation`](https://extrapixel.github.io/gif-animation/)

---

## Team Members and Work Allocation

| FrontEnd     | BackEnd      | Charts       |
|--------------|--------------|--------------|
| Emir         | Aziz         | Ioannis      |
| Parsia       | Dev          | Andreas      |

---

## Project Structure

- **Flight_Program/**  
  Contains all **source code files**, Processing sketches, and visual assets used in the application.

- **Flight_Program/data/**  
  Contains **CSV data files** used for chart generation and flight data analysis.

Make sure both folders are properly located when running the project in Processing.

---

## Getting Started

1. Open the **main `.pde` file** in Processing from the `Flight_Program` folder.
2. Ensure all three libraries (`peasycam`, `sound`, `gifAnimation`) are installed.
3. Run the program.

---

## Data Scope

The data analyzed covers:
- Various U.S. domestic flights from **January 1st to January 31st, 2022**
- With data including delays, origins, destinations, and more
