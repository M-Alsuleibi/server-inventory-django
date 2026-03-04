from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from .models import Server
from .forms import ServerForm

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
            form.save()
            return redirect('inventory:server_list')
    else:
        form = ServerForm()

    return render(request, 'inventory/server_add.html', {'form': form})


@login_required
@require_POST
def server_toggle(request, pk):
    server = get_object_or_404(Server, pk=pk)
    server.toggle()
    return redirect('inventory:server_list')


@login_required
@require_POST
def server_delete(request, pk):
    server = get_object_or_404(Server, pk=pk)
    server.delete()
    return redirect('inventory:server_list')