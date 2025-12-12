| stream input lines move devices devicesReversed total |

Transcript clear.

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.

devices := Dictionary new.
devicesReversed := Dictionary new.
1 to: lines size do: [:i |
	| items device childDevices |
	items := (lines at: i) findTokens: ':'.
	device := items at: 1.
	childDevices := (items at: 2) findTokens: ' '.
	childDevices do: [:d |
		(devicesReversed at: d ifAbsentPut: [ OrderedCollection new ]) add: device.
		].
	devices at: device put: childDevices asArray.
].

move := nil.
move := [:device :target :devicesLookup :ignore :count |
	| newCount |
	newCount := count.
	(device = target)
		ifTrue: [
			newCount := newCount + 1.
			]
		ifFalse: [
			| outputs |
			outputs := devicesLookup at: device.
			(outputs allSatisfy: [:output | ignore includes: output])
			    ifTrue: [
					Transcript show: 'Ignore ', device printString; cr.
					ignore add: device
			    ]
				ifFalse: [
					(outputs reject: [:o | ignore includes: o]) do: [:o |
						newCount := move value: o value: target value: devicesLookup value: ignore value: newCount
						]	
					]
				].
		newCount
	].

total := move value: 'dac' value: 'out' value: devices value: (Set new) value: 0.
total := total * (move value: 'fft' value: 'svr' value: devicesReversed value: (Set new) value: 0).
total := total * (move value: 'dac' value: 'fft' value: devicesReversed value: (Set with: 'svr') value: 0).

Transcript show: 'Total: ', total printString; cr.