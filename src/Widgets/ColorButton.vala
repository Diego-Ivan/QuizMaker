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
        public Gdk.RGBA color {
            get {
                return _color;
            }
            set {
                _color = value;
                visible = true;
                message ("Setting Color to %s", value.to_string ());
                css_provider.load_from_data ((uint8[])
                    "* { background-color: %s; }".printf (value.to_string ())
                );
                color_selected (_color);
            }
        }

        public signal void color_selected (Gdk.RGBA c);

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

                var headerbar = new Gtk.HeaderBar ();
                headerbar.add_css_class ("flat");

                var window = new Gtk.Window () {
                    default_height = 340,
                    default_width = 530,
                    modal = true,
                    title = _("Pick a color"),
                    titlebar = headerbar,
                    transient_for = get_native () as Gtk.Window,
                    child = chooser,
                };
                chooser.color_activated.connect ((c) => {
                    color = c;
                });

                window.present ();
                window.close_request.connect (() => {
                    color = chooser.get_rgba ();
                    return false;
                });
            });

            add_controller (controller);
        }
    }
}
