/* window.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
	[GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/window.ui")]
	public class Window : Adw.ApplicationWindow {
	    [GtkChild] unowned Sidebar sidebar;
	    [GtkChild] unowned Adw.WindowTitle title_widget;

		public Window (Gtk.Application app) {
			Object (
			    application: app
			);
		}

		construct {
		}

		[GtkCallback]
		private void on_play_button_clicked () {
		}

		[GtkCallback]
		private void open_file_request () {
		    var filters = new Gtk.FileFilter () {
                name = "XML"
            };

            filters.add_suffix ("xml");
            filters.add_suffix ("quiz");

            var filechooser = new Gtk.FileChooserNative (
                null,
                this,
                OPEN,
                null,
                null
            );
            filechooser.add_filter (filters);

            filechooser.response.connect ((res) => {
                if (res == Gtk.ResponseType.ACCEPT) {
                    var path = filechooser.get_file ().get_path ();
                    title_widget.subtitle = path;
                    try {
                        sidebar.quiz = new Core.Quiz.from_file (path);
                    }
                    catch (Error e) {
                        critical (e.message);
                    }
                }
            });

            filechooser.show ();
		}
	}
}
