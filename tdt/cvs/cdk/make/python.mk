#
# python
#
BEGIN[[
ifdef ENABLE_PY27
python
  2.7.3
  {PN}-{PV}
  extract:http://www.{PN}.org/ftp/{PN}/{PV}/Python-{PV}.tar.bz2
  pmove:Python-{PV}:{PN}-{PV}
  patch:file://{PN}_{PV}.diff
  patch:file://{PN}_{PV}-ctypes-libffi-fix-configure.diff
  patch:file://{PN}_{PV}-pgettext.diff
;
else
python
  2.6.6
  {PN}-{PV}
  extract:http://www.{PN}.org/ftp/{PN}/{PV}/Python-{PV}.tar.bz2
  pmove:Python-{PV}:{PN}-{PV}
  patch:file://{PN}_{PV}.diff
  patch:file://{PN}_{PV}-ctypes-libffi-fix-configure.diff
  patch:file://{PN}_{PV}-pgettext.diff
endif
;
]]END

PKGR_python = r1
PACKAGES_python = python_core \
		  libpython \
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
		  python_threading \
		  python_unittest \
		  python_unixadmin \
		  python_xml \
		  python_xmlrpc \
		  python_zlib

DESCRIPTION_python_core = Python Interpreter and core modules
RDEPENDS_python_core = python_re libpython python_lang
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

DESCRIPTION_libpython = The Python Programming Language
FILES_libpython = \
  /usr/lib/libpython$(PYTHON_VERSION).*

DESCRIPTION_python_2to3 = Python Automated Python 2 to 3 code translation
RDEPENDS_python_2to3 = python_core
FILES_python_2to3 = \
  /usr/bin/2to3 \
  $(PYTHON_DIR)/lib2to3 \

DESCRIPTION_python_lang =  Python Low-Level Language Support
RDEPENDS_python_lang = python_core libpython
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
RDEPENDS_python_audio = python_core libpython
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
RDEPENDS_python_bsddb = python_core
FILES_python_bsddb = \
  $(PYTHON_DIR)/bsddb

DESCRIPTION_python_codecs = Python Codecs, Encodings & i18n Support
RDEPENDS_python_codecs = python_core python_lang libpython
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
RDEPENDS_python_compression = python_core libpython libbz2_0 python_zlib
FILES_python_compression = \
  $(PYTHON_DIR)/lib-dynload/bz2.so \
  $(PYTHON_DIR)/gzip.* \
  $(PYTHON_DIR)/tarfile.* \
  $(PYTHON_DIR)/zipfile.*

DESCRIPTION_python_crypt = Python Basic Cryptographic and Hashing Support
RDEPENDS_python_crypt = libssl python_core libpython libcrypto
FILES_python_crypt = \
  $(PYTHON_DIR)/lib-dynload/_hashlib.so \
  $(PYTHON_DIR)/lib-dynload/crypt.so \
  $(PYTHON_DIR)/hashlib.* \
  $(PYTHON_DIR)/md5.* \
  $(PYTHON_DIR)/sha.*

DESCRIPTION_python_ctypes = python ctypes module
RDEPENDS_python_ctypes = python_core libpython
FILES_python_ctypes = \
  $(PYTHON_DIR)/lib-dynload/_ctypes.so \
  $(PYTHON_DIR)/lib-dynload/_ctypes_test.so \
  $(PYTHON_DIR)/ctypes

DESCRIPTION_python_curses =  Python Curses Support
RDEPENDS_python_curses = libpython python_core libcursesw5 libtinfo5 libpanelw5
FILES_python_curses = \
  $(PYTHON_DIR)/lib-dynload/_curses.so \
  $(PYTHON_DIR)/lib-dynload/_curses_panel.so \
  $(PYTHON_DIR)/curses

DESCRIPTION_python_datetime = Python Calendar and Time support
RDEPENDS_python_datetime =python_core libpython python_codecs
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
RDEPENDS_python_dev = python_core libpython
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
RDEPENDS_python_elementtree = python_core libpython
FILES_python_elementtree = \
  $(PYTHON_DIR)/lib-dynload/_elementtree.so

DESCRIPTION_python_email = Python Email Support
RDEPENDS_python_email = python_image python_mime python_core python_io python_re python_netclient python_audio
FILES_python_email = \
  $(PYTHON_DIR)/email \
  $(PYTHON_DIR)/imaplib.*

DESCRIPTION_python_fcntl = Python's fcntl Interfaces
RDEPENDS_python_fcntl = python_core libpython
FILES_python_fcntl = \
  $(PYTHON_DIR)/lib-dynload/fcntl.so

DESCRIPTION_python_gdbm = Python GNU Database Support
RDEPENDS_python_gdbm = python_core libpython libgdbm4
FILES_python_gdbm = \
  $(PYTHON_DIR)/lib-dynload/gdbm.so

DESCRIPTION_python_hotshot = Python Hotshot Profile
RDEPENDS_python_hotshot = python_core libpython
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
RDEPENDS_python_image = python_core libpython
FILES_python_image = \
  $(PYTHON_DIR)/lib-dynload/imageop.so \
  $(PYTHON_DIR)/colorsys.* \
  $(PYTHON_DIR)/imghdr.*

DESCRIPTION_python_io =  Python Low-Level I/O
RDEPENDS_python_io = libpython libcrypto python_math python_core libssl
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
RDEPENDS_python_json = python_core libpython python_re python_math
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
RDEPENDS_python_math = python_core libpython 
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
RDEPENDS_python_misc = libpython
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
RDEPENDS_python_mmap = python_core python_io libpython
FILES_python_mmap = \
  $(PYTHON_DIR)/lib-dynload/mmap.so

DESCRIPTION_python_modules = All Python modules
RDEPENDS_python_modules = python_profile python_threading python_distutils python_curses \
python_ctypes python_datetime python_core python_io python_compiler python_compression python_re \
python_ xmlrpc python_email python_image python_compile python_resource python_json python_difflib \
python_math python_hotshot python_unixadmin python_textutils python_tkinter python_gdbm python_elementtree \
python_fcntl python_netclient python_pprint python_netserver python_codecs python_mime python_syslog python_html \
python_readline python_subprocess python_pydoc python_logging python_mailbox python_xml python_terminal \
python_sqlite3  python_sqlite3_tests python_unittest python_stringold python_robotparser python_pickle \
python_multiprocessing python_pkgutil python_2to3 python_debugger python_bsddb python_numbers python_mmap \
python_smtpd python_shell python_idle python_zlib python_db python_crypt python_tests python_lang python_audio
FILES_python_modules = \

DESCRIPTION_python_multiprocessing = Python Multiprocessing Support
RDEPENDS_python_multiprocessing = python_core python_io python_lang libpython
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
RDEPENDS_python_pickle = libpython python_codecs python_core python_io python_re
FILES_python_pickle = \
  $(PYTHON_DIR)/pickle.* \
  $(PYTHON_DIR)/pickletools.* \
  $(PYTHON_DIR)/shelve.* \
  $(PYTHON_DIR)/lib-dynload/cPickle.so

DESCRIPTION_python_pkgutil = Python Package Extension Utility Support
RDEPENDS_python_pkgutil = python_core
FILES_python_pkgutil = $(PYTHON_DIR)/pkgutil.*

DESCRIPTION_python_pprint = Python Pretty-Print Support
RDEPENDS_python_pprint = python_core
FILES_python_pprint = $(PYTHON_DIR)/pprint.*

DESCRIPTION_python_profile = Python Basic Profiling Support
RDEPENDS_python_profile = python_core python_textutils libpython
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
RDEPENDS_python_readline = python_core libpython libreadline libncursesw
FILES_python_readline = \
  $(PYTHON_DIR)/rlcompleter.* \
  $(PYTHON_DIR)/lib-dynload/readline.so

DESCRIPTION_python_resource = Python Resource Control Interfaces
RDEPENDS_python_resource = python_core libpython
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
RDEPENDS_python_sqlite3 = libpython python_threading python_zlib python_datetime python_core python_io libsqlite3 python_crypt python_lang
FILES_python_sqlite3 = $(PYTHON_DIR)/sqlite3/*.* $(PYTHON_DIR)/lib-dynload/_sqlite3.so

DESCRIPTION_python_stringold = Python String APIs [deprecated]
RDEPENDS_python_stringold = python_core libpython python_re
FILES_python_stringold = \
  $(PYTHON_DIR)/lib-dynload/strop.so \
  $(PYTHON_DIR)/string.* \
  $(PYTHON_DIR)/stringold.*

DESCRIPTION_python_subprocess = Python Subprocess Support
RDEPENDS_python_subprocess = python_core python_io python_fcntl python_pickle python_re
FILES_python_subprocess = $(PYTHON_DIR)/subprocess.*

DESCRIPTION_python_syslog = Python Syslog Interfaces
RDEPENDS_python_syslog = python_core libpython
FILES_python_syslog = $(PYTHON_DIR)/lib-dynload/syslog.so

DESCRIPTION_python_terminal = Python Terminal Controlling Support
RDEPENDS_python_terminal = python_core python_io
FILES_python_terminal =  $(PYTHON_DIR)/pty.*  $(PYTHON_DIR)/tty.*

DESCRIPTION_python_tests = Python Tests
RDEPENDS_python_tests = python_core
FILES_python_tests = $(PYTHON_DIR)/test

DESCRIPTION_python_textutils =  Python Option Parsing, Text Wrapping and Comma-Separated-Value Support
RDEPENDS_python_textutils = libpython python_core python_io python_re python_stringold
FILES_python_textutils = $(PYTHON_DIR)/lib-dynload/_csv.so $(PYTHON_DIR)/csv.* $(PYTHON_DIR)/optparse.* $(PYTHON_DIR)/textwrap.*

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
RDEPENDS_python_unittest = python_core python_lang python_stringold
FILES_python_unittest = $(PYTHON_DIR)/unittest

DESCRIPTION_python_unixadmin = Python Unix Administration Support
RDEPENDS_python_unixadmin = python_core libpython
FILES_python_unixadmin = \
  $(PYTHON_DIR)/lib-dynload/grp.so \
  $(PYTHON_DIR)/lib-dynload/nis.so \
  $(PYTHON_DIR)/getpass.*

DESCRIPTION_python_xml =  Python basic XML support.
RDEPENDS_python_xml = python_core libpython
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
RDEPENDS_python_zlin = python_core libpython libz1
FILES_python_zlib = $(PYTHON_DIR)/lib-dynload/zlib.so

#$(PYTHON_DIR)/lib-tk \
#$(PYTHON_DIR)/plat-linux3


$(DEPDIR)/python.do_prepare: bootstrap host_python openssl-dev sqlite ncurses libreadline libz $(DEPENDS_python)
	$(PREPARE_python)
	touch $@

$(DEPDIR)/python.do_compile: $(DEPDIR)/python.do_prepare
	( cd $(DIR_python) && \
		CONFIG_SITE= \
		$(BUILDENV) \
		autoreconf -Wcross --verbose --install --force Modules/_ctypes/libffi && \
		autoconf && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-shared \
			--disable-ipv6 \
			--without-cxx-main \
			--with-threads \
			--with-pymalloc \
			--with-signal-module \
			--with-wctype-functions \
			HOSTPYTHON=$(crossprefix)/bin/python \
			OPT="$(TARGET_CFLAGS)" && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			PYTHON_MODULES_INCLUDE="$(prefix)/$*cdkroot/usr/include" \
			PYTHON_MODULES_LIB="$(prefix)/$*cdkroot/usr/lib" \
			CROSS_COMPILE_TARGET=yes \
			CROSS_COMPILE=$(target) \
			HOSTARCH=sh4-linux \
			CFLAGS="$(TARGET_CFLAGS) -fno-inline" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			LD="$(target)-gcc" \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			all ) && \
	touch $@

$(DEPDIR)/python: $(DEPDIR)/python.do_compile
	$(start_build)
	( cd $(DIR_python) && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			install DESTDIR=$(PKDIR) ) && \
	$(LN_SF) ../../libpython$(PYTHON_VERSION).so.1.0 $(PKDIR)$(PYTHON_DIR)/config/libpython$(PYTHON_VERSION).so
	$(LN_SF) $(PKDIR)$(PYTHON_INCLUDE_DIR) $(PKDIR)/usr/include/python
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@

#
# pythonwifi
#
BEGIN[[
pythonwifi
  0.5.0
  python-wifi-{PV}
  extract:http://freefr.dl.sourceforge.net/project/{PN}.berlios/python-wifi-{PV}.tar.bz2
;
]]END
PACKAGES_pythonwifi = python_wifi
DESCRIPTION_python_wifi = "pythonwifi"
RDEPENDS_python_wifi = python_core python_ctypes python_datetime
FILES_python_wifi =\
$(PYTHON_DIR)/site-packages/pythonwifi

$(DEPDIR)/pythonwifi.do_prepare: bootstrap setuptools python $(DEPENDS_pythonwifi)
	$(PREPARE_pythonwifi)
	touch $@

$(DEPDIR)/pythonwifi.do_compile: $(DEPDIR)/pythonwifi.do_prepare
	cd $(DIR_pythonwifi) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pythonwifi: $(DEPDIR)/pythonwifi.do_compile
	$(start_build)
	cd $(DIR_pythonwifi) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# pythoncheetah
#
BEGIN[[
pythoncheetah
  2.4.4
  Cheetah-{PV}
  extract:http://pypi.python.org/packages/source/C/Cheetah/Cheetah-{PV}.tar.gz
;
]]END
PACKAGES_pythoncheetah = python_cheetah
DESCRIPTION_python_cheetah = Python template engine and code generation tool
RDEPENDS_python_cheetah = python_pickle python_pprint
FILES_python_cheetah = /usr/bin/cheetah* $(PYTHON_DIR)/site-packages/Cheetah

$(DEPDIR)/pythoncheetah.do_prepare: bootstrap setuptools $(DEPENDS_pythoncheetah)
	$(PREPARE_pythoncheetah)
	touch $@

$(DEPDIR)/pythoncheetah.do_compile: $(DEPDIR)/pythoncheetah.do_prepare
	cd $(DIR_pythoncheetah) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pythoncheetah: $(DEPDIR)/pythoncheetah.do_compile
	$(start_build)
	cd $(DIR_pythoncheetah) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# zope interface
#
BEGIN[[
zopeinterface
  3.5.1
  zope.interface-{PV}
  extract:http://pypi.python.org/packages/source/z/zope.interface/zope.interface-{PV}.tar.gz
;
]]END
PACKAGES_zopeinterface = python_zopeinterface
DESCRIPTION_python_zopeinterface =  Interface definitions for Zope products
RDEPENDS_python_zopeinterface = python_core
FILES_python_zopeinterface = \
  $(PYTHON_DIR)/site-packages/zope/interface/common \
  $(PYTHON_DIR)/site-packages/zope/interface/tests \
  $(PYTHON_DIR)/site-packages/zope/interface/__init__.* \
  $(PYTHON_DIR)/site-packages/zope/interface/_flatten.* \
  $(PYTHON_DIR)/site-packages/zope/interface/_zope_interface_coptimizations.so \
  $(PYTHON_DIR)/site-packages/zope/interface/adapter.p* \
  $(PYTHON_DIR)/site-packages/zope/interface/advice.* \
  $(PYTHON_DIR)/site-packages/zope/interface/declarations.* \
  $(PYTHON_DIR)/site-packages/zope/interface/document.* \
  $(PYTHON_DIR)/site-packages/zope/interface/exceptions.* \
  $(PYTHON_DIR)/site-packages/zope/interface/interface.* \
  $(PYTHON_DIR)/site-packages/zope/interface/interfaces.* \
  $(PYTHON_DIR)/site-packages/zope/interface/ro.p* \
  $(PYTHON_DIR)/site-packages/zope/interface/verify.p*

$(DEPDIR)/zopeinterface.do_prepare: bootstrap python setuptools $(DEPENDS_zopeinterface)
	$(PREPARE_zopeinterface)
	touch $@

$(DEPDIR)/zopeinterface.do_compile: $(DEPDIR)/zopeinterface.do_prepare
	cd $(DIR_zopeinterface) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/zopeinterface: $(DEPDIR)/zopeinterface.do_compile
	$(start_build)
	cd $(DIR_zopeinterface) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
#	$(remove_pyc)
	$(toflash_build)
	touch $@

#
# pylimaging
#
BEGIN[[
pylimaging
  1.1.7
  Imaging-{PV}
  extract:http://effbot.org/downloads/Imaging-{PV}.tar.gz
  patch:file://pilimaging-fix-search-paths.patch
;
]]END
PACKAGES_pylimaging = python_imaging
DESCRIPTION_python_imaging =  Python Imaging Library
RDEPENDS_python_imaging = libz1 libfreetype6 python_core python_lang libjpeg8 python_stringold
FILES_python_imaging = $(PYTHON_DIR)/site-packages /usr/bin/*

$(DEPDIR)/pylimaging: bootstrap python setuptools $(DEPENDS_pylimaging)
	$(PREPARE_pylimaging)
	$(start_build)
	cd $(DIR_pylimaging) && \
		echo 'JPEG_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' > setup_site.py && \
		echo 'ZLIB_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		echo 'FREETYPE_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build && \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr && \
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# pycrypto
#
BEGIN[[
pycrypto
  2.5
  {PN}-{PV}
  extract:http://ftp.dlitz.net/pub/dlitz/crypto/{PN}/{PN}-{PV}.tar.gz
  patch:file://python-{PN}-no-usr-include.patch
;
]]END

PACKAGES_pycrypto = python_pycrypto
DESCRIPTION_python_pycrypto =  A collection of cryptographic algorithms and protocols
RDEPENDS_python_pycrypto = python_core libgmp10
FILES_python_pycrypto = \
$(PYTHON_DIR)/site-packages/Crypto/*


$(DEPDIR)/pycrypto.do_prepare: bootstrap setuptools $(DEPENDS_pycrypto)
	$(PREPARE_pycrypto)
	touch $@

$(DEPDIR)/pycrypto.do_compile: $(DEPDIR)/pycrypto.do_prepare
	cd $(DIR_pycrypto) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr
	touch $@

$(DEPDIR)/pycrypto: $(DEPDIR)/pycrypto.do_compile
	$(start_build)
	cd $(DIR_pycrypto) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# pyusb
#
BEGIN[[
pyusb
  1.0.0a3
  {PN}-{PV}
  extract:http://pypi.python.org/packages/source/p/{PN}/{PN}-{PV}.tar.gz
;
]]END
PACKAGES_pyusb = python_pyusb
DESCRIPTION_python_pyusb =  PyUSB provides USB access on the Python language
RDEPENDS_python_pyusb = python_core
FILES_python_pyusb = \
$(PYTHON_DIR)/site-packages/usb/*

$(DEPDIR)/pyusb.do_prepare: bootstrap setuptools $(DEPENDS_pyusb)
	$(PREPARE_pyusb)
	touch $@

$(DEPDIR)/pyusb.do_compile: $(DEPDIR)/pyusb.do_prepare
	cd $(DIR_pyusb) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pyusb: $(DEPDIR)/pyusb.do_compile
	$(start_build)
	cd $(DIR_pyusb) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# pyopenssl
#
BEGIN[[
pyopenssl
  0.13
  pyOpenSSL-{PV}
  extract:http://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-{PV}.tar.gz
;
]]END

PACKAGES_pyopenssl = python_pyopenssl python_pyopenssl_tests
DESCRIPTION_python_pyopenssl = Simple Python wrapper around the OpenSSL library
RDEPENDS_python_pyopenssl = python_threading libssl libcrypto
FILES_python_pyopenssl = \
  $(PYTHON_DIR)/site-packages/OpenSSL/*p* \
  $(PYTHON_DIR)/site-packages/OpenSSL/*so

DESCRIPTION_python_pyopenssl_tests = Simple Python wrapper around the OpenSSL library
RDEPENDS_python_pyopenssl_tests = python_pyopenssl
FILES_python_pyopenssl_tests = $(PYTHON_DIR)/site-packages/OpenSSL/test

$(DEPDIR)/pyopenssl.do_prepare: bootstrap setuptools $(DEPENDS_pyopenssl)
	$(PREPARE_pyopenssl)
	touch $@

$(DEPDIR)/pyopenssl.do_compile: $(DEPDIR)/pyopenssl.do_prepare
	cd $(DIR_pyopenssl) && \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/python$(PYTHON_VERSION)" \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pyopenssl: $(DEPDIR)/pyopenssl.do_compile
	$(start_build)
	cd $(DIR_pyopenssl) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@


#
# twisted
#
BEGIN[[
twisted
  12.0.0
  Twisted-{PV}
  extract:http://twistedmatrix.com/Releases/Twisted/12.0/Twisted-{PV}.tar.bz2
;
]]END
PKGR_twisted = r1
PACKAGES_twisted = python_twisted_conch \
		   python_twisted_core \
		   python_twisted_lore \
		   python_twisted_mail \
		   python_twisted_names \
		   python_twisted_news \
		   python_twisted_pair \
		   python_twisted_protocols \
		   python_twisted_runner \
		   python_twisted_test \
		   python_twisted_web \
		   python_twisted_words \
		   python_twisted_zsh \
		   python_twisted

DESCRIPTION_python_twisted = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including \
 HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more
RDEPENDS_python_twisted = python_twisted_news python_twisted_lore python_twisted_conch python_twisted_names python_twisted_words \
python_twisted_runner python_core python_twisted_web python_twisted_mail 
FILES_python_twisted = \

DESCRIPTION_python_twisted_conch = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including \
 HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more
RDEPENDS_python_twisted_conch = python_twisted_core python_twisted_protocols
FILES_python_twisted_conch = \
  /usr/bin/cftp \
  /usr/bin/ckeygen \
  /usr/bin/conch \
  /usr/bin/tkconch \
  $(PYTHON_DIR)/site-packages/twisted/conch/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/conch/client \
  $(PYTHON_DIR)/site-packages/twisted/conch/insults \
  $(PYTHON_DIR)/site-packages/twisted/conch/openssh_compat \
  $(PYTHON_DIR)/site-packages/twisted/conch/scripts \
  $(PYTHON_DIR)/site-packages/twisted/conch/ssh \
  $(PYTHON_DIR)/site-packages/twisted/conch/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/conch/ui \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_conch.p*

DESCRIPTION_python_twisted_core = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_core = python_core python_zopeinterface
FILES_python_twisted_core = \
  /usr/bin/manhole \
  /usr/bin/pyhtmlizer \
  /usr/bin/tap2deb \
  /usr/bin/tap2rpm \
  /usr/bin/tapconvert \
  /usr/bin/trial \
  /usr/bin/twistd \
  $(PYTHON_DIR)/site-packages/twisted/application/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/cred \
  $(PYTHON_DIR)/site-packages/twisted/enterprise \
  $(PYTHON_DIR)/site-packages/twisted/internet/*.* \
  $(PYTHON_DIR)/site-packages/twisted/internet/iocpreactor \
  $(PYTHON_DIR)/site-packages/twisted/manhole/ui \
  $(PYTHON_DIR)/site-packages/twisted/manhole/*.* \
  $(PYTHON_DIR)/site-packages/twisted/persisted/journal \
  $(PYTHON_DIR)/site-packages/twisted/persisted/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/__init__.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_anonymous.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_file.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_memory.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_unix.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_ftp.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_inet.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_manhole.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_portforward.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_qtstub.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_reactors.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_runner.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_socks.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_telnet.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_trial.* \
  $(PYTHON_DIR)/site-packages/twisted/python/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/scripts/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/spread \
  $(PYTHON_DIR)/site-packages/twisted/tap \
  $(PYTHON_DIR)/site-packages/twisted/trial/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/__init__.p* \
  $(PYTHON_DIR)/site-packages/twisted/_version.p* \
  $(PYTHON_DIR)/site-packages/twisted/copyright.p* \
  $(PYTHON_DIR)/site-packages/twisted/plugin.p*

DESCRIPTION_python_twisted_lore = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_lore = python_twisted_core
FILES_python_twisted_lore = \
  /usr/bin/lore \
  $(PYTHON_DIR)/site-packages/twisted/lore/*.* \
  $(PYTHON_DIR)/site-packages/twisted/lore/scripts \
  $(PYTHON_DIR)/site-packages/twisted/lore/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_lore.*

DESCRIPTION_python_twisted_mail = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_mail = python_twisted_core python_twisted_protocols
FILES_python_twisted_mail = \
  /usr/bin/mailmail \
  $(PYTHON_DIR)/site-packages/twisted/mail/*.* \
  $(PYTHON_DIR)/site-packages/twisted/mail/scripts \
  $(PYTHON_DIR)/site-packages/twisted/mail/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_mail.*

DESCRIPTION_python_twisted_names = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_names = python_twisted_core
FILES_python_twisted_names = \
  $(PYTHON_DIR)/site-packages/twisted/names/*.* \
  $(PYTHON_DIR)/site-packages/twisted/names/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_names.*

DESCRIPTION_python_twisted_news = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_news = python_twisted_core python_twisted_protocols
FILES_python_twisted_news = \
  $(PYTHON_DIR)/site-packages/twisted/news/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/news/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_news.*

DESCRIPTION_python_twisted_pair = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_pair = python_twisted_core
FILES_python_twisted_pair = \
  $(PYTHON_DIR)/site-packages/twisted/pair/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/pair/topfiles

DESCRIPTION_python_twisted_protocols = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_protocols = python_twisted_core
FILES_python_twisted_protocols = \
  $(PYTHON_DIR)/site-packages/twisted/protocols/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/protocols/mice \
  $(PYTHON_DIR)/site-packages/twisted/protocols/gps

DESCRIPTION_python_twisted_runner = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_runner = python_twisted_core python_twisted_protocols
FILES_python_twisted_runner = \
  $(PYTHON_DIR)/site-packages/twisted/runner/*.* \
  $(PYTHON_DIR)/site-packages/twisted/runner/topfiles

DESCRIPTION_python_twisted_test = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_test = python_twisted
FILES_python_twisted_test = \
  $(PYTHON_DIR)/site-packages/twisted/application/test \
  $(PYTHON_DIR)/site-packages/twisted/conch/test \
  $(PYTHON_DIR)/site-packages/twisted/internet/test \
  $(PYTHON_DIR)/site-packages/twisted/lore/test \
  $(PYTHON_DIR)/site-packages/twisted/mail/test \
  $(PYTHON_DIR)/site-packages/twisted/manhole/test \
  $(PYTHON_DIR)/site-packages/twisted/names/test \
  $(PYTHON_DIR)/site-packages/twisted/news/test \
  $(PYTHON_DIR)/site-packages/twisted/pair/test \
  $(PYTHON_DIR)/site-packages/twisted/persisted/test \
  $(PYTHON_DIR)/site-packages/twisted/protocols/test \
  $(PYTHON_DIR)/site-packages/twisted/python/test \
  $(PYTHON_DIR)/site-packages/twisted/runner/test \
  $(PYTHON_DIR)/site-packages/twisted/scripts/test \
  $(PYTHON_DIR)/site-packages/twisted/test \
  $(PYTHON_DIR)/site-packages/twisted/trial/test \
  $(PYTHON_DIR)/site-packages/twisted/web/test \
  $(PYTHON_DIR)/site-packages/twisted/words/test

DESCRIPTION_python_twisted_web = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_web = python_twisted_core python_twisted_protocols
FILES_python_twisted_web = \
  $(PYTHON_DIR)/site-packages/twisted/web/*.* \
  $(PYTHON_DIR)/site-packages/twisted/web/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/web/_auth \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_web.*

DESCRIPTION_python_twisted_words = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_words = python_twisted_core
FILES_python_twisted_words = \
  $(PYTHON_DIR)/site-packages/twisted/words/*.* \
  $(PYTHON_DIR)/site-packages/twisted/words/im \
  $(PYTHON_DIR)/site-packages/twisted/words/protocols \
  $(PYTHON_DIR)/site-packages/twisted/words/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/words/xish \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_words.*

DESCRIPTION_python_twisted_zsh = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_zsh = python_twisted_core
FILES_python_twisted_zsh = \
  $(PYTHON_DIR)/site-packages/twisted/python/zshc* \
  $(PYTHON_DIR)/site-packages/twisted/python/zsh


$(DEPDIR)/twisted.do_prepare: bootstrap setuptools $(DEPENDS_twisted)
	$(PREPARE_twisted)
	touch $@

$(DEPDIR)/twisted.do_compile: $(DEPDIR)/twisted.do_prepare
	cd $(DIR_twisted) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/twisted: $(DEPDIR)/twisted.do_compile
	$(start_build)
	cd $(DIR_twisted) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@


#
# mutagen
#
BEGIN[[
mutagen
  1.22
  {PN}-{PV}
  extract:https://mutagen.googlecode.com/files/{PN}-{PV}.tar.gz
;
]]END
PACKAGES_mutagen = python_mutagen
DESCRIPTION_python_mutagen = Module for manipulating ID3 (v1 + v2) tags in Python
BDEPENDS_python_mutagen = python_core python_shell
FILES_python_mutagen = \
  $(PYTHON_DIR)/site-packages/mutagen \
  /usr/bin

$(DEPDIR)/mutagen.do_prepare: bootstrap python setuptools $(DEPENDS_mutagen)
	$(PREPARE_mutagen)
	touch $@

$(DEPDIR)/mutagen.do_compile: $(DEPDIR)/mutagen.do_prepare
	cd $(DIR_mutagen) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/mutagen: $(DEPDIR)/mutagen.do_compile
	$(start_build)
	cd $(DIR_mutagen) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@


#
# gdata
#
BEGIN[[
gdata
  2.0.18
  gdata-{PV}
  extract:http://gdata-python-client.googlecode.com/files/gdata-{PV}.tar.gz
;
]]END

PACKAGES_gdata = python_gdata

DESCRIPTION_python_gdata = Google Data APIs Python Client Library
RDEPENDS_python_gdata = python_core python_elementtree
FILES_python_gdata = \
  $(PYTHON_DIR)/site-packages/atom/*.* \
  $(PYTHON_DIR)/site-packages/gdata/*.* \
  $(PYTHON_DIR)/site-packages/gdata/


$(DEPDIR)/gdata.do_prepare: bootstrap setuptools $(DEPENDS_gdata)
	$(PREPARE_gdata)
	touch $@

$(DEPDIR)/gdata.do_compile: $(DEPDIR)/gdata.do_prepare
	cd $(DIR_gdata) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/gdata: $(DEPDIR)/gdata.do_compile
	$(start_build)
	cd $(DIR_gdata) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@


#
# mechanize
#
BEGIN[[
mechanize
  0.2.5
  {PN}-{PV}
  extract:http://pypi.python.org/packages/source/m/{PN}/{PN}-{PV}.tar.gz
;
]]END

PKGR_mechanize = r1
PACKAGES_mechanize = python_mechanize
DESCRIPTION_python_mechanize = Stateful programmatic web browsing, after Andy Lester's Perl module WWW::Mechanize.
BDEPENDS_python_mechanize = python_core python_robotparser
FILES_python_mechanize = \
$(PYTHON_DIR)/site-packages/mechanize/*.p*

$(DEPDIR)/mechanize.do_prepare: bootstrap python setuptools $(DEPENDS_mechanize)
	$(PREPARE_mechanize)
	touch $@

$(DEPDIR)/mechanize.do_compile: $(DEPDIR)/mechanize.do_prepare
	cd $(DIR_mechanize) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/mechanize: $(DEPDIR)/mechanize.do_compile
	$(start_build)
	cd $(DIR_mechanize) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@


#
# setuptools
#
BEGIN[[
setuptools
  0.6c11
  {PN}-{PV}
  extract:http://pypi.python.org/packages/source/s/{PN}/{PN}-{PV}.tar.gz
;
]]END

DESCRIPTION_setuptools = "setuptools"
DEPENDS_setuptools += python

FILES_setuptools = \
$(PYTHON_DIR)/site-packages/*.py \
$(PYTHON_DIR)/site-packages/*.pyo \
$(PYTHON_DIR)/site-packages/setuptools/*.py \
$(PYTHON_DIR)/site-packages/setuptools/*.pyo \
$(PYTHON_DIR)/site-packages/setuptools/command/*.py \
$(PYTHON_DIR)/site-packages/setuptools/command/*.pyo

$(DEPDIR)/setuptools.do_prepare: bootstrap $(DEPENDS_setuptools)
	$(PREPARE_setuptools)
	touch $@

$(DEPDIR)/setuptools.do_compile: $(DEPDIR)/setuptools.do_prepare
	cd $(DIR_setuptools) && \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/setuptools: $(DEPDIR)/setuptools.do_compile
	$(start_build)
	cd $(DIR_setuptools) && \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	touch $@

#
# lxml
#
BEGIN[[
lxml
  2.2.8
  {PN}-{PV}
  extract:http://launchpad.net/{PN}/2.2/{PV}/+download/{PN}-{PV}.tgz
;
]]END

DESCRIPTION_lxml = "Python binding for the libxml2 and libxslt libraries"
BDEPENDS_lxml = python

FILES_lxml = \
$(PYTHON_DIR)

$(DEPDIR)/lxml.do_prepare: bootstrap $(DEPENDS_lxml)
	$(PREPARE_lxml)
	touch $@

$(DEPDIR)/lxml.do_compile: $(DEPDIR)/lxml.do_prepare
	cd $(DIR_lxml) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build \
			--with-xml2-config=$(crossprefix)/bin/xml2-config \
			--with-xslt-config=$(crossprefix)/bin/xslt-config
	touch $@

$(DEPDIR)/lxml: $(DEPDIR)/lxml.do_compile
	$(start_build)
	cd $(DIR_lxml) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(extra_build)
	touch $@


#
# libxslt
#
BEGIN[[
libxslt
  1.1.28
  {PN}-{PV}
  extract:http://xmlsoft.org/sources/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libxslt = "XML stylesheet transformation library"
FILES_libxslt = \
/usr/lib/libxslt* \
/usr/lib/libexslt* \
$(PYTHON_DIR)/site-packages/libxslt.py

$(DEPDIR)/libxslt.do_prepare: bootstrap libxml2 $(DEPENDS_libxslt)
	$(PREPARE_libxslt)
	touch $@

$(DEPDIR)/libxslt.do_compile: $(DEPDIR)/libxslt.do_prepare
	cd $(DIR_libxslt) && \
		$(BUILDENV) \
		./configure \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/libxml2 -Os" \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-libxml-prefix="$(crossprefix)" \
			--with-libxml-include-prefix="$(targetprefix)/usr/include" \
			--with-libxml-libs-prefix="$(targetprefix)/usr/lib" \
			--with-python=$(crossprefix)/bin \
			--without-crypto \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libxslt: libxml2 libxslt.do_compile
	$(start_build)
	cd $(DIR_libxslt) && \
		$(INSTALL_libxslt) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xslt-config > $(crossprefix)/bin/xslt-config && \
		chmod 755 $(crossprefix)/bin/xslt-config
	$(tocdk_build_start)
	sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(ipkgbuilddir)/libxslt/usr/lib/xsltConf.sh
	sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(ipkgbuilddir)/libxslt/usr/lib/xsltConf.sh
	$(call do_build_pkg,install,cdk)
	$(toflash_build)
	touch $@

#
# elementtree
#
BEGIN[[
elementtree
  1.2.6-20050316
  {PN}-{PV}
  extract:http://effbot.org/media/downloads/{PN}-{PV}.tar.gz
;
]]END

DESCRIPTION_elementtree = "Provides light-weight components for working with XML"
FILES_elementtree = \
$(PYTHON_DIR)

$(DEPDIR)/elementtree.do_prepare: bootstrap $(DEPENDS_elementtree)
	$(PREPARE_elementtree)
	touch $@

$(DEPDIR)/elementtree.do_compile: $(DEPDIR)/elementtree.do_prepare
	touch $@

$(DEPDIR)/elementtree: $(DEPDIR)/elementtree.do_compile
	$(start_build)
	cd $(DIR_elementtree) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@
