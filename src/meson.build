quizmaker_sources = [
  'main.vala',
  'Application.vala',

  'Core/Question.vala',
  'Core/Quiz.vala',

  'Widgets/ColorButton.vala',
  'Widgets/QuestionList.vala',
  'Widgets/QuestionPage.vala',
  'Widgets/QuestionRow.vala',
  'Widgets/Window.vala',
]

quizmaker_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('libxml-2.0'),
]

blueprints_src = [
    'window.blp',
    'sidebar.blp',
    'questionpage.blp',
    'questionrow.blp',
]
blueprints_ui = []
blueprints_vala = []
foreach b : blueprints_src
	blueprints_ui += b.replace('.blp', '.ui')
	blueprints_vala += b + '.vala'
endforeach


blueprints = custom_target('blueprints',
  input: blueprints_src,
  output: '.',
  command: [find_program('blueprint-compiler'), 'batch-compile', '@OUTDIR@', '@CURRENT_SOURCE_DIR@', '@INPUT@'],
)

blueprints_hack = custom_target('blueprints_hack',
	input: blueprints,
	output: blueprints_vala,
	command: [find_program('touch'), '@OUTPUT@'],
)

gnome = import('gnome')

xml_resources = files('quizmaker.gresources.xml')

quizmaker_resources = gnome.compile_resources(app_id,
  xml_resources,
  c_name: 'Quizmaker',
  dependencies: [blueprints,blueprints_hack],
)

quizmaker_sources += quizmaker_resources

conf = configuration_data()
conf.set_quoted('APP_ID', app_id)
conf.set_quoted('G_LOG_DOMAIN', 'QuizMaker')
conf.set_quoted('PRETTY_NAME', 'Quiz Maker')
conf.set_quoted('VERSION', meson.project_version())
configure_file(output: 'config.h', configuration: conf)

add_project_arguments(
    '-include', 'config.h',
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

executable('quizmaker', [ blueprints_hack, quizmaker_sources ],
  vala_args: [
    '--gresourcesdir=src/',
    '--target-glib=2.50',
    meson.project_source_root() + '/src/vapi/config.vapi',
  ],
  dependencies: quizmaker_deps,
  install: true,
)
