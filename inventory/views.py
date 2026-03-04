from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from .models import Server
from .forms import ServerForm
from django.contrib import messages

# Create your views here.

@login_required
def server_list(request):
    servers = Server.objects.all()
    return render(request, 'inventory/server_list.html', {'servers': servers})


@login_required
def server_add(request):
    if request.method == 'POST':
        form = ServerForm(request.POST)
        if form.is_valid():
            server = form.save()
            messages.success(request, f'Server "{server.hostname}" added successfully.')
            return redirect('inventory:server_list')
        else:
            messages.error(request, 'Please correct the errors below.')

    else:
        form = ServerForm()

    return render(request, 'inventory/server_add.html', {'form': form})


@login_required
@require_POST
def server_toggle(request, pk):
    server = get_object_or_404(Server, pk=pk)
    server.toggle()
    action = 'started' if server.status == 'running' else 'stopped'
    messages.success(request, f'Server "{server.hostname}" {action}.')

    return redirect('inventory:server_list')


@login_required
@require_POST
def server_delete(request, pk):
    server = get_object_or_404(Server, pk=pk)
    hostname = server.hostname
    server.delete()
    messages.success(request, f'Server "{hostname}" deleted.')
    
    return redirect('inventory:server_list')