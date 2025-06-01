from locust import HttpUser, task, between
import re

class ToDoUser(HttpUser):
    wait_time = between(1, 5)  
    host = "http://127.0.0.1:8000"  

    def on_start(self):
        #Получаем CSRF токен при запуске пользователя
        response = self.client.get("/create/")
        csrf_token = re.search(r'name="csrfmiddlewaretoken" value="([^"]+)"', response.text)
        if csrf_token:
            self.csrf_token = csrf_token.group(1)
        else:
            self.csrf_token = ""

    @task(3)
    def list_tasks(self):
        self.client.get("/")  

    @task(2)
    def create_task(self):
        # Получаем актуальный CSRF токен
        response = self.client.get("/create/")
        csrf_token = re.search(r'name="csrfmiddlewaretoken" value="([^"]+)"', response.text)
        csrf_value = csrf_token.group(1) if csrf_token else self.csrf_token
        
        self.client.post("/create/", {
            "title": "Test Task",
            "description": "Description from Locust", 
            "csrfmiddlewaretoken": csrf_value
        })  

    @task(1)
    def view_task(self):
        self.client.get("/")  