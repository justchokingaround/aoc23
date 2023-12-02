import Foundation

let fileURL = URL(fileURLWithPath: "./input.txt")

// Part 1

let colorMax = ["red": 12, "green": 13, "blue": 14]
var sub: Int = 0

do {
    let text = try String(contentsOf: fileURL, encoding: .utf8)
    let lines = text.components(separatedBy: .newlines).dropLast()
    let regex = try! NSRegularExpression(pattern: "([0-9]*) (red|green|blue)")
    
    for line in lines {
        let results = regex.matches(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count))
        
        for result in results {
            let numberRange = Range(result.range(at: 1), in: line)!
            let colorRange = Range(result.range(at: 2), in: line)!
            let number: Int = Int(line[numberRange])!
            let color = String(line[colorRange])
            
            if number > colorMax[color]! {
                sub += Int(line.split(separator: ":").first!.split(separator: " ").last!)!
                break
            }
        }
    }
    
    let totalLines: Int = lines.count
    let x = (1...totalLines).reduce(0, +)
    print(x - sub)
}

// Part 2

do {
    let text = try String(contentsOf: fileURL, encoding: .utf8)
    let lines = text.components(separatedBy: .newlines).dropLast()
    let regex = try! NSRegularExpression(pattern: "[0-9]* (red|green|blue)")
    
    let sum = lines.reduce(0) { (sum, line) in
        var colorMax = ["red": 0, "green": 0, "blue": 0]
        let results = regex.matches(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count))
        let matches = results.map { String(line[Range($0.range, in: line)!]) }
        
        for pair in matches {
            let components = pair.split(separator: " ")
            let number: Int = Int(components.first!)!
            let color = String(components.last!)
            colorMax[color] = max(colorMax[color]!, number)
        }
        return sum + colorMax.values.reduce(1, *)
    }
    print(sum)
}
