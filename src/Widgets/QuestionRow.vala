/* QuestionRow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    public class QuestionRow : Gtk.ListBoxRow {
        public Gtk.Image image { get; set; }
        public Gtk.Widget widget { get; set; }
        private Gtk.Label number_label;
        private int _page;
        public int page {
            get {
                return _page;
            }
            set {
                _page = value;
                number_label.label = value.to_string ();
            }
        }

        public signal void trash_request (QuestionRow r);

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
            margin_top = 3;
            margin_bottom = 3;
            margin_start = 3;
            margin_end = 3;

            number_label = new Gtk.Label ("");
            image = new Gtk.Image () {
                icon_size = LARGE,
                hexpand = true,
                halign = CENTER
            };

            image.icon_name = possible_icons[Random.int_range (0, possible_icons.length)];

            var trash_button = new TrashButton ();
            trash_button.clicked.connect (() => {
                trash_request (this);
            });

            var c_box = new Gtk.CenterBox () {
                margin_top = 6,
                margin_bottom = 6,
            };
            c_box.set_start_widget (trash_button);

            var vbox = new Gtk.Box (VERTICAL, 6);
            vbox.append (image);
            vbox.append (number_label);

            c_box.set_center_widget (vbox);
            child = c_box;
        }
    }
}
