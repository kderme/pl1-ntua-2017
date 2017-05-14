fun merge(nil, ys) f = ys
  | merge(xs, nil) f= xs
  | merge(x::xs, y::ys) f=

  if f(x,y) then
    x::merge(xs, y::ys) f
  else
    y::merge(x::xs, ys) f;

fun split nil = (nil,nil)
  |     split [a] = ([a],[])
  |     split (a::b::cs) = 
let 
  val (M,N) =split cs 
in 
  (a::M, b::N)
end

fun mergesort nil f = nil
  | mergesort [a] f= [a]
  | mergesort [a,b] f= if f(a,b) 
        then [a,b]
        else [b,a]

  |   mergesort L f=
          let val (M,N) = split L
  in
     merge (mergesort M f, mergesort N f) f
  end

fun parse file =
let
        (* a function to read an integer from an input stream *)
        fun next_int input =
                Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        val stream = TextIO.openIn file
        val N = next_int stream
 (*       val _ = print (Int.toString(N))        *)
        val _ = TextIO.inputLine stream
        fun rec_read 0 ls=ls
        |   rec_read k ls=
        let
          val x=next_int stream
        in
          rec_read (k-1) ((x,N-k)::ls)
        end
in 
  rev (rec_read N [])
end

fun compare ((h1,i1),(h2,i2))=
  h1<h2

fun solve (ls:((int*int) list))=
let
        fun taken (n:int)=
        let val (h,_)=List.nth(ls,n)
        in
          h
        end
          val initial_state=(taken 0,taken 0,taken 0)
        
        fun dosth ( (_,index),(start, final, vfinal))=
          if start-final<index-vfinal then
                (index,vfinal,vfinal)
          else 
            if index<vfinal then
                (start,final,index)
            else (start,final,vfinal)
          
        val final_state=foldl dosth initial_state ls
        val ret=(#1 final_state) - (#2 final_state)
in
        ret
end

fun skitrip file=
let
        val ls=parse file
        val sorted_ls = mergesort ls compare
in 
        solve sorted_ls
end


fun main()=
let
  val argv=(CommandLine.arguments())
  val file = hd argv
  val n=skitrip file
in
  print ((Int.toString n)^"\n")
end

(**) val _ =main () (**)




