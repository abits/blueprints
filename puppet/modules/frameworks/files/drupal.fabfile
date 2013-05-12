# Fabfile for bootstrapping frameworks and utility tasks.

from fabric.operations import *
from fabric.api import *
import urllib, os, time

timestamp = int(time.time())
source_dir = 'www'
vm = '33.33.33.10'
env.hosts = [vm, 'localhost']
env.user = 'vagrant'
env.password = 'vagrant'


@task
@hosts('localhost')
def bootstrap(version = '8.x-dev'):
    ''' Download and install Drupal.'''

    pre_bootstrap()
    filename = '%s-%s' % ('drupal', version)
    tarname = filename + '.tar.gz'
    base_url = 'http://ftp.drupal.org/files/projects/'
    url = base_url + tarname
    install_from_url(url, tarname, filename)


def install_from_url(url, tarname, filename):
    target = os.path.join(source_dir, tarname)
    urllib.urlretrieve(url, target)
    untar_cmd = 'tar xvf %s --strip 1' % tarname
    with lcd(source_dir):
        local(untar_cmd)
    os.unlink(target)


# generic stuff, 
# TODO: this should go in a template
@task
@hosts('localhost')
def ip():
    '''Configure host network adapter for host_only communication.'''

    local('sudo ip link set vboxnet0 up')
    local('sudo ip addr add 33.33.33.1/24 dev vboxnet0')


@task
@hosts('localhost')
def nfs(cmd='start'):
    '''Manage nfs services (your mileage may vary).'''

    if cmd == 'start':
        local('sudo systemctl restart rpc-idmapd')
        local('sudo systemctl restart rpc-mountd')
    elif cmd == 'stop':
        local('sudo systemctl stop rpc-idmapd')
        local('sudo systemctl stop rpc-mountd')


def pre_bootstrap():
    if os.path.exists('fabfile.pyc'):
        os.unlink('fabfile.pyc')
    if os.path.exists(source_dir):
        backup_target = '%s.%d' % (source_dir, timestamp)
        os.rename(source_dir, backup_target)
    os.makedirs(source_dir)
