//
//  PageDua.swift
//  CloseModal
//
//  Created by Franciscus Valentinus Ongkosianbhadra on 30/10/22.
//

import SwiftUI

struct PageDua: View {
    @Binding var tempatNerimaDariPageLain: Bool
    @State var showSheet = false
    var body: some View {
        VStack{
            Text("Page Dua")
                
            Button{
                showSheet = true
            }label: {
                Text("Buka Modal")
            }
        }
        .halfSheet(showSheet: $showSheet) {
            
            VStack{
                Text("Ini Modal")
                Button{
                    tempatNerimaDariPageLain = false
                    showSheet = false
                }label: {
                    Text("Tutup Modal dan ke Page satu")
                }
            }
        }onEnd: {
            print("Dismissed")
        }
    }
}

struct PageDua_Previews: PreviewProvider {
    static var previews: some View {
        PageDua(tempatNerimaDariPageLain: .constant(false))
    }
}

// Custom Half Sheet Modifier...
extension View {
    
    //Binding Show Variable...
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView, onEnd: @escaping()->())->some View {
        
        // why we using overlay or background...
        // because it will automatically use the swift ui frame Size only...
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
            )
    }
}

// UIKit Integration...
struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showSheet {
            // presenting Modal View...
            
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetController, animated: true)
        }
        else {
            // closing view when showSheet toggled again...
            uiViewController.dismiss(animated: true)
        }
    }
    
    /// On Dismiss...
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}

// Custom UIHostingController for halfSheet...
class CustomHostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        //setting presentation controller properties...
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            
            // to show grab protion...
            presentationController.prefersGrabberVisible = true
        }
    }
}


struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color("variableColor")))
            .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
    }
}


struct DarkBrownGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .background(RoundedRectangle(cornerRadius: 8).fill(Color("buttonBGColor")))
            .foregroundColor(Color("variableColor"))
            .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
    }
}
