var devices = File.ReadAllLines("input.txt")
    .Select(line => line.Split(':'))
    .ToDictionary(
        parts => parts[0],
        parts => parts[1].Split(' ', StringSplitOptions.RemoveEmptyEntries));

int Move(string device) =>
    device == "out" ? 1 : devices[device].Sum(Move);

var total = Move("you");

Console.WriteLine($"Total: {total}");