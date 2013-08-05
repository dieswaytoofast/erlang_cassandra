%%%-------------------------------------------------------------------
%%% @author Juan Jose Comellas <juanjo@comellas.org>
%%% @author Mahesh Paolini-Subramanya <mahesh@dieswaytoofast.com>
%%% @copyright (C) 2011-2012 Juan Jose Comellas, Mahesh Paolini-Subramanya
%%% @doc Erlastic_search type and record definitions
%%% @end
%%%
%%% This source file is subject to the New BSD License. You should have received
%%% a copy of the New BSD license with this software. If not, it can be
%%% retrieved from: http://www.opensource.org/licenses/bsd-license.php
%%%-------------------------------------------------------------------

-include("cassandra_types.hrl").


-type error()           :: {error, Reason :: term()}.
-type method()          :: atom().
-type request()         :: {atom(), [tuple()]} | error().
-type response()        :: [tuple()] | error().
-type connection()      :: any().
-type node_name()       :: binary().
-type index()           :: binary().
-type type()            :: binary().
-type id()              :: binary() | undefined.
-type doc()             :: binary().
-type params()          :: [tuple()].
-type client_name()     :: binary().
-type pool_name()       :: binary().
-type registered_client_name() :: atom().
-type registered_pool_name()   :: atom().
-type server_ref()      :: atom() | pid() | client_name() | {pool, pool_name()}.
-type target()          :: atom() | pid().


-type keyspace()        ::  binary().
-type keyspace_definition()      ::  #ksDef{}.
-type row_key()         ::  binary().
-type key_range()       ::  #keyRange{}.
-type column_family()   ::  binary().
-type super_column()    ::  binary() | undefined.
-type column_name()     ::  binary().
-type column_value()    ::  binary().
-type column_timestamp()  :: non_neg_integer().
-type column_ttl()      :: non_neg_integer() | undefined.
-type consistency_level() :: non_neg_integer().
-type column()          :: #column{}.
-type column_parent()   :: #columnParent{}.
-type column_path()     :: #columnPath{}.
-type column_family_definition() :: #cfDef{}.
-type counter_column()  :: #counterColumn{}.
-type slice_start()     ::  binary().
-type slice_end()       ::  binary().
-type slice_count()     :: non_neg_integer().
-type slice_predicate() :: #slicePredicate{}.
-type cql_query()       :: binary().
-type compression()     :: binary().

%% Defaults
-define(DEFAULT_KEYSPACE, <<"undefined">>).
-define(DEFAULT_THRIFT_HOST, "localhost").
-define(DEFAULT_THRIFT_PORT, 9160).
-define(DEFAULT_THRIFT_OPTIONS, [{framed, true}]).
-define(DEFAULT_POOL_NAME, <<"default_erlang_cassandra_pool">>).
-define(DEFAULT_POOL_OPTIONS, [{size, 5},
                               {max_overflow, 10}
                              ]).

-define(DEFAULT_CONNECTION_OPTIONS, [{thrift_host, ?DEFAULT_THRIFT_HOST},
                                     {thrift_port, ?DEFAULT_THRIFT_PORT},
                                     {binary_response, true}
                                    ]).
-define(POOL_TIMEOUT, 10000).
-define(REGISTERED_NAME_PREFIX, "erlang_cassandra_").
-define(DEFAULT_SLICE_COUNT, 1000).

%% Errors
-define(NO_SUCH_SEQUENCE, no_such_sequence).

%% Methods
-define(STATE, <<"_cluster/state">>).
-define(HEALTH, <<"_cluster/health">>).
-define(NODES, <<"_cluster/nodes">>).
-define(STATS, <<"stats">>).
-define(STATUS, <<"_status">>).
-define(SEARCH, <<"_search">>).
-define(REFRESH, <<"_refresh">>).
-define(FLUSH, <<"_flush">>).
-define(OPEN, <<"_open">>).
-define(CLOSE, <<"_close">>).
-define(MGET, <<"_mget">>).
-define(COUNT, <<"_count">>).
-define(QUERY, <<"_query">>).
-define(OPTIMIZE, <<"_optimize">>).
-define(SEGMENTS, <<"_segments">>).
-define(CLEAR_CACHE, <<"_cache/clear">>).

% Shortcuts
-define(ALL, <<"_all">>).
