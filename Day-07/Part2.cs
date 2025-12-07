var lines = File.ReadAllLines("input.txt");
var cache = new Dictionary<(int, int), long>();
var splitters = lines.Select(line =>
    line.Select((ch, i) => (ch, i)).Where(x => x.ch == '^').Select(x => x.i).ToHashSet()).ToArray();

Func<int, int, long> compute = null!, memoize = null!;
compute = (beam, index) =>
    index == lines.Length ? 0 :
        splitters[index].Contains(beam)
            ? new[] { beam - 1, beam + 1 }.Aggregate(1L, (acc, b) => acc + memoize(b, index + 1))
            : memoize(beam, index + 1);

memoize = (beam, index) =>
    cache.TryGetValue((beam, index), out var cached) ? cached :
        cache[(beam, index)] = compute(beam, index);

Console.WriteLine(memoize(lines[0].IndexOf('S'), 0) + 1);