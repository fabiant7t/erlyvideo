-module(ems_rtsp).
-author('Max Lapshin <max@maxidoors.ru>').

-include_lib("erlmedia/include/h264.hrl").
-include_lib("erlyvideo/include/rtmp_session.hrl").
-include_lib("erlmedia/include/video_frame.hrl").
-include("../include/ems.hrl").
-include_lib("ertsp/include/rtsp.hrl").

-export([record/1]).

hostpath(URL) ->
  {ok, Re} = re:compile("rtsp://([^/]+)/(.*)$"),
  {match, [_, HostPort, Path]} = re:run(URL, Re, [{capture, all, binary}]),
  {ems:host(HostPort), Path}.


record(URL) -> 
  {Host, Path} = hostpath(URL),
  ?D({"RECORD", Host, Path}),
  ems_log:access(Host, "RTSP RECORD ~s ~s", [Host, Path]),
  Media = media_provider:open(Host, Path, [{type, live}]),
  {ok, Media}.

