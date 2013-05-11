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
def bootstrap_drupal(version = '8'):
    ''' Download and install Drupal.'''

    if version == '8':    
        filename = '%s-%s.x-dev' % ('drupal', version)
    else:
        filename = '%s-%s' % ('drupal', version)
    tarname = filename + '.tar.gz'
    base_url = 'http://ftp.drupal.org/files/projects/'
    url = base_url + tarname
    install_from_url(url, tarname, filename)


@task
def bootstrap_typo3(version = '6.1.0'):
    ''' Download and install Typo3.'''

    filename = '%s-%s' % ('blankpackage', version)
    tarname = filename + '.tar.gz'
    base_url = 'http://prdownloads.sourceforge.net/typo3/'
    url = base_url + tarname + '?download'
    install_from_url(url, tarname, filename)


@task
def bootstrap_wordpress():
    ''' Download and install Wordpress.'''

    filename = 'wordpress'
    tarname = 'latest.tar.gz'
    base_url = 'http://wordpress.org/'
    url = base_url + tarname
    install_from_url(url, tarname, filename)


@task
@hosts(vm)
def bootstrap_symfony(version = '2.2.1'):
    '''Download and install Symfony.'''

    target = os.path.join('/vagrant', source_dir)
    clean_dir(source_dir)
    install_cmd = 'composer create-project symfony/framework-standard-edition %s/ %s' % (target, version)
    run(install_cmd)


@task
@hosts(vm)
def bootstrap_django():
    '''Download and install Django.'''
    
    setup_python_venv('django')
    act_in_venv = 'source /vagrant/www/venv/bin/activate'
    with cd('/vagrant/www'):
        with prefix(act_in_venv):
            run('pip install Django')
            run('pip install south')


@hosts(vm)
def setup_python_venv(name):
    with cd('/vagrant/www'):
        cmd = 'virtualenv --distribute --prompt="(%s) ~ " venv' % name 
        run(cmd)


@task
@hosts(vm)
def django_server():
    act_in_venv = 'source /vagrant/www/venv/bin/activate'
    with cd('/vagrant/www'):
        with prefix(act_in_venv):
            run('venv/bin/python manage.py runserver 0.0.0.0:8000')


def install_from_url(url, tarname, filename):
    download_framework(url, tarname)
    deflate_framework(tarname)
    install_framework(filename)
    os.unlink(tarname)
    shutil.rmtree(filename)


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


def clean_dir(target):
    for item in os.listdir(target):
        try:
            os.unlink(os.path.join(target, item))
        except Exception, e:
            print e

@task        
def ip_up():
    '''Configure host network adapter for host_only communication.'''

    local('sudo ip link set vboxnet0 up')
    local('sudo ip addr add 33.33.33.1/24 dev vboxnet0')


@task
def start_nfs():
    '''Make sure nfs services are running (your mileage may vary).'''

    local('sudo systemctl restart rpc-idmapd')
    local('sudo systemctl restart rpc-mountd')



