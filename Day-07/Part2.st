| stream input lines start total iterate cache |

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.
start := (lines at: 1) indexOf: $S.
cache := Dictionary new.

iterate := nil.
iterate := [:beam :index |
	| line splitters count nextIndex cacheKey |
	(index > lines size)
		ifTrue: [ 0 ]
		ifFalse: [
			cacheKey := index@beam.
			(cache includesKey: cacheKey)
				ifTrue: [ cache at: cacheKey ]
				ifFalse: [
					nextIndex := index + 1.
					line := lines at: index.
					splitters := (1 to: line size) select: [:j | (line at: j) = $^].
					(splitters includes: beam)
						ifTrue: [
							count :=  1.
							count := count + (iterate value: (beam + 1) value: nextIndex).
							count := count + (iterate value: (beam - 1) value: nextIndex).
						]
						ifFalse: [ count := iterate value: beam value: nextIndex ].
					cache at: cacheKey put: count.
					count
				]
		]
].

total := (iterate value: start value: 1) + 1.

Transcript show: total printString; cr.