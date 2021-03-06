/* ColorButton.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    public class ColorButton : Adw.Bin {
        private Gtk.CssProvider css_provider = new Gtk.CssProvider ();
        private const int WIDTH = 36;
        private const int HEIGHT = 24;

        private Gdk.RGBA _color;
        public Gdk.RGBA rgba {
            get {
                return _color;
            }
            set {
                value.alpha = 1;
                _color = value;

                visible = true;
                css_provider.load_from_data ((uint8[])
                    "* { background-color: %s; }".printf (value.to_string ())
                );
                color_activated (_color);
            }
        }

        public signal void color_activated (Gdk.RGBA c);

        construct {
            get_style_context ().add_provider (
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_USER
            );

            visible = false;
            width_request = WIDTH;
            height_request = HEIGHT;
            valign = CENTER;

            var controller = new Gtk.GestureClick ();

            controller.released.connect (() => {
                var chooser = new Gtk.ColorChooserWidget () {
                    hexpand = true,
                    halign = CENTER,
                    vexpand = true,
                    valign = CENTER
                };

                var dialog = new Gtk.ColorChooserDialog (
                    _("Pick a color"),
                    get_native () as Gtk.Window
                );

                dialog.modal = true;

                dialog.color_activated.connect ((c) => {
                    rgba = c;
                });

                dialog.response.connect ((res) => {
                    if (res == Gtk.ResponseType.OK) {
                        rgba = dialog.get_rgba ();
                    }
                    dialog.close ();
                });

                dialog.show ();
            });

            add_controller (controller);
        }
    }
}
