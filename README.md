# Streaming

func createAudioSampleBuffer(pcmBuffer: AVAudioPCMBuffer, ats: AVAudioTime) -> CMSampleBuffer? {
        var asbd = pcmBuffer.format.streamDescription.pointee
        var sampleBuffer: CMSampleBuffer?
        var format: CMAudioFormatDescription?
        var error: OSStatus = noErr
}
