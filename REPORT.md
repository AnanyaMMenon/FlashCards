# MP Report

## Team

- Name(s): Ananya Menon
- AID(s): A20538657

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
- [X] Decks can be created, edited, and deleted
- [X] Cards can be created, edited, sorted, and deleted
- [X] Quizzes work correctly
- [X] Decks and Cards can be loaded from the JSON file
- [X] Decks and Cards are saved/loaded correctly from/to a SQLite database
- [X] The UI is responsive to changes in screen size

## Summary and Reflection

Implementation Decisions & Notes:
I structured the app using the standard Flutter architecture with a separation of concerns between UI, logic, and data. I used Provider for state management to keep the app responsive and modular. SQLite (via sqflite) was used to persist flashcard data locally. I focused on simplicity and reusability when designing components like flashcard tiles and category cards. One limitation I encountered was with handling custom user input for new decks — the UI is in place, but the saving logic could use refinement. Everything else works as expected, including deck switching, quiz mode, and answer reveal animations.

Reflection:
I really enjoyed building the interactive flashcard system, especially working with Flutter's widget system and animations. Designing the UI to feel intuitive and polished was satisfying. The biggest challenge was debugging some state updates tied to asynchronous DB operations — I wish I had started with mock data before integrating storage. I also learned a lot about clean state management and asset optimization through this MP.
