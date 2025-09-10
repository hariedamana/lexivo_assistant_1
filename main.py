from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pyphen
from transformers import pipeline
import threading

# Initialize FastAPI
app = FastAPI()

# Initialize Pyphen for syllable splitting
dic = pyphen.Pyphen(lang='en')

# Global variable for the simplification pipeline
simplify_pipeline = None
model_loading = False

# Pydantic Models
class WordInput(BaseModel):
    word: str

class TextInput(BaseModel):
    text: str

# Function to load model in a separate thread
def load_model():
    global simplify_pipeline, model_loading
    try:
        simplify_pipeline = pipeline(
            "summarization",
            model="facebook/bart-large-cnn"
        )
        model_loading = True
        print("Simplification model loaded successfully.")
    except Exception as e:
        simplify_pipeline = None
        print(f"Error loading model: {e}")

# Endpoint for syllable breakdown
@app.post("/syllables")
async def get_syllables(input: WordInput):
    word = input.word.strip().lower()
    if not word.isalpha():
        raise HTTPException(status_code=400, detail="Please enter a valid word (letters only)")
    
    syllabified = dic.inserted(word)
    syllables = syllabified.split("-")
    
    return {
        "word": word,
        "syllables": syllables,
        "syllable_count": len(syllables)
    }

# Endpoint for text simplification
@app.post("/simplify")
async def simplify_text(input: TextInput):
    global simplify_pipeline, model_loading
    
    if simplify_pipeline is None and not model_loading:
        # Start model loading in a background thread
        threading.Thread(target=load_model).start()
        raise HTTPException(status_code=503, detail="Model is loading, please try again in a few seconds.")

    if simplify_pipeline is None and model_loading:
        raise HTTPException(status_code=503, detail="Model is still loading, please wait...")

    text = input.text.strip()
    if not text:
        raise HTTPException(status_code=400, detail="Text cannot be empty.")
    
    try:
        # Summarize and simplify the text
        result = simplify_pipeline(
            text,
            max_length=60,  # Adjust length depending on desired summary
            min_length=15,
            do_sample=False
        )
        simplified = result[0]['summary_text']
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Model error: {str(e)}")
    
    return {
        "original": text,
        "simplified": simplified
    }
