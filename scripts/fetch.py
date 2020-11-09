#!/usr/bin/env python3
import sys
import os
import re
from git import Repo
import json
import time
import argparse
import paramiko
from operator import itemgetter


def isPython3():
    '''
    Check version of python running the script.
    Returns True, if version 3. Otherwise, False.
    '''
    return sys.version_info[0] == 3


if isPython3():
    import http.client
else:
    import httplib


def request(CID, version='master'):
    print("Initiating compile request...")

    if version != 'master':
        version = 'branch_' + version

    payload = {
        'CID': CID,
        'cmd': 'check_update',
        'version': version,
        'appVersion': 'web_1.0',
    }

    if isPython3():
        conn = http.client.HTTPSConnection('staging.skaarhoj.com')
    else:
        conn = httplib.HTTPSConnection('staging.skaarhoj.com')

    conn.request('POST', '/api.php', json.dumps(payload))
    resp = json.loads(conn.getresponse().read())

    if resp['status'] == 'error':
        print("Failed to generate firmware with error: {}".format(
            resp['description']))
        exit(1)


fileMapping = {
    "{BASE_PATH}/privateLibraries/"
}


def getNewestFile(sftp, time=0):
    newest = None
    for folder in sftp.listdir_iter():
        mtime = folder.st_mtime
        if mtime > time:
            newest = folder
            time = mtime

    return (newest, time)


def getFile(sftp, src, dst):
    for _ in range(3):
        try:
            sftp.get(src, dst)
            print("{}/{}' -> '{}'".format(sftp.getcwd(), src, dst))
            break
        except:
            time.sleep(0.5)


def fetch(sftp, ino_path, header_path, newerThan=0):
    print("Waiting for compilation to start...")
    time.sleep(2)
    file = None
    for i in range(10):
        file, newer = getNewestFile(sftp, newerThan)
        if file:
            break
        time.sleep(1)

    if not file:
        print("Seems no new compile directory was created, exiting...")
        exit(1)

    print("Downloading files:")
    sftp.chdir(file.filename)
    sftp.chdir('privateLibraries/SkaarhojUniSketch')
    files = [x for x in sftp.listdir_iter(
    ) if 'SK_CFGDEF_' in x.filename or 'SK_CTRL_' in x.filename]
    files = sorted(files, key=lambda x: x.st_mtime, reverse=True)
    files = files[:2]

    endings = [x.filename.split('_')[-1] for x in files]
    if endings[0] != endings[1]:
        print("These files were the newest:", [x.filename for x in files])
        print("... but don't seem to be from the same controller. Trying again!")
        raise Exception('Mismatched files')

    if not os.path.exists(ino_path):
        os.makedirs(ino_path)
    if not os.path.exists(header_path):
        os.makedirs(header_path)
    for f in files:
        getFile(sftp, f.filename,
                "{}/{}".format(header_path, f.filename))

    sftp.chdir('../../')
    getFile(sftp, 'unisketch/UniSketch.ino',
            '{}/UniSketch.ino'.format(ino_path))

def app():
    parser = argparse.ArgumentParser()
    parser.add_argument("CID")
    parser.add_argument(
        "-b", "--branch", help="branch name to build", default="master")
    parser.add_argument(
         "--ino_path", help="branch name to build", default="Software/UniSketch")
    parser.add_argument(
         "--header_path", help="branch name to build",
         default="ArduinoLibs/SkaarhojUniSketch")
    parser.add_argument("--current_branch", action='store_true')
    args = parser.parse_args()

    client = paramiko.SSHClient()
    client.load_system_host_keys()
    client.connect('cores.skaarhoj.com', username='core-files')
    sftp = client.open_sftp()
    sftp.chdir('CustomGenerator')

    print("Fetching file list...")
    _, newestBeforeRequest = getNewestFile(sftp)

    if args.current_branch:
        try:
            # Try to fetch current branch with git
            request(args.CID, Repo('./').active_branch.name)
        except:
            # Warning message
            print("Error compiling '{}', falling back to branch '{}'".format(
                Repo('./').active_branch.name, args.branch))
            # Fallback to provided branch, if unsuccessful
            request(args.CID, args.branch)
    else:
        request(args.CID, args.branch)

    try:
        fetch(sftp, args.ino_path, args.header_path, newestBeforeRequest)
    except:
        app()

if __name__ == "__main__":
    app()
