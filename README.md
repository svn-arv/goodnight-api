# API Good Night

API Good Night is a Ruby on Rails application designed for managing user sleep records and social interactions like following/unfollowing other users. This project serves as a testing ground for an interview scenario and demonstrates clean code practices and functional API design.

## Features

- **Sleep Records**

  - Clock-in and clock-out functionality for tracking sleep sessions
  - View sleep records of users you follow

- **Social Interactions**

  - Follow and unfollow other users
  - View sleep records from people you follow

## Requirements

- Ruby 3.2+
- Rails 7+
- SQLite3

## Setup Instructions

### Clone the Repository

```bash
git clone https://github.com/your-username/goodnight-api.git
cd goodnight-api
```

### Install Dependencies

```bash
bundle install
```

### Set Up the Database

```bash
rails db:setup
```

This will create, migrate, and seed the database.

### Run the Server

```bash
rails server
```

The application will be accessible at `http://localhost:3000`.

## API Endpoints

### Base URL

```
http://localhost:3000
```

### Sleep Records

- **Clock In**: `POST /clock_in?user_id=:id`

  - Creates a new sleep record with start time
  - Optional parameter: `at` for custom start time

- **Clock Out**: `POST /clock_out?user_id=:id&sleep_record_id=:sleep_record_id`
  - Updates a sleep record with end time
  - Optional parameter: `at` for custom end time

### Social Interactions

- **Follow a User**: `POST /follow?user_id=:id`

  - Required parameter: `following_id` - ID of the user to follow

- **Unfollow a User**: `POST /unfollow?user_id=:id`

  - Required parameter: `following_id` - ID of the user to unfollow

- **View Following Sleep Records**: `GET /following_sleep_records?user_id=:id`
  - Returns sleep records from users you follow
  - Records are from the past week, sorted by sleep duration

## Testing

To run the test suite:

```bash
bundle exec rspec
```

## Principles & Architecture

### 1. Separation of Concerns

The application clearly separates different responsibilities:

- **Controllers**: Handle HTTP requests/responses and parameter validation
- **Models**: Define the data structure and relationships
- **Service Objects**: Encapsulate business logic
- **Helpers**: Provide utility functions

This separation makes the codebase more maintainable, as each component has a specific purpose and can be modified independently.

### 2. Service-Oriented Architecture

The application uses a service layer pattern through the `Actions` namespace:

- Actions are organized by domain (e.g., `Actions::SleepRecord`, `Actions::Relationship`)
- Each action is a single-responsibility class (e.g., `ClockIn`, `ClockOut`, `Follow`)
- Service objects return standardized results with success/failure status

This approach makes business logic testable, reusable, and decoupled from the HTTP layer.

### 3. DRY (Don't Repeat Yourself)

Common patterns are abstracted into base classes:

- `Actions::Base` provides shared transaction handling and error management
- Shared scopes in models prevent query duplication
- Helper classes encapsulate cross-cutting concerns

### 4. Single Responsibility Principle

Each class has a clear, focused purpose:

- Controllers are thin and delegate to service objects
- Service objects focus on specific business operations
- Models handle data relationships and validations
- Helper classes provide focused utility functions

### 5. Transaction Safety and Concurrency Control

The application addresses concurrency concerns:

- Database transactions ensure data consistency
- Advisory locks prevent race conditions (e.g., when following/unfollowing users)
- All business operations run in transactions to ensure atomicity

### 6. Consistent Error Handling

The application implements a standardized approach to error handling:

- Service objects capture and return errors consistently
- Controllers handle errors uniformly with appropriate HTTP status codes
- Rescue handlers for common exceptions provide graceful failure modes

### 7. Domain-Driven Design Influences

The code organization reflects the problem domain:

- Services are organized around domain concepts (sleep records, relationships)
- Business rules are encapsulated within the domain services
- Models reflect real-world entities and relationships

### 8. Pagination and Performance Considerations

The application handles potential performance issues:

- Pagination helper for large result sets
- Database-level ordering and filtering
- Indexes on frequently queried columns
- Scopes for common query patterns to leverage database efficiencies

### 9. API-First Design

The application is designed as a pure API:

- Inherits from `ActionController::API` for lightweight controllers
- JSON-based communication
- RESTful resource design with clear resource boundaries

### 10. Security Practices

Several security patterns are present:

- Input validation and parameter sanitization
- Database constraints to enforce data integrity
- Protection against common vulnerabilities like SQL injection through proper ActiveRecord usage

### Future Improvements

- API Versioning
- Migrate to PostgreSQL
- Cache API responses
- Enhanced error handling and validation

## Contributing

This is a recruitment test project. Feel free to fork and modify according to your needs.
