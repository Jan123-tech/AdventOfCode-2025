"Define the class"
Object subclass: #GameState
    instanceVariableNames: 'state buttons count previousState buttonsIndex'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Games'.

"Class-side constructor"
GameState class compile: '
withState: aState buttons: someButtons count: aCount previous: aPrevious buttonsIndex: anIndex
    ^ self new
        state: aState;
        buttons: someButtons;
        count: aCount;
        previousState: aPrevious;
        buttonsIndex: anIndex;
        yourself
' classified: 'instance creation'.

"Instance-side accessors"
GameState compile: 'state ^ state' classified: 'accessing'.
GameState compile: 'state: aState state := aState' classified: 'accessing'.

GameState compile: 'buttons ^ buttons' classified: 'accessing'.
GameState compile: 'buttons: someButtons buttons := someButtons' classified: 'accessing'.

GameState compile: 'count ^ count' classified: 'accessing'.
GameState compile: 'count: aCount count := aCount' classified: 'accessing'.

GameState compile: 'previousState ^ previousState' classified: 'accessing'.
GameState compile: 'previousState: aPrevious previousState := aPrevious' classified: 'accessing'.

GameState compile: 'buttonsIndex ^ buttonsIndex' classified: 'accessing'.
GameState compile: 'buttonsIndex: anIndex buttonsIndex := anIndex' classified: 'accessing'.

"Helper to get the selected button"
GameState compile: '
selectedButton
    ^ (buttons isNil or: [buttonsIndex isNil])
        ifTrue: [nil]
        ifFalse: [buttons at: buttonsIndex]
' classified: 'accessing'.

"Printing"
GameState compile: '
printOn: aStream
    aStream
        nextPutAll: ''GameState('';
        nextPutAll: ''state: ''; nextPutAll: state printString;
        nextPutAll: '', buttons: ''; nextPutAll: buttons printString;
        nextPutAll: '', count: ''; nextPutAll: count printString;
        nextPutAll: '', buttonsIndex: ''; nextPutAll: buttonsIndex printString;
        nextPutAll: '', previousState: '';
        nextPutAll: (previousState isNil
            ifTrue: [ ''nil'' ]
            ifFalse: [ previousState printString ]);
        nextPutAll: '')''
' classified: 'printing'.