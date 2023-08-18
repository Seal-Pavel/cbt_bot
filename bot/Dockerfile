FROM python:3.9

WORKDIR /bot

COPY image_requirements.txt .
RUN pip install --no-cache-dir -r image_requirements.txt

COPY . .

CMD ["python", "app.py"]
