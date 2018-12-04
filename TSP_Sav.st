"create point class"
Object subclass: Partier [
    | location_x location_y distance comment |
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
    getDistance [
        ^distance
    ]
    setLocation_y: newLocation [
        <category: 'location stuff'>
        location_y := newLocation
    ]
    setLocation_x: newLocation [
        <category: 'location stuff'>
        location_x := newLocation
    ]
    setComment: phrase [
        <category: 'talking stuff'>
        comment := phrase
    ]
    setDistance: dist [
        <category: 'distance stuff'>
        distance := dist
    ]
    printOn: stream [
      <category: 'printing'>
      stream nextPutAll: '('.
      location_x printOn: stream.
      stream nextPutAll: ','.
      location_y printOn: stream.
      stream nextPutAll: ')'.
    ]
].

Object subclass: TSPSolver [
  TSPSolver class >> new [
      <category: 'instance creation'>
      | r |
      r := super new.
      r init.
      ^r
  ]
  init [
    | f numberOfPoints pointsSet count pointArray newPoint pathArray currentPoint minimum min_dist testX testY x_distance y_distance total_distance i j userSet userPath userChoice difference|
    "read in from the file"
    f := FileStream open: 'input.txt' mode: FileStream read.
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
    userSet := pointsSet deepCopy.

    "create array for storing decisions"
    pathArray := Array new: (numberOfPoints asInteger) + 1.
    userPath := pathArray deepCopy.

    "Remove starting point"
    currentPoint := pointsSet at: 1.
    pathArray at: 1 put: currentPoint deepCopy.
    pointsSet at: 1 put: nil.

    minimum := Partier new.
    minimum setLocation_x: 0.
    minimum setLocation_y: 0.

    "Initialize all variables"
    count := 2.
    min_dist := 100.

    numberOfPoints asInteger timesRepeat: [
      "loop through points to find closest"
      pointsSet do: [ :testPoint |
        "Because we're using an array, ignore the nil entries"
        (testPoint == nil) ifFalse: [
          testX := (testPoint getLocation_x).
          testY := (testPoint getLocation_y).
          x_distance := (testX - (currentPoint getLocation_x)) abs.
          y_distance := (testY - (currentPoint getLocation_y)) abs.
          total_distance := ((x_distance raisedTo: 2) + (y_distance raisedTo: 2)) asFloatE sqrt.
          "Sets the new minimum"
          (total_distance < min_dist) ifTrue: [
            minimum setLocation_x: testX.
            minimum setLocation_y: testY.
            minimum setDistance: total_distance.
            min_dist := total_distance.
          ].
        ].
      ].
      j := 1.
      pointsSet do: [ :testPoint |
        (testPoint == nil) ifFalse: [
          ((testPoint getLocation_x == (minimum getLocation_x)) and: [(testPoint getLocation_y == (minimum getLocation_y))]) ifTrue: [
            "Reset the current position"
            currentPoint setLocation_x: (testPoint getLocation_x).
            currentPoint setLocation_y: (testPoint getLocation_y).
            "Add point to path history and set as NIL in pointSet array"
            pathArray at: count put: currentPoint deepCopy.
            pointsSet at: j put: nil.
            count := count + 1.
            min_dist := 100.
          ].
        ].
        j := j + 1.
      ].
    ].

    "Do user stuff"
    currentPoint := (userSet at: 1) deepCopy.
    userPath at: 1 put: currentPoint deepCopy.
    userSet at: 1 put: nil.
    i := 2.
    (numberOfPoints asInteger) - 1 timesRepeat: [
      'You are at: ' display.
      currentPoint displayNl.
      'Choose a point from the following to travel to: ' displayNl.
      j := 1.
      userSet do: [ :printPoint |
        (printPoint == nil) ifFalse: [
          j display.
          ': ' display.
          printPoint displayNl.
        ].
        j := j + 1.
      ].
      'Enter choice: ' display.
      userChoice := (stdin nextLine) asInteger.

      userPath at: i put: ((userSet at: userChoice) deepCopy).
      currentPoint := ((userSet at: userChoice) deepCopy).
      userSet at: userChoice put: nil.

      i := i + 1.
    ].

    "add initial point to the end of the path array"
    pathArray at: (pathArray size) put: (pathArray at: 1) deepCopy.

    "repurpose total_distance variable"
    total_distance := 0.

    "repurpose other variables"
    currentPoint := pathArray at: 1.

    pathArray do: [ :testPoint |

      x_distance := ((testPoint getLocation_x) - (currentPoint getLocation_x)) abs.
      y_distance := ((testPoint getLocation_y) - (currentPoint getLocation_y)) abs.
      total_distance := total_distance + ((x_distance raisedTo: 2) + (y_distance raisedTo: 2)) asFloatE sqrt.
      currentPoint setLocation_x: (testPoint getLocation_x).
      currentPoint setLocation_y: (testPoint getLocation_y).
    ].

    Transcript cr.
    'Nearest Neighbor Path: ' display.
    pathArray do: [ :printPoint |
      printPoint display.
      ', ' display.
    ].
    Transcript cr.
    'Nearest Neighbor Total Distance: ' display.
    total_distance displayNl.

    difference := total_distance deepCopy.

    "add initial point to the end of the path array"
    userPath at: (userPath size) put: (userPath at: 1) deepCopy.

    "repurpose total_distance variable"
    total_distance := 0.

    "repurpose other variables"
    currentPoint := userPath at: 1 deepCopy.

    userPath do: [ :testPoint |

      x_distance := ((testPoint getLocation_x) - (currentPoint getLocation_x)) abs.
      y_distance := ((testPoint getLocation_y) - (currentPoint getLocation_y)) abs.
      total_distance := total_distance + ((x_distance raisedTo: 2) + (y_distance raisedTo: 2)) asFloatE sqrt.
      currentPoint setLocation_x: (testPoint getLocation_x).
      currentPoint setLocation_y: (testPoint getLocation_y).
    ].

    Transcript cr.
    'Your Path: ' display.
    userPath do: [ :printPoint |
      printPoint display.
      ', ' display.
    ].
    Transcript cr.
    'Your Total Distance: ' display.
    total_distance displayNl.

    "repurpose total_distance again"
    difference := difference - total_distance.

    (difference asInteger == 0) ifTrue: [
      'You tied. Nice work!' displayNl.
    ].
    (difference < 0) ifTrue: [
      'You lost. Tough algorithm to beat ;)' displayNl.
    ].
    (difference > 0) ifTrue: [
      'You won! You outsmarted them you clever bastard!' displayNl.
    ].

    f close
    "add closest point to decision array"
    "remove point from point array"
    "return sum of distances gathered along the way"
  ]
].


TSPSolver new
