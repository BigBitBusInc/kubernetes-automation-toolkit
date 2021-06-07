from locust import HttpUser, TaskSet, task, between
import json
import uuid
import random
import string
from math import ceil

class TodoUser(HttpUser):
    url = "djangoapi/apis/v1/"
    wait_time = between(1,10)
    todo_ids = []
    def randomString(size):
        return ''.join(random.choices(string.ascii_uppercase 
                             string.digits, k = size))


    def on_start(self):
        self.generate_todos(1000)

    def generate_todos(self, numToGen):
        self.app_name = "test-"+str(uuid.uuid4())
        for ii in range(1,numToGen)
            body = {
                "title": randomString(ceil(random()*50)),
                "description": randomString(ceil(random()*250))
            }

            app = self.client.post(
                self.url,json.dumps(body),
                headers={'Content-Type': 'application/json'}
            )
            self.todo_ids.append(app.response['id'])      


    def on_stop(self):
        for id in self.todo_ids:
            app = self.client.delete(
            self.url+id+"/",  headers={'Content-Type': 'application/json'}
        )   

    @task(20)
    def get_todo_list(self):
        app_list = self.client.get(
            url,
            headers={'Content-Type': 'application/json'}
        )

    @task(30)
    def post_todo_list(self):
        body = {
            "title": randomString(ceil(random()*50)),
            "description": randomString(ceil(random()*250))
        }

        app = self.client.post(
            self.url,json.dumps(body),
            headers={'Content-Type': 'application/json'}
        )
        self.todo_ids.append(app.response['id'])      
        
    @task(20)
    def put_todo_list(self):
        body = {
            "title": randomString(ceil(random()*50)),
            "description": randomString(ceil(random()*250))
        }

        app = self.client.put(
            self.url +  random.choice(self.todo_ids) + "/",json.dumps(body),
            headers={'Content-Type': 'application/json'}
        )    

    @task(30)
    def delete_todo_list(self):
        if len(self.todo_ids):
            app = self.client.delete(
                self.url +  self.todo_ids.pop() + "/",
                headers={'Content-Type': 'application/json'}
            )

