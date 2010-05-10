#!/usr/bin/python

import sys
import os

search_path = os.getcwd()
while search_path != '/':
	if os.path.exists(os.path.join(search_path, 'profiles/repo_name')):
		print 'Appending %s to PORTDIR_OVERLAY...' % search_path
		if 'PORTDIR_OVERLAY' not in os.environ:
			os.environ['PORTDIR_OVERLAY'] = search_path
		else:
			os.environ['PORTDIR_OVERLAY'] += ' ' + search_path
	search_path = os.path.dirname(search_path)

import portage
import portage.versions as portage_versions
import portage.output as output

def resolvePackage(db, item):
	cpvs = []
	try:
		cpvs = db.xmatch('match-all', item)
	except (Exception), e:
		print output.red('"%s" matches to more than one package:' % item)
		for x in e.args[0]:
			print '    ' + output.green('*') + ' ' + x
		sys.exit(0)
	if len(cpvs) == 0:
		print output.red('Package "%s" not found' % item)
		if item.find('/') != -1:
			item = item[item.find('/') + 1:]
			try:
				cpvs = db.xmatch('match-all', item)
			except (Exception), e:
				print 'Try:'
				for x in e.args[0]:
					print '    ' + output.green('*') + ' ' + x
				sys.exit(0)
			if len(cpvs) != 0:
				print 'Try:\n    %s' % output.green('*') + ' ' + output.bold(portage_versions.pkgsplit(cpvs[0])[0])
		sys.exit(0)
	pkg = portage_versions.pkgsplit(cpvs[0])[0]
	vers = []
	for i in cpvs:
		vers.append(i[len(pkg) + 1:])
	# Sort versions:
	verRv = []
	for i in sorted(vers):
		skip = False
		for x in range(len(verRv)):
			if portage_versions.vercmp(i, verRv[x]) > 0:
				verRv.insert(x, i)
				skip = True
				break
		if not skip:
			verRv.append(i)
	vers = []
	for i in reversed(verRv):
		vers.append(i)
	return ( pkg, vers )

def flagFor(arch, keywords, myArch):
	maskAll = False
	for x in keywords:
		tilde = False
		maskMe = False
		if x == '-*':
			maskAll = True
			continue
		if x[0] == '~':
			x = x[1:]
			tilde = True
		if x[0] == '-':
			x = x[1:]
			maskMe = True
		if x == arch:
			if tilde:
				if arch == myArch:
					return output.yellow('~')
				return output.darkyellow('~')
			if maskMe:
				if arch == myArch:
					return output.red('-')
				return output.darkred('-')
			if arch == myArch:
				return output.green('+')
			return output.darkgreen('+')
	if maskAll:
		if arch == myArch:
			return output.red('*')
		return output.darkred('*')
	return ' '

def showMe(myArch, db, pkg):
	pkg, versions = resolvePackage(db, pkg)
	archs = []
	for i in open(portage.settings['PORTDIR'] + '/profiles/arch.list').readlines():
		if i == '':
			break
		i = i.strip()
		if i == '' or i[0] == '#':
			continue
		if not 'ESHOWKW_ALL_ARCHS' in os.environ and i.find('-') != -1:
			continue
		archs.append(i)
	longestVerLen = 0
	for i in versions:
		if len(i) > longestVerLen:
			longestVerLen = len(i)
	longestVerLen += 1
	longestSlot = 0
	for i in versions:
		slot = db.aux_get(pkg + '-' + i, [ 'SLOT' ])[0]
		if len(slot) > longestSlot:
			longestSlot = len(slot)
	lines = 0
	for i in archs:
		if len(i) > lines:
			lines = len(i)
	for i in range(lines):
		print longestVerLen * ' ' + '|',
		for x in archs:
			if x == myArch:
				if len(x) > i:
					print output.green(x[i]),
				else:
					print ' ',
			else:
				if len(x) > i:
					print x[i],
				else:
					print ' ',
		print '|',
		print
	print longestVerLen * '-' + '+-' + len(archs) * '--' + '+-' + (longestSlot + 3) * '-'
	sys.stdout.flush()
	prevSlot = None
	for x in versions:
		keywords, slot = db.aux_get(pkg + '-' + x, [ 'KEYWORDS', 'SLOT' ])
		keywords = keywords.split()
		slot = ' (' + slot + ')'
		if slot != prevSlot:
			print output.bold(x + (longestVerLen - len(x)) * ' ') + '|',
		else:
			print x + (longestVerLen - len(x)) * ' ' + '|',
		for a in archs:
			print flagFor(a, keywords, myArch),
		if slot != prevSlot:
			print '|' + output.blue(slot)
		else:
			print '|'
			#print '|' + output.darkblue(slot)
		prevSlot = slot
		sys.stdout.flush()

pkg = None
if len(sys.argv) == 1:
	if os.getcwd() != '/':
		pkg = os.path.basename(os.path.dirname(os.getcwd())) + '/' + os.path.basename(os.getcwd())
	else:
		print output.red('Can not get package name')
		sys.exit(1)
else:
	pkg = sys.argv[1]

myArch = None
for i in portage.settings['ACCEPT_KEYWORDS'].split():
	myArch = i
	if i[0] == '~':
		myArch = i[1:]

showMe(myArch, portage.portdbapi(portage.settings['PORTDIR']), pkg)
