/*******************************************/
/**    Your solution goes in this file    **/ 
/*******************************************/

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
atom_count(0, Atom, []) :- !.
atom_count(Acc, Atom, [H|T]) :-
	atom_count(AccH, Atom, H),
	atom_count(AccT, Atom, T),
	Acc is AccH + AccT,
	!.
atom_count(1, Atom, Atom) :- !.
atom_count(0, _, _).
