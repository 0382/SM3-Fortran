project(
    'sm3-fortran',
    'fortran', 'c',
    version: '1.0.0',
    license: 'MIT',
    default_options: [
        'buildtype=debugoptimized',
        'fortran_std=f2008',
        'default_library=both',
        'c_std=c11',
    ],
)

# add source files
src = files(
    'src/SM3.f90',
    'GmSSL/src/sm3.c',
    'GmSSL/src/md5.c',
    'GmSSL/src/hex.c',
)

sm3_fortran_inc = include_directories(
    'GmSSL/include',
)

sm3_fortran_lib = library(
    meson.project_name(),
    src,
    include_directories: sm3_fortran_inc,
    install: true,
    version: meson.project_version(),
)

# declare dependency
sm3_fortran_dep = declare_dependency(
    include_directories: sm3_fortran_lib.private_dir_include(),
    link_with: sm3_fortran_lib,
)

# add example
example_md5 = executable(
    'example_md5',
    'example/example_md5.f90',
    dependencies: sm3_fortran_dep,
)

example_sm3 = executable(
    'example_sm3',
    'example/example_sm3.f90',
    dependencies: sm3_fortran_dep,
)

example_md5test = executable(
    'example_md5test',
    'GmSSL/example/md5test.c',
    dependencies: sm3_fortran_dep,
    include_directories: sm3_fortran_inc,
)

# copy LICENSE file
sm3_fortran_lic = files('LICENSE')
GmSSL_lic = files('GmSSL/LICENSE')

install_data(
    sm3_fortran_lic,
    install_dir: join_paths(get_option('prefix'), 'licenses', meson.project_name()),
)
install_data(
    GmSSL_lic,
    install_dir: join_paths(get_option('prefix'), 'licenses', meson.project_name(), 'GmSSL'),
)



# install fortran module
if host_machine.system() == 'windows'
    symbols_file = 'lib'+meson.project_name()+'-'+meson.project_version().split('.')[0]+'.dll.symbols'
    obj_suffix = '.obj'
else
    symbols_file = 'lib'+meson.project_name()+'.so.'+meson.project_version()+'.symbols'
    obj_suffix = '.o'
endif

install_subdir(sm3_fortran_lib.full_path()+'.p',
    install_dir: 'include'/meson.project_name(),
    strip_directory: true,
    exclude_files: [
        'depscan.dd',
        meson.project_name()+'-deps.json',
        symbols_file,
        meson.project_name()+'.dat',
        'src_SM3.f90'+obj_suffix,
        'GmSSL_src_md5.c'+obj_suffix,
        'GmSSL_src_sm3.c'+obj_suffix,
        'GmSSL_src_hex.c'+obj_suffix,
    ]
)

# install pkg-config file
pkg = import('pkgconfig')
pkg.generate(
    sm3_fortran_lib,
    name: meson.project_name(),
    description: 'The SM3 password hashing algorithm is a hash algorithm similar to SHA-256',
    version: meson.project_version(),
    subdirs: meson.project_name(),
)
