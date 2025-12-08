| stream input lines points diffs sortedDiffs top groups iterate diffed topGroups result topCount |

topCount := 1000.

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.

points := OrderedCollection new.
1 to: lines size do: [:i |
	| point |
	point := ((lines at: i) findTokens: ',') collect: [:each | each asInteger].
	point add: i.
	points add: point asArray
].

diffs := OrderedCollection new.
diffed := Set new.
points do: [:p0 |
	points do: [:p1 |	
		| dx dy dz distance item key |
		key := ((p0 at: 4) min: (p1 at: 4)) @ ((p0 at: 4) max: (p1 at: 4)).
		(p0 ~= p1 and: [(diffed includes: key) not]) ifTrue: [
			dx := (p1 at: 1) - (p0 at: 1).
			dy := (p1 at: 2) - (p0 at: 2).
			dz := (p1 at: 3) - (p0 at: 3).
			distance := ((dx * dx) + (dy * dy) + (dz * dz)) sqrt.
			item := Array with: p0 with: p1 with: distance.
			diffed add: key.
			diffs add: item
		]
	]
].

sortedDiffs := diffs sorted: [:a :b | (a at: 3) < (b at: 3)].
top := sortedDiffs first: topCount.

pointToPoint := Dictionary new.
top do: [:x |
	| i0 i1 |
	i0 := (x at: 1) at: 4.
	i1 := (x at: 2) at: 4.
	(pointToPoint at: i0 ifAbsentPut: [OrderedCollection new]) add: i1.
	(pointToPoint at: i1 ifAbsentPut: [OrderedCollection new]) add: i0.
].


iterate := nil.
iterate := [:group :x  |
	(grouped includes: x) ifFalse: [
		| items |
		group add: x.
		grouped add: x.
		items := pointToPoint at: x.
		items do: [:i |
			iterate value: group value: i.
		]
	]
].

groups := OrderedCollection new.
grouped := Set new.
pointToPoint keysDo: [:x |
	| group |
	(grouped includes: x) ifFalse: [
		group := Set new.
		groups add: group.
		iterate value: group value: x.
	].
].

topGroups := (groups asSortedCollection: [:a :b | a size > b size]) first: 3.
result := topGroups inject: 1 into: [:acc :x | acc * x size].

Transcript show: result printString; cr.