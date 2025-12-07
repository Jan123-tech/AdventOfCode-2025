| stream input lines start beams count |

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.
start := (lines at: 1) indexOf: $S.
beams := Set with: start.
count := 0.

1 to: lines size do: [:i |
	| line splitters newBeams |
	newBeams := Set new.
	line := lines at: i.
	splitters := (1 to: line size) select: [:j | (line at: j) = $^].
	beams do: [:value |
		(splitters includes: value)
			ifTrue: [
				count := count + 1.
				newBeams add: value + 1.
				newBeams add: value - 1.
			]
			ifFalse: [ newBeams add: value ].
	].
	beams := newBeams
].

Transcript show: count printString; cr.