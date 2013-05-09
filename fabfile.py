# Fabfile for bootstrapping frameworks and utility tasks.

from fabric.operations import *
from fabric.api import *
import urllib
import tarfile
import os
import shutil


source_dir = 'www'
vm = '33.33.33.10'
env.hosts = [vm]
env.user = 'vagrant'
env.password = 'vagrant'


@task
def bootstrap_drupal():
    ''' Downloading and installing drupal.'''

    version = 8
    filename = '%s-%s.x-dev' % ('drupal', version)
    tarname = filename + '.tar.gz'
    base_url = 'http://ftp.drupal.org/files/projects/'
    url = base_url + tarname
    download_framework(url, tarname)
    deflate_framework(tarname)
    install_framework(filename)
    os.unlink(tarname)
    shutil.rmtree(filename)


@task
@hosts(vm)
def bootstrap_symfony():
    '''Downloading and installing Symfony.'''

    target = os.path.join('/vagrant', source_dir)
    install_cmd = 'composer create-project symfony/framework-standard-edition %s/ 2.2.1' % target
    run(install_cmd)


def download_framework(url, target):
    urllib.urlretrieve(url, target)


def deflate_framework(tarname):
    with tarfile.open(tarname, "r") as tar:
        tar.extractall()


def install_framework(filename):
    for item in os.listdir(filename):
        src = os.path.join(filename, item)
        target = os.path.join(source_dir, item)
        shutil.move(src, target)


@task        
def ip_up():
    '''Configure host network adapter for host_only communication.'''

    local('sudo ip link set vboxnet0 up')
    local('sudo ip addr add 33.33.33.1/24 dev vboxnet0')


@task
def start_nfs():
    '''Make sure nfs services are running (tested with Arch, your mileage may vary).'''

    local('sudo systemctl restart rpc-idmapd')
    local('sudo systemctl restart rpc-mountd')



