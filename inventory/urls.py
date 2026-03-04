from django.urls import path
from . import views

app_name = 'inventory'

urlpatterns = [
    path('servers/',              views.server_list,   name='server_list'),
    path('servers/add/',          views.server_add,    name='server_add'),
    path('servers/<int:pk>/toggle/', views.server_toggle, name='server_toggle'),
    path('servers/<int:pk>/delete/', views.server_delete, name='server_delete'),
]