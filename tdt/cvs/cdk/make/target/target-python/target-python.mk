#
# AR-P buildsystem smart Makefile
#
package[[ target_python

BDEPENDS_${P} = $(target_glibc) $(cross_python) $(target_zlib) $(target_openssl) $(target_libffi) $(target_bzip2)

PR_${P} = 1

#FIXME: add /usr/include/python2.7/pyconfig.h

call[[ base ]]

rule[[
  extract:http://www.${PN}.org/ftp/${PN}/${PV}/Python-${PV}.tar.bz2
  pmove:Python-${PV}:${PN}-${PV}
  patch:file://${PN}_${PV}.diff
  patch:file://${PN}_${PV}-ctypes-libffi-fix-configure.diff
  patch:file://${PN}_${PV}-pgettext.diff
  patch:file://${PN}-fix-configure-Wformat.diff
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		CONFIG_SITE= \
		$(BUILDENV) \
		autoreconf --verbose --install --force Modules/_ctypes/libffi && \
		autoconf && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-shared \
			--disable-ipv6 \
			--with-threads \
			--with-pymalloc \
			--with-signal-module \
			--with-wctype-functions \
			HOSTPYTHON=$(crossprefix)/bin/python \
		&& \
		$(MAKE) $(MAKE_ARGS) \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			CROSS_COMPILE=$(target) \
			CROSS_COMPILE_TARGET=yes \
			ac_sys_system=Linux \
			ac_sys_release=2 \
			ac_cv_file__dev_ptmx=yes \
			ac_cv_file__dev_ptc=no \
			ac_cv_no_strict_aliasing_ok=yes \
			ac_cv_pthread=yes \
			ac_cv_cxx_thread=yes \
			ac_cv_sizeof_off_t=8 \
			ac_cv_have_chflags=no \
			ac_cv_have_lchflags=no \
			ac_cv_py_format_size_t=yes \
			ac_cv_broken_sem_getvalue=no \
			MACHDEP=linux2 \
			HOSTARCH=$(target) \
			BUILDARCH=$(build) \
			PYTHON_MODULES_INCLUDE="$(targetprefix)/usr/include" \
			PYTHON_MODULES_LIB="$(targetprefix)/usr/lib" \
			CFLAGS="$(TARGET_CFLAGS)" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			LD="$(target)-gcc" \
		&& true
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			HOSTPYTHON=$(crossprefix)/bin/python \
			CROSS_COMPILE=$(target) \
			CROSS_COMPILE_TARGET=yes \
			install DESTDIR=$(PKDIR)

	ln -sf ../../libpython$(PYTHON_VERSION).so.1.0 $(PKDIR)/$(PYTHON_DIR)/config/libpython$(PYTHON_VERSION).so
	ln -sf python$(PYTHON_VERSION) $(PKDIR)/usr/include/python

	touch $@


call[[ ipk ]]

PACKAGES_${P} = \
	libpython \
	python_core \
	python_2to3 \
	python_lang \
	python_re \
	python_audio \
	python_bsddb \
	python_codecs \
	python_compile \
	python_compiler \
	python_compression \
	python_crypt \
	python_ctypes \
	python_curses \
	python_datetime \
	python_db \
	python_debugger \
	python_dev \
	python_difflib \
	python_distutils \
	python_doctest \
	python_elementtree \
	python_email \
	python_fcntl \
	python_gdbm \
	python_hotshot \
	python_html \
	python_idle \
	python_image \
	python_io \
	python_json \
	python_logging \
	python_mailbox \
	python_math \
	python_mime \
	python_misc \
	python_mmap \
	python_modules \
	python_multiprocessing \
	python_netclient \
	python_netserver \
	python_numbers\
	python_pickle \
	python_pkgutil \
	python_pprint \
	python_profile \
	python_pydoc \
	python_readline \
	python_resource \
	python_robotparser \
	python_shell \
	python_smtpd \
	python_sqlite3_tests \
	python_sqlite3 \
	python_stringold \
	python_subprocess \
	python_syslog \
	python_terminal \
	python_tests \
	python_textutils \
	python_tkinter \
	python_threading \
	python_unittest \
	python_unixadmin \
	python_xml \
	python_xmlrpc \
	python_zlib

DESCRIPTION_python_core = Python Interpreter and core modules
RDEPENDS_python_core = python_re libpython$(PYTHON_VERSION) python_lang libz1 libc6
FILES_python_core = \
  /usr/bin/python* \
  /usr/include/python$(PYTHON_VERSION)/pyconfig.h \
  $(PYTHON_DIR)/config/Makefile \
  $(PYTHON_DIR)/lib-dynload/_struct.so \
  $(PYTHON_DIR)/lib-dynload/binascii.so \
  $(PYTHON_DIR)/lib-dynload/time.so \
  $(PYTHON_DIR)/ConfigParser.* \
  $(PYTHON_DIR)/UserDict.* \
  $(PYTHON_DIR)/UserList.* \
  $(PYTHON_DIR)/UserString.* \
  $(PYTHON_DIR)/__future__.* \
  $(PYTHON_DIR)/_abcoll.* \
  $(PYTHON_DIR)/_weakrefset.* \
  $(PYTHON_DIR)/abc.* \
  $(PYTHON_DIR)/copy.* \
  $(PYTHON_DIR)/copy_reg.* \
  $(PYTHON_DIR)/genericpath.* \
  $(PYTHON_DIR)/getopt.* \
  $(PYTHON_DIR)/linecache.* \
  $(PYTHON_DIR)/new.* \
  $(PYTHON_DIR)/os.* \
  $(PYTHON_DIR)/platform.* \
  $(PYTHON_DIR)/posixpath.* \
  $(PYTHON_DIR)/site.* \
  $(PYTHON_DIR)/sitecustomize.* \
  $(PYTHON_DIR)/stat.* \
  $(PYTHON_DIR)/struct.* \
  $(PYTHON_DIR)/sysconfig.* \
  $(PYTHON_DIR)/types.* \
  $(PYTHON_DIR)/warnings.*

NAME_libpython = libpython$(PYTHON_VERSION)
DESCRIPTION_libpython = The Python Programming Language
RDEPENDS_libpython = libc6
FILES_libpython = \
  /usr/lib/libpython$(PYTHON_VERSION).*

DESCRIPTION_python_2to3 = Python Automated Python 2 to 3 code translation
RDEPENDS_python_2to3 = python_core
FILES_python_2to3 = \
  /usr/bin/2to3 \
  $(PYTHON_DIR)/lib2to3 \

DESCRIPTION_python_lang =  Python Low-Level Language Support
RDEPENDS_python_lang = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_lang = \
  $(PYTHON_DIR)/lib-dynload/_bisect.so \
  $(PYTHON_DIR)/lib-dynload/_collections.so \
  $(PYTHON_DIR)/lib-dynload/_functools.so \
  $(PYTHON_DIR)/lib-dynload/_heapq.so \
  $(PYTHON_DIR)/lib-dynload/array.so \
  $(PYTHON_DIR)/lib-dynload/itertools.so \
  $(PYTHON_DIR)/lib-dynload/operator.so \
  $(PYTHON_DIR)/lib-dynload/parser.so \
  $(PYTHON_DIR)/atexit.* \
  $(PYTHON_DIR)/bisect.* \
  $(PYTHON_DIR)/code.* \
  $(PYTHON_DIR)/codeop.* \
  $(PYTHON_DIR)/collections.* \
  $(PYTHON_DIR)/dis.* \
  $(PYTHON_DIR)/functools.* \
  $(PYTHON_DIR)/heapq.* \
  $(PYTHON_DIR)/inspect.* \
  $(PYTHON_DIR)/keyword.* \
  $(PYTHON_DIR)/opcode.* \
  $(PYTHON_DIR)/repr.* \
  $(PYTHON_DIR)/symbol.* \
  $(PYTHON_DIR)/token.* \
  $(PYTHON_DIR)/tokenize.* \
  $(PYTHON_DIR)/traceback.* \
  $(PYTHON_DIR)/weakref.*

DESCRIPTION_python_re = Python Regular Expression APIs
RDEPENDS_python_re = python_core
FILES_python_re = \
  $(PYTHON_DIR)/re.* \
  $(PYTHON_DIR)/sre.* \
  $(PYTHON_DIR)/sre_compile.* \
  $(PYTHON_DIR)/sre_constants.* \
  $(PYTHON_DIR)/sre_parse.*

DESCRIPTION_python_audio = Python Audio Handling
RDEPENDS_python_audio = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_audio = \
  $(PYTHON_DIR)/lib-dynload/audioop.so \
  $(PYTHON_DIR)/lib-dynload/ossaudiodev.so \
  $(PYTHON_DIR)/audiodev.* \
  $(PYTHON_DIR)/chunk.* \
  $(PYTHON_DIR)/sndhdr.* \
  $(PYTHON_DIR)/sunau.* \
  $(PYTHON_DIR)/sunaudio.* \
  $(PYTHON_DIR)/toaiff.* \
  $(PYTHON_DIR)/wave.*

DESCRIPTION_python_bsddb = Python Berkeley Database Bindings
RDEPENDS_python_bsddb = python_core db libc6
FILES_python_bsddb = \
  $(PYTHON_DIR)/bsddb

DESCRIPTION_python_codecs = Python Codecs, Encodings & i18n Support
RDEPENDS_python_codecs = python_core python_lang libpython$(PYTHON_VERSION) libc6
FILES_python_codecs = \
  $(PYTHON_DIR)/encodings \
  $(PYTHON_DIR)/lib-dynload/_codecs_cn.so \
  $(PYTHON_DIR)/lib-dynload/_codecs_hk.so \
  $(PYTHON_DIR)/lib-dynload/_codecs_iso2022.so \
  $(PYTHON_DIR)/lib-dynload/_codecs_jp.so \
  $(PYTHON_DIR)/lib-dynload/_codecs_kr.so \
  $(PYTHON_DIR)/lib-dynload/_codecs_tw.so \
  $(PYTHON_DIR)/lib-dynload/_locale.so \
  $(PYTHON_DIR)/lib-dynload/_multibytecodec.so \
  $(PYTHON_DIR)/lib-dynload/unicodedata.so \
  $(PYTHON_DIR)/codecs.* \
  $(PYTHON_DIR)/gettext.* \
  $(PYTHON_DIR)/locale.* \
  $(PYTHON_DIR)/stringprep.* \
  $(PYTHON_DIR)/xdrlib.*

DESCRIPTION_python_compile = Python Bytecode Compilation Support
RDEPENDS_python_compile = python_core
FILES_python_compile = \
  $(PYTHON_DIR)/compileall.* \
  $(PYTHON_DIR)/py_compile.*

DESCRIPTION_python_compiler = Python Compiler Support
RDEPENDS_python_compiler = python_core
FILES_python_compiler = \
  $(PYTHON_DIR)/compiler

DESCRIPTION_python_compression = Python High Level Compression Support
RDEPENDS_python_compression = python_core libpython$(PYTHON_VERSION) libbz2 python_zlib libc6
FILES_python_compression = \
  $(PYTHON_DIR)/lib-dynload/bz2.so \
  $(PYTHON_DIR)/gzip.* \
  $(PYTHON_DIR)/tarfile.* \
  $(PYTHON_DIR)/zipfile.*

DESCRIPTION_python_crypt = Python Basic Cryptographic and Hashing Support
RDEPENDS_python_crypt = libssl1 python_core libpython$(PYTHON_VERSION) libcrypto1 libc6
FILES_python_crypt = \
  $(PYTHON_DIR)/lib-dynload/_hashlib.so \
  $(PYTHON_DIR)/lib-dynload/crypt.so \
  $(PYTHON_DIR)/hashlib.* \
  $(PYTHON_DIR)/md5.* \
  $(PYTHON_DIR)/sha.*

DESCRIPTION_python_ctypes = python ctypes module
RDEPENDS_python_ctypes = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_ctypes = \
  $(PYTHON_DIR)/lib-dynload/_ctypes.so \
  $(PYTHON_DIR)/lib-dynload/_ctypes_test.so \
  $(PYTHON_DIR)/ctypes

DESCRIPTION_python_curses =  Python Curses Support
RDEPENDS_python_curses = libpython$(PYTHON_VERSION) python_core libncurses5 libpanel5 libc6
FILES_python_curses = \
  $(PYTHON_DIR)/lib-dynload/_curses.so \
  $(PYTHON_DIR)/lib-dynload/_curses_panel.so \
  $(PYTHON_DIR)/curses

DESCRIPTION_python_datetime = Python Calendar and Time support
RDEPENDS_python_datetime =python_core libpython$(PYTHON_VERSION) python_codecs libc6
FILES_python_datetime = \
  $(PYTHON_DIR)/lib-dynload/datetime.so \
  $(PYTHON_DIR)/_strptime.* \
  $(PYTHON_DIR)/calendar.*

DESCRIPTION_python_db =  Python File-Based Database Support
RDEPENDS_python_db = python_core
FILES_python_db = \
  $(PYTHON_DIR)/anydbm.* \
  $(PYTHON_DIR)/dumbdbm.* \
  $(PYTHON_DIR)/whichdb.*

DESCRIPTION_python_debugger = Python Debugger
RDEPENDS_python_debugger = python_core python_shell python_io python_re python_stringold python_lang python_pprint
FILES_python_debugger = \
  $(PYTHON_DIR)/bdb.* \
  $(PYTHON_DIR)/pdb.*

DESCRIPTION_python_dev = Python Development Package
RDEPENDS_python_dev = python_core libpython$(PYTHON_VERSION)
FILES_python_dev = \
  /usr/lib/libpython$(PYTHON_VERSION).so.* \
  /usr/include/python$(PYTHON_VERSION)

DESCRIPTION_python_difflib = Python helpers for computing deltas between objects.
RDEPENDS_python_difflib = python_re python_lang
FILES_python_difflib = \
  $(PYTHON_DIR)/difflib.*

DESCRIPTION_python_distutils = Python Distribution Utilities
RDEPENDS_python_distutils = python_core
FILES_python_distutils = \
  $(PYTHON_DIR)/config/Setup \
  $(PYTHON_DIR)/config/Setup.config \
  $(PYTHON_DIR)/config/Setup.local \
  $(PYTHON_DIR)/config/config.c \
  $(PYTHON_DIR)/config/config.c.in \
  $(PYTHON_DIR)/config/install-sh \
  $(PYTHON_DIR)/config/makesetup \
  $(PYTHON_DIR)/config/python.o \
  $(PYTHON_DIR)/distutils

DESCRIPTION_python_doctest = Python framework for running examples in docstrings.
RDEPENDS_python_doctest = python_debugger python_difflib python_core python_io python_re python_lang python_unittest
FILES_python_doctest = \
  $(PYTHON_DIR)/doctest.*

DESCRIPTION_python_elementtree = Python elementree
RDEPENDS_python_elementtree = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_elementtree = \
  $(PYTHON_DIR)/lib-dynload/_elementtree.so

DESCRIPTION_python_email = Python Email Support
RDEPENDS_python_email = python_image python_mime python_core python_io python_re python_netclient python_audio
FILES_python_email = \
  $(PYTHON_DIR)/email \
  $(PYTHON_DIR)/imaplib.*

DESCRIPTION_python_fcntl = Python's fcntl Interfaces
RDEPENDS_python_fcntl = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_fcntl = \
  $(PYTHON_DIR)/lib-dynload/fcntl.so

DESCRIPTION_python_gdbm = Python GNU Database Support
RDEPENDS_python_gdbm = python_core libpython$(PYTHON_VERSION) libgdbm4 libc6
FILES_python_gdbm = \
  $(PYTHON_DIR)/lib-dynload/gdbm.so

DESCRIPTION_python_hotshot = Python Hotshot Profile
RDEPENDS_python_hotshot = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_hotshot = \
  $(PYTHON_DIR)/lib-dynload/_hotshot.so \
  $(PYTHON_DIR)/hotshot

DESCRIPTION_python_html = Python HTML Processing
RDEPENDS_python_html = python_core
FILES_python_html = \
  $(PYTHON_DIR)/HTMLParser.* \
  $(PYTHON_DIR)/formatter.* \
  $(PYTHON_DIR)/htmlentitydefs.* \
  $(PYTHON_DIR)/htmllib.* \
  $(PYTHON_DIR)/markupbase.* \
  $(PYTHON_DIR)/sgmllib.*

DESCRIPTION_python_idle =  Python Integrated Development Environment
RDEPENDS_python_idle = python_core python_tkinter
FILES_python_idle = \
  /usr/bin/idle \
  $(PYTHON_DIR)/idlelib

DESCRIPTION_python_image = Python Graphical Image Handling
RDEPENDS_python_image = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_image = \
  $(PYTHON_DIR)/lib-dynload/imageop.so \
  $(PYTHON_DIR)/colorsys.* \
  $(PYTHON_DIR)/imghdr.*

DESCRIPTION_python_io =  Python Low-Level I/O
RDEPENDS_python_io = libpython$(PYTHON_VERSION) libcrypto1 python_math python_core libssl1 python_textutils libc6
FILES_python_io = \
  $(PYTHON_DIR)/lib-dynload/_io.so \
  $(PYTHON_DIR)/lib-dynload/_socket.so \
  $(PYTHON_DIR)/lib-dynload/_ssl.so \
  $(PYTHON_DIR)/lib-dynload/cStringIO.so \
  $(PYTHON_DIR)/lib-dynload/select.so \
  $(PYTHON_DIR)/lib-dynload/termios.so \
  $(PYTHON_DIR)/StringIO.* \
  $(PYTHON_DIR)/_pyio.* \
  $(PYTHON_DIR)/io.* \
  $(PYTHON_DIR)/pipes.* \
  $(PYTHON_DIR)/socket.* \
  $(PYTHON_DIR)/ssl.* \
  $(PYTHON_DIR)/tempfile.*

DESCRIPTION_python_json = Python JSON Support
RDEPENDS_python_json = python_core libpython$(PYTHON_VERSION) python_re python_math libc6
FILES_python_json = \
  $(PYTHON_DIR)/json \
  $(PYTHON_DIR)/lib-dynload/_json.so

DESCRIPTION_python_logging = Python Logging Support
RDEPENDS_python_logging = python_core python_io python_lang python_pickle python_stringold
FILES_python_logging = \
  $(PYTHON_DIR)/logging

DESCRIPTION_python_mailbox =  Python Mailbox Format Support
RDEPENDS_python_mailbox = python_core python_mime
FILES_python_mailbox = \
  $(PYTHON_DIR)/mailbox.*

DESCRIPTION_python_math =  Python Math Support
RDEPENDS_python_math = python_core libpython$(PYTHON_VERSION) libc6 python_crypt
FILES_python_math = \
  $(PYTHON_DIR)/lib-dynload/_random.so \
  $(PYTHON_DIR)/lib-dynload/cmath.so \
  $(PYTHON_DIR)/lib-dynload/math.so \
  $(PYTHON_DIR)/random.* \
  $(PYTHON_DIR)/sets.*

DESCRIPTION_python_mime =  Python MIME Handling APIs
RDEPENDS_python_mime = python_core python_io
FILES_python_mime = \
  $(PYTHON_DIR)/MimeWriter.* \
  $(PYTHON_DIR)/mimetools.* \
  $(PYTHON_DIR)/quopri.* \
  $(PYTHON_DIR)/rfc822.* \
  $(PYTHON_DIR)/uu.*

DESCRIPTION_python_misc = The Python Programming Language
RDEPENDS_python_misc = libpython$(PYTHON_VERSION) libc6
FILES_python_misc = \
  $(PYTHON_DIR)/importlib \
  $(PYTHON_DIR)/lib-dynload/Python-* \
  $(PYTHON_DIR)/lib-dynload/_testcapi.so \
  $(PYTHON_DIR)/lib-dynload/dbm.so \
  $(PYTHON_DIR)/lib-dynload/dl.so \
  $(PYTHON_DIR)/lib-dynload/future_builtins.so \
  $(PYTHON_DIR)/lib-dynload/linuxaudiodev.so \
  $(PYTHON_DIR)/lib-dynload/spwd.so \
  $(PYTHON_DIR)/plat-linux2 \
  $(PYTHON_DIR)/site-packages \
  $(PYTHON_DIR)/wsgiref \
  $(PYTHON_DIR)/Bastion.* \
  $(PYTHON_DIR)/__phello__.foo.* \
  $(PYTHON_DIR)/aifc.* \
  $(PYTHON_DIR)/antigravity.* \
  $(PYTHON_DIR)/argparse.* \
  $(PYTHON_DIR)/ast.* \
  $(PYTHON_DIR)/asynchat.* \
  $(PYTHON_DIR)/asyncore.* \
  $(PYTHON_DIR)/binhex.* \
  $(PYTHON_DIR)/cgitb.* \
  $(PYTHON_DIR)/contextlib.* \
  $(PYTHON_DIR)/dbhash.* \
  $(PYTHON_DIR)/filecmp.* \
  $(PYTHON_DIR)/fileinput.* \
  $(PYTHON_DIR)/fpformat.* \
  $(PYTHON_DIR)/fractions.* \
  $(PYTHON_DIR)/ihooks.* \
  $(PYTHON_DIR)/imputil.* \
  $(PYTHON_DIR)/macpath.* \
  $(PYTHON_DIR)/macurl2path.* \
  $(PYTHON_DIR)/mailcap.* \
  $(PYTHON_DIR)/mhlib.* \
  $(PYTHON_DIR)/mimify.* \
  $(PYTHON_DIR)/modulefinder.* \
  $(PYTHON_DIR)/multifile.* \
  $(PYTHON_DIR)/netrc.* \
  $(PYTHON_DIR)/ntpath.* \
  $(PYTHON_DIR)/nturl2path.* \
  $(PYTHON_DIR)/os2emxpath.* \
  $(PYTHON_DIR)/plistlib.* \
  $(PYTHON_DIR)/posixfile.* \
  $(PYTHON_DIR)/pyclbr.* \
  $(PYTHON_DIR)/rexec.* \
  $(PYTHON_DIR)/runpy.* \
  $(PYTHON_DIR)/sched.* \
  $(PYTHON_DIR)/statvfs.* \
  $(PYTHON_DIR)/symtable.* \
  $(PYTHON_DIR)/tabnanny.* \
  $(PYTHON_DIR)/this.* \
  $(PYTHON_DIR)/timeit.* \
  $(PYTHON_DIR)/trace.* \
  $(PYTHON_DIR)/user.* \
  $(PYTHON_DIR)/webbrowser.* \
  $(PYTHON_DIR)/wsgiref.egg-info

DESCRIPTION_python_mmap = Python Memory-Mapped-File Support
RDEPENDS_python_mmap = python_core python_io libpython$(PYTHON_VERSION) libc6
FILES_python_mmap = \
  $(PYTHON_DIR)/lib-dynload/mmap.so

DESCRIPTION_python_modules = All Python modules
RDEPENDS_python_modules = python_profile python_threading python_distutils python_curses \
python_ctypes python_datetime python_core python_io python_compiler python_compression python_re \
python_ xmlrpc python_email python_image python_compile python_resource python_json python_difflib \
python_math python_hotshot python_unixadmin python_textutils python_tkinter python_gdbm python_elementtree \
python_fcntl python_netclient python_pprint python_netserver python_codecs python_mime python_syslog python_html \
python_readline python_subprocess python_pydoc python_logging python_mailbox python_xml python_terminal \
python_sqlite3 python_sqlite3_tests python_unittest python_stringold python_robotparser python_pickle \
python_multiprocessing python_pkgutil python_2to3 python_debugger python_bsddb python_numbers python_mmap \
python_smtpd python_shell python_idle python_zlib python_db python_crypt python_tests python_lang python_audio
FILES_python_modules = \

DESCRIPTION_python_multiprocessing = Python Multiprocessing Support
RDEPENDS_python_multiprocessing = python_core python_io python_lang libpython$(PYTHON_VERSION) python_pickle python_threading python_ctypes libc6
FILES_python_multiprocessing = \
  $(PYTHON_DIR)/multiprocessing \
  $(PYTHON_DIR)/lib-dynload/_multiprocessing.so

DESCRIPTION_python_netclient = Python Internet Protocol Clients
RDEPENDS_python_netclient = python_mime python_datetime python_core python_io python_logging python_crypt python_lang
FILES_python_netclient = \
  $(PYTHON_DIR)/Cookie.* \
  $(PYTHON_DIR)/_LWPCookieJar.* \
  $(PYTHON_DIR)/_MozillaCookieJar.* \
  $(PYTHON_DIR)/base64.* \
  $(PYTHON_DIR)/cookielib.* \
  $(PYTHON_DIR)/ftplib.* \
  $(PYTHON_DIR)/hmac.* \
  $(PYTHON_DIR)/httplib.* \
  $(PYTHON_DIR)/mimetypes.* \
  $(PYTHON_DIR)/nntplib.* \
  $(PYTHON_DIR)/poplib.* \
  $(PYTHON_DIR)/smtplib.* \
  $(PYTHON_DIR)/telnetlib.* \
  $(PYTHON_DIR)/urllib.* \
  $(PYTHON_DIR)/urllib2.* \
  $(PYTHON_DIR)/urlparse.* \
  $(PYTHON_DIR)/uuid.*

DESCRIPTION_python_netserver = Python Internet Protocol Servers
RDEPENDS_python_netserver = python_core python_netclient
FILES_python_netserver = \
  $(PYTHON_DIR)/BaseHTTPServer.* \
  $(PYTHON_DIR)/CGIHTTPServer.* \
  $(PYTHON_DIR)/SimpleHTTPServer.* \
  $(PYTHON_DIR)/SocketServer.* \
  $(PYTHON_DIR)/cgi.*

DESCRIPTION_python_numbers = Python Number APIs
RDEPENDS_python_numbers = python_core python_lang python_re
FILES_python_numbers = \
  $(PYTHON_DIR)/decimal.* \
  $(PYTHON_DIR)/numbers.*

DESCRIPTION_python_pickle = Python Persistence Support
RDEPENDS_python_pickle = libpython$(PYTHON_VERSION) python_codecs python_core python_io python_re libc6
FILES_python_pickle = \
  $(PYTHON_DIR)/pickle.* \
  $(PYTHON_DIR)/pickletools.* \
  $(PYTHON_DIR)/shelve.* \
  $(PYTHON_DIR)/lib-dynload/cPickle.so

DESCRIPTION_python_pkgutil = Python Package Extension Utility Support
RDEPENDS_python_pkgutil = python_core
FILES_python_pkgutil = $(PYTHON_DIR)/pkgutil.*

DESCRIPTION_python_pprint = Python Pretty-Print Support
RDEPENDS_python_pprint = python_core python_io
FILES_python_pprint = $(PYTHON_DIR)/pprint.*

DESCRIPTION_python_profile = Python Basic Profiling Support
RDEPENDS_python_profile = python_core python_textutils libpython$(PYTHON_VERSION) libc6
FILES_python_profile = \
  $(PYTHON_DIR)/cProfile.* \
  $(PYTHON_DIR)/profile.* \
  $(PYTHON_DIR)/pstats.* \
  $(PYTHON_DIR)/lib-dynload/_lsprof.so

DESCRIPTION_python_pydoc =  Python Interactive Help Support
RDEPENDS_python_pydoc = python_core python_stringold python_lang python_re
FILES_python_pydoc = \
  /usr/bin/pydoc \
  $(PYTHON_DIR)/pydoc_data \
  $(PYTHON_DIR)/pydoc.*

DESCRIPTION_python_readline = Python Readline Support
RDEPENDS_python_readline = python_core libpython$(PYTHON_VERSION) libreadline6 libncurses5 libc6
FILES_python_readline = \
  $(PYTHON_DIR)/rlcompleter.* \
  $(PYTHON_DIR)/lib-dynload/readline.so

DESCRIPTION_python_resource = Python Resource Control Interfaces
RDEPENDS_python_resource = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_resource = $(PYTHON_DIR)/lib-dynload/resource.so

DESCRIPTION_python_robotparser = Python robots.txt parser
RDEPENDS_python_robotparser = python_core python_netclient
FILES_python_robotparser = $(PYTHON_DIR)/robotparser.*

DESCRIPTION_python_shell =  Python Shell-Like Functionality
RDEPENDS_python_shell = python_core python_re
FILES_python_shell = \
  $(PYTHON_DIR)/cmd.* \
  $(PYTHON_DIR)/commands.* \
  $(PYTHON_DIR)/dircache.* \
  $(PYTHON_DIR)/fnmatch.* \
  $(PYTHON_DIR)/glob.* \
  $(PYTHON_DIR)/popen2.* \
  $(PYTHON_DIR)/shlex.* \
  $(PYTHON_DIR)/shutil.*

DESCRIPTION_python_smtpd = Python Simple Mail Transport Daemon
RDEPENDS_python_smtpd = python_core python_mime python_netserver python_email
FILES_python_smtpd = /usr/bin/smtpd.* $(PYTHON_DIR)/smtpd.*

DESCRIPTION_python_sqlite3_tests = Python Sqlite3 Database Support Tests
RDEPENDS_python_sqlite3_tests = python_sqlite3 python_core
FILES_python_sqlite3_tests = $(PYTHON_DIR)/sqlite3/test

DESCRIPTION_python_sqlite3 = Python Sqlite3 Database Support
RDEPENDS_python_sqlite3 = libpython$(PYTHON_VERSION) python_threading python_zlib python_datetime python_core python_io libsqlite3 python_crypt python_lang libc6
FILES_python_sqlite3 = $(PYTHON_DIR)/sqlite3/*.* $(PYTHON_DIR)/lib-dynload/_sqlite3.so

DESCRIPTION_python_stringold = Python String APIs [deprecated]
RDEPENDS_python_stringold = python_core libpython$(PYTHON_VERSION) python_re libc6
FILES_python_stringold = \
  $(PYTHON_DIR)/lib-dynload/strop.so \
  $(PYTHON_DIR)/string.* \
  $(PYTHON_DIR)/stringold.*

DESCRIPTION_python_subprocess = Python Subprocess Support
RDEPENDS_python_subprocess = python_core python_io python_fcntl python_pickle python_re
FILES_python_subprocess = $(PYTHON_DIR)/subprocess.*

DESCRIPTION_python_syslog = Python Syslog Interfaces
RDEPENDS_python_syslog = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_syslog = $(PYTHON_DIR)/lib-dynload/syslog.so

DESCRIPTION_python_terminal = Python Terminal Controlling Support
RDEPENDS_python_terminal = python_core python_io
FILES_python_terminal =  $(PYTHON_DIR)/pty.*  $(PYTHON_DIR)/tty.*

DESCRIPTION_python_tests = Python Tests
RDEPENDS_python_tests = python_core
FILES_python_tests = $(PYTHON_DIR)/test

DESCRIPTION_python_textutils =  Python Option Parsing, Text Wrapping and Comma-Separated-Value Support
RDEPENDS_python_textutils = libpython$(PYTHON_VERSION) python_core python_io python_re python_stringold libc6
FILES_python_textutils = $(PYTHON_DIR)/lib-dynload/_csv.so $(PYTHON_DIR)/csv.* $(PYTHON_DIR)/optparse.* $(PYTHON_DIR)/textwrap.*

DESCRIPTION_python_tkinter = Python Tcl/Tk bindings
RDEPENDS_python_tkinter = python_core
FILES_python_tkinter = \
  $(PYTHON_DIR)/lib-tk/*.*

DESCRIPTION_python_threading = Python Threading & Synchronization Support
RDEPENDS_python_threading = python_core python_lang
FILES_python_threading = \
  $(PYTHON_DIR)/Queue.* \
  $(PYTHON_DIR)/_threading_local.* \
  $(PYTHON_DIR)/dummy_thread.* \
  $(PYTHON_DIR)/dummy_threading.* \
  $(PYTHON_DIR)/mutex.* \
  $(PYTHON_DIR)/threading.*

DESCRIPTION_python_unittest = Python Unit Testing Framework
RDEPENDS_python_unittest = python_core python_lang python_stringold python_shell python_difflib python_io python_pprint
FILES_python_unittest = $(PYTHON_DIR)/unittest

DESCRIPTION_python_unixadmin = Python Unix Administration Support
RDEPENDS_python_unixadmin = python_core libpython$(PYTHON_VERSION) libc6
FILES_python_unixadmin = \
  $(PYTHON_DIR)/lib-dynload/grp.so \
  $(PYTHON_DIR)/lib-dynload/nis.so \
  $(PYTHON_DIR)/getpass.*

DESCRIPTION_python_xml =  Python basic XML support.
RDEPENDS_python_xml = python_core libpython$(PYTHON_VERSION) python_elementtree python_re libc6
FILES_python_xml = \
  $(PYTHON_DIR)/lib-dynload/pyexpat.so \
  $(PYTHON_DIR)/xml \
  $(PYTHON_DIR)/xmllib.*

DESCRIPTION_python_xmlrpc = Python XMLRPC Support
RDEPENDS_python_xmlrpc = python_xml python_core python_lang python_netserver
FILES_python_xmlrpc = \
  $(PYTHON_DIR)/DocXMLRPCServer.* \
  $(PYTHON_DIR)/SimpleXMLRPCServer.* \
  $(PYTHON_DIR)/xmlrpclib.*

DESCRIPTION_python_zlib = Python zlib Support.
RDEPENDS_python_zlin = python_core libpython$(PYTHON_VERSION) libz1 libc6
FILES_python_zlib = $(PYTHON_DIR)/lib-dynload/zlib.so


call[[ ipkbox ]]

]]package
