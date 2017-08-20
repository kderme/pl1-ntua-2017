read_lines(Stream, List,N):-
read_line(Stream, AsciiNewLine),
(
AsciiNewLine=[] -> List=[]
;
NewN is N+1,
read_lines(Stream, NewList,NewN),
maplist(decode,AsciiNewLine,NewLine),
List = [NewLine|NewList]
).

memberiAux([H|_],H,Acc,Acc):-!.
memberiAux([_|T],X,Acc,Res):-
    NewAcc is Acc + 1,
    memberiAux(T,X,NewAcc,Res).

memberi(Ls,X,Res):- 
    memberiAux(Ls,X,0,Res).

decode(46,t).
decode(83,s).
decode(69,e).
decode(88,x).

nullify([[]],[]):-!.
% !nulify([X],X).
nullify([[]|Ys],List):-
    nullify(Ys,List),!.
nullify([[X|Xs]|Ys],[X|List]):-
    nullify([Xs|Ys],List).

findM([H|_],M):-
    length(H,M).

read_file(File,ListLists,N,M):-
open(File,read,Stream),
read_lines(Stream,ListLists, 0),
length(ListLists,N),
findM(ListLists,M).
% nulify(ListLists,List).
%
read_line(Stream,[]):-
    at_end_of_stream(Stream),!.

read_line(Stream, List):-
    read_line_to_codes(Stream, Line),
    List=Line.

vis(s,v):-!.
vis(_,nv).

foldl([],_,[]):-!.
foldl([H|T],K,[NewH|NewList]):-
    vis(H,V),
    NewK is K + 1,
% (type,k,min,visited,move,prev)
    NewH = (H,K,1000000000000,V,nm,np),
    foldl(T,NewK,NewList).


moredeli(File,Cost,Solution):-
read_file(File,LsLs,N,M),
nullify(LsLs,Ls),
Len is N*M,
foldl(Ls,0,Ls1),
newArr(Ls1,Len,Nodes),
memberi(Ls,s,Sk),
memberi(Ls,e,Ek),
Ls4=([Sk],[],[]),
search(N,M,Sk,Ek,Nodes,Ls4,Cost,Solution).

search(N,M,Sk,Ek,Nodes,Ls4,Cost,Solution):-
    Counter=0,
    loop(N,M,Ek,Nodes,Counter,Ls4,NewArr,Cost),
    find_path(N,M,NewArr,Ek,Sk,[],Solution).

loop(N,M,Ek,Nodes,Counter,(X,Y,Z),NewArr,FinalCost):-
(
    member(Ek,X) -> FinalCost = Counter, NewArr = Nodes
;

    %    print(X),
    foldlMWrapper(N,M,r,1,Counter,X,Nodes,Y,Nodes1,Y1),
    foldlMWrapper(N,M,d,1,Counter,X,Nodes1,Y1,Nodes2,NewY),
    foldlMWrapper(N,M,l,2,Counter,X,Nodes2,Z,Nodes3,NewZ),
    foldlMWrapper(N,M,u,3,Counter,X,Nodes3,[],Nodes4,NewW),
    %    print(Counter),
    %    print(NewY),
    NewCounter is Counter + 1,
    loop(N,M,Ek,Nodes4,NewCounter,(NewY,NewZ,NewW),NewArr,FinalCost)
).

newIJ(I,J,r,I,NewJ):- NewJ is J + 1.
newIJ(I,J,d,NewI,J):- NewI is I + 1.
newIJ(I,J,l,I,NewJ):- NewJ is J - 1.
newIJ(I,J,u,NewI,J):- NewI is I - 1.

foldlMWrapper(N,M,Move,CostM,Counter,A,B,C,D,E):-
    Cost is CostM + Counter,
    foldlMove(N,M,Move,Cost,A,B,C,D,E).

foldlMove(_,_,_,_,[],Arr,Ls,Arr,Ls):-!.
foldlMove(N,M,Move,Cost,[X|Tx],Arr,Ls,NewArr,NewLs):-
    I is X div M,
    J is X mod M,
    newIJ(I,J,Move,NewI,NewJ),
    foldlMove(N,M,Move,Cost,Tx,Arr,Ls,NewArr1,NewLs1),
(
    valid(N,M,X,Move,Cost,NewI,NewJ,NewArr1,Arr2,Res) ->
        NewArr = Arr2,
        NewLs = [Res|NewLs1]
;   NewArr = NewArr1,
    NewLs = NewLs1
).

% (type,k,min,visited,move,prev)
valid(N,M,X,Move,Cost,I,J,Arr,NewArr,K):-
    I>=0,I<N,J>=0,J<M,
    K is I*M+J,
    % print(K),write('-'),
    %    (K=6 -> print(Arr) ; true),
    lookup(Arr,K,(T,_,Min,Vis,_,Prev)),
    %    write('lookup'),
    Vis = nv,
    not(T=x),
    Prev = np,
    Min > Cost,
    NewVal = (T,K,Cost,nv,Move,X),
    modify(Arr,K,NewVal,NewArr).

find_path(_,_,_,Sk,Sk,Acc,Acc):-!.
find_path(N,M,Nodes,X,Sk,Acc,Solution):-
    % print(Nodes),
    lookup(Nodes,X,(_,_,_,_,Move,Prev)),
    find_path(N,M,Nodes,Prev,Sk,[Move|Acc],Solution).


% lookup(Arr,Size,I,Res)
% modify(Arr,Size,I,NewVal,Res)
% N(L,R)
% L(val)

minPowAux(Len,Acc,Pow):-
(
    Acc >= Len -> Pow = Acc
    ;
    NewAcc is 2*Acc,
    minPowAux(Len,NewAcc,Pow)
).

minPow(Len,Pow):-
    minPowAux(Len,1,Pow).

perfect(1,l(0)):-!.
perfect(Pow,n(LR,LR)):-
    DPow is Pow div 2,
    perfect(DPow,LR).

insertAll([],_,Acc,_,Acc):-!.
insertAll([H|T],I,Acc,Size,New):-
    modifyAux(Acc,Size,I,H,NewAcc),
    NewI is I + 1,
    insertAll(T,NewI,NewAcc,Size,New).

newArr(Ls,Len,array(Size,Len,Arr)):-
    minPow(Len,Size),
    perfect(Size,Perf),
    insertAll(Ls,0,Perf,Size,Arr).

lookup(array(Size,Len,Arr),I,Res):-
    I>=0,I<Len,
    lookupAux(Arr,Size,I,Res).

lookupAux(n(L,R),Size,I,Res):-
    DSize is Size div 2,
    (
        I < DSize -> lookupAux(L,DSize,I,Res)
        ;
        NewI is I - DSize,
        lookupAux(R,DSize,NewI,Res)
    ).
        
lookupAux(l(Val),_,_,Val).

modify(array(Size,Len,Arr),I,NewVal,array(Size,Len,Res)):-
    I>=0,I<Len,
    modifyAux(Arr,Size,I,NewVal,Res).

modifyAux(n(L,R),Size,I,NewVal,Res):-
    DSize is Size div 2,
    (
        I < DSize -> modifyAux(L,DSize,I,NewVal,ResL),
        Res = n(ResL,R)
        ;
        I < Size -> 
        NewI is I - DSize,
        modifyAux(R,DSize,NewI,NewVal,ResR),
        Res = n(L,ResR)
    ).

modifyAux(l(_),_,_,NewVal,l(NewVal)).
    


