import pandas as pd
from pymongo import MongoClient

# ======= KONEKSI KE MONGODB ========
client = MongoClient("mongodb://localhost:27017/")
db = client["diabetes"]             
collection = db["pasien"]           
    
# ======= BACA CSV =========
csv_file = "diabetes.csv"           
df = pd.read_csv(csv_file)

# ======= KONVERSI DAN INSERT =======
data = df.to_dict(orient="records") 
collection.insert_many(data)        

print(f"Berhasil import {len(data)} data ke MongoDB!")
