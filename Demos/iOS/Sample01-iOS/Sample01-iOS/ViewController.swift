//
//  ViewController.swift
//  Sample01-iOS
//
//  Created by Erick Jung on 01/11/2019.
//  Copyright © 2019 Erick Jung. All rights reserved.
//

import UIKit
import SwiftGui
import SwiftGui_PlatformiOS


class ViewController: UIViewController {
    
    var renderer: SGRenderer?
    let mtkView = MTKView()
    var counterState = 0
    var radioState = 0
    var logo: SGImage?

    override func loadView() {
        self.view = mtkView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let mtkView = self.view as? MTKView {
            
            mtkView.device = MTLCreateSystemDefaultDevice()
            
            self.renderer = SGRenderer(view: mtkView)
            self.renderer?.delegate = self
            mtkView.delegate = self.renderer
        }
        
        self.renderer?.initializePlatform()
        
        self.loadResources()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.renderer?.handle(event, view: self.view)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.renderer?.handle(event, view: self.view)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.renderer?.handle(event, view: self.view)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.renderer?.handle(event, view: self.view)
    }
    
    private func loadResources() {
        
        logo = self.renderer?.loadTexture(withName: "swiftgui")
    }
}

extension ViewController: SGRendererDelegate {
    
    func setup() {
        DefaultFontGroup().load()
        DarculaTheme().apply()
    }

    func showProgrammerGuide() -> GuiNode {
        Group {
            Text("PROGRAMMER GUIDE:")
            BulletText("Please see the ShowDemoWindow() code in imgui_demo.cpp. <- you are here!")
            BulletText("Please see the comments in imgui.cpp.")
            BulletText("Please see the examples/ application.")
            BulletText("Enable 'io.ConfigFlags |= NavEnableKeyboard' for keyboard controls.")
            BulletText("Enable 'io.ConfigFlags |= NavEnableGamepad' for gamepad controls.")
        }
    }
    func showUserGuide() -> GuiNode {
        Group {
            Text("USER GUIDE:")
            BulletText("Double-click on title bar to collapse window.")
            BulletText("Click and drag on lower corner to resize window\n(double-click to auto fit window to its contents).")
            BulletText("Click and drag on any empty space to move window.")
            BulletText("TAB/SHIFT+TAB to cycle through keyboard editable fields.")
            BulletText("CTRL+Click on a slider or drag box to input value as text.")
            BulletText("Mouse Wheel to scroll.")
            BulletText("While editing text:\n")

            Indent() {
                BulletText("Hold SHIFT or use mouse to select text.")
                BulletText("CTRL+Left/Right to word jump.")
                BulletText("CTRL+A or double-click to select all.")
                BulletText("CTRL+X,CTRL+C,CTRL+V to use clipboard.")
                BulletText("CTRL+Z,CTRL+Y to undo/redo.")
                BulletText("ESCAPE to revert.")
                BulletText("You can apply arithmetic operators +,*,/ on numerical values.\nUse +- to subtract.")
            }
        }
    }
    
    func helpMarker(_ text: String, atSameLine: Bool = true) -> GuiNode {
        Group {
            atSameLine ? SameLine() : Empty()
            TextDisabled("(?)").onHover {
                
                Tooltip {
                    Text(text)
                }
            }
        }
    }
    
    func showDemoWindowWidgets_Basic() -> GuiNode {
        Tree("Basic") {
            
            Button("Button")
            CheckBox("checkbox", selectedState: false)

            HStack {
                RadioButtonGroup(["radio a", "radio b", "radio c"],
                                 selectedState: radioState) {
                    self.radioState = $0
                }
            }

            HStack {
                ForEach((1...7)) { val in
                    Button("Click \(val)")
                        .color(.buttonHovered, color: .brown)
                        .color(.buttonActive, color: .orange)
                }
            }
            NewLine()

            HStack {
                Text("Hold to repeat:")

                PushButtonGroup {
                    HStack {
                        ArrowButton("##left", direction: .left) {
                            self.counterState -= 1
                        }

                        ArrowButton("##right", direction: .right) {
                            self.counterState += 1
                        }
                    }
                }

                Text("\(self.counterState)")
            }

            Text("Hover over me").onHover {

                Tooltip {
                    Text("I am a tooltip")
                }
            }

            SameLine()
            Text("- or me").onHover {

                Tooltip {
                    Text("I am a fancy tooltip")
                    Plot("Curve", type: .line, values: [0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2])
                }
            }

            Separator()

            LabelText("label", format: "Value")
            ComboBox("combo", currentItemState: 0, items: ["AAAA", "BBBB", "CCCC", "DDDD", "EEEE", "FFFF", "GGGG", "HHHH", "IIII", "JJJJ", "KKKK", "LLLLLLL", "MMMM", "OOOOOOO"])
            helpMarker("Refer to the \"Combo\" section below for an explanation of the full BeginCombo/EndCombo API, and demonstration of various flags.\n")

            InputText("input text", textState: "Hello, world!")
            helpMarker("USER:\nHold SHIFT or use mouse to select text.\nCTRL+Left/Right to word jump.\nCTRL+A or double-click to select all.\nCTRL+X,CTRL+C,CTRL+V clipboard.\nCTRL+Z,CTRL+Y undo/redo.\nESCAPE to revert.\n\nPROGRAMMER:\nYou can use the ImGuiInputTextFlags_CallbackResize facility if you need to wire InputText() to a dynamic string type. See misc/cpp/imgui_stdlib.h for an example (this is not demonstrated in imgui_demo.cpp).")

            InputText("input text (w/ hint)", textState: "", placeHolder: "enter text here")

            InputInt("input int", valueState: 0)
            helpMarker("You can apply arithmetic operators +,*,/ on numerical values.\n  e.g. [ 100 ], input \'*2\', result becomes [ 200 ]\nUse +- to subtract.\n")

            InputFloat("input float", valueState: 0, step: 0.01, stepFast: 1.0, format: "%.3f")

            DragInt("drag int", valueState: 0)
            helpMarker("Click and drag to edit value.\nHold SHIFT/ALT for faster/slower edit.\nDouble-click or CTRL+click to input value.")

            DragInt("drag int", valueState: 0, valueSpeed: 1.0, min: 0, max: 100, format: "%d%%")

            ListBox("listbox\n(single select)", currentItemState: 0, items: ["Apple", "Banana", "Cherry", "Kiwi", "Mango", "Orange", "Pineapple", "Strawberry", "Watermelon"])
        }
    }

    func showDemoWindowWidgets_Tree() -> GuiNode {
        Tree("Trees") {
            
            Tree("Basic trees") {
                ForEach((1...5)) { value in
                    Tree("Child \(value)") {
                        Text("blah blah")
                        SameLine()
                        SmallButton("button")
                    }
                }
            }

            Tree("Advanced, with Selectable nodes") {
                helpMarker("This is a more typical looking tree with selectable nodes.\nClick to select, CTRL+Click to toggle, click on arrows or double-click to open.", atSameLine: false)
                CheckBox("ImGuiTreeNodeFlags_OpenOnArrow", selectedState: false)
                Text("Hello!")
                
                ForEach((1...3)) { value in
                    Tree("Selectable Node  \(value)", options: .selected) {
                        BulletText("Blah blah\nBlah Blah")
                    }
                }
                ForEach((1...2)) { value in
                    Tree("Selectable Leaf \(value)", options: [.leaf, .bullet]) {
                        BulletText("Blah blah\nBlah Blah")
                    }
                }
            }

        }
    }
    
    func showDemoWindowWidgets_Collapsing() -> GuiNode {
        Tree("Collapsing Headers") {
            CollapsingHeader("Header") {
                ForEach((1...5)) { value in
                    Text("Some content \(value)")
                }
            }
            CollapsingHeaderClosable("Header with a close button", closeState: true) {
                ForEach((1...5)) { value in
                    Text("Some content \(value)")
                }
            }
        }
    }
    
    func showDemoWindowWidgets_Bullets() -> GuiNode {
        Tree("Bullets") {
            BulletText("Bullet point 1")
            BulletText("Bullet point 2\nOn multiple lines")
            
            Tree("Tree node") {
                BulletText("Another bullet point")
            }
            
            Bullet()
            Text("Bullet point 3 (two calls)")

            Bullet()
            SmallButton("Button")
        }
    }
    
    func showDemoWindowWidgets_Text() -> GuiNode {
        Tree("Text") {
            
            Tree("Colored Text") {
                Text("Pink")
                    .color(.text, color: .systemPink)
                Text("Yellow")
                    .color(.text, color: .yellow)
                TextDisabled("Disabled")
                helpMarker("The TextDisabled color is stored in ImGuiStyle.")
            }

            Tree("Word Wrapping") {
                TextWrapped("This text should automatically wrap on the edge of the window. The current implementation for text wrapping follows simple rules suitable for English and possibly other languages.")
                Spacing()
                
                SliderFloat("Wrap width", valueState: 200, min: -20, max: 600, format: "%.0f")
                Text("Test paragraph 1:")
                TextWrapped("The lazy dog is a good dog. This paragraph is made to fit within %.0f pixels. Testing a 1 character word. The quick brown fox jumps over the lazy dog.")
            }
            
            Tree("UTF-8 Text") {
                TextWrapped("CJK text will only appears if the font was loaded with the appropriate CJK character ranges. Call io.Font->AddFontFromFileTTF() manually to load extra character ranges. Read misc/fonts/README.txt for details.")
                Text("Hiragana: \u{e3}\u{81} (kakikukeko)")
            }
        }
    }

    func showDemoWindowWidgets_Plots() -> GuiNode {
        Tree("Plots Widgets") {
            CheckBox("Animate", selectedState: false)
            
            Plot("Frame Times", type: .line, values: [0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2], size: CGSize(width: 0, height: 80))
            Plot("Histogram", type: .histogram, values: [0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2], size: CGSize(width: 0, height: 80))
            
            ProgressBar(0.5, size: .zero)
            SameLine()
            Text("Progress Bar")
        }
    }

    func showDemoWindowWidgets_Color() -> GuiNode {
        Tree("Color/Picker Widgets") {
            Text("Color widget:")
            ColorEdit3("MyColor##1", color: .red)
        }
    }

    func showDemoWindowWidgets() -> GuiNode {
        
        CollapsingHeader("Widgets") {
            showDemoWindowWidgets_Basic()
            showDemoWindowWidgets_Tree()
            showDemoWindowWidgets_Collapsing()
            showDemoWindowWidgets_Bullets()
            showDemoWindowWidgets_Text()
            showDemoWindowWidgets_Plots()
            showDemoWindowWidgets_Color()
        }
    }
      
    func mainView() -> GuiNode {
        
        Window("SwiftGUI Demo", flags: .noTitleBar) {
            
            Image(imageId: logo, size: SGSize(width: 250, height: 65))
            
            CollapsingHeader("Help") {
                showProgrammerGuide()
                Separator()
                showUserGuide()
            }
            
            CollapsingHeader("Configuration") {
                Tree("Configuration##2") {
                    CheckBox("io.ConfigFlags: NavEnableKeyboard", selectedState: false)

                    CheckBox("io.ConfigFlags: NavEnableGamepad", selectedState: false)
                    helpMarker("Required back-end to feed in gamepad inputs in io.NavInputs[] and set io.BackendFlags |= ImGuiBackendFlags_HasGamepad.\n\nRead instructions in imgui.cpp for details.")

                    CheckBox("io.ConfigFlags: NavEnableSetMousePos", selectedState: false)
                    helpMarker("Instruct navigation to move the mouse cursor. See comment for ImGuiConfigFlags_NavEnableSetMousePos.")
                    
                    CheckBox("io.ConfigFlags: NoMouse", selectedState: false)
                    CheckBox("io.ConfigFlags: NoMouseCursorChange", selectedState: false)
                    helpMarker("Instruct back-end to not alter mouse cursor shape and visibility.")
                }

                Tree("Style") {
                    ShowStyleEditorDebug()
                }

                Tree("Capture/Logging") {
                    TextWrapped("The logging API redirects all text output so you can easily capture the content of a window or a block. Tree nodes can be automatically expanded.")
                    helpMarker("Try opening any of the contents below in this window and then click one of the \"Log To\" button.", atSameLine: false)
                    
                    LogButtons()
                    
                    TextWrapped("You can also call ImGui::LogText() to output directly to the log without a visual output.")
                    Button("Copy \"Hello, world!\" to clipboard")
                }

                Tree("Window options") {
                    
                    HStack {
                        CheckBox("No titlebar", selectedState: false)
                        CheckBox("No scrollbar", selectedState: false)
                        CheckBox("No menu", selectedState: false)
                        CheckBox("No move", selectedState: false)
                        CheckBox("No resize", selectedState: false)
                    }
                }
            }
            
            CollapsingHeader("Font") {
                
                Text("FiraCode font 14").font(DefaultFontGroup.Types.FiraCode_14)
                Text("FiraCode font 18").font(DefaultFontGroup.Types.FiraCode_18)
                Text("FiraCode font 22").font(DefaultFontGroup.Types.FiraCode_22)
            }

            showDemoWindowWidgets()
        }
        .position(CGPoint(x: 0, y: (0 + 20)), condition: .always)
        .size(CGSize(width: self.view.frame.width,
                     height: self.view.frame.height - 20), condition: .always)
        .property(.windowRounding, set: 0)
        .font(DefaultFontGroup.Types.FiraCode_18)
    }
    
    func draw() {
        mainView().render()
    }
}
