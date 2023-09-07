from rest_framework import generics

from serializers import ChatSerializer


class ChatCreateView(generics.CreateAPIView):
    serializer_class = ChatSerializer
