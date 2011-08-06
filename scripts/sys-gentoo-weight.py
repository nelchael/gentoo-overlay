#!/usr/bin/python

import os, sys, portage.output as output

spinpos = 0
spinner = "/-\\|/-\\|/-\\|/-\\|\\-/|\\-/|\\-/|\\-/|"

def update_spinner():
	global spinner, spinpos
	spinpos = (spinpos+1) % len(spinner)
	sys.stdout.write("\b\b "+spinner[spinpos])
	sys.stdout.flush()

def formatSize(x):
	x = int(x)
	if x < 1024:
		return str(x) + ' B'
	if x < 1024 * 1024:
		return '%.2f KB' % (float(x) / 1024)
	return '%.2f MB' % (float(x) / (1024.0 * 1024.0))

packages = {}
total_size = 0

print output.blue('Counting...  ')

counter = 0
for category in sorted(os.listdir('/var/db/pkg/')):

	print output.green(' *'),category,' ',
	update_spinner()

	for package in sorted(os.listdir('/var/db/pkg/' + category)):

		fh = file('/var/db/pkg/' + category + '/' + package + '/CONTENTS')
		content = fh.readlines()
		fh.close()

		size = 0
		for entity in content:
			counter += 1
			if counter % 10 == 0:
				update_spinner()
			data = entity.strip().split(' ')
			if data[0] != 'obj':
				continue
			try:
				size += os.path.getsize(data[1])
			except:
				if '--report-missing' in sys.argv:
					print '\n', output.red('   *'), 'File missing:', data[1],
				pass

		total_size += size
		packages[category + '/' + package] = size

	print '\b   '

print

if '--sort-size' in sys.argv:
	pkgs = packages.items()
	pkgs2 = []
	for pkg in pkgs:
		pkgs2 += [[ pkg[1], pkg[0] ]]
	pkgs = pkgs2
	del(pkgs2)
	for package in sorted(pkgs):
		print output.green(' * ') + output.bold(package[1]) + ' - ' + formatSize(package[0])
else:
	for package in sorted(packages.keys()):
		print output.green(' * ') + output.bold(package) + ' - ' + formatSize(packages[package])

print output.green('Total size:'), formatSize(total_size)
