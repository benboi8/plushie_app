from fastapi import FastAPI, Depends
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session

app = FastAPI()

DATABASE_URL = "sqlite:////home/benboi8/plush.db"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class Item(Base):
    __tablename__ = "plush"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(String)

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def search(search_terms: dict, db: Session):
    print(type(vars))
    print(vars)
    # process search_terms
    if search_terms != dict:
        return ["Search Terms not a Dict"]
    
    name = search_terms["name"]

    results = db.query (Item).filter(Item.name.contains(name)).all()
    if results:
        return results
    return []

@app.post("/plush/")
def read_items(request: dict, db: Session = Depends(get_db)):
    if request["function"] == "search":
        return {"message": "Search results", "data": search(request["vars"], db)}
    else:
        return {"message": "POST route works", "data": request}
