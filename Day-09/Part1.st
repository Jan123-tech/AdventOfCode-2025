| stream input lines points pairs paired sortedPairs |

Transcript clear.

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.

points := OrderedCollection new.
1 to: lines size do: [:i |
	| point |
	point := ((lines at: i) findTokens: ',') collect: [:each | each asInteger].
	point := (point at: 1) @ (point at: 2).
	points add: { i. point }.
].

pairs := OrderedCollection new.
paired := Set new.
points do: [:p0 |
	points do: [:p1 |	
		| key pt0 pt1 dx dy area item |
		key := ((p0 at: 1) min: (p1 at: 1)) @ ((p0 at: 1) max: (p1 at: 1)).
		(p0 ~= p1 and: [(paired includes: key) not])
			ifTrue: [
				pt0 := p0 at: 2.
				pt1 := p1 at: 2.
				dx := (pt0 x) - (pt1 x).
				dy := (pt0 y) - (pt1 y).
				dx := dx + 1.
				dy := dy + 1.
				area := (dx * dy) abs.
				item := Array with: p0 with: p1 with: area.
				paired add: key.
				pairs add: item.
			]
	]
].
sortedPairs := pairs sorted: [:a :b | (a at: 3) > (b at: 3)].
Transcript show: ((sortedPairs at: 1) at: 3) printString; cr.