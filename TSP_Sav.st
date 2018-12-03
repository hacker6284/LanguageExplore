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
    "setComment: phrase [
        <category: 'talking stuff'>
        location_x := phrase
    ]"
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
pointsSet := Array new: numberOfPoints asInteger.
count := 1.
numberOfPoints asInteger timesRepeat: [
  pointArray := f nextLine substrings: ' '.
  "comment := f nextLine."
  newPoint := Partier new.
  newPoint setLocation_x: (pointArray first) asInteger.
  newPoint setLocation_y: (pointArray last) asInteger.
  pointsSet at: count put: newPoint deepCopy.
  count := count + 1.
].

"create array for storing decisions"
pathArray:= Array new: numberOfPoints asInteger.

"Remove starting point"
currentPoint := pointsSet at: 1.
pathArray at: 1 put: currentPoint.
pointsSet at: 1 put: nil.

"Initialize all variables"
count := 2.
min_dist := 100.
testX := 0.
testY := 0.
x_distance := 0.
y_distance := 0.
total_distance := 0.
minX := 0.
minY := 0.
min_dist := 0.

numberOfPoints asInteger timesRepeat: [

  Transcript show: 'Current point: ', currentPoint getLocation_x, ' ', currentPoint getLocation_y; cr.
  "'current point' printNl.
  currentPoint getLocation_x printNl.
  currentPoint getLocation_y printNl."

  "loop through points to find closest"
  pointsSet do: [ :testPoint |
    "Because we're using an array, ignore the nil entries"
    (testPoint == nil) ifFalse: [
      testX := testPoint getLocation_x.
      testY := testPoint getLocation_y.
      x_distance := (testX - (currentPoint getLocation_x)) abs.
      y_distance := (testY - (currentPoint getLocation_y)) abs.
      total_distance := ((x_distance raisedTo: 2) + (y_distance raisedTo: 2)) raisedTo: 0.5.
      "Sets the new minimum"
      (total_distance < min_dist) ifTrue: [
        'New minimum' printNl.
        minX := testX.
        minY := testY.
        min_dist := total_distance.
      ].
    ].
  ].
  Transcript show: 'Next point: ', minX, ' ', minY; cr.
  "'next point' printNl.
  minX printNl.
  minY printNl."
  j := 1.
  pointsSet do: [ :testPoint |
    (testPoint == nil) ifFalse: [
      ((testPoint getLocation_x == minX) and: [(testPoint getLocation_y == minY)]) ifTrue: [
        'Adding point' printNl.
        "Reset the current position"
        currentPoint setLocation_x: (testPoint getLocation_x).
        currentPoint setLocation_y: (testPoint getLocation_y).
        "Add point to path history and set as NIL in pointSet array"
        pathArray at: count put: currentPoint.
        pointsSet at: j put: nil.
        count := count + 1.
        min_dist := 100.
      ].
    ].
    j := j + 1.
  ].
].

Transcript show: 'pointsSet size: ', pointsSet size; cr.
"pointsSet size printNl."

"pathArray do: [ :testPoint |
  testPoint getLocation_x printNl.
  testPoint getLocation_y printNl.
]."

f close
"add closest point to decision array"
"remove point from point array"
"return sum of distances gathered along the way"
