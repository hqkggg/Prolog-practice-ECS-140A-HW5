/*
	Working on the farmer, wolf, goat, cabbage ferrying across a river puzzle
	Solve should check if move from state(l,l,l,l) to state(r,r,r,r) with history [] works

	Run
		gprolog --init-goal "['part1.facts.pl','hw5.pl']" --query-goal 'solve'
*/

%% Indicate whether two banks of a river are opposite
opposite(left, right).
opposite(right, left).

%% A state is an indication of which riverbank (left or right) holds the four entities:
%% farmer, wolf, goat, cabbage
state(_, _, _, _).

print_history([]).
print_history([arc(take(Obj, B0, B1), _, State1)|T]) :-
	print_history(T),
	print('take '), print(Obj), print(' from '), print(B0), print(' to '), print(B1), nl,
	print('\t'), print(State1), nl.

%% A move succeeds if
%% - its initial state is a legal state
%% - its terminal state is a legal state
%% - its proposed take is not a member of its history	.
move(State0, State1, History) :-
	safe(State0),
	A = arc(_, State0, State1),
	A,
	\+ member(A, History),
	print_history([A|History]),
	!.
move(State0, State1, History) :-
	safe(State0),
	Arc0 = arc(take(_,_,_), State0, StateIntermediate),
	\+ member(Arc0, History),
	Arc0,
	move(StateIntermediate, State1, [Arc0|History]).

safe(state(F, _, G, _)) :- F = G, !.
safe(state(_, W, G, C)) :- opposite(W,G), opposite(G,C).
unsafe(A) :- \+ safe(A).

take(Obj, A, B) :- opposite(A, B).

arc(take(wolf, F0, F1), state(F0, F0, G, C), state(F1, F1, G, C)) :-
	take(wolf, F0, F1),
	safe(state(F1, F1, G, C)).
arc(take(goat, F0, F1), state(F0, W, F0, C), state(F1, W, F1, C)) :-
	take(goat, F0, F1),
	safe(state(F1, W, F1, C)).
arc(take(cabbage, F0, F1), state(F0, W, G, F0), state(F1, W, G, F1)) :-
	take(cabbage, F0, F1),
	safe(state(F1, W, G, F1)).
arc(take(farmer, F0, F1), state(F0, W, G, C), state(F1, W, G, C)) :-
	take(farmer, F0, F1),
	safe(state(F1, W, G, C)).

solve :- move(state(left, left, left, left), state(right, right, right, right), []), !.

/*
	Simple exercises
*/

%% Find all courses with 3 or 4 credits (fc course).
fc_course(X) :-
	course(X,_,N),
	N >= 3,
	N =< 4.

%% Find all courses whose immediate pre-requisite is ecs110 (prereq 110).
prereq_110(X) :-
	course(X,Y,_),
	member(ecs110, Y).

%% Find names of all students in ecs140a (ecs140a students).
ecs140a_students(X) :-
	student(X,Y),
	member(ecs140a, Y).

%% Find the names of all instructors who teach john’s courses (instructor names).
instructor_names(IName) :-
	student(john, SCourses),
	instructor(IName, ICourses), 
	any_member(SCourses, ICourses).

%% Find all elements of one List which are also members of another List
any_member([H|_], [H|_]) :- !.
any_member(L1, [_|T2]) :- any_member(L1, T2), !.
any_member([_|T1], L2) :- any_member(T1, L2), !.

%% Find the names of all students who are in jim’s class (students).
students(Student) :-
	instructor(jim, JCourses),
	student(Student, SCourses),
	any_member(SCourses, JCourses).

%% Find all pre-requisites of a course (allprereq). (This will involve finding not only the immediate
%% prerequisites of a course, but pre-requisite courses of pre-requisites and so on.)
allprereq([], []) :- !.
allprereq([H|T], Output):-
	course(H, HP, _),
	allprereq(HP, HPP),
	append(HPP, HP, HPrereqs),
	allprereq(T, TPrereqs),
	append(TPrereqs, HPrereqs, Output), !.
allprereq(Course, Output) :- allprereq([Course], Output).


%% Predicate all length takes a list and counts the number of atomic elements that occur in the list at
%% all levels.
all_length([], 0) :- !.
all_length([[]|T], Count) :-  % remember that empty list is atomic, but we don't cover it in first predicate
	all_length(T, TCount),
	Count is 1 + TCount,
	!.
all_length([H|T], Count) :-
	all_length(H, HCount),
	all_length(T, TCount),
	Count is HCount + TCount,
	!.
all_length(_, 1). % should match only atoms

%% Returns true if L contains an equal number of a and b terms
equal_a_b(L) :-
	atom_count(ACount, a, L),
	atom_count(BCount, b, L),
	ACount = BCount.

%% Returns number of times a given atom appears as a member of List
atom_count(0, _, []) :- !.
atom_count(Acc, Atom, [H|T]) :-
	atom_count(AccH, Atom, H),
	atom_count(AccT, Atom, T),
	Acc is AccH + AccT,
	!.
atom_count(1, Atom, Atom) :- !.
atom_count(0, _, _).

%% True if first argument is a list that appears at the end of the second
%% argument.
%% suffix(Suff, List) :- append(_, Suff, List).

%% swap_prefix_suffix(K,L,S) is true if:
%% • K is a sub-list of L, and
%% • S is the list obtained by appending the suffix of L following an occurrence of K in L, with K and
%% 		with the prefix that precedes that same occurrence of K in L.
%% E.g.
%% ?-swap_prefix_suffix([c, d], [a, b, c, d, e], S).
%% yes. S=[e, c, d, a, b]
%% ?-swap_prefix_suffix([c, e], [a, b, c, d, e], S).
%% no.
%% ?-swap_prefix_suffix(K, [a, b, c, d, e], [b, c, d, e, a]).
%% yes. K=[a]
swap_prefix_suffix(K, List, Swapped) :-
	swap_prefix_suffix(K, List, [], Swapped).
swap_prefix_suffix(K, List, Prefix, Swapped) :-
	append(K, Suffix, List),
	append(K, Prefix, KAndPrefix),
	append(Suffix, KAndPrefix, Swapped).
swap_prefix_suffix(K, [Prefix|T], PrefixAcc, Swapped) :-
	append(PrefixAcc, [Prefix], P),
	swap_prefix_suffix(K, T, P, Swapped).

%% palin(A) is true if the list A is a palindrome, that is, it reads the same backwards
%% as forwards. For instance, [1, 2, 3, 2, 1] is a palindrome, but [1, 2] is not.
palin(List) :- palin(List, []).
palin([_|ListAndSuffix], ListAndSuffix).
palin(ListAndSuffix, ListAndSuffix).
palin([H|T], SuffAcc) :-
	suffix([H|SuffAcc], T),
	palin(T, [H|SuffAcc]).

%% A good sequence consists either of the single number 0, or of the number 1
%% followed by two other good sequences: thus, [1,0,1,0,0] is a good sequence,
%% but [1,1,0,0] is not.
good([0]).
good([1|T]) :-
	append(X,Y,T),
	good(X),
	good(Y).
