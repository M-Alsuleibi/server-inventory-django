from django.contrib import admin
from .models import Server

# Register your models here.

@admin.register(Server)
class ServerAdmin(admin.ModelAdmin):
    list_display  = ['hostname', 'ip_address', 'status', 'created_at']
    list_filter   = ['status']
    search_fields = ['hostname']
    ordering      = ['hostname']