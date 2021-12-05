!classDefinition: #BingoSolver category: 'BingoSolver'!
Object subclass: #BingoSolver
	instanceVariableNames: 'numbers fileContents boards results'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BingoSolver'!

!BingoSolver methodsFor: 'initialization' stamp: 'ds 12/4/2021 18:46:50'!
createBoardsFrom: aListOfPreBoards
	
	| listOfBoards |
	listOfBoards := OrderedCollection new.
	
	aListOfPreBoards do: [ :preBoard | listOfBoards add: (Board from: preBoard)].
	
	^ listOfBoards.
		
		! !

!BingoSolver methodsFor: 'initialization' stamp: 'ds 12/4/2021 19:20:17'!
initializeWith: aFileName
	
	results := OrderedCollection new.
	fileContents := self parseFile: aFileName.
	numbers := self parseNumbersFromContents: fileContents.	
	boards := (self createBoardsFrom: (self parseBoardsFromContents: fileContents)).
	self runBingo.! !

!BingoSolver methodsFor: 'initialization' stamp: 'ds 12/4/2021 19:17:51'!
parseBoardsFromContents: inputLines
	
	| index listOfBoards boardsIndex numberOfBoards |
	index := 2.
	boardsIndex := 0.
	
	numberOfBoards := 1 to: 100.
	listOfBoards := OrderedCollection new.
	numberOfBoards do: [:boardNum | listOfBoards add: (OrderedCollection new)].
	
	inputLines do: [:line | | localBoardIndex boardNumbers |
		localBoardIndex := ((index - 2) mod: 5).
		(localBoardIndex = 0) ifTrue: [boardsIndex := boardsIndex + 1].
		(boardsIndex > 100) ifTrue: [^ listOfBoards].
		
		boardNumbers := ((inputLines at: index) substrings) collect: [:number | number asNumber].
		(listOfBoards at: boardsIndex) add: boardNumbers.
		index := index + 1.
	].

	^ listOfBoards.! !

!BingoSolver methodsFor: 'initialization' stamp: 'ds 12/4/2021 18:19:03'!
parseFile: aFileName
	| input lines |
	input := aFileName asFileEntry fileContents.
	
	lines := OrderedCollection new.
	input linesDo: [:line | lines add: line].
	
	lines := lines select: [:line | (line size) > 0].
	
	^ lines.! !

!BingoSolver methodsFor: 'initialization' stamp: 'ds 12/4/2021 18:16:19'!
parseNumbersFromContents: inputLines
	
	| inputNumbers numbersString |
	numbersString := ''.
	inputNumbers := (inputLines at: 1).
	
	inputNumbers do: [:character |
		(character = $,) ifTrue: [numbersString := numbersString , ' ']
					 ifFalse: [numbersString := numbersString , (character asString) ]].
	
	numbersString := numbersString substrings.
	^ numbersString collect: [:number | number asNumber].! !


!BingoSolver methodsFor: 'bingo' stamp: 'ds 12/4/2021 19:24:28'!
mark: aNumber

	boards do: [:board | 
		board mark: aNumber.
		(board isBingo) ifTrue: [
			results add: ((board nonMarkedNumbersSum) * aNumber).
			board finish.
		].
	].! !

!BingoSolver methodsFor: 'bingo' stamp: 'ds 12/4/2021 18:57:23'!
runBingo
	
	numbers do: [:number |
		self mark: number.
	].! !


!BingoSolver methodsFor: 'results' stamp: 'ds 12/4/2021 19:28:32'!
firstResult

	^ results first.! !

!BingoSolver methodsFor: 'results' stamp: 'ds 12/4/2021 19:27:45'!
results

	^ results.! !

!BingoSolver methodsFor: 'results' stamp: 'ds 12/4/2021 19:28:28'!
secondResult

	^ results last.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BingoSolver class' category: 'BingoSolver'!
BingoSolver class
	instanceVariableNames: ''!

!BingoSolver class methodsFor: 'as yet unclassified' stamp: 'ds 12/4/2021 18:10:17'!
from: aFileName
	
	^ self new initializeWith: aFileName.! !


!classDefinition: #Board category: 'BingoSolver'!
Object subclass: #Board
	instanceVariableNames: 'cells finished'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BingoSolver'!

!Board methodsFor: 'initialization' stamp: 'ds 12/4/2021 19:22:49'!
initializeWith: aPreBoard
	| y |
	y := 1.
	cells := OrderedCollection new.
	finished := false.
	
	aPreBoard do: [:row |
		self parseRow: row withY: y.
		y := y + 1.
	].! !

!Board methodsFor: 'initialization' stamp: 'ds 12/4/2021 18:48:00'!
parseRow: aRow withY: aYCoordinate

	| x |
	
	x := 1.
	aRow do: [:rowCell | 
		cells add: (Cell at: (x@aYCoordinate) with: rowCell).
		x := x + 1.
	].! !


!Board methodsFor: 'modifiers' stamp: 'ds 12/4/2021 19:23:00'!
finish

	finished := true.! !

!Board methodsFor: 'modifiers' stamp: 'ds 12/4/2021 19:11:10'!
mark: aNumber

	| wanted |
	wanted := cells detect: [:cell | cell is: aNumber] ifNone: [^ nil].
	wanted mark.! !


!Board methodsFor: 'isBingo' stamp: 'ds 12/4/2021 19:29:32'!
isBingo
	
	^ (finished not) and: [(self isBingoHorizontal) | (self isBingoVertical)].! !

!Board methodsFor: 'isBingo' stamp: 'ds 12/4/2021 19:32:36'!
isBingoHorizontal

	^ self isBingoWithCriteria: [:cell :row | (cell position) y = row].! !

!Board methodsFor: 'isBingo' stamp: 'ds 12/4/2021 19:32:26'!
isBingoVertical
	
	^ self isBingoWithCriteria: [:cell :column | (cell position) x = column].! !

!Board methodsFor: 'isBingo' stamp: 'ds 12/4/2021 19:32:55'!
isBingoWithCriteria: aCriteria

	| cellPositions |
	cellPositions := 1 to: 5.
	
	cellPositions do: [ :position | |cellsAtColumn|
		cellsAtColumn := cells select: [:cell | aCriteria value: cell value: position].
		(cellsAtColumn allSatisfy: [:cell | cell marked]) ifTrue: [^ true].
	].

	^ false.! !


!Board methodsFor: 'result' stamp: 'ds 12/4/2021 19:22:35'!
nonMarkedNumbersSum

	^ ((cells select: [:cell | cell marked not]) sum: [:cell | cell number]).! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Board class' category: 'BingoSolver'!
Board class
	instanceVariableNames: ''!

!Board class methodsFor: 'as yet unclassified' stamp: 'ds 12/4/2021 18:38:10'!
from: aPreBoard
	
	^ self new initializeWith: aPreBoard.! !


!classDefinition: #Cell category: 'BingoSolver'!
Object subclass: #Cell
	instanceVariableNames: 'position number marked'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BingoSolver'!

!Cell methodsFor: 'initialization' stamp: 'ds 12/4/2021 19:07:20'!
initializeAt: aPosition with: aNumber
	
	position := aPosition.
	number := aNumber.
	marked := false.! !


!Cell methodsFor: 'accessors' stamp: 'ds 12/4/2021 18:52:47'!
is: aNumber
	
	^ number = aNumber.! !

!Cell methodsFor: 'accessors' stamp: 'ds 12/4/2021 19:13:03'!
number
	
	^ number.! !

!Cell methodsFor: 'accessors' stamp: 'ds 12/4/2021 19:05:44'!
position
	
	^ position.! !


!Cell methodsFor: 'mark' stamp: 'ds 12/4/2021 19:10:56'!
mark
	
	marked := true.! !

!Cell methodsFor: 'mark' stamp: 'ds 12/4/2021 18:50:32'!
marked
	
	^ marked.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cell class' category: 'BingoSolver'!
Cell class
	instanceVariableNames: ''!

!Cell class methodsFor: 'as yet unclassified' stamp: 'ds 12/4/2021 18:52:37'!
at: aPosition with: aNumber
	
	^ self new initializeAt: aPosition with: aNumber.! !
