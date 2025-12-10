| stream input lines counts cache |

Transcript clear.

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.

games := OrderedCollection new.
1 to: (lines size) do: [:i |
	| items answer buttons |
	items := ((lines at: i) findTokens: ' ').
	answer := items at: 1.
	answer := answer copyFrom: 2 to: (answer size - 1).
	buttons := items copyFrom: 2 to: (items size - 1).
	buttons := buttons collect: [:each | each copyFrom: 2 to: (each size - 1) ].
	buttons := buttons collect: [:each | ((each findTokens: ',') collect: [:x | x asInteger]) asArray ].
	games add: (Array with: answer with: buttons asArray).
].

cache := nil.
cacheHits := nil.
counts := nil.

pressButtons := nil.
pressButtons := [:queue :allButtons :answer |
	| gameState count board |
	gameState := queue removeFirst.
	count := gameState count + 1.
	(queue size > 10000000)
		ifTrue: [
			Transcript show: gameState printString; cr.
			Transcript show: 'Quit: ', (queue size), ' Count: ', count, ' Answer:', answer printString; cr.
			^nil
			].
	board := gameState state.
	gameState buttons do: [:b |
		| offset value newValue |
		offset := b + 1.
		value := board at: offset.
		(value = $.)
			ifTrue: [ newValue := $# ]
			ifFalse: [ newValue := $. ].
		board at: offset put: newValue.
		].
	(board = answer)
		ifTrue: [
			Transcript show: 'Finished ' , (counts size) , ' Count: ', count, ' Cache Size: ', (cache size), ' Cache Hits ', (cacheHits) printString; cr.
			queue removeAll.
			count
			]
		ifFalse: [ 
			| allButtonsWithIndex filteredButtons cacheKey |
			cacheKey := gameState state , gameState buttonsIndex.
			cache add: cacheKey.
			allButtonsWithIndex := allButtons withIndexCollect: [:b :i | { i. b }].
			filteredButtons := allButtonsWithIndex select: [:pair | pair first ~~ gameState buttonsIndex].
			filteredButtons do: [:pair |
				| newGameState newBoard newCacheKey |
				index := pair first.
				btns := pair second.
				newBoard := board copy.
				newCacheKey := newBoard , index.
				(cache includes: newCacheKey)
					ifTrue: [ cacheHits := cacheHits + 1 ]
					ifFalse: [
						newGameState := GameState
							withState: newBoard
							buttons: btns
							count: count
							previous: gameState
							buttonsIndex: index.
						queue add: newGameState.
					]
				]
			].
	].

counts := OrderedCollection new.

games do: [:game |
	| initialState buttons answer queue count |
	answer := game at: 1.
	initialState := String new: (answer size) withAll: $. .
	buttons := game at: 2.
	queue := OrderedCollection new.
	cache := Set new.
	cacheHits := 0.
	buttons withIndexDo: [:btns :index |
		| state |
		state := GameState
		    withState: initialState copy
		    buttons: btns
		    count: 0
		    previous: nil
		    buttonsIndex: index.
		queue add: state.
		].
	[ queue isEmpty ] whileFalse: [
	    count := pressButtons value: queue value: buttons value: answer
		].
	counts add: count.
	].

Transcript show: 'Games: ', (counts size) printString; cr.
Transcript show: (counts sum) printString; cr.