//
//  VideoPlayer.swift
//  PlayerDemo
//
//  Created by 周辉 on 2024/10/26.
//

import SwiftUI
import AVKit

struct Player: View {
    let url: URL
    @State var isPlaying: Bool = false
    @State var player: AVPlayer? = nil
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player = AVPlayer(url: url)
                // 不设置这个的话，如果在静音模式，视频没有声音
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(.playback, mode: .default)
                    try audioSession.setActive(true)
                } catch {
                    print("设置音频会话失败: \(error)")
                }
                
                if !audioSession.outputVolume.isZero {
                    player?.volume = 1.0
                } else {
                    player?.volume = 0.0
                }
                
                player?.play()
            }
            .onLongPressGesture(minimumDuration: 1, perform: {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                player?.rate = 2.0
            }, onPressingChanged: { _ in
                player?.rate = 1.0
            })
            .onDisappear {
                url.stopAccessingSecurityScopedResource()
            }
            .navigationBarTitle("")
    }
}
