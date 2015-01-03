//
//  ManyStringsSpeaker.h
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 14/11/12.
//
//

#import <Foundation/Foundation.h>
@class FlickCodeKeyboard;

@interface ManyStringsSpeaker : NSObject

@property (nonatomic, strong) NSMutableArray *remainingStringsToBeSpoken;

-(id)initWithStringsToBeSpoken:(NSArray *)string;
- (void)speak:(NSNotification *)dict;
-(void)cancelSpeaking;

@end
