%%%----------------------------------------------------------------------
%%% File    : mod_mobile_echo.erl
%%%
%%% Copyright (C) 2014   Keewon Seo
%%%
%%% This program is free software; you can redistribute it and/or
%%% modify it under the terms of the GNU General Public License as
%%% published by the Free Software Foundation; either version 2 of the
%%% License, or (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%%% General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with this program; if not, write to the Free Software
%%% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
%%% 02111-1307 USA
%%%
%%%----------------------------------------------------------------------

-module(mod_mobile_echo).
-author('oedalpha@gmail.com').

-behaviour(gen_mod).

-export([start/2,
	 stop/1,
	 user_send_packet/3]).

-define(PROCNAME, ?MODULE).
-define(NS_FORWARD, <<"urn:xmpp:forward:0">>).

-include("ejabberd.hrl").
-include("jlib.hrl").
-include("logger.hrl").

start(Host, _Opts) ->
    ?INFO_MSG("Starting mod_mobile_echo", [] ),
    ejabberd_hooks:add(user_send_packet, Host, ?MODULE, user_send_packet, 90),
    ok.

stop(Host) ->
    ?INFO_MSG("Stopping mod_mobile_echo", [] ),
    ejabberd_hooks:delete(user_send_packet, Host, ?MODULE, user_send_packet, 90),
    ok.

user_send_packet(From, _To, #xmlel{name = <<"message">>, attrs = Attrs} = Packet) ->
    case xml:get_attr_s(<<"type">>, Attrs) of
        <<"groupchat">> ->
            ok;
        <<"error">> ->
            ok;
        <<"headline">> ->
            ok;
        _ ->
            case xml:get_subtag(Packet, <<"private">>) of
                false ->
                    case xml:get_subtag(Packet,<<"forwarded">>) of
                        false ->
                            echo_packet(From, Packet);
                        _ ->
                            ok
                    end;
                _ ->
                    ok
            end
    end;

user_send_packet(_, _, _) ->
    ok.

echo_packet(#jid{} = From, Packet) ->
    FromStr = jlib:jid_to_string(From),
    BareJid = jlib:jid_remove_resource(From),
    BareJidStr = jlib:jid_to_string(BareJid),
    NewPacket = #xmlel{name = <<"message">>,
           attrs = [ % {<<"xmlns">>, <<"jabber:client">>},
                    {<<"type">>, <<"chat">>},
                    {<<"from">>, FromStr},
                    {<<"to">>, BareJidStr}],
           children = [
                    #xmlel{name = <<"forwarded">>,
                            attrs = [{<<"xmlns">>, ?NS_FORWARD}],
                            children = [
                            % delay element can be here
                            complete_packet(FromStr, Packet)]}
           ]},

    ejabberd_router:route(From, BareJid, NewPacket).

%% copied and modified from mod_carboncopy.erl
complete_packet(FromStr, #xmlel{name = <<"message">>, attrs = OrigAttrs} = Packet) ->
    %% if this is a packet sent by user on this host, then Packet doesn't
    %% include the 'from' attribute. We must add it.
    Attrs = lists:keystore(<<"xmlns">>, 1, OrigAttrs, {<<"xmlns">>, <<"jabber:client">>}),
    case proplists:get_value(<<"from">>, Attrs) of
        undefined ->
                Packet#xmlel{attrs = [{<<"from">>, FromStr}|Attrs]};
        _ ->
                Packet#xmlel{attrs = Attrs}
    end.
