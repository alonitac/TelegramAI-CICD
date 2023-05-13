FROM python:3.8.12-slim-buster
WORKDIR /app
ARG ENV
COPY . .
RUN pip install -r bot/requirements.txt

CMD ["python3", "-m", "bot.app"]