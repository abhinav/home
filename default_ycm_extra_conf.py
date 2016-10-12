# This provides a nice default global YCM extra conf. It provides some
# reasonable defaults and reads .clang_complete files.
#
# Use by setting,
#
#   let g:ycm_global_ycm_extra_conf = '~/.dotfiles/default_ycm_extra_conf.py'

from __future__ import unicode_literals, print_function

from os import path


DEFAULT_FLAGS = (
    '-Wall',
    '-I/usr/include',
    '-I/usr/local/include',
)

DEFAULT_C_FLAGS = (
    '-xc',
)

DEFAULT_CPP_FLAGS = (
    '-xc++',
    '-std=c++14',
)


CPP_SOURCES = ('cc', 'cpp', 'cxx')
CPP_FILES = CPP_SOURCES + ('hh', 'hpp', 'hxx')


def is_cpp(filename):
    base, ext = path.splitext(filename)
    if ext[1:] in CPP_FILES:
        return True

    # Header is .h but file might be cpp
    if ext == 'h':
        return any(path.exists(base + '.' + ext) for ext in CPP_SOURCES)

    return False


def findup(root, name):
    while True:
        candidate = path.join(root, name)
        if path.exists(candidate):
            return candidate
        parent = path.dirname(root)
        if parent == root:
            return None
        root = parent


def flags_from_clang_complete(root):
    clang_complete = findup(root, '.clang_complete')
    if not clang_complete:
        return None
    with open(clang_complete, 'r') as f:
        return list(l.strip() for l in f)


def flags_implicit(root):
    include = findup(root, 'include')
    if not include:
        return None
    return ['-I' + include]


def flags_for_file(filename):
    root = path.realpath(path.dirname(filename))

    flags = list(DEFAULT_FLAGS)
    if is_cpp(filename):
        flags += DEFAULT_CPP_FLAGS
    else:
        flags += DEFAULT_C_FLAGS

    for f in [flags_from_clang_complete, flags_implicit]:
        new_flags = f(root)
        if new_flags is not None:
            flags += new_flags
            break

    return flags


def FlagsForFile(filename):
    return {'flags': flags_for_file(filename), 'do_cache': True}
