"create point class"
Object subclass: Partier [
    | location_x location_y|
    <comment:
        'I love 2 partay'>
    Partier class >> new [
        <category: 'instance creation'>
        | r |
        r := super new.
        r init.
        ^r
    ]
    init [
        <category: 'initialization'>
        location_x := 0.
        location_y := 0
    ]
    getLocation_x [
        <category: 'location stuff'>
        ^location_x
    ]
    getLocation_y [
        <category: 'location stuff'>
        ^location_y
    ]
    setLocation_y: newLocation [
        <category: 'location stuff'>
        location_y := newLocation
    ]
    setLocation_x: newLocation [
        <category: 'location stuff'>
        location_x := newLocation
    ]
].
"read in from the file"
f := FileStream open: 'input.txt' mode: FileStream read.
"f linesDo: [ :c | Transcript nextPutAll: c; nl ]."
numberOfPoints := f nextLine.
"read in from the file"
f := FileStream open: 'input.txt' mode: FileStream read.
"f linesDo: [ :c | Transcript nextPutAll: c; nl ]."
numberOfPoints := f nextLine.
"create array of size specified in file"
pointsSet := Bag new: numberOfPoints asInteger.
numberOfPoints asInteger timesRepeat: [
  pointArray := f nextLine substrings: ' '.
  newPoint := Partier new.
  newPoint setLocation_x: pointArray first.
  newPoint setLocation_y: pointArray last.
  pointsSet add: newPoint
].

"create array for storing decisions"
pathArray:= Array new: numberOfPoints asInteger.

"choose a starting point"
firstPoint := pointsSet anyOne.
pathArray at: 1 put: firstPoint.
pointsSet remove: firstPoint ifAbsent: firstPoint

"loop through each point and determine which is closest"

counter := 2.
[pointsArray isEmpty] whileFalse:[
  thisPoint := pointsArray first.
  (thisPoint getLocation_x) print.
  (thisPoint getLocation_y) printNl.
  pathArray at: counter put: thisPoint.
  pointsArray removeFirst.
  counter := counter + 1
].
"f position: 0.
4 timesRepeat: [ Transcript nextPut: (f next) ]."
f close
"add closest point to decision array"
"remove point from point array"
"return sum of distances gathered along the way"
