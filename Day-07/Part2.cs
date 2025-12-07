var lines = File.ReadAllLines("input.txt");
var splitters = lines.Select(line =>
        line.Select((ch, i) => (ch, i)).Where(x => x.ch == '^').Select(x => x.i).ToHashSet()).ToArray();
var cache = new Dictionary<(int, int), long>();

Func<int, int, long> iterate = null!;
iterate = (beam, index) =>
    index == lines.Length ? 0 :
        cache.TryGetValue((beam, index), out var cached) ? cached :
            cache[(beam, index)] = splitters[index].Contains(beam)
                ? new[] { beam - 1, beam + 1 }.Aggregate(1L, (acc, b) => acc + iterate(b, index + 1))
                : iterate(beam, index + 1);

Console.WriteLine(iterate(lines[0].IndexOf('S'), 0) + 1);