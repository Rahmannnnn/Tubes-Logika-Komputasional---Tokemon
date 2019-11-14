% FAKTA

% VARIASI

% VARIASI TOKEMON
% Jumlah Tokemon : 18 Normal Tokemon + 3 Legendary Tokemon
% a. Normal Tokemon
tokemon(bulbasaur). tokemon(oddish). tokemon(gloom).
tokemon(charmander). tokemon(flareon). tokemon(magmar).
tokemon(squirtle). tokemon(magikarp). tokemon(horsea).
tokemon(sandshrew). tokemon(diglett). tokemon(geodude).
tokemon(pikachu). tokemon(electrode). tokemon(magneton).
tokemon(pidgey). tokemon(spearow). tokemon(zubat).
% b. Legendary Tokemon
tokemon(zapdos). tokemon(moltres). tokemon(articuno).


% -------------------------------------
% VARIASI JENIS TOKEMON a. Jenis Normal
jenis(bulbasaur, normal). jenis(oddish, normal). jenis(gloom, normal).
jenis(charmander, normal). jenis(flareon, normal). jenis(magmar, normal).
jenis(squirtle, normal). jenis(magikarp, normal). jenis(horsea, normal).
jenis(sandshrew, normal). jenis(diglett, normal). jenis(geodude, normal).
jenis(pikachu, normal). jenis(electrode, normal). jenis(magneton, normal).
jenis(pidgey, normal). jenis(spearow, normal). jenis(zubat, normal).
% b. Jenis Legendary
jenis(zapdos, legendary). jenis(moltres, legendary). jenis(articuno, legendary).

% -------------------------------------
% VARIASI TYPE TOKEMON
% a. Type Leaves
%    jika melawan Tokemon type :
%        1. water    : Damage lebih besar 50% dari biasanya.
%        2. ground   : Damage lebih besar 50% dari biasanya.
%        3. fire     : Damage lebih kecil 50% dari biasanya.
%        4. flying   : Damage lebih kecil 50% dari biasanya.
%
% - Normal Tokemon
type(bulbasaur, leaves). type(oddish, leaves). type(gloom, leaves).
% - Legendary Tokemon
type(zapdos, leaves).

% b. Type Fire
%    jika melawan Tokemon type :
%        1. leaves   : damage lebih besar 50% dari biasanya.
%        2. water    : damage lebih kecil 50% dari biasanya.
%        3. ground   : damage lebih kecil 50% dari biasanya.
%
% - Normal Tokemon
type(charmander, fire). type(flareon, fire). type(magmar, fire).
% - Legendary Tokemon
type(moltres, fire).

% c. Type Water
%    jika melawan Tokemon type :
%        1. fire     : damage lebih besar 50% dari biasanya.
%        2. ground   : damage lebih besar 50% dari biasanya.
%        3. leaves   : damage lebih kecil 50% dari biasanya.
%        4. electric : damage lebih kecil 50% dari biasanya.
%
% - Normal Tokemon
type(squirtle, water). type(magikarp, water). type(horsea, water).
% - Legendary Tokemon
type(articuno, water).

% < BONUS >
% d. Type Ground
%    jika melawan Tokemon type :
%        1. fire     : damage lebih besar 50% dari biasanya.
%        2. electric : damage lebih besar 50% dari biasanya.
%        3. water    : damage lebih kecil 50% dari biasanya.
%        4. leaves   : damage lebih kecil 50% dari biasanya.
%
% - Normal Tokemon
type(sandshrew, ground). type(diglett, ground). type(geodude, ground).

% e. Type Electric
%    jika melawan Tokemon type :
%        1. water    : damage lebih besar 50% dari biasanya.
%        2. flying   : damage lebih besar 50% dari biasanya.
%        3. ground   : damage lebih kecil 50% dari biasanya.
%
% - Normal Tokemon
type(pikachu, electric). type(electrode, electric). type(magneton, electric).

% f. Type Flying
%     jika melawan Tokemon type :
%	 1. grass    : damage lebih besar 50% dari biasanya.
%	 2. electric : damage lebih kecil 50% dari biasanya.
%
% - Normal Tokemon
type(pidgey, flying). type(spearow, flying). type(zubat, flying).

% -------------------------------------
% VARIASI ATTACK
% a. Normal Attack
% Normal Pokemon
attack(bulbasaur, 200). attack(oddish, 80). attack(gloom, 140).
attack(charmander, 200). attack(flareon, 140). attack(magmar, 80).
attack(squirtle, 200). attack(magikarp, 120). attack(horsea, 120).
attack(sandshrew, 200). attack(diglett, 140). attack(geodude, 80).
attack(pikachu, 200). attack(electrode, 120). attack(magneton, 120).
attack(pidgey, 200). attack(spearow, 80). attack(zubat, 140).
% Legendary Pokemon
attack(zapdos, 400). attack(moltres, 400). attack(articuno, 400).

% b. Special Attack
specialattack(bulbasaur, 300). specialattack(oddish, 180). specialattack(gloom, 240).
specialattack(charmander, 300). specialattack(flareon, 240). specialattack(magmar, 180).
specialattack(squirtle, 300). specialattack(magikarp, 220). specialattack(horsea, 220).
specialattack(sandshrew, 300). specialattack(diglett, 240). specialattack(geodude, 180).
specialattack(pikachu, 300). specialattack(electrode, 220). specialattack(magneton, 220).
specialattack(pidgey, 300). specialattack(spearow, 180). specialattack(zubat, 240).
% Legendary Pokemon
specialattack(zapdos, 600). specialattack(moltres, 600). specialattack(articuno, 600).

% ----------------------------------
% VARIASI MAX HEALTH
maxhealt(articuno,1000).
maxhealt(moltres,1500).
maxhealt(zapdos,2000).
maxhealt(pikachu,500).
maxhealt(squirtle,400).
maxhealt(sandshrew,550).
maxhealt(charmander,700).
maxhealt(pidgey,450).
maxhealt(flareon,600).
maxhealt(magikarp,400).
maxhealt(diglett,500).
maxhealt(electrode,450).
maxhealt(spearow,550).
maxhealt(gl0om,400).
maxhealt(magmar,650).
maxhealt(horsea,500).
maxhealt(geodude,650).
maxhealt(magneton,750).
maxhealt(zubat,450).
maxhealt(bulbasaur,600).
maxhealt(oddish,500).

% ----------------------------------

start :- printheader, printhelp, printlegend.

help :- printhelp.

printheader :-

    write('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'), nl,
    write('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'), nl,
    write('XX                                                                     XX'), nl,
    write('XX                                                                     XX'), nl,
    write('XX                                                                     XX'), nl,
    write('XX   8888888  88888  888  88  888888  888       88  88888  888    88   XX'), nl,
    write('XX   8888888  888 8  888 88   888     8888     888  888 8  8888   88   XX'), nl,
    write('XX     888    888 8  88888    888     88888   8888  888 8  88888  88   XX'), nl,
    write('XX     888    888 8  88888    88888   888 88 88 88  888 8  888 88 88   XX'), nl,
    write('XX     888    888 8  888 88   888     888  888  88  888 8  888  8888   XX'), nl,
    write('XX     888    88888  888  88  888888  888   8   88  88888  888   888   XX'), nl,
    write('XX                                                                     XX'), nl,
    write('XX        88888    88888    88888   888     88888   8888888            XX'), nl,
    write('XX        888 88   888 88   888 8   888     888 8   888  88            XX'), nl,
    write('XX        888 88   888 88   888 8   888     888 8   888                XX'), nl,
    write('XX        88888    88888    888 8   888     888 8   888 888            XX'), nl,
    write('XX        888      88 88    888 8   888     888 8   888  88            XX'), nl,
    write('XX        888      88  88   88888   88888   88888   8888888            XX'), nl,
    write('XX                                                                     XX'), nl,
    write('XX                                                                     XX'), nl,
    write('XX                                                                     XX'), nl,
    write('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'), nl,
    write('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'), nl,
    nl,
    write('Gotta catch em all!                                                  '), nl,
    write('Hello there! Welcome to the world of Tokemon! My name is Aril!       '), nl,
    write('People call me the Tokemon Professor! This world is inhabited by     '), nl,
    write('creatures called Tokemon! There are hundreds of Tokemon loose in     '), nl,
    write('Labtek 5! You can catch them all to get stronger, but what I am      '), nl,
    write('really interested in are the 3 legendary Tokemons, Zapdos, Moltres,  '), nl,
    write('and Articuno. If you can defeat or capture all those Tokemons I      '), nl,
    write('will not kill you.				                        '), nl.

printhelp :-
    write('Available commands:'),nl,
    write('    start.          -- Start the Game!'),nl,
    write('    help.           -- Show Available Command'),nl,
    write('    quit.           -- Quit the Game'),nl,
    write('    n. s. e. w.     -- Move'),nl,
    write('    map.            -- Look at the Map'),nl,
    write('    heal.           -- Cure Tokemon in Inventory if in Gym Center'),nl,
    write('    status.         -- Show Your Status'),nl,
    write('    save(Filename). -- Save Your Game'),nl,
    write('    load(Filename). -- Load Previously Saved Game'),nl,
    nl.

printlegend :-
    write('Legends:'),nl,
    write('   - X = Pagar  '),nl,
    write('   - P = Player '),nl,
    write('   - G = Gym    '),nl,
    nl.