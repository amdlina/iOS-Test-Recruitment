# REFLECTION.md

## Overview

This project is an iOS application built in SwiftUI that displays a list
of classified ads retrieved from a local API. Users can browse listings,
filter them by category, and view detailed information for each item.

The goal of this implementation was to deliver a clean, maintainable,
and testable application that respects the core requirements while
providing a smooth and understandable user experience.

During development, I focused on:

-   building a simple and testable architecture
-   managing UI states clearly (loading, error, empty)
-   keeping responsibilities well separated between layers
-   paying attention to user experience and visual clarity

I also spent time refining the screens to make them readable and
pleasant to use. Even though this is a technical test, I believe that
good UX and clean UI are part of delivering a quality product.

------------------------------------------------------------------------

## Tools Used

I used AI tools (primarily ChatGPT) during development for the following
tasks:

-   discussing architectural approaches
-   validating Swift syntax and best practices
-   generating initial drafts for some components
-   reviewing naming and readability

All generated code was manually reviewed, adjusted, and integrated into
the final solution.

AI was used as a support tool, not as a decision maker.

------------------------------------------------------------------------

## AI Suggestions I Rejected or Reworked

One AI suggestion proposed introducing additional abstraction layers
such as:

-   service layers
-   dependency containers
-   generic data sources

I decided not to implement this because it would add unnecessary
complexity for a small application and reduce readability.

Instead, I kept a simple and explicit structure:

View → ViewModel → Repository → APIClient

This provides clear separation of concerns while remaining easy to
understand and test.

------------------------------------------------------------------------

## Architectural Decisions I Owned

### Repository Pattern

I introduced repositories (`ListingsRepository`, `CategoriesRepository`)
to separate networking logic from UI logic.

This improves:

-   testability
-   readability
-   maintainability

------------------------------------------------------------------------

### URLSession Abstraction

I created a `URLSessionProtocol` to allow mocking network calls.

This enables deterministic unit tests without requiring the API server
to run.

------------------------------------------------------------------------

### ViewModel State Management

The ViewModel owns UI states:

-   loading
-   error
-   empty
-   data

The view simply renders the state.

This keeps the UI predictable and easier to test.

------------------------------------------------------------------------

### Client-Side Category Filtering

Filtering is performed locally because the API does not provide a
category filter parameter.

This keeps the interface responsive and avoids unnecessary network
requests.

------------------------------------------------------------------------

## Why I Introduced a ListingsListContainer

I introduced a ListingsListContainer to coordinate multiple ViewModels and keep the main view focused on UI rendering.

In this screen, both ListingsListViewModel and ClassifiedAdDraftViewModel are required:
    •    one manages the listings data and filtering logic
    •    the other manages the draft state and persistence

Instead of instantiating these ViewModels directly inside the main view, I used a container to handle their creation and lifecycle in one place.

This approach improves:
    •    separation of responsibilities
    •    readability of the main view
    •    scalability if additional dependencies or ViewModels are introduced later

It also keeps the view declarative and focused on displaying state rather than managing object construction.

------------------------------------------------------------------------


## Why I Chose the Draft Feature Instead of Other Bonus Options

I decided to implement the "Draft a Classified Ad" feature instead of
pagination or search.

Reasons:

-   it introduces persistence and state restoration, which are common
    real-world product requirements
-   it demonstrates handling local storage and lifecycle behavior
-   it adds meaningful user value while remaining manageable within the
    project scope

Pagination and search are valuable features, but I prioritized
implementing a feature that showcases user state management and
persistence.

------------------------------------------------------------------------

## User Experience Considerations

I paid attention to the user experience throughout the implementation.

In particular:

-   I ensured loading, error, and empty states are clearly visible
-   I handled missing or failed images gracefully
-   I refined spacing, layout, and readability of the screens
-   I made sure interactions feel predictable

Designing and polishing the screens required time, but I believe this
effort contributes to the overall quality of the application.

------------------------------------------------------------------------

## Testing Strategy

I focused on a small set of deterministic tests covering meaningful
behaviors rather than maximizing coverage.

Examples include:

-   JSON decoding validation
-   request building
-   ViewModel state transitions

Tests do not require the local server to run.

------------------------------------------------------------------------

## What I Would Improve With More Time

### 1) Design system

With more time, I would focus on standardizing the visual design across the application.

In particular, I would introduce a centralized design system to define:
    •    spacing values (padding, margins, layout spacing)
    •    typography sizes
    •    color definitions
    •    reusable layout constants

Currently, spacing and sizing values are defined directly in the views. While this works for a small project, I prefer using shared constants or tokens to ensure consistency and maintainability.

This would make the UI easier to evolve, more consistent visually, and simpler to maintain in the long term.

### 2) Image Caching

With more time, I would introduce an image caching mechanism to improve performance and reduce unnecessary network usage.

Currently, images are fetched from the network each time they appear on screen. While this behavior is acceptable for a small dataset and a technical test environment, implementing caching would significantly improve the user experience, especially when scrolling through lists or reopening previously viewed screens.

A simple in-memory or disk-based cache would allow the application to reuse already downloaded images instead of requesting them again.

This would make the interface more responsive, reduce loading times, and improve network efficiency in real-world usage.

### 3) Retry Policies

With more time, I would also improve the retry behavior for network requests to make the application more resilient to temporary failures.

At the moment, the user can manually retry a failed request, which is sufficient for this scope. However, in a production environment, it is common to automatically retry certain types of errors, such as transient network issues or temporary connectivity loss.

For example, a simple retry strategy with a short delay could help recover from intermittent failures without requiring user intervention.

This would improve reliability and provide a smoother user experience in unstable network conditions

------------------------------------------------------------------------

## Final Reflection

The objective of this project was to demonstrate clear architectural
decisions, clean code structure, and attention to product quality.

I aimed to balance technical correctness, simplicity, and user
experience while staying within the constraints of the assignment.
