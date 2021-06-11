# Streaming

func createAudioSampleBuffer(pcmBuffer: AVAudioPCMBuffer, ats: AVAudioTime) -> CMSampleBuffer? {
        var asbd = pcmBuffer.format.streamDescription.pointee
        var sampleBuffer: CMSampleBuffer?
        var format: CMAudioFormatDescription?
        var error: OSStatus = noErr

        error = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &asbd, 0, nil, 0, nil, nil, &format)
        guard error == noErr else {
            return nil
        }

        let pts = CMTimeMake(Int64(AVAudioTime.seconds(forHostTime: ats.hostTime) * ats.sampleRate), Int32(ats.sampleRate))
        let count = CMItemCount(pcmBuffer.audioBufferList[0].mBuffers.mDataByteSize / asbd.mBytesPerFrame)
        error = CMAudioSampleBufferCreateReadyWithPacketDescriptions(kCFAllocatorDefault, nil, format!, count, pts, nil, &sampleBuffer)
        guard error == noErr else {
            return nil
        }

        error = CMSampleBufferSetDataBufferFromAudioBufferList(sampleBuffer!, kCFAllocatorDefault, kCFAllocatorDefault, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, pcmBuffer.audioBufferList)
        guard error == noErr else {
            return nil
        }

        return sampleBuffer
    }
