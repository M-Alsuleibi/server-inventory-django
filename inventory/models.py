from django.db import models

# Create your models here.

class Server(models.Model):
    STATUS_CHOICES = [
        ('running', 'Running'),
        ('stopped', 'Stopped'),
    ]

    hostname   = models.CharField(max_length=255, unique=True)
    ip_address = models.GenericIPAddressField(unique=True)
    status     = models.CharField(max_length=10, choices=STATUS_CHOICES, default='stopped')
    created_at = models.DateTimeField(auto_now_add=True)

    def start(self):
        self.status = 'running'
        self.save()

    def stop(self):
        self.status = 'stopped'
        self.save()

    def toggle(self):
        if self.status == 'running':
            self.stop()
        else:
            self.start()

    def __str__(self):
        return f"{self.hostname} ({self.ip_address}) — {self.status}"

    class Meta:
        ordering = ['hostname']