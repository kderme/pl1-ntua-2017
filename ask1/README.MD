## SkiTrip

Given N numbers, find a pair, one left and one right, with:<br />
right>=left <br />
index(left)<=index(right)<br />
distance:=index(right)-index(left)=max<br />
Program must print the distance of this pair<br />
## Examples

### C
$ ./skitrip h1.txt<br />
10 <br />
<br />
$ ./skitrip h2.txt <br />
0<br />
<br />

### SML
\- skitrip "h1.txt";<br />
val it = 10 : int<br />
<br />
\- skitrip "h2.txt";<br />
 val it = 0 : int<br />

### Files
$ cat h1.txt<br />
16<br />
78 88 64 94 17 91 57 69 38 62 13 17 35 15 20 15<br />
<br />
$ cat h2.txt<br />
6<br />
42 41 40 39 38 37<br />
