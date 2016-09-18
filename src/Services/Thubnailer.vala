// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2016-2016 elementary LLC.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Artem Anufrij <artem.anufrij@live.de>
 *
 */

namespace Audience.Services {
    [DBus (name = "org.freedesktop.thumbnails.Thumbnailer1")]
    private interface Tumbler : GLib.Object {
        public abstract uint Queue (string[] uris, string[] mime_types, string flavor, string sheduler, uint handle_to_dequeue) throws GLib.IOError, GLib.DBusError;
        public signal void Finished (uint handle);
    }

    public class DbusThumbnailer : GLib.Object {
        private Tumbler tumbler;
        private Gee.ArrayList<string> uris;
        private Gee.ArrayList<string> mimes;


        private const string THUMBNAILER_IFACE = "org.freedesktop.thumbnails.Thumbnailer1";
        private const string THUMBNAILER_SERVICE = "/org/freedesktop/thumbnails/Thumbnailer1";

        public signal void finished (uint handle);

        public DbusThumbnailer () {
            this.uris = new Gee.ArrayList<string> ();
            this.mimes = new Gee.ArrayList<string> ();

            try {
                this.tumbler = Bus.get_proxy_sync (BusType.SESSION, THUMBNAILER_IFACE, THUMBNAILER_SERVICE);
                this.tumbler.Finished.connect ((handle) => { finished (handle); });
            } catch (Error e) {
                warning (e.message);
            }
        }

        public uint Queue (string uri, string mime) {
            this.uris.add (uri);
            this.mimes.add (mime);

            uint handle = this.tumbler.Queue (this.uris.to_array (), this.mimes.to_array (), "normal", "default", 0);

            this.uris.clear ();
            this.mimes.clear ();

            return handle;
        }
    }
}
