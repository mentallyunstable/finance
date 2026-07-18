#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceAudioTapInstaller : NSObject

+ (nullable NSString *)installTapOnNode:(AVAudioNode *)node
                                    bus:(AVAudioNodeBus)bus
                             bufferSize:(AVAudioFrameCount)bufferSize
                                 format:(AVAudioFormat *)format
                                  block:(AVAudioNodeTapBlock)tapBlock;

@end

NS_ASSUME_NONNULL_END
