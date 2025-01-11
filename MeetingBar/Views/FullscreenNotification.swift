//
//  FullscreenNotification.swift
//  MeetingBar
//
//  Created by Andrii Leitsius on 31.07.2023.
//  Copyright © 2023 Andrii Leitsius. All rights reserved.
//

import Defaults
import SwiftUI

struct FullscreenNotification: View {
    var event: MBEvent
    var window: NSWindow?
    
    private var displayTitle: String {
        ScreenSharing.isActive ? "Upcoming Meeting" : event.title
    }

    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow()
            VStack {
                HStack {
                    if let meetingLink = event.meetingLink {
                        Image(nsImage: getIconForMeetingService(meetingLink.service))
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    Text(displayTitle).font(.title)
                }
                VStack(spacing: 10) {
                    Text(getEventDateString(event))
                }.padding(15)
                
                // Hide location during screen sharing as it might contain sensitive info
                if let location = event.location, !ScreenSharing.isActive {
                    VStack(spacing: 10) {
                        Text(location)
                    }.padding(15)
                }
             
                HStack(spacing: 30) {
                    Button(action: dismiss) {
                        Text("general_close".loco()).padding(.vertical, 5).padding(.horizontal, 20)
                    }
                    if event.meetingLink != nil {
                        Button(action: joinEvent) {
                            Text("notifications_meetingbar_join_event_action".loco())
                                .padding(.vertical, 5)
                                .padding(.horizontal, 25)
                        }
                        .background(Color.accentColor)
                        .cornerRadius(5)
                    }
                }
            }
        }
        .colorScheme(.dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func dismiss() {
        window?.close()
    }

    func joinEvent() {
        event.openMeeting()
        window?.close()
    }
}

public extension View {
    static func semiOpaqueWindow() -> some View {
        if #available(macOS 11.0, *) {
            return VisualEffect().ignoresSafeArea()
        } else {
            return VisualEffect()
        }
    }
}

struct VisualEffect: NSViewRepresentable {
    func makeNSView(context _: Context) -> NSView {
        let view = NSVisualEffectView()
        view.material = .underWindowBackground
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_: NSView, context _: Context) {}
}

#Preview {
    FullscreenNotification(event: generateFakeEvent(), window: nil)
}
