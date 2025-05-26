:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).

% База данни с факти
animal(1, "Лъв", "Савана").
animal(2, "Пингвин", "Антарктика").
animal(3, "Мече", "Гора").

% HTTP handler
:- http_handler('/animal', animal_handler, []).

% Стартиране на сървъра
server(3000) :-
    http_server(http_dispatch, [port(3000)]).

% Обработка на заявка
animal_handler(Request) :-
    http_parameters(Request, [ id(IDAtom, []) ]),
    atom_number(IDAtom, ID),
    (   animal(ID, Name, Habitat)
    ->  reply_json_dict(_{id: ID, name: Name, habitat: Habitat})
    ;   reply_json_dict(_{error: "Животно с такова ID не съществува"})
    ).
