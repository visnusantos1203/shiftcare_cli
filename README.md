# Shiftcare CLI

Shiftcare CLI is a command-line tool built with Ruby and Thor that allows users to search for clients by name and detect duplicate emails from a JSON data file.

## 📌 Prerequisites

Ensure you have the following installed:
- Ruby (>= 2.7)
- Bundler

## 🔧 Installation

1. Clone this repository:
   ```sh
   git clone https://github.com/visnusantos1203/shiftcare-cli.git
   cd shiftcare-cli
   ```
2. Install dependencies:
   ```sh
   bundle install
   ```

## 🚀 Usage

### 1️⃣ Finding Duplicate Emails
Detects and displays clients with duplicate email addresses:
```sh
ruby shiftcare_cli.rb duplicate_emails
```

### 2️⃣ Searching for Clients by Name
Performs a case-insensitive search for clients whose full name partially matches the given input:
```sh
ruby shiftcare_cli.rb search "Alice"
```

## 📝 Assumptions
- The client data is stored in a file named `clients.json` in the same directory as `shiftcare_cli.rb`.
- Each client entry has a `full_name` and `email` field.
- Some `full_name` values may be missing (handled safely in search).
- Special characters in search queries (e.g., `.` or `*`) should be treated as plain text, not regex.

## ✅ Running Tests
To run the RSpec tests:
```sh
rspec spec/shiftcare_cli_spec.rb
```


