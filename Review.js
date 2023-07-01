import requests
import random
import time

API_KEYS = ["API_KEY_1", "API_KEY_2", "API_KEY_3"]  # Replace with your API keys
PLACE_ID = "PLACE_ID_OF_THE_RESTAURANT"

REVIEW_TEXTS = [
    "Great food and service!",
    "Excellent place to dine!",
    "Highly recommended!",
    "Delicious food and friendly staff!",
    "Amazing experience!",
    "Top-notch quality!",
    "Outstanding service!",
    "Lovely ambiance and tasty dishes!"
]

def submit_review(api_key, text):
    url = f"https://maps.googleapis.com/maps/api/place/addreview/json?key={api_key}"
    review_data = {
        "language": "en",
        "place_id": PLACE_ID,
        "rating": 5,
        "text": text
    }

    response = requests.post(url, json=review_data)

    if response.status_code == 200:
        print("Review submitted successfully!")
    else:
        print("Failed to submit the review.")

# Submit the review every hour, 8 times
for i in range(8):
    api_key = random.choice(API_KEYS)
    review_text = random.choice(REVIEW_TEXTS)
    submit_review(api_key, review_text)
    if i < 7:
        print("Waiting for the next hour...")
        time.sleep(3600)  # Wait for 1 hour (3600 seconds)

print("Review submission completed.")
