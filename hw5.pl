/*******************************************/
/**    Your solution goes in this file    **/ 
/*******************************************/

%% Find all courses with 3 or 4 credits (fc course).
fc_course(X) :- course(X,_,3); course(X,_,4).

%% Find all courses whose immediate pre-requisite is ecs110 (prereq 110).
prereq_100(X) :-
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

any_member([H1|_], [H2|_]) :- H1 = H2, !.
any_member(L1, [_|T2]) :- any_member(L1, T2), !.
any_member([_|T1], L2) :- any_member(T1, L2), !.

%% Find the names of all students who are in jim’s class (students).
students(Classmate) :-
	student(john, SCourses),
	student(Classmate, XCourses),
	any_member(SCourses, XCourses).

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
