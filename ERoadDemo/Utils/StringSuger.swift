//
//  StringSuger.swift
//  ERoadDemo
//
//  Created by Admin on 2021/4/15.
//

import Foundation


//MARK: - Cupcake -
/**
 * Create String from formatted string.
 * Also can be use to convert any type to String.
 * Usages:
    Str("1+1=%d", 2)        //"1+1=2"
    Str(1024)               //"1024"
    Str(3.14)               //"3.14"
    ...
 */
public func _Str(_ any: Any, _ arguments: CVarArg...) -> String {
    let str = String(format: String(describing: any), arguments: Array(arguments))
    return str
}

//MARK: - Adaptor
extension String {
    func _length() -> Int {
        #if swift(>=3.2)
        return count
        #else
        return characters.count
        #endif
    }
    
    private func _substring(with range: Range<String.Index>) -> String {
        #if swift(>=4.0)
            return String(self[range])
        #else
            return substring(with: range)
        #endif
    }
    
    private func _substring(to index: String.Index) -> String {
        #if swift(>=4.0)
            return String(self[..<index])
        #else
            return substring(to: index)
        #endif
    }
    
    func _substring(from index: String.Index) -> String {
        #if swift(>=4.0)
            return String(self[index...])
        #else
            return substring(from: index)
        #endif
    }
}



extension String {
    
    /**
     * Return substring from index or to some particular string.
     * Usages:
        "hello world".subFrom(6)        //"world"
        "hello world".subFrom(-5)       //"world"
        "hello world".subFrom("wo")     //"world"
     */
    @discardableResult func _subFrom(_ indexOrSubstring: Any) -> String {
        if var index = indexOrSubstring as? Int {
            if index < 0 { index += _length() }
            let from = self.index(startIndex, offsetBy: index)
            return _substring(from: from)
            
        } else if let substr = indexOrSubstring as? String {
            if let range = self.range(of: substr) {
                return _substring(from: range.lowerBound)
            }
        }
        
        return ""
    }
    
    /**
     * Return substring to index or to some particular string.
     * Usages:
        "hello world".subTo(5)          //"hello"
        "hello world".subTo(-6)         //"hello"
        "hello world".subTo(" ")        //"hello"
     */
    @discardableResult func _subTo(_ indexOrSubstring: Any) -> String {
        if var index = indexOrSubstring as? Int {
            if index < 0 { index += _length() }
            let to = self.index(startIndex, offsetBy: index)
            return _substring(to: to)
            
        } else if let substr = indexOrSubstring as? String {
            if let range = self.range(of: substr) {
                return _substring(to: range.lowerBound)
            }
        }
        
        return ""
    }
    
    
    /**
     * Return substring at index or in range.
     * Usages:
        "hello world".subAt(1)          //"e"
        "hello world".subAt(1..<4)      //"ell"
     */
    @discardableResult func _subAt(_ indexOrRange: Any) -> String {
        if let index = indexOrRange as? Int {
            return String(self[self.index(startIndex, offsetBy: index)])
            
        } else if let range = indexOrRange as? Range<String.Index> {
            return _substring(with: range)
            
        } else if let range = indexOrRange as? Range<Int> {
            let lower = self.index(startIndex, offsetBy: range.lowerBound)
            let upper = self.index(startIndex, offsetBy: range.upperBound)
            return _substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? CountableRange<Int> {
            let lower = self.index(startIndex, offsetBy: range.lowerBound)
            let upper = self.index(startIndex, offsetBy: range.upperBound)
            return _substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? ClosedRange<Int> {
            let lower = self.index(startIndex, offsetBy: range.lowerBound)
            let upper = self.index(startIndex, offsetBy: range.upperBound + 1)
            return _substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? CountableClosedRange<Int> {
            let lower = self.index(startIndex, offsetBy: range.lowerBound)
            let upper = self.index(startIndex, offsetBy: range.upperBound + 1)
            return _substring(with: lower..<upper)
        
        } else if let range = indexOrRange as? NSRange {
            let lower = self.index(startIndex, offsetBy: range.location)
            let upper = self.index(startIndex, offsetBy: range.location + range.length)
            return _substring(with: lower..<upper)
        }
        
        return ""
    }
    
    
    /**
     * Return substring that match the pattern.
     * Usages:
        "abc123".subMatch("\\d+")       //"123"
     */
    @discardableResult func _subMatch(_ pattern: String) -> String {
        let options = NSRegularExpression.Options(rawValue: 0)
        
        if let exp = try? NSRegularExpression(pattern: pattern, options: options) {
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            let matchRange = exp.rangeOfFirstMatch(in: self,
                                                   options:options,
                                                   range: NSMakeRange(0, _length()))
            
            if matchRange.location != NSNotFound {
                return _subAt(matchRange)
            }
        }
        
        return ""
    }
    
    
    /**
     * Replace substring with template.
     * Usages:
        "abc123".subReplace("abc", "ABC")               //ABC123
        "abc123".subReplace("([a-z]+)(\\d+)", "$2$1")   //"123abc"
     */
    @discardableResult func _subReplace(_ pattern: String, _ template: String) -> String {
        let options = NSRegularExpression.Options(rawValue: 0)
        
        if let exp = try? NSRegularExpression(pattern: pattern, options: options) {
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            return exp.stringByReplacingMatches(in: self,
                                                options: options,
                                                range: NSMakeRange(0, _length()),
                                                withTemplate: template)
        }
        
        return ""
    }
}


//MARK: - M
extension String {
    
    /// 匹配两边字符，取中间内容 (开区间)
    /// - Parameters:
    ///   - left: left
    ///   - right: right
    /// - Returns: string
    @discardableResult func _subBoundary(_ left: String = "", _ right: String = "") -> String {

        let start = left == "" ? startIndex : (firstIndex(of: Character(left)) ?? startIndex)
        let end = right == "" ? endIndex : (lastIndex(of: Character(right)) ?? endIndex)
        
        var sub = self[start..<end]
        // var sub = suffix(from: start).prefix(upTo: end)
        
        if start != startIndex {
            sub = sub.dropFirst()
        }
        else if start == startIndex, left != "" {
            if contains(Character(left)) {
                sub = sub.dropFirst()
            }
        }
        return String(sub)
    }

}
