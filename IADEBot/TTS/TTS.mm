//
//  TTS.m
//  IADE_bot
//
//  Created by Ezequiel dos Santos on 11/03/2024.
//

#import "TTS.h"
#import <AVFoundation/AVFoundation.h>

@implementation TTS_IOS

- (instancetype)init {
    self = [super init];
    if (self) {
        _speaking = NO;
        _av_synth = [[AVSpeechSynthesizer alloc] init];
        _av_synth.delegate = self;
        _ids = [NSMutableDictionary dictionary];
        _queue = [NSMutableArray array];
        NSLog(@"Text-to-Speech: AVSpeechSynthesizer initialized.");
    }
    return self;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSNumber *utteranceID = [self.ids objectForKey:utterance];
    if (utteranceID) {
        [self.ids removeObjectForKey:utterance];
        self.speaking = NO;
        [self update];
    }
}

- (void)update {
    if (!self.speaking && self.queue.count > 0) {
        NSDictionary *message = [self.queue firstObject];
        NSString *text = message[@"text"];
        NSString *voice = message[@"voice"];
        float volume = [message[@"volume"] floatValue];
        float pitch = [message[@"pitch"] floatValue];
        float rate = [message[@"rate"] floatValue];
        int utteranceID = [message[@"id"] intValue];
        
        AVSpeechUtterance *newUtterance = [[AVSpeechUtterance alloc] initWithString:text];
        newUtterance.voice = [AVSpeechSynthesisVoice voiceWithIdentifier:voice];
        newUtterance.rate = rate;
        newUtterance.pitchMultiplier = pitch;
        newUtterance.volume = volume;
        
        [self.av_synth speakUtterance:newUtterance];
        
        [self.ids setObject:@(utteranceID) forKey:newUtterance];
        
        [self.queue removeObjectAtIndex:0];
        
        self.speaking = YES;
    }
}

- (void)stopSpeaking {
    [self.av_synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self.ids removeAllObjects];
    [self.queue removeAllObjects];
    self.speaking = NO;
}

- (BOOL)isSpeaking {
    return self.speaking || self.queue.count > 0;
}

- (void)speak:(NSString *)text voice:(NSString *)voice volume:(float)volume pitch:(float)pitch rate:(float)rate utterance_id:(int)utterance_id interrupt:(BOOL)interrupt {
    if (interrupt) {
        [self stopSpeaking];
    }
    
    if ([text isEqualToString:@""]) {
        // handle empty text
        NSLog(@"Empty text provided.");
        return;
    }
    
    NSDictionary *message = @{@"text": text,
                              @"voice": voice,
                              @"volume": @(volume),
                              @"pitch": @(pitch),
                              @"rate": @(rate),
                              @"id": @(utterance_id)};
    
    [self.queue addObject:message];
    
    if (!self.speaking) {
        [self update];
    }
}

- (NSArray<AVSpeechSynthesisVoice *> *)getVoices {
    NSMutableArray *list = [NSMutableArray array];
    for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
        NSString *voiceIdentifierString = voice.identifier;
        NSString *voiceLocaleIdentifier = voice.language;
        NSString *voiceName = voice.name;
        NSDictionary *voiceDict = @{@"name": voiceName,
                                    @"id": voiceIdentifierString,
                                    @"language": voiceLocaleIdentifier};
        [list addObject:voiceDict];
    }
    return [list copy];
}

@end
