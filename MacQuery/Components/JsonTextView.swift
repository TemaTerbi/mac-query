//
//  JsonTextView.swift
//  MacQuery
//
//  Created by Артем Соловьев on 31.01.2024.
//

import SwiftUI

struct JsonTextView: NSViewRepresentable {
    let attributedString: NSAttributedString

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()
        
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder

        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = NSColor.black.withAlphaComponent(0.6)
        textView.textStorage?.setAttributedString(attributedString)
        textView.textContainerInset = NSSize(width: 10, height: 10)
        
        scrollView.documentView = textView

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        textView.textStorage?.setAttributedString(attributedString)
    }
}

//MARK: - Functional for highlighting JSON syntax
func highlightJsonSyntax(jsonString: String) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: jsonString)
    let fullRange = NSRange(location: 0, length: jsonString.utf16.count)
    let options: [NSAttributedString.Key: Any] = [
        .font: NSFont.monospacedSystemFont(ofSize: 14, weight: .semibold),
        .foregroundColor: NSColor.textColor
    ]
    
    attributedString.addAttributes(options, range: fullRange)

    // Регулярные выражения для ключей и значений
    let keyRegexPattern = "\"\\s*([\\w\\s]+?)\\s*\"\\s*:(?!\\s*\\{)"
    let stringRegexPattern = "\"\\s*(.+?)\\s*\"(?=\\s*:\\s)"
    let valueRegexPattern = ":\\s*\"\\s*(.+?)\\s*\""
    let numberRegexPattern = ":\\s*(\\d+\\.?\\d*|\\d*\\.?\\d+)"
    let boolNullRegexPattern = ":\\s*(true|false|null)"
    let bracesRegexPattern = "[\\[\\]\\{\\}]"

    // Словарь с регулярными выражениями и соответствующими цветами
    let syntaxColors: [(pattern: String, color: NSColor)] = [
        (keyRegexPattern, .systemTeal), // Ключи
        (stringRegexPattern, .systemTeal), // Строковые ключи
        (valueRegexPattern, .systemOrange), // Строковые значения
        (numberRegexPattern, .systemCyan), // Числа
        (boolNullRegexPattern, .systemPurple), // Булевы значения и null
        (bracesRegexPattern, .white) // Скобки
    ]
    
    // Применяем стили к элементам JSON
    for (pattern, color) in syntaxColors {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            regex.enumerateMatches(in: jsonString, options: [], range: fullRange) { match, _, _ in
                if let matchRange = match?.range {
                    attributedString.addAttribute(.foregroundColor, value: color, range: matchRange)
                }
            }
        } catch {
            print("Regex had an error: \(error)")
        }
    }
    
    return attributedString
}
