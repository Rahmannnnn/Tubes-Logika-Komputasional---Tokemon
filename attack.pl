:- dynamic(acakrun/1).

fight :- battle(false), write('Anda tidak bertemu musuh.'),!.
fight :- battle(true), write('Anda sudah berada dalam battle.'),!.
fight :-
	battle(pending),

	retract(battle(_)),
	asserta(battle(true)),
	printInventory,
	!.

peluangRun :- random(0,2,A),
	assert(acakrun(A)),!.

run :- battle(false), write('Anda tidak bertemu musuh.'),!.
run :-
	battle(true),
	write('Anda sedang berada dalam battle'), nl,
	write('Anda tidak bisa Run.'),!.

run :-
	battle(pending),

	peluangRun,
	acakrun(A),
	A =:= 0,

	retract(battle(_)),
	assert(battle(true)),

	write('You failed to run!'), nl,
	write('Choose your Tokemon!'),nl,

	printInventory,
	!.

run :-
	battle(pending),

	peluangRun,
	acakrun(A),
	A > 0,

	retract(battle(_)),
	assert(battle(false)),

	write('You succesfully escaped the Tokemon.'), nl,
	!.

printInventory :-
	write('Available Tokemons: '),
	forall(inventory(Obj),
		  (
			write('['),
		        write(Obj),
		        write('] ')
		  )
	).

printStatusAttack(Player, Enemy) :-
    inventory(Player),
    write(Player), nl,
    healthP(Player,XP),write('Health : '),write(XP),nl,
    type(Player,YP),write('Type   : '),write(YP), nl,
	nl,
    musuh(Enemy,_),
    write(Enemy), nl,
    healthM(Enemy,XM),write('Health : '),write(XM),nl,
    type(Enemy,YM),write('Type   : '), write(YM), nl,
	nl,!.


%update health dengan x sebagai tokemon dan y sebagai serangan
updateHealth(X,Y) :-
    retract(healthP(X,Darah)),
    Darahbaru is Darah-Y,
    asserta(healthP(X, Darahbaru)).

updateHealthMusuh(X,Y) :-
    retract(healthM(X,Darah)),
    Darahbaru is Darah-Y,
    asserta(healthM(X, Darahbaru)).

pattackLebih(X,Enemy) :-
	 attack(X,DamageP),
	 DamagePNew is DamageP*3/2,
	 write('You dealt '), write(DamagePNew), write(' damage to '), write(Enemy), nl,
	 updateHealthMusuh(Enemy,DamagePNew),
	 healthM(Enemy,Darah),
	 ( Darah =< 0 ->
			musuhKalah(Enemy), !;
			printStatusAttack(X,Enemy),!)
	 , !.

pattackKurang(X,Enemy) :-
	 attack(X,DamageP),
	 DamagePNew is DamageP*1/2,
	 write('You dealt '), write(DamagePNew), write(' damage to '), write(Enemy), nl,
	 updateHealthMusuh(Enemy,DamagePNew),
	 healthM(Enemy,Darah),
	 ( Darah =< 0 ->
			musuhKalah(Enemy);
			printStatusAttack(X,Enemy),!)
	 , !.
	 
pattack(X,Enemy) :-
	 attack(X,DamageP),
	 write('You dealt '), write(DamageP), write(' damage to '), write(Enemy), nl,
	 updateHealthMusuh(Enemy,DamageP),
	 healthM(Enemy,Darah),
	 ( Darah =< 0 ->
			musuhKalah(Enemy), !;
			printStatusAttack(X,Enemy), !)
	 , !.
	 
mattackLebih(X,Enemy) :-
	write(Enemy), write(' attacks!'), nl,
	attack(Enemy,DamageM),
	DamageMNew is DamageM*3/2,
	write('It dealts '), write(DamageMNew), write(' damage to '), write(X), nl,
	updateHealth(X,DamageMNew),
	healthP(X,Darah),
	 ( Darah =< 0 ->
			playerKalah(X), !;
			printStatusAttack(X,Enemy), !)
	 , !.
	 
mattackKurang(X, Enemy) :-
        write(Enemy), write(' attacks!'),nl,
        attack(Enemy,DamageM),
        DamageMNew is DamageM*1/2,
        write('It dealts '), write(DamageMNew), write(' damage to '), write(X), nl,
        updateHealth(X,DamageMNew),
		healthP(X,Darah),
		 ( Darah =< 0 ->
				playerKalah(X), !;
				printStatusAttack(X,Enemy), !)
		 , !.

mattack(X, Enemy) :-
        write(Enemy), write(' attacks!'),nl,
        attack(Enemy,DamageM),
        write('It dealts '), write(DamageM), write(' damage to '), write(X), nl,
        updateHealth(X,DamageM),
		healthP(X,Darah),
		 ( Darah =< 0 ->
				playerKalah(X), !;
				printStatusAttack(X,Enemy), !)
		 , !.

playerKalah(X) :-
		dropP(X),
		jumInv(B),
		( (B =:= 0) ->
				kalah, !;
				write(X), write(' kalah. Segera pilih Tokemonmu yang lain!'), nl, nl, printInventory, !
		), !.

musuhKalah(Enemy) :-
		(jenis(Enemy,legendary) ->
			jumLegend(A),
			Ax is A-1,
			((Ax =:= 0) ->
				menang, !; !
			); !
		),
		write(Enemy), write(' faints! Do you want to capture '), write(Enemy), write(' ? capture/0 to capture '),
		write(Enemy), write(' , otherwise move away.'),
		retract(battle(true)),
		asserta(battle(false)), !.
			
attack :- play(false), write('Start dulu'), !.
attack :- battle(false), write('Anda tidak sedang dalam battle.'), !.
attack :- battle(pending), write('Fight or Run?'),!.

/* 1. Leaves vs Water */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, leaves),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, water),
    healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
				pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
		), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 2. Leaves vs Ground */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, leaves),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, ground),
	healthP(X,P),
    healthM(Enemy,M),
	( (M > 0) ->
		( (P > 0) ->
			pattackLebih(X,Enemy),
			healthM(Enemy,HM),
			(HM =< 0 ->
				musuhKalah(Enemy), !;
				mattackKurang(X,Enemy), !
			), !;
			/* Pokemon Player Mati */			
			playerKalah(X), !
		), !;
		/* Musuh Mati */		
		musuhKalah(Enemy), !
	), !.

/* 3. Leaves vs Fire */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, leaves),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, fire),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 4. Leaves vs Flying */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, leaves),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, flying),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.


/* 5. Leaves vs Leaves */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, leaves),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, leaves),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 6. Leaves vs Electric */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, leaves),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, electric),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.


/* 7. Fire vs Leaves */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, fire),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, leaves),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 8. Fire vs Fire */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, fire),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, fire),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;				
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 9. Fire vs Water */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, fire),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, water),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 10. Fire vs Ground */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, fire),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, ground),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 11. Fire vs Electric */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, fire),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, electric),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 12. Fire vs Flying */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, fire),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, flying),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 13. Water vs Leaves */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, water),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, leaves),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 14. Water vs Fire */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, water),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, fire),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 15. Water vs Water */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, water),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, water),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 16. Water vs Ground */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, water),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, ground),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 17. Water vs Electric */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, water),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, electric),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 18. Water vs Flying */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, water),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, flying),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 19. Ground vs Leaves */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, ground),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, leaves),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 20. Ground vs Fire */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, ground),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, fire),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 21. Ground vs Water */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, ground),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, water),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 22. Ground vs Ground */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, ground),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, ground),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 23. Ground vs Electric */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, ground),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, electric),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 24. Ground vs Flying */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, ground),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, flying),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 25. Electric vs Leaves */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, electric),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, leaves),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 26. Electric vs Fire */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, electric),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, fire),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;				
				mattack(X,Enemy), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 27. Electric vs Water */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, electric),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, water),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 28. Electric vs Ground */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, electric),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, ground),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 29. Electric vs Electric */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, electric),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, electric),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 30. Electric vs Flying */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, electric),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, flying),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 31. Flying vs Leaves */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, flying),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, leaves),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 32. Flying vs Fire */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, flying),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, fire),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 33. Flying vs Water */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, flying),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, water),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 34. Flying vs Ground */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, flying),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, ground),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattack(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattack(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 35. Flying vs Electric */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, flying),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, electric),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackKurang(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackLebih(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.

/* 36. Flying vs Flying */
attack :-
    battle(true),
    pickTokemon(X),
    type(X, flying),

    %enemy
    player([A,B]),
    musuh(Enemy, [A,B]),
    type(Enemy, flying),
	healthP(X,P),
    healthM(Enemy,M),
    (	(M > 0) ->
			( (P > 0) ->
		        pattackLebih(X,Enemy),
				healthM(Enemy,HM),
				(HM =< 0 ->
					musuhKalah(Enemy), !;
					mattackKurang(X,Enemy), !
				), !;
				/* Pokemon Player Mati */
				playerKalah(X), !
			), !;
		/* Musuh Mati */
		musuhKalah(Enemy), !
    ), !.
