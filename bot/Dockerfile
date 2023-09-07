FROM python:3.9

WORKDIR /bot

COPY requirements_bot.txt .
RUN pip install --no-cache-dir -r requirements_bot.txt

COPY . .

CMD ["python", "app.py"]
