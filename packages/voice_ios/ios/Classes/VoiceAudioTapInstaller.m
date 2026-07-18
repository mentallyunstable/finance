#import "VoiceAudioTapInstaller.h"

@implementation VoiceAudioTapInstaller

+ (nullable NSString *)installTapOnNode:(AVAudioNode *)node
                                    bus:(AVAudioNodeBus)bus
                             bufferSize:(AVAudioFrameCount)bufferSize
                                 format:(AVAudioFormat *)format
                                  block:(AVAudioNodeTapBlock)tapBlock {
  @try {
    [node installTapOnBus:bus bufferSize:bufferSize format:format block:tapBlock];
    return nil;
  } @catch (NSException *exception) {
    NSString *reason = exception.reason ?: @"Unknown AVAudioEngine exception";
    return [NSString stringWithFormat:@"%@: %@", exception.name, reason];
  }
}

@end
