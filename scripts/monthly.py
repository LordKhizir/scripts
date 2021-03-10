#!/usr/bin/env python3
import argparse, os, subprocess, sys, yaml


def do_simple_listing(folder, patreons):
    for patreon in patreons:
        print("================================================")
        os.system("ls -r \"" + folder + patreon + "\" | grep -v \".jpg\" | head -5")
        print("------------------------------------------------")
        print(" ")


def check_patreons_for_month(folder, patreons, month):
    for patreon in patreons:
        path = folder + patreon + '/' + patreon + ' ' + month
        # We can not simply check os.path.isdir(path), as it can have extra info like release name, etc
        command = 'ls -d "' + path + '"*'
        proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        proc.wait()
        if proc.returncode == 0:
            print('\t✅ ' + patreon)
        else:
            print('\t❌ ' + patreon + ' - does not exists yet')


# parse arguments
parser = argparse.ArgumentParser(description='Monthly Patreon checker. List the completion status for your preferred '
                                             'Patreons.')
parser.add_argument('month', type=str, metavar='YYYY-MM', nargs='?', help='Month to be checked')
args = parser.parse_args()
print(args.month)

configFolder = os.path.split(sys.argv[0])[0] + "/../config/"
with open(configFolder + "monthly.yaml", "r") as stream:
    try:
        config = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)

baseFolder = config['baseFolder']

if args.month is None:
    do_simple_listing(baseFolder, config['patreons'])
else:
    check_patreons_for_month(baseFolder, config['patreons'], args.month)
