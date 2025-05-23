//
//  ToastMessage.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

extension View {
    
    ///  Add this modifier to the top most  views in hierarchy.
    ///  Parameters:
    ///   - isPresented: binding to determine if the message view should be seen on-screen or hidden
    ///   - type: set type of view alert, toast and float.
    ///   - position: top or bottom (for default case it just determines animation direction).
    ///   - animation: custom animation for message view sliding onto screen.
    ///   - duration: time after which message view should disappear.
    ///   - closeOnTap: on message view tap it should disappear.
    ///   - onTap: on message view tap perform any action or navigation.
    ///   - onToastDismiss: on toast dismiss perform any action.
    ///   - closeOnTapOutside: on outside tap message view should disappear.
    ///   - view: view you want to display on your message view
    /// - Returns: void
    public func present<MessageContent: View>(
        isPresented: Binding<Bool>,
        type: MessageView<MessageContent>.MessageType = .alert,
        position: MessageView<MessageContent>.Position = .bottom,
        animation: Animation = Animation.easeOut(duration: 0.3),
        horizontalPadding: CGFloat? = 0,
        duration: Double? = 3.0,
        closeOnTap: Bool = true,
        closeOnTapOutside: Bool = false,
        onTap: (() -> Void)? = nil,
        onToastDismiss: (() -> Void)? = nil,
        view: @escaping () -> MessageContent) -> some View {
        self.modifier(
            MessageView(
                isPresented: isPresented,
                type: type,
                position: position,
                animation: animation,
                duration: duration,
                horizontalPadding: horizontalPadding,
                closeOnTap: closeOnTap,
                onTap: onTap ?? {},
                onToastDismiss: onToastDismiss ?? {},
                closeOnTapOutside: closeOnTapOutside,
                view: view)
        )
    }
}


class DispatchWorkHolder {
    var work: DispatchWorkItem?
}


public struct MessageView<MessageContent>: ViewModifier where MessageContent: View {
    
    @ObservedObject var viewModel = ViewModel()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    public enum MessageType: Equatable {
        
        case alert
        case toast
        case floater(verticalPadding: CGFloat = 50)
        case leftToastView
        case rightToastView
        
        func shouldBeCentered() -> Bool {
            switch self {
                case .alert:
                    return true
                default:
                    return false
            }
        }
    }
    
    public enum Position {
        
        case top
        case bottom
    }
    
    // MARK: - Public Properties
    
    /// Tells if the sheet should be presented or not
    @Binding var isPresented: Bool
    
    var type: MessageType
    var position: Position
    
    var animation: Animation
    
    /// If nil - don't dismiss automatically
    var duration: Double?
    
    /// Should Add horizontal padding - default - 0
    var horizontalPadding: CGFloat?
    
    /// Should close on tap - default is `true`
    var closeOnTap: Bool
    
    /// Allow to perform action on tap default is
    var onTap: () -> Void
    
    /// Allow to perform any action when toast dismiss
    var onToastDismiss: () -> Void
    
    /// Should close on tap outside - default is `false`
    var closeOnTapOutside: Bool
    
    /// Use to show Left toast view
    @State var leftToastMessage: Bool = false
    
    /// Use to show Right toast view
    @State var rightToastMessage: Bool = false
    
    var view: () -> MessageContent
        
    @State private var viewHeight: CGFloat = .zero
    @State private var viewWidth: CGFloat = .zero

    /// holder for autohiding dispatch work (to be able to cancel it when needed)
    var dispatchWorkHolder = DispatchWorkHolder()
    
    // MARK: - Private Properties
    
    /// The rect of the hosting controller
    @State private var presenterContentRect: CGRect = .zero
    
    /// The rect of popup content
    @State private var sheetContentRect: CGRect = .zero
    
    /// offset for setting up left & right toast
    @State private var offset: CGFloat = 0
    
    /// Toast message width
    @State var toastViewWidth: CGFloat = 0
    
    /// Toast message height
    @State var toastViewHeight: CGFloat = 0
    
    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        switch type {
        case .alert:
            return  -presenterContentRect.midY + viewHeight/2
        case .toast:
            if position == .bottom {
                return viewHeight - presenterContentRect.midY - sheetContentRect.height/2
            } else {
                let topSafeArea = safeAreaInsets?.top ?? getSafeAreaTopInset()
                return -presenterContentRect.midY + sheetContentRect.height/2 + topSafeArea
            }
        case .floater(let verticalPadding):
            if position == .bottom {
                return viewHeight - presenterContentRect.midY - sheetContentRect.height/2 - verticalPadding
            } else {
                let topSafeArea = safeAreaInsets?.top ?? getSafeAreaTopInset()
                return -presenterContentRect.midY + sheetContentRect.height/2 + verticalPadding + topSafeArea
            }
        case .leftToastView, .rightToastView:
            if position == .bottom {
                return leftRightToastViewPosition - 30
            } else {
                let topSafeArea = safeAreaInsets?.top ?? getSafeAreaTopInset()
                return -(leftRightToastViewPosition - 60) + topSafeArea
            }
        }
    }

    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if position == .top {
            if presenterContentRect.isEmpty {
                return -1000
            }
            #if targetEnvironment(macCatalyst)
            return -presenterContentRect.midY - sheetContentRect.height/2 - 300
            #else
            return -presenterContentRect.midY - sheetContentRect.height/2 - 5
            #endif
        } else {
            if presenterContentRect.isEmpty {
                return 1000
            }
            #if targetEnvironment(macCatalyst)
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 300
            #else
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
            #endif
        }
    }
    
    /// Set left and and right view toast view position
    private var leftRightToastViewPosition: CGFloat {
        viewHeight/2 - toastViewHeight/2
    }
    
    /// The current offset, based on the **presented** property
    private var currentOffset: CGFloat {
        return isPresented ? displayedOffset : hiddenOffset
    }
    
    private var screenHeight: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size.height
        #elseif os(macOS)
        return NSScreen.main?.frame.height ?? 0
        #elseif os(iOS)
        return UIScreen.main.bounds.size.height
        #endif
    }
    
    private var screenWidth: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size.width
        #elseif os(macOS)
        return  NSScreen.main?.frame.width ?? 0
        #elseif os(iOS)
        return UIScreen.main.bounds.size.width
        #endif
    }
    
    // Helper method to get safe area insets
    private func getSafeAreaTopInset() -> CGFloat {
        #if os(iOS)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.top
        #else
        return 0
        #endif
    }
    
    // MARK: - Content Builders
    
    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                content
                    .background(
                        GeometryReader { proxy -> AnyView in
                            let rect = proxy.frame(in: .global)
                            // This avoids an infinite layout loop
                            if rect.integral != self.presenterContentRect.integral {
                                DispatchQueue.main.async {
                                    viewModel.updateView = true
                                    self.presenterContentRect = rect
                                }
                            }
                            return AnyView(EmptyView())
                        }
                    )
                    .overlay(presentSheet())
                #if !(os(macOS))
                    .navigationBarHidden(true)
                #endif
                if closeOnTapOutside {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.isPresented = false
                        }
                        .opacity(isPresented ? 0.5 : 0)
                }
            }.onReceive(viewModel.$updateView, perform: { _ in
                viewHeight = proxy.size.height
                #if os(macOS) || targetEnvironment(macCatalyst)
                viewWidth = proxy.size.width - (horizontalPadding ?? 0)
                #elseif os(iOS)
                viewWidth = screenWidth - (horizontalPadding ?? 0)
                #endif
            })
            .onAppear {
                if type == .leftToastView {
                    setLeftToastOffset()
                } else if type == .rightToastView  {
                    setRightToastOffset()
                }
            }
            .onChange(of: isPresented) { updatedValue in
                if !updatedValue {
                    leftToastMessage = false
                    rightToastMessage = false
                } else {
                    leftToastMessage = type == .leftToastView
                    rightToastMessage = type == .rightToastView
                }
                setLeftRightToastOffset()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    /// This is the builder for the sheet content
    func presentSheet() -> some View {
        
        // if needed, dispatch autoDismiss and cancel previous one
        if let duration = duration, !(type == .leftToastView || type == .rightToastView) {
            dispatchWorkHolder.work?.cancel()
            dispatchWorkHolder.work = DispatchWorkItem(block: {
                self.isPresented = false
                self.onToastDismiss()
            })
            if isPresented, let work = dispatchWorkHolder.work {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
            }
        }
        
        let commonVStack = VStack {
            self.view()
                .simultaneousGesture(TapGesture().onEnded {
                    if self.closeOnTap {
                        DispatchQueue.main.async {
                            self.isPresented = false
                            self.onTap()
                        }
                    }
                })
                .background(
                    GeometryReader { proxy -> AnyView in
                        let rect = proxy.frame(in: .global)
                        // This avoids an infinite layout loop
                        if rect.integral != self.sheetContentRect.integral {
                            DispatchQueue.main.async {
                                self.sheetContentRect = rect
                                toastViewWidth = proxy.size.width
                                toastViewHeight = proxy.size.height
                            }
                        }
                        return AnyView(EmptyView())
                    }
                )
                .offset(x: (leftToastMessage || rightToastMessage) ? offset : 0, y: (leftToastMessage || rightToastMessage) ? displayedOffset : currentOffset)
                .onReceive(viewModel.$isLeftRightToastView, perform: { _ in

                    if leftToastMessage || rightToastMessage {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if rightToastMessage {
                                #if os(macOS) || targetEnvironment(macCatalyst)
                                offset = (viewWidth / 2) - toastViewWidth / 2 - 10
                                #elseif os(iOS)
                                offset = (screenWidth / 2) - toastViewWidth / 2 - 10
                                #endif
                            } else if leftToastMessage {
                                #if os(macOS) || targetEnvironment(macCatalyst)
                                offset = -((viewWidth / 2) - toastViewWidth / 2 - 10)
                                #elseif os(iOS)
                                offset = -((screenWidth / 2) - toastViewWidth / 2) + 10
                                #endif
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + (duration ?? 0)) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                setLeftRightToastOffset()
                            }
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: ((duration ?? 0) + 0.5), repeats: false) { _ in
                            onToastDismiss()
                            isPresented = false
                        }
                    }
                })
        }
        
        return ZStack() {
            Group {
                if !(leftToastMessage || rightToastMessage) {
                    commonVStack
                        .frame(width: viewWidth)
                        .animation(animation, value: isPresented)
                } else {
                    commonVStack
                }
            }
        }
    }
    
    /// offset is used for showing left and right toast view
    func setLeftRightToastOffset() {
        if leftToastMessage {
            setLeftToastOffset()
        } else if rightToastMessage {
            setRightToastOffset()
        }
    }
    
    /// offset is used for showing left view
    func setLeftToastOffset() {
        #if os(macOS)
        offset = -(NSScreen.main?.frame.size.width ?? 0)
        #elseif os(iOS)
        offset = -UIScreen.main.bounds.width
        #endif
    }
    
    /// offset is used for showing right toast view
    func setRightToastOffset() {
        #if os(macOS)
        offset = NSScreen.main?.frame.size.width ?? 0
        #elseif os(iOS)
        offset = UIScreen.main.bounds.width
        #endif
    }
}

class ViewModel: ObservableObject {
   
    @Published var updateView: Bool = false
    @Published var isLeftRightToastView: Bool = false
    
}

// Add a private extension to access safe area insets in ViewModifier
private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets? = nil
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets? {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

// Extension to pass safe area insets to views
extension View {
    func safeAreaInsets(_ insets: EdgeInsets) -> some View {
        environment(\.safeAreaInsets, insets)
    }
}

