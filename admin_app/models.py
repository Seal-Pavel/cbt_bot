from django.db import models


class User(models.Model):
    user_id = models.AutoField(primary_key=True)
    user_tg_id = models.BigIntegerField(unique=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100, blank=True, null=True)
    nickname = models.CharField(max_length=100, blank=True, null=True)
    created_on = models.DateTimeField(auto_now_add=True)
    last_activity = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.nickname or self.first_name


class Chat(models.Model):
    chat_id = models.AutoField(primary_key=True)
    chat_tg_id = models.BigIntegerField(unique=True)
    users = models.ManyToManyField(User, related_name="chats")
    type = models.CharField(max_length=50)
    title = models.CharField(max_length=200, blank=True, null=True)
    created_on = models.DateTimeField(auto_now_add=True)
    last_activity = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.title or str(self.chat_id)
