//
//  TTS.h
//  IADE_bot
//
//  Created by Ezequiel dos Santos on 11/03/2024.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TTS_IOS : NSObject <AVSpeechSynthesizerDelegate>

@property (nonatomic, assign) BOOL speaking;
@property (nonatomic, strong) AVSpeechSynthesizer *av_synth;
@property (nonatomic, strong) NSMutableDictionary *ids;
@property (nonatomic, strong) NSMutableArray *queue;

- (instancetype)init;
- (void)speak:(NSString *)text voice:(NSString *)voice volume:(float)volume pitch:(float)pitch rate:(float)rate utterance_id:(int)utterance_id interrupt:(BOOL)interrupt;
- (void)stopSpeaking;
- (BOOL)isSpeaking;
- (NSArray *)getVoices;

@end

