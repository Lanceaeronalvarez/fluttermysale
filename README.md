# flutter_mysale

installs flutter version manager
$ dart pub global activate fvm

downloads flutter version to fvm global cache, will use version specified in .fvmrc
$ fvm install

creates a link to the version stored in global cache, will use version specified in .fvmrc
$ cd <project directory>
$ fvm use

download dependencies
$ fvm flutter pub get

Notes
prefix commands with fvm in terminal
$ fvm flutter run
$ fvm flutter build apk