/* TrashButton.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    public class TrashButton : Adw.Bin {
        public signal void clicked ();

        public TrashButton () {
            Object (
                css_name: "trashbutton"
            );
        }

        construct {
            var image = new Gtk.Image () {
                icon_name = "user-trash-symbolic"
            };

            child = image;

            var gesture = new Gtk.GestureClick ();

            gesture.released.connect (() => {
                clicked ();
            });

            add_controller (gesture);
        }
    }
}
