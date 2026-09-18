# QuestTable

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Matteo-Marcoccia_QuestTable&metric=alert_status)](https://sonarcloud.io/project/overview?id=Matteo-Marcoccia_QuestTable)
[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=Matteo-Marcoccia_QuestTable&metric=ncloc)](https://sonarcloud.io/project/overview?id=Matteo-Marcoccia_QuestTable)

Java desktop & CLI application designed for Board Game Cafés. The implementation focuses on the core use case: **Table & Seat Reservation ("Prenota Posto")**, including table availability search, booking management, and loyalty point calculation.

---

## 📌 Implemented Scope & Features

- **Focused Use Case:** End-to-end implementation of the **Prenota Posto** (Book Seat/Table) workflow.
- **Dual User Interface:** Full graphic support via JavaFX and alternative Command-Line Interface (CLI).
- **Flexible Persistence:** Seamlessly switch between In-Memory Demo, File System (CSV/Serialization), and MySQL Database.
- **Availability Check:** Real-time seat and table filtering based on date, time slots, and party size.
- **Loyalty Rewards:** Automated point calculation and loyalty tracking upon reservation.

---

## 🏗️ Architecture & Design Patterns

The project follows the **MVC (Model-View-Controller)** pattern and **Boundary-Control-Entity (BCE)** architecture to ensure strict separation of concerns, decoupling presentation, application logic (`PrenotaPostoControllerApplicativo`), and domain state.

Key Gang of Four (GoF) design patterns implemented:
- **Factory:** Utilized via `DAOFactory` to instantiate the appropriate Data Access Objects based on the selected persistence layer (In-Memory Demo, File System, or MySQL).
- **Singleton:** Utilized via `SessionManagerSingleton` to maintain a single, consistent user session state across the application lifecycle.

---

## 🛠️ Tech Stack

- **Language:** Java 21 (LTS)
- **GUI:** JavaFX (OpenJFX 21)
- **Database:** MySQL
- **Build & Dependency Management:** Apache Maven
- **Testing:** JUnit 5
- **Static Analysis & CI/CD:** SonarCloud, GitHub Actions

---

## 📄 Documentation

The comprehensive project specification, architectural diagrams, and test plans are available in the repository:

- 📖 [Project Documentation (PDF)](docs/QuestTable.pdf)

---

## 🚀 Getting Started

### Prerequisites

- Java Development Kit (JDK) 21+
- Apache Maven 3.8+
- MySQL Server (optional, only required if selecting MySQL persistence)

### Installation & Run

1. Clone the repository:
```bash
   git clone https://github.com/Matteo-Marcoccia/QuestTable.git
```

2. Enter directory and compile:
```bash
   cd QuestTable
   mvn clean compile
```

3. Run the application:
```bash
   mvn javafx:run
```
