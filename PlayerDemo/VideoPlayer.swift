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
            .onDisappear {
                url.stopAccessingSecurityScopedResource()
            }
    }
}
