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
  h1>h2

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
        val sorted_ls = ListMergeSort.sort compare ls 
in 
        solve sorted_ls
end

