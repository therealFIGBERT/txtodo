//
//  Onboarding.swift
//  txtodo
//
//  Created by FIGBERT on 3/16/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import UserNotifications

struct Onboarding: View {
    @EnvironmentObject var globalVars: GlobalVars
    @State private var currentPage = 0
    let subviews = [
        UIHostingController(rootView: Introduction()),
        UIHostingController(rootView: AddTaskDemo()),
        UIHostingController(rootView: TaskDemo()),
        UIHostingController(rootView: TaskTypes()),
        UIHostingController(rootView: AddNoteDemo()),
        UIHostingController(rootView: NoteDemo()),
        UIHostingController(rootView: RequestNotifications()),
        UIHostingController(rootView: ThankYou())
    ]
    let titles = ["onboardingTitleOne", "onboardingTitleTwo", "onboardingTitleThree", "onboardingTitleFour", "onboardingTitleFive", "onboardingTitleSix", "onboardingTitleSeven", "onboardingTitleEight"]
    let captions = ["onboardingCaptionOne", "onboardingCaptionTwo", "onboardingCaptionThree", "onboardingCaptionFour", "onboardingCaptionFive", "onboardingCaptionSix", "onboardingCaptionSeven", "onboardingCaptionEight"]
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                PageViewController(currentPage: $currentPage, viewControllers: subviews)
                    .frame(height: 200)
                Spacer()
                Group {
                    Text(String(format: NSLocalizedString(titles[currentPage], comment: "")))
                        .underline()
                        .header()
                    Text(String(format: NSLocalizedString(captions[currentPage], comment: "")))
                        .bodyText(color: .systemGray, alignment: .leading)
                }
                HStack {
                    PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPage)
                    Spacer()
                    if currentPage != subviews.count - 1 {
                        Image(systemName: "arrow.right.circle")
                            .onTapGesture {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                if self.currentPage + 1 == self.subviews.count {
                                    self.currentPage = 0
                                } else {
                                    self.currentPage += 1
                                }
                                generator.impactOccurred()
                            }
                            .flipsForRightToLeftLayoutDirection(true)
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(Color.init(UIColor.label))
                    } else {
                        Image(systemName: "arrow.counterclockwise.circle")
                            .onTapGesture {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                if self.currentPage + 1 == self.subviews.count {
                                    self.currentPage = 0
                                } else {
                                    self.currentPage += 1
                                }
                                generator.impactOccurred()
                            }
                            .flipsForRightToLeftLayoutDirection(true)
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(Color.init(UIColor.label))
                    }
                    if currentPage == subviews.count - 1 {
                        Image(systemName: "xmark.circle")
                            .onTapGesture {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                self.globalVars.showOnboarding = false
                                generator.impactOccurred()
                            }
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(Color.init(UIColor.label))
                    }
                }
            }
                .padding()
        }
    }
}

struct PageViewController: UIViewControllerRepresentable {
    @Environment(\.layoutDirection) var direction
    @Binding var currentPage: Int
    var viewControllers: [UIViewController]
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [viewControllers[currentPage]],
            direction: direction == LayoutDirection.leftToRight ? .forward : .reverse,
            animated: true
        )
    }
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                 return nil
            }
            if index == 0 {
                return parent.viewControllers.last
            }
            return parent.viewControllers[index - 1]
            
        }
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.viewControllers.count {
                return parent.viewControllers.first
            }
            return parent.viewControllers[index + 1]
        }
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.viewControllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
    }
}

struct PageControl: UIViewRepresentable {
    let numberOfPages: Int
    @Binding var currentPageIndex: Int
    func makeUIView(context: Context) -> UIPageControl {
       let control = UIPageControl()
       control.numberOfPages = numberOfPages
       control.currentPageIndicatorTintColor = UIColor.label
       control.pageIndicatorTintColor = UIColor.systemGray
       return control
    }
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
}

struct Introduction: View {
    @Environment(\.locale) var language
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            Text("title")
                .font(.system(size: language == Locale.init(identifier: "en") ? 125 : 100, weight: .ultraLight, design: .rounded))
                .foregroundColor(Color.init(UIColor.label))
        }
    }
}

struct AddTaskDemo: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                MainImage(name: "plus.square", color: .systemGray)
                Spacer()
                Text("create a task")
                    .bodyText(color: .systemGray, alignment: .center)
                Spacer()
                MainImage(name: "plus.square", color: .systemGray)
            }
                .padding(.horizontal, 25)
        }
    }
}

struct TaskDemo: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                MainImage(name: "square", color: .label)
                Spacer()
                Text("lorem ipsum")
                    .bodyText()
                Spacer()
                Text("! ! !")
                    .font(.system(size: 10, weight: .light))
            }
                .padding(.horizontal, 25)
        }
    }
}

struct TaskTypes: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                VStack {
                    Image(systemName: "clock")
                        .font(.system(size: 25, weight: .light, design: .rounded))
                        .foregroundColor(Color.init(UIColor.label))
                    Text("daily")
                        .bodyText()
                }
                    .padding(.horizontal, 50)
                VStack {
                    Image(systemName: "cloud")
                        .font(.system(size: 25, weight: .light, design: .rounded))
                        .foregroundColor(Color.init(UIColor.label))
                    Text("floating")
                        .bodyText()
                }
                    .padding(.horizontal, 50)
            }
        }
    }
}

struct AddNoteDemo: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                MainImage(name: "plus.square", color: .systemGray)
                Spacer()
                Text("create a note")
                    .bodyText(color: .systemGray, alignment: .center)
                Spacer()
                MainImage(name: "plus.square", color: .systemGray)
            }
                .padding(.horizontal, 25)
        }
    }
}

struct NoteDemo: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                MainImage(name: "minus", color: .label)
                    .padding(.trailing, 20)
                Text("lorem ipsum dolor sit amet")
                    .bodyText(color: .label, alignment: .leading)
                Spacer()
            }
                .padding(.horizontal, 25)
        }
    }
}

struct RequestNotifications: View {
    @EnvironmentObject var globalVars: GlobalVars
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack {
                    if globalVars.notifications {
                        Text(String(format: NSLocalizedString("notifications set for %@", comment: ""), "\("0\(self.globalVars.notificationHour):\(self.globalVars.notificationMinute != 0 ? "\(self.globalVars.notificationMinute)" : "00")")"))
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .foregroundColor(self.globalVars.notifications ? Color.green : Color.blue)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(self.globalVars.notifications ? Color.green : Color.blue, lineWidth: 1)
                            )
                    } else {
                        Text("set notifications to 08:30")
                            .onTapGesture {
                                self.globalVars.notificationHour = 8
                                self.globalVars.notificationMinute = 30
                                self.globalVars.notifications = true
                            }
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .foregroundColor(self.globalVars.notifications ? Color.green : Color.blue)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(self.globalVars.notifications ? Color.green : Color.blue, lineWidth: 1)
                            )
                    }
            }
        }
    }
}

struct ThankYou: View {
    @Environment(\.locale) var language
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("title")
                    .font(.system(size: language == Locale.init(identifier: "en") ? 125 : 100, weight: .ultraLight, design: .rounded))
                    .foregroundColor(Color.init(UIColor.label))
                Text("app pitch")
                    .font(.system(size: language == Locale.init(identifier: "en") ? 20 : 17, weight: .light, design: .rounded))
                    .foregroundColor(Color.init(.label))
                    .multilineTextAlignment(.center)
                Text("made by FIGBERT")
                    .font(.system(size: language == Locale.init(identifier: "en") ? 20 : 17, weight: .light, design: .rounded))
                    .foregroundColor(Color.init(.systemGray))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
