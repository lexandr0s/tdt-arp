#!/usr/bin/env python

# Copy paste from BitBake Build System Python Library
#
# Copyright (C) 2003  Holger Schurig
# Copyright (C) 2003, 2004  Chris Larson
#
# Based on Gentoo's portage.py.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# TODO: rewrite in bash.

import os, sys

def mkdirhier(dir):
	"""
	Create a directory like 'mkdir -p', but does not complain if
	directory already exists like os.makedirs
	"""

	try:
		os.makedirs(dir)
	except OSError, e:
		if e.errno != 17: raise e
	
def copyfile(src,dest,newmtime=None,sstat=None):
	"""
	Copies a file from src to dest, preserving all permissions and
	attributes; mtime will be preserved even when moving across
	filesystems.  Returns true on success and false on failure.
	"""
	import os, stat, shutil

	#print "copyfile("+src+","+dest+","+str(newmtime)+","+str(sstat)+")"
	try:
		if not sstat:
			sstat=os.lstat(src)
	except Exception, e:
		print "copyfile: Stating source file failed...", e
		return False

	destexists=1
	try:
		dstat=os.lstat(dest)
	except:
		dstat=os.lstat(os.path.dirname(dest))
		destexists=0

	if destexists:
		if stat.S_ISLNK(dstat[stat.ST_MODE]):
			try:
				os.unlink(dest)
				destexists=0
			except Exception, e:
				pass

	if stat.S_ISLNK(sstat[stat.ST_MODE]):
		try:
			target=os.readlink(src)
			if destexists and not stat.S_ISDIR(dstat[stat.ST_MODE]):
				os.unlink(dest)
			os.symlink(target,dest)
			#os.lchown(dest,sstat[stat.ST_UID],sstat[stat.ST_GID])
			return os.lstat(dest)
		except Exception, e:
			print "copyfile: failed to properly create symlink:", dest, "->", target, e
			return False

	if stat.S_ISREG(sstat[stat.ST_MODE]):
			try: # For safety copy then move it over.
				shutil.copyfile(src,dest+"#new")
				os.rename(dest+"#new",dest)
			except Exception, e:
				print 'copyfile: copy', src, '->', dest, 'failed.', e
				return False
	else:
			#we don't yet handle special, so we need to fall back to /bin/mv
			a=getstatusoutput("/bin/cp -f "+"'"+src+"' '"+dest+"'")
			if a[0]!=0:
				print "copyfile: Failed to copy special file:" + src + "' to '" + dest + "'", a
				return False # failure
	try:
		os.lchown(dest,sstat[stat.ST_UID],sstat[stat.ST_GID])
		os.chmod(dest, stat.S_IMODE(sstat[stat.ST_MODE])) # Sticky is reset on chown
	except Exception, e:
		print "copyfile: Failed to chown/chmod/unlink", dest, e
		return False

	if newmtime:
		os.utime(dest,(newmtime,newmtime))
	else:
		os.utime(dest, (sstat[stat.ST_ATIME], sstat[stat.ST_MTIME]))
		newmtime=sstat[stat.ST_MTIME]
	return newmtime

seen = []

def install_files(files, root):
	import glob, errno, re,os
	
	for file in files:
		#print "-->  ", file
		
		if os.path.isabs(file):
			file = '.' + file
		if not os.path.islink(file):
			if os.path.isdir(file):
				newfiles =  [ os.path.join(file,x) for x in os.listdir(file) ]
				if newfiles:
					files += newfiles
					continue
		globbed = glob.glob(file)
		if globbed:
			if [ file ] != globbed:
				if not file in globbed:
					files += globbed
					continue
				else:
					globbed.remove(file)
					files += globbed
		if (not os.path.islink(file)) and (not os.path.exists(file)):
			continue
		if file[-4:] == '.pyc':
			continue
		if file in seen:
			continue
		seen.append(file)
		if os.path.isdir(file) and not os.path.islink(file):
			mkdirhier(os.path.join(root,file))
			os.chmod(os.path.join(root,file), os.stat(file).st_mode)
			continue
		fpath = os.path.join(root,file)
		dpath = os.path.dirname(fpath)
		mkdirhier(dpath)
		ret = copyfile(file, fpath)
		if ret is False:
			raise("File population failed when copying %s to %s" % (file, fpath))


if __name__ == "__main__":
	sdir = sys.argv[1]
	dest = sys.argv[2]
	print "--> split", sdir, "to ..."
	pkgs = sys.argv[3:]
	
	os.chdir(sdir)
	for p in pkgs:
		d = dest + '/' + p
		print "-->  ", d
		mkdirhier(d)
		files = os.environ['FILES_%s' % p]
		install_files(files.split(' '), d)

# kate: space-indent off; indent-width 4; replace-tabs off;