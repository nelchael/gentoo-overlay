#!/usr/bin/python

# Author: Krzysztof Pawlik <nelchael@gentoo.org>
# This is released as-is. I'm not responsible if it cooks your cat or dog.
# You are using it without support, and on your own!

WHITE_LIST = []

import sys, os, portage
import portage.output as output

if '--help' in sys.argv:
	print """
unneded_distfiles.py [options]

Options are:
	--script    - silent, just prints the file names
	--remove    - removes found files
	--download  - list all downloadable files (not fetch RESTRICed)
	--help      - this screen
"""
	sys.exit(0)

def formatSize(x):
	x = int(x)
	if x < 1024:
		return str(x) + ' B'
	if x < 1024 * 1024:
		return '%.2f KB' % (float(x) / 1024)
	return '%.2f MB' % (float(x) / (1024.0 * 1024.0))

# spinner code from emerge - great work!
spinpos = 0
spinner = "/-\\|/-\\|/-\\|/-\\|\\-/|\\-/|\\-/|\\-/|"

def update_spinner():
	global spinner, spinpos
	spinpos = (spinpos+1) % len(spinner)
	sys.stdout.write("\b\b "+spinner[spinpos])
	sys.stdout.flush()

silent = False
remove = False
downloadable = False
if '--script' in sys.argv:
	silent = True
if '--remove' in sys.argv:
	remove = True
if '--download' in sys.argv:
	downloadable = True

portdir = portage.settings['PORTDIR']
distdir = portage.settings['DISTDIR']

DBPATHS = [
	'/var/db/pkg/'
]

try:
	f = open('/etc/portage/pkgs-db', 'r')
	pkgs = f.readlines()
	f.close()
	for i in pkgs:
		i = i.strip()
		if i[-1:] != '/':
			DBPATHS.append(i + '/')
		else:
			DBPATHS.append(i)
except:
	pass

try:
	f = open('/etc/portage/distfiles.whitelist', 'r')
	for i in f.readlines():
		WHITE_LIST.append(i.strip())
	f.close()
except:
	pass

def echo(x):
	if not silent:
		print x

echo(output.green('Using portage tree: ') + portdir)
echo(output.green('Using distfiles directory: ') + distdir)
echo(output.green('Using DB directories: '))
for i in DBPATHS:
	echo(output.blue('  * ') + i)

db = portage.portdbapi(portdir)

if not silent:
	print output.green('Gathering files...  '),
	update_spinner()

required_files = []
counter = 0

for dbpkg in DBPATHS:

	try:
		for category in sorted(os.listdir(dbpkg)):

			if (os.path.isdir(dbpkg + category)):

				for package in sorted(os.listdir(dbpkg + category)):

					if downloadable:
						try:
							isRestricted = db.aux_get(category + '/' + package, [ 'RESTRICT' ])[0]
							isRestricted = isRestricted.split()
							if not ('fetch' in isRestricted):
								continue
						except:
							continue

					try:
						src_uri = db.aux_get(category + '/' + package, [ 'SRC_URI' ])[0]
					except:
						continue
					elements = src_uri.split(' ')

					for elem in elements:

						if elem == '(' or elem == ')':
							continue
						if elem[-1:] == '?':
							continue

						counter += 1
						if counter % 10 == 0 and not silent:
							update_spinner()

						elem = os.path.basename(elem)

						if not elem in required_files:
							required_files += [ elem ]
	except:
		pass

if not silent:
	print '\b   '

total_size = 0
count = 0
for file in sorted(os.listdir(distdir)):

	if file == 'metadata.dtd':
		continue

	fullpath = os.path.normpath(distdir + '/' + file)
	if not os.path.isfile(fullpath):
		continue

	isInWhiteList = False
	for wl in WHITE_LIST:
		if file.find(wl) != -1:
			isInWhiteList = True
			break
	if isInWhiteList:
		continue

	if not file in required_files:
		total_size += os.path.getsize(fullpath)
		count += 1
		echo(output.yellow(' *') + ' Stale file: ' + fullpath + output.blue(' [' + formatSize(os.path.getsize(fullpath)) + ']'))
		if silent:
			print fullpath
		if remove:
			try:
				os.unlink(fullpath)
			except:
				if silent:
					sys.stderr.write(' *** Error removing file "' + fullpath + '"\n')
				else:
					echo(output.red(' *    ') + ' Error removing file.')

echo(output.green('Total unneded files: ') + str(count))
echo(output.green('Total size: ') + formatSize(total_size))
