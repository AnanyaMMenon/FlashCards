# 🧠 FlashCards App

A multi-page Flutter app that lets users create, edit, and manage decks of two-sided flashcards. Each flashcard has a question on one side and an answer on the other, and users can quiz themselves using any selected deck.

All data is persisted locally using SQLite, and the app is fully responsive across different screen sizes.

---

## ✨ Features

- Create, edit, and delete flashcard decks
- Add, edit, sort, and delete individual flashcards
- Load a starter set of decks/cards from a JSON file
- Quiz mode for reviewing flashcards from a selected deck
- Persistent storage using SQLite
- Fully responsive design

---

## 📱 Pages & Functionality

### 🔹 Deck List Page
- Scrollable list of decks with card counts
- Buttons to create a new deck or import from JSON
- Tapping a deck opens its flashcards
- Edit/delete decks easily with secondary controls

### 🔹 Deck Editor
- Edit the title of a deck
- Option to delete the deck (deletes all associated cards)

### 🔹 Card List Page
- Scrollable list of cards in the selected deck
- Sort cards by creation order or alphabetically
- Option to navigate to quiz mode

### 🔹 Card Editor
- Edit question and answer fields
- Option to delete the card

### 🔹 Quiz Mode
- Randomly shuffled flashcards
- Flip to see answers
- Navigate forward/backward through shuffled cards
- Track how many cards and answers have been reviewed

---

## 📐 Responsive Design

- Mobile-first layout with adaptive components for larger screens
- Deck and card list pages combine on wider screens
- Quiz page scales based on available space to prioritize flashcard display
