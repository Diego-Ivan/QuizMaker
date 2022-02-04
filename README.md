<div align="center">

# QuizMaker

**A Quiz Editor and Player**

This project is being developed as part of my IB CAS

</div>

## Install and Running

### GNOME Builder

The recommended way of running this project is through Flatpak and GNOME Builder. Clone the project and run. Requires the `org.gnome.Platform` runtime, from the master branch. You can get it from the GNOME Nightly Flatpak remote. Libpanel will be built with the project.

To install, use the *Export as package* feature (available in the top bar omniarea) and open the `.flatpak` double-clicking, and install.

### Other

This project requires the following dependencies:

```
gtk4
libadwaita-1
libpanel-1
libxml-2.0
```

The `blueprint-compiler` will be built as subproject.

Build using the Meson Build System:

```sh
meson builddir --prefix=/usr
cd builddir
ninja
./src/quizmaker
```

To install, run in the `builddir`:

```sh
sudo ninja install
```