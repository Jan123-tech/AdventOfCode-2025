| stream input lines move queue total devices |

Transcript clear.

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.

devices := Dictionary new.
1 to: lines size do: [:i |
	| items device childDevices |
	items := (lines at: i) findTokens: ':'.
	device := items at: 1.
	childDevices := (items at: 2) findTokens: ' '.
	devices at: device put: childDevices asArray.
].

queue := nil.
total := 0.

move := nil.
move := [:device |
	(device = 'out')
		ifTrue: [
			1 ]
		ifFalse: [
			| outputs |
			outputs := devices at: device.
			outputs do: [:o |
				queue add: o.
				].
			nil
			]
	].

queue := OrderedCollection with: 'you'.
[ queue isEmpty ] whileFalse: [
	| path count |
	path := queue removeFirst.
	count := move value: path.
	(count ~~ nil)
		ifTrue: [
			total := total + 1
			]
	].

Transcript show: 'Total: ', total printString; cr.