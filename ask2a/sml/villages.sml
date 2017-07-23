fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC)
  input)
val DEBUG  = false


fun str (n:int) = Int.toString n

fun solve (N,M,edges:((int*int) list)) = 
let 
  val arr = Array.tabulate (N,fn x=>x)
  fun find i = 
  let 
    val p = Array.sub (arr,i)
  in
    if  p=i then i else 
      let val _ = Array.update (arr,i,p)
      in find p end
  end
  fun union (x,y) =
  let
    val xset = find x
    val yset = find y
    val _ = Array.update (arr,xset,yset)
  in
    if xset <> yset then 1 else 0
  end

  fun f ((x,y),setsN) = 
  let
    val _ = app (fn x=> print (str x)) 
  in
    setsN - union(x,y)
  end

in
  foldl f N edges 
end

fun parse file =
let
  val input = TextIO.openIn file
  val N = readInt input
  val M = readInt input
  val K = readInt input
  val _ = TextIO.inputLine input
  fun rec_read 0 ls=ls
  |   rec_read k ls=
  let
    val tp=(readInt input - 1, readInt input - 1)
    val _ = TextIO.inputLine input
  in
    rec_read (k-1) (tp::ls)
  end
in
  (N,M,K,rec_read M [])
end

fun villages file=
let
  val (N,M,K,edges) = parse file
  val _ =if DEBUG then print ((str N) ^ "," ^ (str M ) ^ "," ^ (str K) ^"\n") else ()
  val teams = solve (N,M,edges)
  val res = if teams-K < 1 then 1 else teams-K
in 
  res
end

fun main () = 
let
  val argv = CommandLine.arguments()
  val file = hd argv
  val res = villages file
  val resStr = (str res)^"\n"
in
  print resStr
end

(**) val _ = main () (**)
