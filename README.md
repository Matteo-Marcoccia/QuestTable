# QuestTable

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Matteo-Marcoccia_QuestTable&metric=alert_status)](https://sonarcloud.io/project/overview?id=Matteo-Marcoccia_QuestTable)
[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=Matteo-Marcoccia_QuestTable&metric=ncloc)](https://sonarcloud.io/project/overview?id=Matteo-Marcoccia_QuestTable)

**[⬇️ Download the Windows demo](https://github.com/Matteo-Marcoccia/QuestTable/releases/tag/v1.0.0)**

Download the ZIP from the release assets, extract it, and open `QuestTable.exe`. **Java is included — no Maven or database setup required.** Windows x64.

A Java application for reserving seats at a **Board Game Café**, with a JavaFX desktop interface and a command-line interface (CLI).

Developed by **Matteo Marcoccia** for the **ISPW course at the University of Rome Tor Vergata**, academic year **2025–2026**. The project demonstrates separation of presentation and business logic, interchangeable persistence implementations, and automated testing through the **“Prenota posto al tavolo” (Reserve a seat at a table)** use case.

## 📌 Implemented features

- **Customer and manager access:** login, logout, and operations restricted by user role.
- **Table search:** browse available game sessions and filter by game title and day of the week.
- **Booking quote:** select the number of seats and calculate the total price and expected loyalty points.
- **Simulated payment:** choose a payment method and type `paga` to complete the simulation. No external payment service is contacted.
- **Manager approval:** new bookings remain pending until the manager confirms them.
- **Loyalty points:** customers receive 10 points per euro when the manager confirms a booking.
- **Booking history:** customers can view their bookings and confirmation status.
- **Two interfaces:** JavaFX and CLI share the same application controllers and domain logic. The application UI is in Italian.

### Booking workflow

1. The customer logs in, searches for a table, and selects the number of seats.
2. The application calculates a quote from the table's per-person fee.
3. After simulated payment, seats are deducted and the booking is saved as `IN_ATTESA` (pending).
4. The manager logs in and confirms the booking.
5. The booking becomes `CONFERMATA` (confirmed), loyalty points are credited, and a message is queued for the customer.

Customer messages are held in memory and displayed when the customer returns to the relevant interface, for example after logging in again within the same application run. They are not email or push notifications.

### Scope

This academic prototype implements the seat reservation use case. The broader specification also describes a game shop, spending loyalty points, and requesting new tables; those features are not implemented. Account registration, Google login, and PDF ticket export are also outside the current implementation.

Game sessions use a **day of the week and a time slot**, rather than a specific calendar date. The booking date records when the request was created.

## 🏗️ Architecture and design patterns

The code separates the responsibilities of **Boundary, Control, and Entity (BCE)**:

| Layer | Responsibility |
| --- | --- |
| `view/javafx` and `view/cli` | User interaction, presentation, and navigation |
| `bean` | Data exchanged between the interfaces and application controllers |
| `controller` | Login and reservation use-case coordination |
| `model` | Domain entities, booking state, seat availability, and loyalty rules |
| `dao` | Data access interfaces and persistence implementations |
| `session` | Authenticated sessions and role checks |
| `service` | In-process booking communications |

- **Abstract Factory:** `DAOFactory` supplies a matching family of user, table-session, and booking DAOs for the selected persistence mode.
- **Singleton:** `SessionManagerSingleton` provides one session manager per application process. It manages multiple authenticated users, with at most one active session per username in that process.

### Persistence options

The persistence mode is selected at startup:

| Mode | Storage | Setup |
| --- | --- | --- |
| Demo | In-memory data, reset on restart | No database required; includes sample users, tables, and pending bookings |
| File system | CSV files in `data/file_system/` | Missing files are initialized automatically with sample users and tables; the booking archive starts empty |
| MySQL | Relational database | Requires MySQL and the supplied initialization script |

## 🛠️ Technology stack

- Java 21
- JavaFX / OpenJFX 21 and FXML
- MySQL with JDBC
- Apache Maven
- JUnit 5 and JaCoCo
- GitHub Actions for continuous integration and SonarCloud for static analysis

## 🖥️ Run the Windows demo without installing Java

The portable Windows x64 package includes Java and the application dependencies. To use a built package:

1. Extract the entire `QuestTable-1.0.0-windows-x64.zip` archive.
2. Open `QuestTable.exe` inside the extracted `QuestTable` folder.
3. Log in with a sample account listed below.

The main executable starts the JavaFX demo directly. No Java installation, Maven, database, or internet connection is needed. Keep the `app` and `runtime` folders alongside the executable. Demo data resets when the app closes.

`QuestTable-Console.exe` provides the original startup menus for choosing the interface and persistence mode. MySQL still requires the optional setup described below.

### Build a portable package

On Windows x64, with JDK 21 and Maven available, run from the repository root in PowerShell:

```powershell
./scripts/package-windows.ps1
```

Set `JAVA_HOME` to the JDK 21 directory. The script runs verification, collects dependencies, and uses `jpackage` to bundle the app and its Java runtime. It prints the ZIP location under `target/windows-package/` and generates a SHA-256 checksum beside it. No installer tooling is required.

The manually triggered **Package Windows demo** GitHub Actions workflow also builds the ZIP and saves it as a workflow artifact. For public distribution, attach the ZIP and checksum to a GitHub Release; the workflow does not publish a release automatically.

## 🚀 Getting started from source

### Requirements

- **JDK 21**
- **Apache Maven**
- A Java IDE with Maven support, such as IntelliJ IDEA
- MySQL Server 8.0+ only if using MySQL persistence

### Build

```bash
git clone https://github.com/Matteo-Marcoccia/QuestTable.git
cd QuestTable
mvn clean compile
```

### Run from the IDE

1. Open the cloned directory as a Maven project and let the IDE load its dependencies.
2. Set the project SDK to **JDK 21**.
3. Run the `main` method in `src/main/java/com/questtable/main/AvvioQuestTable.java`, with the repository root as the working directory.
4. In the run console, choose a persistence mode: `1` Demo, `2` File system, or `3` MySQL.
5. Choose an interface: `1` JavaFX or `2` CLI.

For a first walkthrough, select **Demo**. Both startup choices are entered in the console, including when launching the graphical interface.

### Sample accounts

These accounts are supplied by the demo data, the initial CSV data, and the MySQL initialization script:

| Role | Username | Password |
| --- | --- | --- |
| Customer | `matteo` | `1234` |
| Customer | `erik` | `1234` |
| Manager | `admin` | `admin` |

To try the full workflow, book seats as a customer, log out, log in as the manager and confirm the booking, then log back in as the customer to see the updated status and points. Keep the application running throughout the demo.

### Optional MySQL setup

1. Run [`database/mysql/questtable.sql`](database/mysql/questtable.sql) against a local MySQL server to create the database, tables, and sample data.
2. Adjust the connection constants in [`PersistenceConfig.java`](src/main/java/com/questtable/config/PersistenceConfig.java) to match your local setup. The supplied defaults target `jdbc:mysql://localhost:3306/questtable`, with username `root` and password `MySQL`.
3. Start the application and select **MySQL** persistence.

The SQL script populates sample data and overwrites matching sample records when rerun; use it to initialize a demonstration database.

## 🧪 Tests and continuous integration

Run the unit tests:

```bash
mvn test
```

Build the project, run tests, and generate the JaCoCo coverage report:

```bash
mvn verify
```

The HTML report is generated at `target/site/jacoco/index.html`.

The test suite covers bean validation, login and session checks, reservation controller behavior using demo persistence, and domain rules. It does not include automated GUI tests or integration tests for CSV and MySQL persistence; those interface and persistence implementations are also excluded from the coverage report.

GitHub Actions runs verification and SonarCloud analysis on pushes to `main` and on pull request creation, updates, and reopening. The workflow does not deploy the application.

## 📄 Project documentation

The [project report (PDF)](docs/QuestTable.pdf) contains the academic specification, storyboards, UML diagrams, and testing overview. Some sections describe the broader planned system or earlier design iterations; the implemented scope and workflow are described above.
