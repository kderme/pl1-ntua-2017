fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC)
  input)

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
     val tp=(readInt input, readInt input)
     val _ = TextIO.inputLine input
   in
     rec_read (k-1) (tp::ls)
   end
in
    (N,M,K,rec_read M [])
end

fun villages file=
let
  val ls_file=parse file
in ls_file
end
