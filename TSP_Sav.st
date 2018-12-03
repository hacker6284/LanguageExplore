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
pointsSet := Array new: numberOfPoints asInteger.
count := 1.
numberOfPoints asInteger timesRepeat: [
  pointArray := f nextLine substrings: ' '.
  newPoint := Partier new.
  newPoint setLocation_x: (pointArray first) asInteger.
  newPoint setLocation_y: (pointArray last) asInteger.
  pointsSet at: count put: newPoint deepCopy.
  count := count + 1.
].

"create array for storing decisions"
pathArray:= Array new: numberOfPoints asInteger.

"choose a starting point"
"firstPoint := pointsSet anyOne.
pathArray at: 1 put: firstPoint.
pointsSet remove: firstPoint."

"
pointsSet do: [ :testPoint |
  testPoint getLocation_x printNl.
  testPoint getLocation_y printNl.
].
"

"loop through each point and determine which is closest"

"Remove starting point"
currentPoint := pointsSet at: 1.
pathArray at: 1 put: currentPoint.
pointsSet at: 1 put: nil.

count := 2.
min_dist := 100.

numberOfPoints asInteger timesRepeat: [
  'current point' printNl.
  currentPoint getLocation_x printNl.
  currentPoint getLocation_y printNl.
  i := 1.
  "loop to find the next closest point"
  pointsSet do: [ :testPoint |
    (testPoint == nil) ifFalse: [
      testX := testPoint getLocation_x.
      testY := testPoint getLocation_y.
      x_distance := (testX - (currentPoint getLocation_x)) abs.
      y_distance := (testY - (currentPoint getLocation_y)) abs.
      total_distance := ((x_distance raisedTo: 2) + (y_distance raisedTo: 2)) raisedTo: 0.5.

      (total_distance < min_dist) ifTrue: [
        'new minimum' printNl.
        minX := testX.
        minY := testY.
        min_dist := total_distance.
      ].
      i := i + 1.
    ].
  ].
  'next point' printNl.
  minX printNl.
  minY printNl.

  j := 1.
  pointsSet do: [ :testPoint |
    (testPoint == nil) ifFalse: [
      ((testPoint getLocation_x == minX) and: [(testPoint getLocation_y == minY)]) ifTrue: [
        'adding point' printNl.
        currentPoint setLocation_x: (testPoint getLocation_x).
        currentPoint setLocation_y: (testPoint getLocation_y).
        pathArray at: count put: currentPoint.
        pointsSet at: j put: nil.
        count := count + 1.
        min_dist := 100.
      ].
    ].
    j := j + 1.
  ].
].

pointsSet size printNl.

"pathArray do: [ :testPoint |
  testPoint getLocation_x printNl.
  testPoint getLocation_y printNl.
]."

    "firstPoint := pointsSet anyOne.
    pathArray at: count put: firstPoint.
    pointsSet remove: firstPoint.
    count := count + 1."

"Get any random point as the minimum point guess"
"
[pointsSet size == 0] whileFalse:[
  'loop iteration: ' printNl.
  counter printNl.
  pointsSet do: [ :testPoint |
    testPoint getLocation_x printNl.
    testPoint getLocation_y printNl.
  ].

  minPoint := pointsSet anyOne.
  pointsSet remove: minPoint ifAbsent: ['damn' printNl.].

  x_distance := ((minPoint getLocation_x) - (pathArray at: counter - 1) getLocation_x) abs.
  y_distance := ((minPoint getLocation_y) - (pathArray at: counter - 1) getLocation_y) abs.
  min_distance := ((x_distance raisedTo: 2) + (y_distance raisedTo: 2)) raisedTo: 0.5.
"
  "loop and find the minimum distance"
  "
  pointsSet do: [ :thisPoint |
    x_distance := ((thisPoint getLocation_x) - (pathArray at: counter - 1) getLocation_x) abs.
    y_distance := ((thisPoint getLocation_y) - (pathArray at: counter - 1) getLocation_y) abs.
    total_distance := ((x_distance raisedTo: 2) + (y_distance raisedTo: 2)) raisedTo: 0.5.

    (total_distance < min_distance) ifTrue: [
      pointsSet add: minPoint.
      min_distance := total_distance.
      minPoint := thisPoint.
      pointsSet remove: thisPoint ifAbsent: ['unbelievable' printNl.].
      pathArray at: counter put: minPoint
    ]
  ].
  counter := counter + 1.
].

'Answer:' printNl.

counter := 1.
pathArray size timesRepeat: [
  (pathArray at: counter) getLocation_x printNl.
  (pathArray at: counter) getLocation_y printNl.
  counter := counter + 1
].
"
"f position: 0.
4 timesRepeat: [ Transcript nextPut: (f next) ]."
f close
"add closest point to decision array"
"remove point from point array"
"return sum of distances gathered along the way"
