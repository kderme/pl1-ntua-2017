val DEBUG=false;
val DEBUG2=true;


exception over;
exception notall

fun mp #"S"  = 1
  | mp #"."  = 2
  | mp #"X"  = 3 
  | mp #"W"  = 4
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
|   mov 5="W"
|   mov _=raise notall

fun arr2 (i,j)=4*i+j

fun str (n:int)=Int.toString n

fun strb b=if b then "true" else "false"

fun print_node (M:int)
  (typee:int,k:int,pizza:bool,min:int,visited:bool,move:int,prev:int)=
  print 
("("^ty(typee)^","^str(Int.div(k,M))^","^str(Int.mod(k,M))^","^strb(pizza)^","^str(min)^","^strb(visited)^","^mov(move)^","^str(prev)^")")

fun print_node_k (M:int) ( nodes:(((int*int*bool*int*bool*int*int) array))) (k:int) =
    print_node M (Array.sub(nodes,k))

fun print_node_list (M:int)
  ( nodes1:(((int*int*bool*int*bool*int*int) array))) 
  ( nodes0:(((int*int*bool*int*bool*int*int) array))) 
  (k2,ls:int list) =
let 
  val _ = print ("--{"^str(List.length(ls))^"}--[")
  val nodes=if Int.mod(k2,4)=0 orelse Int.mod(k2,4)=1 then nodes0 else nodes1
  val _ = List.map (print_node_k M nodes ) ls
  val _ = print "]\n"
in () end
  
fun print_array (
  arr:(int list array),
  nodes1:(int*int*bool*int*bool*int*int) array,
  nodes0:(int*int*bool*int*bool*int*int) array,
  M:int  )=
Array.appi (print_node_list M nodes1 nodes0) arr

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

(* (type,k,pizza,min,visited,move,prev) *)

fun fff (i,(c,_,_,_,_,_,_),y)=ffff(i,c,y)

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
  nodes1:(int*int*bool*int*bool*int*int) array,
  nodes0:(int*int*bool*int*bool*int*int) array,
  arr:int list array)=
let
  fun ii x=Int.div(x,M)
  fun jj x=Int.mod(x,M)

(*main loop function with counter*)  
fun loop counter= if DEBUG andalso counter=100 then raise over else
let
  val _ =if DEBUG then print ("\ncounter="^str(counter)^"\n") else ()
  val _ =if DEBUG then print_array (arr,nodes1,nodes0,M) else ()
  (*find path at the end*)  
(*fun search(N,M,s,e,nodes1,nodes0,arr)*)
  fun find_path _=
  let
    val _ = if DEBUG then print ("\nPATH\n") else ()
    fun path_rec acc (k,pizza) q=
    let 
      val nodes=if pizza then nodes1 else nodes0
      val node=Array.sub(nodes,k)
      val move=(#6 node)
      val prev_pizza=if (move=5) then not pizza else pizza
      val _ = if DEBUG then print ("k="^str(k)^"->") else ()
      val _ = if DEBUG then print_node M node else ()
      val _ = if DEBUG then print "\n" else ()
    in
      if k=s then String.concat (map mov ((acc)))
      else path_rec (move::acc) (#7 node,prev_pizza) (q+1)
    end
  in
    path_rec [] (e,true) 0
  end

  (*rewind at each loop*)
  fun rewind _=
  let
    val _=Array.update(arr,arr2(0,NOPIZZA),Array.sub(arr,arr2(1,NOPIZZA)))
    val _=Array.update(arr,arr2(0,W_NOPIZZA),Array.sub(arr,arr2(1,W_NOPIZZA)))
    val _=Array.update(arr,arr2(0,W_PIZZA),Array.sub(arr,arr2(1,W_PIZZA)))
    val _=Array.update(arr,arr2(0,PIZZA),Array.sub(arr,arr2(1,PIZZA)))

    val _=Array.update(arr,arr2(1,NOPIZZA),Array.sub(arr,arr2(2,NOPIZZA)))
    val _=Array.update(arr,arr2(1,W_NOPIZZA),Array.sub(arr,arr2(2,W_NOPIZZA)))
    val _=Array.update(arr,arr2(1,W_PIZZA),Array.sub(arr,arr2(2,W_PIZZA)))
    val _=Array.update(arr,arr2(1,PIZZA),Array.sub(arr,arr2(2,PIZZA)))

    val _=Array.update(arr,arr2(2,NOPIZZA),[])
    val _=Array.update(arr,arr2(2,W_NOPIZZA),[])
    val _=Array.update(arr,arr2(2,W_PIZZA),[])
    val _=Array.update(arr,arr2(2,PIZZA),[])
  in () end

  (*check if new node is valid, insert and update*)
  fun valid(pizza,k,
    new_nodes:(int * int * bool * int * bool * int * int) array,
    cost,typee,
    node:(int * int * bool * int * bool * int * int),
    i,j,move)=
    if i>=0 andalso i<N andalso j>=0 andalso j<M then 
    let 
      val new_k=i*M+j
      val new_node = Array.sub(new_nodes,new_k)
      val (new_t,_,new_pizza,_,new_visited,_,_)=new_node
    in 
      if not new_visited andalso new_t <> 3 then
      let 
        val _ = insert(arr,cost,typee,new_k,move)
        val _ = if new_t=4 andalso move<>5 then 
          let val w_typee=if pizza then W_PIZZA else W_NOPIZZA
          in insert(arr,cost,w_typee,new_k,move) end
            else ()
        val updated=(new_t,new_k,new_pizza,counter+cost,true,move,k)
        val _ = Array.update(new_nodes,new_k,updated)
      in (true,new_t=5 andalso new_pizza) end
      else (false,false)
    end
    else (false,false)(*valid*)
  
  (*check if w move is valid *)
  fun move_w pizza (k:int)=
  let 
    val (nodes,new_nodes)=if pizza then (nodes1,nodes0)
                                   else (nodes0,nodes1)
    val cost=1
    val typee=if pizza then NOPIZZA else PIZZA
    val node=Array.sub(nodes,k)
    val i = ii k
    val j = jj k

    val _=valid(pizza,k,new_nodes,cost,typee,node,i,j,5)
  in false 
  end(*move_w*)

  (*check if all urld moves are valid*)
  fun move_urld pizza (k:int)=
  let
    val nodes=if pizza then nodes1 else nodes0
    val new_nodes=nodes
    val cost=if pizza then 2 else 1
    val typee=if pizza then PIZZA else NOPIZZA
    val node=Array.sub(nodes,k)
    val i = ii k
    val j = jj k

    val (a,found1)=valid(pizza,k,new_nodes,cost,typee,node,i-1,j,1)
    val (b,found2)=valid(pizza,k,new_nodes,cost,typee,node,i,j+1,2)
    val (c,found3)=valid(pizza,k,new_nodes,cost,typee,node,i,j-1,3)
    val (d,found4)=valid(pizza,k,new_nodes,cost,typee,node,i+1,j,4)
  in if found1 orelse found2 orelse found3 orelse found4 then true else false
  end (*move_urld*)

  val x = Array.sub(arr,arr2(0,NOPIZZA))
  val y = Array.sub(arr,arr2(0,W_NOPIZZA))
  val z = Array.sub(arr,arr2(0,W_PIZZA))
  val w = Array.sub(arr,arr2(0,PIZZA))

  val _=List.exists (move_urld false) x
  val _=List.exists (move_w false )y
  val _=List.exists (move_w true) z
  val found=List.exists (move_urld true) w
  in
    if found then (counter+2,find_path 1) else 
      let val _ =rewind() 
      in loop (counter+1) end (*loop*)
  end    
  in
  loop 0
end

fun mpp (c,ls)=
let
  val n=mp c
in 
  if n<>10 then (n::ls) else ls
end

fun spacedeli file=
let 
  val ls_file=parse file
  val ls_file_int=foldr mpp [] ls_file
  val lsls1=foldr ff [[]] ls_file_int
  val N=List.length(lsls1)
  val M=List.length(hd lsls1)
  val ls1=foldr f [] ls_file_int
(* (type,k,pizza,min,visited,move,prev) *)
  val (l1_node,_)= 
foldl (fn (c,(ls,k))=>((c,k,true,Option.valOf  Int.maxInt,c=1,0,~1)::ls,k+1)) ([],0) ls1
  val ls1_node=rev l1_node
  val (l0_node,_)=
foldl (fn (c,(ls,k))=>((c,k,false,Option.valOf  Int.maxInt,false,0,~1)::ls,k+1)) ([],0) ls1
  val ls0_node=rev l0_node

  val nodes1=Array.fromList ls1_node
  val nodes0=Array.fromList ls0_node
  val (s,e)=Array.foldli fff (0,0) nodes1
  val arr=Array.array(12,[]:int list)
  val _=Array.update(arr,3,[s])
in
(*fun search(N,M,s,e,nodes1,nodes0,arr)*)

 search(N,M,s,e,nodes1,nodes0,arr)
end

fun main ()=
let 
  val argv=(CommandLine.arguments())
  val file = hd argv
  val (counter,path) = spacedeli file
  val output=if DEBUG2 then (str(counter)^" "^path^"\n")
        else ("("^str(counter)^","^path^")\n")
in
  print output
end

(**) val _ = main () (**)
