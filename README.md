# PostgreSQL: swap partitions test - Docker Compose Project 

This project demonstrates a multi-service setup using Docker Compose, including a Node.js application, PostgreSQL database, and scripts for managing partitioning in PostgreSQL. Below is an overview of the project structure and its key functionalities.

---

## **Project Structure**

```
├── .gitignore                # Ignored files for Git
├── LICENSE                   # License information
├── node-app                  # Node.js application directory
│   ├── dockerfile            # Dockerfile for Node.js application
│   ├── index.js              # Entry point of the Node.js application
│   ├── node_modules          # Node.js dependencies (excluded in Git)
│   ├── package.json          # Node.js project configuration
│   └── yarn.lock             # Yarn lockfile for dependency management
├── package.json              # Root package.json for additional dependencies
├── README.md                 # Project README file
└── scripts                   # SQL scripts for partition testing
    ├── partitionSwapTest_1.sql
    ├── partitionSwapTest_2.sql
    ├── partitionSwapTest_3.sql
    └── README.md             # README for SQL script usage
```

---

## **Services**

### **1. Node.js Application**
- The `node-app` directory contains a simple Express.js server that connects to a PostgreSQL database.
- Key functionalities:
  - Database connection using Sequelize.
  - API endpoints for creating and querying records.

### **2. PostgreSQL Database**
- A PostgreSQL instance is used as the backend database for managing partitioned tables.
- Data insertion, partition management, and query operations are demonstrated.

### **3. Partition Management Scripts**
- The `scripts` directory contains SQL scripts for testing partitioning strategies:
  - `partitionSwapTest_1.sql`: Implements the temporary partition approach.
  - `partitionSwapTest_2.sql`: Demonstrates range-based partitioning.
  - `partitionSwapTest_3.sql`: Illustrates dynamic range partitioning with auto-creation.

---

## **Setting Up the Project**

### **1. Prerequisites**
- Docker and Docker Compose installed on your system.
- Yarn package manager (optional).

### **2. Running the Project**

To set up and run the project, use the following commands:

```bash
# Start services using Docker Compose
docker-compose up -d

# Build services without using cache
docker-compose build --no-cache
```

### **3. Accessing Services**
- **Node.js API**: Accessible at `http://localhost:3000`
- **PostgreSQL**: Connect using a database client (e.g., DBeaver) with the following credentials:
  - Host: `localhost`
  - Port: `5432`
  - Username: `test_user`
  - Password: `test_password`
  - Database: `test_db`

---

## **Partitioning Strategies**
The project demonstrates three partitioning strategies:

### **1. Temporary Partition (Approach 1)**
- Uses `LIST` partitioning.
- Temporary partitions are created for updates.
- Old partitions are swapped and dropped.

### **2. Range-Based Partitioning (Approach 2)**
- Partitions are created for ranges of IDs.
- Data is migrated from a default partition when necessary.

### **3. Dynamic Range Partitioning (Approach 3)**
- Dynamically creates partitions when new ranges are needed.
- Reduces manual intervention.

For more details, refer to the `scripts` directory and its `README.md`.

---

## **Development Notes**
- Ensure `.env` or environment variables are set for database credentials.
- Use the SQL scripts to test partitioning logic in PostgreSQL.

---

## **License**
This project is licensed under the terms specified in the `LICENSE` file.

