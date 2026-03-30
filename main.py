import argparse
import json
import sys
import os
from datetime import datetime

# ANSI escape codes for terminal formatting
BOLD = '\033[1m'
GREEN = '\033[92m'
RED = '\033[91m'
CYAN = '\033[96m'
YELLOW = '\033[93m'
RESET = '\033[0m'

DATA_FILE = 'data.json'
STATS_FILE = 'user_stats.json'

def load_json(filepath):
    """Loads a JSON file safely."""
    try:
        with open(filepath, 'r') as file:
            return json.load(file)
    except FileNotFoundError:
        if filepath == DATA_FILE:
            print(f"{RED}Error: {DATA_FILE} not found. Ensure it is in the project root.{RESET}")
            sys.exit(1)
        return [] # Return empty list if stats file doesn't exist yet
    except json.JSONDecodeError:
        print(f"{RED}Error: {filepath} is improperly formatted.{RESET}")
        sys.exit(1)

def save_stats(score, total):
    """Saves quiz performance to a local file for data persistence."""
    stats = load_json(STATS_FILE)
    new_entry = {
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "score": score,
        "total": total,
        "percentage": round((score / total) * 100, 1)
    }
    stats.append(new_entry)
    
    with open(STATS_FILE, 'w') as file:
        json.dump(stats, file, indent=4)

def view_stats():
    """Displays historical quiz performance."""
    stats = load_json(STATS_FILE)
    if not stats:
        print(f"\n{YELLOW}No quiz history found. Take the quiz first!{RESET}\n")
        return
    
    print(f"\n{CYAN}{BOLD}--- Quiz Performance History ---{RESET}")
    for idx, attempt in enumerate(stats[-5:]): # Show last 5 attempts
        print(f"Attempt {idx + 1} ({attempt['timestamp']}): {BOLD}{attempt['score']}/{attempt['total']}{RESET} - {attempt['percentage']}%")
    print(f"{CYAN}--------------------------------{RESET}\n")

def show_timeline(data):
    """Parses and formats chronological events from the dataset."""
    print(f"\n{CYAN}{BOLD}--- The OpenOffice/LibreOffice Timeline ---{RESET}")
    for item in data.get('timeline', []):
        print(f"{YELLOW}{BOLD}{item['year']}{RESET}: {item['event']}")
    print(f"{CYAN}-------------------------------------------{RESET}\n")

def search_topic(query, data):
    """Performs a full-text search across the topics database."""
    query = query.lower().strip()
    found = False
    
    print(f"\n{CYAN}{BOLD}--- Search Results for '{query.upper()}' ---{RESET}")
    
    for key, description in data['topics'].items():
        if query in key.lower() or query in description.lower():
            print(f"\n{BOLD}Topic:{RESET} {key.capitalize()}")
            print(f"{description}")
            found = True
            
    if not found:
        print(f"\n{RED}No matches found for '{query}'.{RESET}")
        print(f"Try searching for concepts like: jca, oracle, fork, mariadb, stewardship.")
        
    print(f"\n{CYAN}--------------------------------------{RESET}\n")

def run_quiz(data):
    """Runs an interactive CLI quiz and saves the score."""
    print(f"\n{CYAN}{BOLD}--- The LibreOffice Case Study Quiz ---{RESET}")
    print("Test your knowledge on open source governance.\n")
    
    score = 0
    total_questions = len(data['quiz'])

    for index, item in enumerate(data['quiz']):
        print(f"{BOLD}Question {index + 1}:{RESET} {item['question']}")
        for option in item['options']:
            print(f"  {option}")
        
        while True:
            answer = input(f"\nYour answer (A/B/C): ").strip().upper()
            if answer in ['A', 'B', 'C']:
                break
            print(f"{RED}Invalid input. Please enter A, B, or C.{RESET}")

        if answer == item['answer']:
            print(f"{GREEN}Correct!{RESET}\n")
            score += 1
        else:
            print(f"{RED}Incorrect. The correct answer was {item['answer']}.{RESET}\n")
            
    print(f"{CYAN}{BOLD}--- Quiz Complete ---{RESET}")
    print(f"Your final score is: {BOLD}{score}/{total_questions}{RESET}\n")
    
    save_stats(score, total_questions)
    print(f"{YELLOW}* Your score has been saved to your local stats file.{RESET}\n")

def main():
    parser = argparse.ArgumentParser(
        description="A comprehensive CLI analytics tool for 'The Fork in the Road' open-source case study."
    )
    
    parser.add_argument('--search', type=str, metavar='KEYWORD', help='Full-text search the case study database')
    parser.add_argument('--timeline', action='store_true', help='View the chronological timeline of events')
    parser.add_argument('--quiz', action='store_true', help='Run the interactive case study quiz')
    parser.add_argument('--stats', action='store_true', help='View your past quiz scores')

    args = parser.parse_args()
    data = load_json(DATA_FILE)

    if args.search:
        search_topic(args.search, data)
    elif args.timeline:
        show_timeline(data)
    elif args.quiz:
        run_quiz(data)
    elif args.stats:
        view_stats()
    else:
        parser.print_help()

if __name__ == "__main__":
    main()