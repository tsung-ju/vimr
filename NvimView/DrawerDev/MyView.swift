//
// Created by Tae Won Ha on 25.08.18.
// Copyright (c) 2018 Tae Won Ha. All rights reserved.
//

import Cocoa

//    let cells = ["👨‍👨‍👧‍👧", "", "a"]
//    let cells = ["👶🏽", "", "a"]
//    let cells = ["ü", "a͆", "a̪"]
//    let cells = ["a", "b" , "c"]
//    let cells = ["<", "-", "-", "\u{1F600}", "", " ", "b", "c"]

class MyView: NSView {

  required init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
    self.setupUgrid()
  }

  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current?.cgContext else { return }

    let cellSize = FontUtils.cellSize(of: fira, linespacing: 1)

    /*
//    let glyphs: [CGGlyph] = [1614, 1494, 1104, 133]
    let glyphs: [CGGlyph] = [1614, 1614, 1063]
    let positions = (0..<3).compactMap {
      CGPoint(x: CGFloat($0) * cellSize.width, y: 10)
    }
    CTFontDrawGlyphs(
      fira,
      glyphs,
      positions,
      3,
      context
    )
    */

    let runs = (0..<3).map { row in
      AttributesRun(
        location: CGPoint(x: 0, y: CGFloat(row) * cellSize.height),
        cells: self.ugrid.cells[row][0..<10],
        attrs: CellAttributes(
          fontTrait: [],
          foreground: 0,
          background: 0xFFFFFF,
          special: 0xFF0000,
          reverse: false
        )
      )
    }
    let defaultAttrs = CellAttributes(
      fontTrait: [],
      foreground: 0,
      background: 0xFFFFFF,
      special: 0xFF0000,
      reverse: false
    )
    runs.forEach { run in
      self.runDrawer.draw(run, with: defaultAttrs, xOffset: 0, in: context) }

    self.draw(cellGridIn: context, cellSize: cellSize)
  }

  private let ugrid = UGrid()
  private let runDrawer = AttributesRunDrawer(
    baseFont: fira, linespacing: 1, usesLigatures: true
  )

  private func draw(cellGridIn context: CGContext, cellSize: CGSize) {
    context.saveGState()
    defer { context.restoreGState() }

    let color = NSColor.magenta.cgColor
    context.setFillColor(color)

    var lines = [
      CGRect(x: 0, y: 0, width: 1, height: self.bounds.height),
      CGRect(x: self.bounds.width - 1, y: 0,
             width: 1, height: self.bounds.height),
      CGRect(x: 0, y: 0, width: self.bounds.width, height: 1),
      CGRect(x: 0, y: self.bounds.height - 1,
             width: self.bounds.width, height: 1),
    ]
    let rowCount = Int(ceil(self.bounds.height / cellSize.height))
    let columnCount = Int(ceil(self.bounds.width / cellSize.width))

    for row in 0..<rowCount {
      for col in 0..<columnCount {
        lines.append(contentsOf: [
          CGRect(x: CGFloat(col) * cellSize.width,
                 y: CGFloat(row) * cellSize.height,
                 width: 1,
                 height: self.bounds.height),
          CGRect(x: CGFloat(col) * cellSize.width,
                 y: CGFloat(row) * cellSize.height,
                 width: self.bounds.width,
                 height: 1),
        ])
      }
    }

    lines.forEach { $0.fill() }
  }

  private func setupUgrid() {
    self.ugrid.resize(Size(width: 10, height: 10))
    self.ugrid.update(
      row: 0,
      startCol: 0,
      endCol: 10,
      clearCol: 10,
      clearAttr: 0,
      chunk: [
        "하", "", "태", "", "원", "", " ", "a\u{1DC1}", "a\u{032A}", "a\u{034B}"
      ],
      attrIds: Array(repeating: 0, count: 10)
    )
    self.ugrid.update(
      row: 1,
      startCol: 0,
      endCol: 10,
      clearCol: 10,
      clearAttr: 0,
      chunk: [">", "=", " ", "-", "-", ">", " ", "<", "=", ">"],
      attrIds: Array(repeating: 0, count: 10)
    )
    self.ugrid.update(
      row: 1,
      startCol: 0,
      endCol: 10,
      clearCol: 10,
      clearAttr: 0,
      chunk: [ "ἐ", "τ" ,"έ", "ἔ", "-", ">", " ", "<", "=", ">"],
      attrIds: Array(repeating: 0, count: 10)
    )
    self.ugrid.update(
      row: 2,
      startCol: 0,
      endCol: 10,
      clearCol: 10,
      clearAttr: 0,
      chunk: (0..<10).compactMap { String($0) },
      attrIds: Array(repeating: 0, count: 10)
    )
  }
}

private let fira = NSFont(name: "FiraCode-Regular", size: 36)!