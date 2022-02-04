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
	    [GtkChild] unowned Gtk.Picture picture;

		public Window (Gtk.Application app) {
			Object (
			    application: app
			);
		}

		construct {
		}

		[GtkCallback]
		private void on_play_button_clicked () {
		    var snap = new Gtk.Snapshot ();
		    var f_row = sidebar.listbox.get_row_at_y (1);

		    Graphene.Size size = {
		        300,
		        300
		    };

		    f_row.snapshot (snap);
		    picture.paintable = snap.to_paintable (size);
		}
	}
}