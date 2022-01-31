/* SlideRow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    public class SlideRow : Gtk.ListBoxRow {
        public Gtk.Image image { get; set; }
        private Gtk.Label number_label;
        private string _page;
        public string page {
            get {
                return _page;
            }
            set {
                _page = value;
                number_label.label = value;
            }
        }

        private string[] possible_icons = {
            "audio-volume-high-symbolic",
            "mail-unread-symbolic",
            "zoom-in-symbolic",
            "zoom-original-symbolic",
            "alarm-symbolic",
            "dialog-error-symbolic",
            "user-trash-symbolic",
            "security-low-symbolic",
            "dialog-warning-symbolic",
            "display-projector-symbolic"
        };

        construct {
            number_label = new Gtk.Label ("");
            image = new Gtk.Image () {
                icon_size = LARGE
            };

            image.icon_name = possible_icons[Random.int_range (0, possible_icons.length)];

            var box = new Gtk.Box (VERTICAL, 0) {
                margin_top = 6,
		        margin_bottom = 6,
		        margin_start = 6
            };
            box.append (image);
            box.append (number_label);

            child = box;
        }
    }
}
