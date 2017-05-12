fun mp #"S"  = 1
  | mp #"."  = 2
  | mp #"X"  = 3 
  | mp #"W"  = 4
  | mp #"E"  = 5
  | mp #"\n" = 6

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

fun ffff (i,1,(s,e))=(i,e)
|   ffff (i,5,(s,e))=(s,i)
|   ffff (i,_,(s,e))=(s,e)

(* (type,k,pizza,min,visited,move,prev) *)

fun fff (i,(c,_,_,_,_,_,_),y)=ffff(i,c,y)

  fun insert(arr:int list Array2.array,cost:int,typee:int,newnode:int,move)= 
Array2.update(arr,cost,typee,newnode::Array2.sub(arr,cost,typee))

(*types*)
val NOPIZZA=0;
val W_NOPIZZA=1;
val W_PIZZA=2;
val PIZZA=3;

fun mov 0="q"
|   mov 1="U"
|   mov 2="R"
|   mov 3="L"
|   mov 4="D"

fun search(
  N:int,
  M:int,
  s:int,
  e:int,
  nodes1:(int*int*bool*int*bool*int*int) array,
  nodes0:(int*int*bool*int*bool*int*int) array,
  arr:int list Array2.array)=
let
  fun ii x=Int.div(x,M)
  fun jj x=Int.mod(x,M)
(*main loop function with counter*)  
fun loop counter=
let
 
  (*find path at the end*)  
(*fun search(N,M,s,e,nodes1,nodes0,arr)*)
  fun find_path _=
  let 
    fun path_rec acc k=
    let 
      val node=Array.sub(nodes1,e)
    in
      if k=s then String.concat (map mov (((#1 node)::acc)))
      else path_rec ((#1 node)::acc) (#7 node)
    end
  in
    path_rec [] e
  end

  (*rewind at each loop*)
  fun rewind _=
  let
    val _=Array2.update(arr,0,NOPIZZA,Array2.sub(arr,1,NOPIZZA))
    val _=Array2.update(arr,0,W_NOPIZZA,Array2.sub(arr,1,W_NOPIZZA))
    val _=Array2.update(arr,0,W_PIZZA,Array2.sub(arr,1,W_PIZZA))
    val _=Array2.update(arr,0,PIZZA,Array2.sub(arr,1,PIZZA))    

    val _=Array2.update(arr,1,NOPIZZA,Array2.sub(arr,2,NOPIZZA))
    val _=Array2.update(arr,1,W_NOPIZZA,Array2.sub(arr,2,W_NOPIZZA))
    val _=Array2.update(arr,1,W_PIZZA,Array2.sub(arr,2,W_PIZZA))
    val _=Array2.update(arr,1,PIZZA,Array2.sub(arr,2,PIZZA))

    val _=Array2.update(arr,0,NOPIZZA,[])
    val _=Array2.update(arr,0,W_NOPIZZA,[])
    val _=Array2.update(arr,0,W_PIZZA,[])
    val _=Array2.update(arr,0,PIZZA,[])
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
      if new_visited then
      let 
        val _ = insert(arr,cost,typee,new_k,move)
        val _ = if new_t=4 andalso move<>5 then 
          let val w_typee=if pizza then W_PIZZA else W_NOPIZZA
          in insert(arr,cost,w_typee,new_k,move) end
            else ()
        val updated=(new_t,new_k,new_pizza,counter+cost,true,move,k)
        val _ = Array.update(new_nodes,new_k,updated)
      in true end
      else false
    end
    else false(*valid*)
  
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

    val _=valid(pizza,k,new_nodes,cost,typee,node,i-1,j,1)
    val _=valid(pizza,k,new_nodes,cost,typee,node,i,j+1,2)
    val _=valid(pizza,k,new_nodes,cost,typee,node,i,j-1,3)
    val _=valid(pizza,k,new_nodes,cost,typee,node,i+1,j,4)
  in if (#1 node)=5 andalso pizza then true else false
  end (*move_urld*)

  val x = Array2.sub(arr,0,NOPIZZA)
  val y = Array2.sub(arr,0,W_NOPIZZA)
  val z = Array2.sub(arr,0,W_PIZZA)
  val w = Array2.sub(arr,0,PIZZA)

  val _=List.exists (move_urld false) x
  val _=List.exists (move_w false )y
  val _=List.exists (move_w false) z
  val found=List.exists (move_urld true) w
  in
    if found then find_path 1 else 
      let val _ =rewind() 
      in loop (counter+1) end (*loop*)
  end    
  in
  loop 0
end

fun spacedeli file=
let 
  val ls_file=parse file
  val ls_file_int=map mp ls_file
  val lsls1=foldr ff [[]] ls_file_int
  val N=List.length(lsls1)
  val M=List.length(hd lsls1)
  val ls1=foldr f [] ls_file_int
(* (type,k,pizza,min,visited,move,prev) *)
  val ls1_node=map (fn c=>(c,0,true,Option.valOf Int.maxInt,false,0,0)) ls1
  val ls0_node=map (fn c=>(c,0,false,Option.valOf Int.maxInt,false,0,0)) ls1
  val nodes1=Array.fromList ls1_node
  val nodes0=Array.fromList ls0_node
  val (s,e)=Array.foldli fff (0,0) nodes1
  val arr=Array2.array(3,4,[]:int list)
  val _=Array2.update(arr,0,3,[s])
in
(*fun search(N,M,s,e,nodes1,nodes0,arr)*)
  search(N,M,s,e,nodes1,nodes0,arr)
end
