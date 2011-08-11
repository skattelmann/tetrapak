%    __                        __      _
%   / /__________ __   _____  / /___  (_)___  ____ _
%  / __/ ___/ __ `/ | / / _ \/ / __ \/ / __ \/ __ `/
% / /_/ /  / /_/ /| |/ /  __/ / /_/ / / / / / /_/ /
% \__/_/   \__,_/ |___/\___/_/ .___/_/_/ /_/\__, /
%                           /_/            /____/
%
% Copyright (c) Travelping GmbH <info@travelping.com>

-module(tetrapak_task_doc).
-behaviour(tetrapak_task).
-export([check/1, run/2]).

check("clean:edoc") ->
    filelib:is_dir(tetrapak:config_path("edoc.outdir")).

run("doc:edoc", _) ->
    case tetrapak:config("edoc.pretty_print") of
        true  -> PPOpts = [{pretty_printer, erl_pp}];
        false -> PPOpts = []
    end,

    DD = tetrapak:config_path("edoc.outdir"),
    tpk_file:mkdir(DD),
    edoc:application(tetrapak:get("config:appfile:name"),
                     tetrapak:dir(),
                     [{dir, DD},
                      {includes, [tetrapak:subdir("include")]},
                      {private, tetrapak:config("edoc.private")},
                      {hidden, tetrapak:config("edoc.hidden")},
                      {todo, tetrapak:config("edoc.todo")},

                      %% layout options
                      {sort_functions, tetrapak:config("edoc.sort_functions")}
                        | PPOpts]);

run("clean:edoc", _) ->
    DD = tetrapak:config_path("edoc.outdir"),
    tpk_file:delete("(\\.(html|css|png)$)|edoc-info", DD),
    file:del_dir(DD),
    ok.
