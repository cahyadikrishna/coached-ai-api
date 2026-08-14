# AI Coach Assistant

A Ruby on Rails (API-only) backend that connects to the Strava API to pull a user's logged activities, uses the DeepSeek API to generate personalized AI coaching summaries and sport recommendations, and stores weekly summaries in a Supabase PostgreSQL database.

## Tech Stack

- **Ruby** 3.4.10
- **Rails** 8.1 (API-only)
- **PostgreSQL** (Supabase)
- **Faraday** — HTTP client for the Strava API
- **ruby-openai** — OpenAI-compatible client pointed at DeepSeek

## Features

- Strava OAuth 2.0 connect + callback flow.
- Automatic refresh of expired Strava access tokens.
- Fetch a user's activities (last 7 days) and activity details from Strava.
- Generate a weekly AI coaching summary via DeepSeek and persist it as a `WeeklySummary`.
- Public sport-recommendation endpoint powered by DeepSeek (no auth required).

## Requirements

- Ruby 3.4.10
- PostgreSQL (Supabase project)
- A Strava API application
- A DeepSeek API key

## Setup

```bash
bundle install
cp .env.example .env   # then fill in your credentials
bin/rails db:prepare
bin/rails server
```

### Environment Variables

Create a `.env` file (see `.env.example`) with the following variables:

| Variable                | Description                                          |
| ----------------------- | ---------------------------------------------------- |
| `DATABASE_URL`          | Supabase PostgreSQL connection string                |
| `STRAVA_CLIENT_ID`      | Strava API application client ID                     |
| `STRAVA_CLIENT_SECRET`  | Strava API application client secret                 |
| `STRAVA_REDIRECT_URI`   | OAuth callback URL, e.g. `http://localhost:3000/auth/strava/callback` |
| `DEEPSEEK_API_KEY`      | DeepSeek API key                                     |
| `DEEPSEEK_MODEL`        | DeepSeek model name (optional, defaults to `deepseek-chat`) |

## Database

```bash
bin/rails db:migrate
```

### Models

- **User** — `strava_id`, `access_token`, `refresh_token`, `token_expires_at`.
- **WeeklySummary** — belongs to `User`; `start_date`, `end_date`, `metrics` (jsonb), `content`.

## API Endpoints

### Health

| Method | Path  | Description         |
| ------ | ----- | ------------------- |
| GET    | `/up` | Health check        |

### Strava OAuth

| Method | Path                    | Description                              |
| ------ | ----------------------- | ---------------------------------------- |
| GET    | `/auth/strava`          | Redirect to Strava authorization         |
| GET    | `/auth/strava/callback` | Exchange code for tokens, save the user  |

### Activities (requires auth)

| Method | Path             | Description                          |
| ------ | ---------------- | ------------------------------------ |
| GET    | `/activities`    | Last 7 days of activities            |
| GET    | `/activities/:id`| Details for a single activity        |

### Weekly Summaries (requires auth)

| Method | Path                 | Description                                     |
| ------ | -------------------- | ----------------------------------------------- |
| GET    | `/weekly_summaries`  | List the user's summaries                       |
| POST   | `/weekly_summaries`  | Generate + persist a summary via `AiCoachService` |

### Recommendations (public, no auth)

| Method | Path               | Description                                       |
| ------ | ------------------ | ------------------------------------------------- |
| POST   | `/recommendations` | Sport recommendation based on personal profile    |

## Authentication

Protected endpoints resolve the user via a bearer token that is the user's Strava ID:

```
Authorization: Bearer <strava_id>
```

## Usage Examples

### 1. Connect a Strava account

Open `GET /auth/strava` in a browser, authorize, and the callback saves the user.

### 2. Fetch activities

```bash
curl -H "Authorization: Bearer <strava_id>" localhost:3000/activities
```

### 3. Generate a weekly summary

```bash
curl -X POST -H "Authorization: Bearer <strava_id>" localhost:3000/weekly_summaries
```

### 4. Get a sport recommendation (no auth)

```bash
curl -X POST localhost:3000/recommendations \
  -H "Content-Type: application/json" \
  -d '{"age":30,"gender":"male","daily_activity":"desk job, walks 20 min daily","latest_fitness":"occasional 5k runs"}'
```

## Project Structure

```
app/
  controllers/
    sessions_controller.rb          # Strava OAuth flow
    activities_controller.rb        # Strava activity endpoints
    weekly_summaries_controller.rb  # AI weekly summary endpoints
    recommendations_controller.rb   # Public sport recommendation endpoint
  models/
    user.rb
    weekly_summary.rb
  services/
    deepseek_client.rb              # Shared DeepSeek OpenAI::Client wrapper
    strava_service.rb               # Strava API (auto token refresh)
    ai_coach_service.rb             # Aggregates activities + generates summary
    sport_recommendation_service.rb # DeepSeek sport recommendation
```

## Tests

```bash
bin/rails test
```

## Deployment

The project is Docker/Kamal-ready (see `Dockerfile` and `.kamal/`).
