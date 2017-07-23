val DEBUG=false;
val DEBUG2=false;


exception over;
exception ekato;
exception notall

fun mp #"S"  = 1
  | mp #"."  = 2
  | mp #"X"  = 3 
  | mp #"E"  = 5
  | mp #"\n" = 6
  | mp _     = 10

fun ty 1="S" 
  | ty 2="." 
  | ty 3="X"  
  | ty 4="W" 
  | ty 5="E" 
  | ty 6="\n"
  | ty _=raise notall

fun mov 0="q"
|   mov 1="U"
|   mov 2="R"
|   mov 3="L"
|   mov 4="D"
|   mov _=raise notall

fun cst 1 = 3
|   cst 2 = 1
|   cst 3 = 2
|   cst 4 = 1
|   cst _=raise notall

fun arr2 (i,j)=4*i+j

fun str (n:int)=Int.toString n

fun strb b=if b then "true" else "false"

fun print_node (M:int)
  (typee:int,k:int,min:int,visited:bool,move:int,prev:int)=
  print 
("("^ty(typee)^","^str(Int.div(k,M))^","^str(Int.mod(k,M))^","^str(min)^","^strb(visited)^","^mov(move)^","^str(prev)^")")

fun print_node_k (M:int) ( nodes:(((int*int*int*bool*int*int) array))) (k:int) =
    print_node M (Array.sub(nodes,k))

fun print_node_list 
  (M:int)
  ( nodes:(((int*int*int*bool*int*int) array))) 
  (ls:int list) =
let
  val _ = print ("--{"^str(List.length(ls))^"}--[")
  val _ = List.map (print_node_k M nodes ) ls
  val _ = print "]\n"
in () end

fun print4 (
  ls4:(int list*int list*int list*int list),
  nodes:(int*int*int*bool*int*int) array,
  M:int  )=
  let 
    val _= print_node_list M nodes (#1 ls4)
    val _= print_node_list M nodes (#2 ls4)
    val _= print_node_list M nodes (#3 ls4)
    val _= print_node_list M nodes (#4 ls4)
  in 
    ()
  end

fun parse file =
let 
  fun next_String input=(TextIO.inputAll input)
  val stream = TextIO.openIn file
  val a = next_String stream
in
  explode(a)
end

fun f (6,x)=x
|   f (c,x)=c::x

fun ff (6,(h1::tail1)::tail)=[]::((h1::tail1)::tail)
|   ff (6,[]::tail)=[]::tail
|   ff (c,[q])=[c::q]
|   ff (c,head::tail)=(c::head)::tail
|   ff _=raise notall

fun ffff (i,1,(s,e))=(i,e)
|   ffff (i,5,(s,e))=(s,i)
|   ffff (i,_,(s,e))=(s,e)

(* (type,k,min,visited,move,prev) *)

fun fff (i,(c,_,_,_,_,_),y)=ffff(i,c,y)

  fun insert(arr:int list array,cost:int,typee:int,newnode:int,move)= 
Array.update(arr,arr2(cost,typee),newnode::Array.sub(arr,arr2(cost,typee)))

(*types*)
val NOPIZZA=0;
val W_NOPIZZA=1;
val W_PIZZA=2;
val PIZZA=3;

fun search(
  N:int,
  M:int,
  s:int,
  e:int,
  nodes,
  ls4:(int list*int list*int list*int list)
  )=
let
  val _=if DEBUG then print ("("^str(N)^","^str(M)^","^str(s)^","^str(e)^")") else
    ()
  fun is_end x=x=e

  fun ii k=Int.div(k,M)
  fun jj k=Int.mod(k,M)

  (*find path at the end*)
  fun find_path _=
  let
    val _ = if DEBUG then print ("\nPATH\n") else ()
    fun path_rec acc k q=
    let 
      val node=Array.sub(nodes,k)
      val move=(#5 node)
      val _ = if DEBUG then print ("k="^str(k)^"->") else ()
      (*val _ = if DEBUG then print_node M node else ()*)
      val _ = if DEBUG then print "\n" else ()
    in
      if k=s then 
      let
        val path=String.concat (map mov acc)
        val cost=List.foldl (fn (a,sum)=>sum+cst(a)) 0 acc
      in 
        (cost,path)
      end
      else path_rec (move::acc) (#6 node) (q+1)
    end
  in
    path_rec [] e 0
  end (*find path *)

(*
 *  main loop function with counter
 *   This function is nested in search 
 *)
fun loop (counter:int) (ls4:(int list*int list*int list*int list))=
let
  val _ =if DEBUG then print ("\ncounter="^str(counter)^"\n") else ()
  val _ =if DEBUG then print4(ls4,nodes,M) else ()
  (*check if new node is valid, insert and update*)
  (* (type,k,min,visited,move,prev) *)
  fun valid(
    k:int,
    cost:int,
    i:int,j:int,move:int)=
  if i<0 orelse i>=N orelse j<0 orelse j>=M then Option.NONE else
  let 
(*  val _ =print ((mov move)^"---------")*)
    val new_k=i*M+j
    val new_node = Array.sub(nodes,new_k)
    val (new_t,_,new_min,new_visited,new_move,new_prev)=new_node
  in 
    if new_visited orelse new_t = mp #"X" then Option.NONE else
    if not (new_prev = ~1) orelse cost+counter>=new_min then Option.NONE else
    let 
      val _ =
        Array.update(nodes,new_k,(new_t,new_k,cost+counter,false,move,k))
    in 
      Option.SOME new_k
    end 
  end(*valid*)
  
  fun valid_wrapper(ls:int list,args:(int*int*int*int*int))=
  let 
    val opt=valid args
  in
    if Option.isSome(opt) then ((Option.valOf opt)::ls) else ls
  end

  (*check if all urld moves are valid*)
  (* (type,k,min,visited,move,prev) *)
  fun move cost (k:int) (ls:int list)=
  let
    val node=Array.sub(nodes,k)
(*    val _ =print_node M node*)
    val i = ii k
    val j = jj k
(*    val _ =print(str(i)^","^str(j)^"\n")*)
  in
    if cost=1 then
    let 
      val ls_1=valid_wrapper(ls,(k,cost,i,j+1,2))
    in
      valid_wrapper(ls_1,(k,cost,i+1,j,4))
    end
    else if cost=2 then 
      valid_wrapper(ls,(k,cost,i,j-1,3))
    else 
      valid_wrapper(ls,(k,cost,i-1,j,1))
  end (*move*)

  val (x,y,z,w)=ls4 

(* (type,k,min,visited,move,prev) *)
  in if List.exists is_end x then find_path true else 
  let
    val new_y:int list = foldl (fn (k,yy) => move 1 k yy) y x
    val new_z:int list = foldl (fn (k,zz) => move 2 k zz) z x
    val new_w:int list = foldl (fn (k,ww) => move 3 k ww) w x
    in
      loop (counter+1) (new_y,new_z,new_w,[]:int list)
    end
  end (*loop*)
  in
  loop 0 ls4
end

fun mpp (c,ls)=
let
  val n=mp c
in 
  if n<>10 then (n::ls) else ls
end

fun moredeli file=
let 
  val ls_file=parse file
  val ls_file_int=foldr mpp [] ls_file
  val lsls1=foldr ff [[]] ls_file_int
  val N=List.length(lsls1)
  val M=List.length(hd lsls1)
  val ls1=foldr f [] ls_file_int
(* (type,k,min,visited,move,prev) *)
  val (l1_node,_)= 
foldl (fn (c,(ls,k))=>((c,k,Option.valOf  Int.maxInt,c=1,0,~1)::ls,k+1))
    ([],0) ls1
  val ls_node=rev l1_node

  val nodes=Array.fromList ls_node
  val (s,e)=Array.foldli fff (0,0) nodes
  val ls4=([s]:int list,[]:int list,[]:int list,[]:int list)
in
(*fun search(N,M,s,e,nodes1,nodes0,arr)*)
  search(N,M,s,e,nodes,ls4)
end

fun main ()=
let 
  val argv=(CommandLine.arguments())
  val file = hd argv
  val (counter,path) = moredeli file
  val output=str(counter)^" "^path^"\n"
in
  print output
end
(**) val _ = main () (**)
