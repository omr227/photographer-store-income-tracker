# Photographer Store Manager

A Flutter mobile application for managing photographers’ daily income, expenses, and costume usage.

## Features

- Login system for users
- Track daily photographer income
- Support for multiple payment types:
  - Egyptian Pound (EGP)
  - US Dollar (USD)
  - Euro (EUR)
  - Visa/Card payments
- Record costumes/dresses used in sessions
- Calculate total income by date
- View and manage daily transactions
- REST API integration with Oracle APEX
- Oracle Autonomous Database backend

---

# Technologies Used

## Frontend
- Flutter
- Dart
- Basic State Management

## Backend
- Oracle Autonomous Database
- Oracle APEX REST APIs

---

# Database Structure

## Table 1: USERS

| Column Name | Type |
|---|---|
| username | VARCHAR |
| password | VARCHAR |

---

## Table 2: TRANSACTIONS

| Column Name | Type |
|---|---|
| money_pound | NUMBER |
| money_euro | NUMBER |
| money_dollar | NUMBER |
| money_visa | NUMBER |
| dresses | VARCHAR |
| work_date | DATE |
| username | VARCHAR |

---

# REST APIs

The application uses Oracle APEX REST APIs for backend communication.

## Available APIs

- Delete Transactions
- Get Date
- Get Total By Date
- Get Transactions By Day
- Get Users

---

# Application Workflow

1. User logs into the application
2. Transactions are added daily
3. Income is recorded in multiple currencies
4. Dresses/costumes used are stored
5. Daily totals are calculated automatically
6. Data is fetched and managed through REST APIs

---

# Project Goals

This project was created to simplify financial tracking and daily management for photography stores and studios.

---

# Future Improvements

- Advanced state management (Provider / Bloc)
- Analytics dashboard
- Currency conversion support
- Export reports to PDF/Excel
- Cloud backup
- Role-based access control

---

# Author

Developed using Flutter, Dart, Oracle Autonomous Database, and Oracle APEX REST APIs.

### Screenshots

 - Login Screen
<img width="500" height="1000" alt="Screenshot_2026-06-04-00-49-50-97_6c7c709e96bff5c0b1bd62e76de66eab" src="https://github.com/user-attachments/assets/a6e3e344-f0d7-4695-b9aa-45a9d98789bd" />

 - Add Transaction Screen
<img width="500" height="1000" alt="Screenshot_2026-06-04-00-51-26-82_6c7c709e96bff5c0b1bd62e76de66eab" src="https://github.com/user-attachments/assets/098e3678-9287-45a0-bea2-7cba429172b7" />

 - days
<img width="500" height="1000" alt="Screenshot_2026-06-04-00-52-41-09_6c7c709e96bff5c0b1bd62e76de66eab" src="https://github.com/user-attachments/assets/860fd309-74fa-4272-8a49-a5234cb18bee" />

 - Home Dashboard
<img width="500" height="1000" alt="Screenshot_2026-06-04-00-52-46-49_6c7c709e96bff5c0b1bd62e76de66eab" src="https://github.com/user-attachments/assets/18820e5b-3a1e-436e-a79c-5e34cf37b0ae" />

 - Daily Income Summary
<img width="500" height="1000" alt="Screenshot_2026-06-04-00-52-50-76_6c7c709e96bff5c0b1bd62e76de66eab" src="https://github.com/user-attachments/assets/cc5ec13f-5442-4331-9249-9626215a410a" />

<img width="500" height="1000" alt="Screenshot_2026-06-04-00-52-17-57_6c7c709e96bff5c0b1bd62e76de66eab" src="https://github.com/user-attachments/assets/05326422-06a9-4893-8d38-1f4d3c2d342c" />


