project('quizmaker', ['c', 'vala'],
          version: '0.1.0',
    meson_version: '>= 0.58.0',
  default_options: [ 'warning_level=2',
                   ],
)

i18n = import('i18n')

app_id = 'io.github.diegoivanme.quizmaker'


subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
