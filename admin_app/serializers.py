from django.utils import timezone

from rest_framework import serializers

from .models import Chat, User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'
        read_only_fields = ['user_id', 'created_on', 'last_activity']

    def create(self, validated_data):
        user_tg_id = validated_data['user_tg_id']
        user, created = User.objects.get_or_create(user_tg_id=user_tg_id, defaults=validated_data)
        user.last_activity = timezone.now()

        if not created:
            user_fields = ['first_name', 'last_name', 'nickname']
            for field in user_fields:
                if getattr(user, field) != validated_data[field]:
                    setattr(user, field, validated_data[field])
            user.save()

        return user


class ChatSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chat
        fields = '__all__'
        read_only_fields = ['chat_id', 'created_on', 'last_activity']

    def to_internal_value(self, data):
        user_data = {
            'user_tg_id': data['message']['from']['id'],
            'first_name': data['message']['from']['first_name'],
            'last_name': data['message']['from'].get('last_name'),
            'nickname': data['message']['from'].get('username'),
        }
        chat_data = {
            'chat_tg_id': data['message']['chat']['id'],
            'type': data['message']['chat']['type'],
            'title': data['message']['chat'].get('title'),
        }
        return {'user': user_data, 'chat': chat_data}

    def create(self, validated_data):
        user_data = validated_data['user']
        chat_data = validated_data['chat']

        user, user_created = User.objects.get_or_create(user_tg_id=user_data['user_tg_id'], defaults=user_data)
        chat, chat_created = Chat.objects.get_or_create(chat_tg_id=chat_data['chat_tg_id'], defaults=chat_data)

        if not chat_created:
            chat_fields = ['type', 'title']
            for field in chat_fields:
                if getattr(chat, field) != validated_data[field]:
                    setattr(chat, field, validated_data[field])
            chat.save()

        chat.users.add(user)
        return chat
