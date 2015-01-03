//
//  ManyStringsSpeaker.m
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 14/11/12.
//  Copyright (c) 2012 fandaliu. All rights reserved.
//

#import "ManyStringsSpeaker.h"

@interface ManyStringsSpeaker()
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@end

@implementation ManyStringsSpeaker
@synthesize remainingStringsToBeSpoken;

- (id)init {
    
    return [self initWithStringsToBeSpoken:nil];
}

// designated initializer
-(id)initWithStringsToBeSpoken:(NSArray *)string{
    self = [super init];
    if (self) {
        remainingStringsToBeSpoken = [NSMutableArray arrayWithArray:string];
        
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
            return self;
        }
        
        if (string && [string count] > 0) {
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(speak:)
             name:UIAccessibilityAnnouncementDidFinishNotification
             object:nil];
        }
    }
    
    return self;
}

- (void)cancelSpeaking {
    
    remainingStringsToBeSpoken = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)speak:(NSNotification *)dict {
    
    // figure out what you should speak (from the array of strings) and put it in the stringToBeSpoken
    NSString *stringToBeSpoken = nil;
    if ([remainingStringsToBeSpoken count] == 0) {
        [self cancelSpeaking];
        return;
    }
    stringToBeSpoken = [remainingStringsToBeSpoken objectAtIndex:0];
    
    // Speak the stringToBeSpoken
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, stringToBeSpoken);
    
    // Update the array of strings to be spoken, so that we know what's left to say
    [remainingStringsToBeSpoken removeObjectAtIndex:0];
    
    // If there is nothing else to be spoken, make sure you just return
    if ([remainingStringsToBeSpoken count] == 0) {
        [self cancelSpeaking];
        return;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
