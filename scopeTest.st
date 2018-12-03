x := 0.
y := 0.

numArray := Array new: 4.

counter := 1.
[counter < 20] whileTrue: [
  count := 1.
  numArray size timesRepeat: [
    numArray at: count put: count.
    count := count + 1.
  ].

  numArray do: [ :numbie |
    x := x + numbie.
    x printNl.
  ].

  counter := counter + 1.

x printNl.]

x printNl.
