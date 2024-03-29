include(CheckIncludeFiles)
include(CheckIncludeFileCXX)
include(CheckFunctionExists)
include(CheckStructHasMember)
include(TestBigEndian)
find_package (Threads REQUIRED)



set(CMAKE_INSTALL_PREFIX /usr)

TEST_BIG_ENDIAN(BIGENDIAN)
if(${BIGENDIAN})
	set(HAVE_BIG_ENDIAN 1)
else()
	set(HAVE_LITTLE_ENDIAN 1)
endif()



set(HAVE_LINUX_OS 1)
set(HAVE_PTHREADS 1)
set(HAVE_OOM_ADJ 1)
set(HAVE_SYMLINKS 1)
set(HAVE_SYSTEM_PROPERTY_SERVER 1)
set(HAVE_PRINTF_ZD 1)
set(OS_SHARED_LIB_FORMAT_STR "lib%s.so")
set(MINCORE_POINTER_TYPE "unsigned char *")
set(HAVE_SA_NOCLDWAIT 1)
set(OS_PATH_SEPARATOR "/")
set(OS_CASE_SENSITIVE 1)
set(_FILE_OFFSET_BITS 64)
set(_LARGEFILE_SOURCE 1)
set(HAVE_OFF64_T)
set(HAVE_FUTEX 1)
string(TOUPPER ${CMAKE_SYSTEM_PROCESSOR} ARCH)
set(PLATFORM_ARCH "ARCH_${ARCH}")


CHECK_INCLUDE_FILES(sys/uio.h HAVE_SYS_UIO_H)
CHECK_INCLUDE_FILES(sys/ipc.h HAVE_SYSV_IPC)
CHECK_INCLUDE_FILES(termio.h  HAVE_TERMIO_H)
CHECK_INCLUDE_FILES(sys/sendfile.h  HAVE_SYS_SENDFILE_H)
CHECK_INCLUDE_FILES(sys/mman.h HAVE_POSIX_FILEMAP)
CHECK_INCLUDE_FILE_CXX(cxxabi.h HAVE_CXXABI)
CHECK_INCLUDE_FILES(malloc.h HAVE_MALLOC_H)
CHECK_INCLUDE_FILES(sys/inotify.h HAVE_INOTIFY)
CHECK_INCLUDE_FILE(sys/epoll.h HAVE_EPOLL)
CHECK_INCLUDE_FILE(endian.h HAVE_ENDIAN_H)
CHECK_INCLUDE_FILE(sys/socket.h HAVE_SYS_SOCKET_H)
CHECK_INCLUDE_FILE(stdint.h HAVE_STDINT_H)
CHECK_INCLUDE_FILE(stdbool.h HAVE_STDBOOL_H)
CHECK_INCLUDE_FILE(sched.h HAVE_SCHED_H)


CHECK_FUNCTION_EXISTS(fork HAVE_FORKEXEC)
CHECK_FUNCTION_EXISTS(localtime_r HAVE_LOCALTIME_R)
CHECK_FUNCTION_EXISTS(gethostbyname_r HAVE_GETHOSTBYNAME_R)
CHECK_FUNCTION_EXISTS(ioctl HAVE_IOCTL)
CHECK_FUNCTION_EXISTS(clock_gettime HAVE_POSIX_CLOCKS)
CHECK_FUNCTION_EXISTS(pthread_cond_timedwait_monotonic HAVE_TIMEDWAIT_MONOTONIC)
CHECK_FUNCTION_EXISTS(backtrace HAVE_BACKTRACE)
CHECK_FUNCTION_EXISTS(gettid HAVE_GETTID)
CHECK_FUNCTION_EXISTS(sched_setscheduler HAVE_SCHED_SETSCHEDULER)
CHECK_FUNCTION_EXISTS(madvise HAVE_MADVISE)
CHECK_FUNCTION_EXISTS(strlcpy HAVE_STRLCPY)
CHECK_FUNCTION_EXISTS(open_memstream HAVE_OPEN_MEMSTREAM)
CHECK_FUNCTION_EXISTS(funopen HAVE_FUNOPEN)
CHECK_FUNCTION_EXISTS(prctl HAVE_PRCTL)
CHECK_FUNCTION_EXISTS(writev HAVE_WRITEV)
CHECK_FUNCTION_EXISTS(pread HAVE_PREAD)

CHECK_STRUCT_HAS_MEMBER("struct tm" tm_gmtoff time.h HAVE_TM_GMTOFF)
CHECK_STRUCT_HAS_MEMBER("struct dirent" d_type dirent.h HAVE_DIRENT_D_TYPE)
CHECK_STRUCT_HAS_MEMBER("struct stat" st_mtim sys/stat.h HAVE_STAT_ST_MTIM)

configure_file(${CMAKE_CURRENT_LIST_DIR}/config.h.in ${CMAKE_BINARY_DIR}/config.h)
add_definitions(-include ${CMAKE_BINARY_DIR}/config.h -DANDROID_SMP=1)

set(INSTALL_LIB_DIR lib${LIB_SUFFIX}/android CACHE PATH "Installation directory for libraries")
set(INSTALL_INCLUDE_DIR include/android CACHE PATH "Installation directory for header files")
set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")

foreach(p LIB INCLUDE BIN)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

set(ANDROID_ROOT ${CMAKE_INSTALL_PREFIX})

set(ENV{PKG_CONFIG_PATH} "${ANDROID_ROOT}/lib${LIB_SUFFIX}/android/pkgconfig")

list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_LIST_DIR})

SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
