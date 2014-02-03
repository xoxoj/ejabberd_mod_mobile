ejabberd_mod_mobile
===================

Several useful ejabberd modules for mobile usage

* mod_mobile_echo
 * Echo sending messages to its other resources. Can be used as an ACK.
* mod_push_notification
 * Send push notification to mobile device/web browser through APN, GCM and others
* mod_chat_list
 * Keep chat list, unread message count
 * Archive and fetch messages
* mod_mobile_groupchat
 * Invitation based group chat
* mod_mqtt
 * MQTT interface for ejabberd


Since each sub module doesn't have dependencies,
you can turn on/off each module in ejabberd.yml


How to compile and install
--------------
 1. Download ejabberd source and build it
 2. Make a soft link to your ejabberd source dir in this directory as `ejabberd`
 3. Do `make`
 4. Copy `ebin/*.beam` to your ejabberd ebin dir
 5. Add modules to your ejabberd.yml


LICENSE
-------
Copyright (C) 2014   Keewon Seo

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
02111-1307 USA


Support
------------------
For bug reporting and suggestions, use GitHub issues.

You can also get commercial support by contacting to oedalpha@gmail.com.
 - Customizing ejabberd modules or developing new modules
 - Other consulting

