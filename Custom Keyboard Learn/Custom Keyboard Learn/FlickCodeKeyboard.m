//
//  FlickCodeKeyboard.m
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 19/10/12.
//  Copyright (c) 2012 fandaliu. All rights reserved.
//

#import "FlickCodeKeyboard.h"
#import "SBJson.h"
#import "FlickCode.h"
#import "ManyStringsSpeaker.h"

@interface FlickCodeKeyboard()

@property (nonatomic, strong) ManyStringsSpeaker *tempSpeaker;
@property (nonatomic, strong) NSString *flickSequence;
@property (nonatomic, strong) FlickCode *flickCode;
@property (nonatomic, assign) BOOL speakFlick;
@property (nonatomic, assign) BOOL speakWhatIsNext;

-(BOOL)handleTextFunctions:(NSString *)textFunction withSelectedText:(UITextRange *)selectedText;

@end

@implementation FlickCodeKeyboard

@synthesize delegate, rightSwipeGestureRecognizer, leftSwipeGestureRecognizer, oneTapGestureRecognizer, twoTouchTapGestureRecognizer, upSwipeGestureRecognizer, downSwipeGestureRecognizer, twoTouchLongPressGestureRecognizer;
@synthesize tempSpeaker, flickSequence, flickCode, speakFlick, speakWhatIsNext;

#pragma mark -
#pragma mark Configuration

-(void)awakeFromNib {
    [self configureGestureRecognizers];
}

-(BOOL)isAccessibilityElement {
    return YES;
}

/*
 If we give to the input view the trait UIAccessibilityTraitKeyboardKey, it(the input view) will behave as the default keyboard of the system. This means it is sensitive to the settings of the Voice Over rotor, in particular the typing mode (standard typing/touch typing).
 When the standard typing is on, the user touches a key, Voice Over says what the key is, then the user double taps to use the key. When the touch typing is on, the keyboard behaves as if the Voice Over is not on.
 For FlickCode keyboard, this means that if the touch typing is selected, each time the FlickCode keyboard is selected, it receives two taps for free. We don't want that, but we'll do it anyway, because there is still no possiblity to find out when the rotor options change (Apple said so).
 And we really need it, because otherwise, when selecting text, the keyboard loses the focus (I mean the move to the previous character, word etc. won't say what that previous thing is). 
 */
-(UIAccessibilityTraits)accessibilityTraits {
    return UIAccessibilityTraitAllowsDirectInteraction
    | UIAccessibilityTraitKeyboardKey
    ;
}

-(void)configureGestureRecognizers {
    
    self.numberOfLines = 0;
    self.textColor = UIColor.lightGrayColor;
    flickSequence = @"";
    flickCode = [[FlickCode alloc] init];
    speakFlick = YES;
    speakWhatIsNext = YES;
}

-(void)accessibilityElementDidLoseFocus {
  
    [self handleTwoTouchLongPressFrom:nil];
}

- (void)dealloc {
    tempSpeaker = nil;
}

#pragma mark -
#pragma mark Gestures handling

- (IBAction)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    UISwipeGestureRecognizerDirection mySwipeDirection = recognizer.direction;
    
    if (mySwipeDirection == UISwipeGestureRecognizerDirectionLeft) {
        
        [self checkFlickSequence:@"<"];
        return;
    }
    
    if (mySwipeDirection == UISwipeGestureRecognizerDirectionRight) {
        
        [self checkFlickSequence:@">"];
        return;
    }
    
    if (mySwipeDirection == UISwipeGestureRecognizerDirectionUp) {
        
        [self checkFlickSequence:@"^"];
        return;
    }
    
    if (mySwipeDirection == UISwipeGestureRecognizerDirectionDown) {
        
        [self checkFlickSequence:@"v"];
        return;
    }
}

- (IBAction)handleOneTapFrom:(UITapGestureRecognizer *)recognizer {
    
    [self checkFlickSequence:@"."];
}

- (IBAction)handleTwoTouchTapFrom:(UITapGestureRecognizer *)recognizer {
    
    [self checkFlickSequence:@":"];
}

- (IBAction)handleTwoTouchLongPressFrom:(UILongPressGestureRecognizer *)recognizer {
    
    NSLog(@"Two touch long press");
    [self resetFlickSequence];
    [tempSpeaker cancelSpeaking];
//    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"");
}

- (void)checkFlickSequence:(NSString *)flick {
    
    flickSequence = [flickSequence stringByAppendingString:flick];
    
    NSString *stringToBeSpoken = [flickCode getStringToBeSpoken:flickSequence];
    if (stringToBeSpoken) {
        [self speakNextGesturesAfterSpeaking:stringToBeSpoken];
    }
    
    NSLog(@"%@ %d", flickSequence, flickSequence.length);
    // If there aren't three flicks, we don't have a full gesture, so we stop here the check
    if (flickSequence.length != 3) {
        return;
    }
    
    NSString *function = [flickCode getFunction:flickSequence];
    
    if (function) {
        [self handleTextFunctions:function withSelectedText:[delegate selectedTextRange]];
    } else {
        NSString *character = [flickCode getCharacter:flickSequence];
        if ([character length] == 0) {
            [self resetFlickSequence];
            return;
        }
        [self write:character];
    }
    
    [self resetFlickSequence];
}

-(void)resetFlickSequence {
    
    flickSequence = @"";
    [self setText:@""];
}

#pragma mark
#pragma mark Speach

/**
 Speak what are the available options if the user would do one more flick.
 But first, speak stringToBeSpoken.
 If the flick sequence is three, it means we have a full gesture, so we are
 going to speak only the stringToBeSpoken.
 If the flick sequence is different than three (this means almost all the time
 that it's less than three) it means that we don't have a full flick, so we need to
 speak the stringToBeSpoken, which is probably what the gesture means until now, and
 then speak what will be possible if the user does a new flick.
 */
-(void)speakNextGesturesAfterSpeaking:(NSString *) firstStringToBeSpoken {
    
    NSMutableArray *nextStringsToBeSpoken = [NSMutableArray array];
    
    if (speakFlick) {
        [nextStringsToBeSpoken addObject:firstStringToBeSpoken];
    }
    
    if (speakWhatIsNext) {
        NSArray *possibleNextThings = [flickCode getPossibleNextFunctionsAndCharactersAfterFlickSequence:flickSequence];
        [nextStringsToBeSpoken addObjectsFromArray:possibleNextThings];
    }
    
    // Write nextStringsToBeSpoken in the Keyboard label
    NSString *longString = @"";
    for (int i = 0; i < [nextStringsToBeSpoken count]; i++) {
        NSString *string = [nextStringsToBeSpoken objectAtIndex:i];
        if (i == 0) {
            longString = [longString stringByAppendingFormat:@"%@ %@:\n", flickSequence, string];
            continue;
        }
        
        longString = [longString stringByAppendingFormat:@"%@ %@\n", [[flickCode allFlicks] objectAtIndex:i-1], string];
    }
    
    [self setText:longString];
    NSLog(@"%@", longString);
    
    // Speak nextStringsToBeSpoken
    tempSpeaker = [[ManyStringsSpeaker alloc] initWithStringsToBeSpoken:nextStringsToBeSpoken];
    [tempSpeaker speak:[NSNotification notificationWithName:@"keyboard" object:self]];
}

- (void) speakForFunctionWithString: (NSString *)string {
    
    NSString *stringToBeSpoken = [flickCode getStringToBeSpoken:flickSequence];
    NSArray *strings = [NSArray arrayWithObjects:stringToBeSpoken, string, nil];
    
    tempSpeaker = [[ManyStringsSpeaker alloc] initWithStringsToBeSpoken:strings];
    [tempSpeaker speak:[NSNotification notificationWithName:@"keyboard" object:self]];
}

#pragma mark -
#pragma mark Writing

- (void)write:(NSString *)something {
    
    UITextRange *selectedText = [delegate selectedTextRange];
    
    if (selectedText == nil) {
        // no selection or insertion point
        
    } else if (selectedText.empty){
        // inserting text at an insertion point
        [delegate replaceRange:selectedText withText:something];
        
        tempSpeaker = [[ManyStringsSpeaker alloc] initWithStringsToBeSpoken:[NSArray arrayWithObject:something]];
        [tempSpeaker speak:nil];
    } else {
        // inserting text at an insertion point
        [delegate replaceRange:selectedText withText:something];
                
        tempSpeaker = [[ManyStringsSpeaker alloc] initWithStringsToBeSpoken:[NSArray arrayWithObject:something]];
        [tempSpeaker speak:nil];
    }
}

#pragma mark -
#pragma mark Functions

-(BOOL)handleTextFunctions:(NSString *)textFunction withSelectedText:(UITextRange *)selectedText {
    
    
    if ([textFunction isEqualToString:@"newline"]) {
        
        [delegate replaceRange:selectedText withText:@"\n"];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Delete next"]) {
        
        UITextPosition *oneAfterSelectedThingPosition = [delegate positionFromPosition:[selectedText start] offset:1];
        if (!oneAfterSelectedThingPosition) {
            return YES;
        }
        
        UITextRange *oneAfterSelectedThingRange = [delegate textRangeFromPosition:[selectedText start] toPosition:oneAfterSelectedThingPosition];
        [delegate replaceRange:oneAfterSelectedThingRange withText:@""];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Delete previous"]) {
        
        [delegate deleteBackward];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Beginning"]) {
        
        UITextPosition *beginningOfTextPosition = [delegate beginningOfDocument];
        UITextRange *range =  [delegate textRangeFromPosition:beginningOfTextPosition toPosition:beginningOfTextPosition];
        [delegate setSelectedTextRange:range];
        
        return YES;
    }
    if ([textFunction isEqualToString:@"End"]) {
        
        UITextPosition *endOfText = [delegate endOfDocument];
        UITextRange *range =  [delegate textRangeFromPosition:endOfText toPosition:endOfText];
        [delegate setSelectedTextRange:range];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Move to previous sentence"]) {
        
        [self moveToPreviousSentenceWithSelectedText:selectedText];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Move to next"]) {
        
        [self moveToNextCharacterWithSelectedText:selectedText];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Move to next sentence"]) {
        
        [self moveToNextSentenceWithSelectedText:selectedText];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Move to previous"]) {
        
        [self moveToPreviousCharacterWithSelectedText:selectedText];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Move to next word"]) {
        
        [self moveToNextWordWithSelectedText:selectedText];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Move to previous word"]) {
        
        [self moveToPreviousWordWithSelectedText:selectedText];
        
        return YES;
    }
    
    if ([textFunction isEqualToString:@"Select all the text"]) {
        
        [self selectAllTheTextWithSelectedText:selectedText];
        
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark Moving in the text

-(void)moveToPreviousCharacterWithSelectedText: (UITextRange *)selectedText {
    
    UITextPosition *position = [selectedText start];
    UITextPosition *oneBeforeSelectedThingPosition = [delegate positionFromPosition:position offset:-1];
    if (!oneBeforeSelectedThingPosition) {
        return;
    }
    
    UITextRange *oneBeforeSelectedThingRange = [delegate textRangeFromPosition:oneBeforeSelectedThingPosition toPosition:oneBeforeSelectedThingPosition];
    [delegate setSelectedTextRange:oneBeforeSelectedThingRange];
    
    // Speak
    NSString *previousCharacter = [delegate textInRange:[delegate textRangeFromPosition:oneBeforeSelectedThingPosition toPosition:position]];
    [self speakForFunctionWithString:previousCharacter];
}

-(void)moveToPreviousWordWithSelectedText: (UITextRange *)selectedText {
    
    id<UITextInputTokenizer> tokenizer = [delegate tokenizer];
    UITextPosition *position = [selectedText start];
    
    if ([position isEqual:[delegate beginningOfDocument]]) {
        return;
    }
    
    UITextPosition *startOfWord = [tokenizer positionFromPosition:position toBoundary:UITextGranularityWord inDirection:UITextStorageDirectionBackward];
    
    if (startOfWord) {
        
        UITextRange *oneBeforeSelectedThingRange = [delegate textRangeFromPosition:startOfWord toPosition:startOfWord];
        [delegate setSelectedTextRange:oneBeforeSelectedThingRange];
        
        // Speak
        NSString *previousWord = [delegate textInRange:[delegate textRangeFromPosition:startOfWord toPosition:position]];
        [self speakForFunctionWithString:previousWord];
    } else {
        [self moveToPreviousCharacterWithSelectedText:selectedText];
        [self moveToPreviousWordWithSelectedText:[delegate selectedTextRange]];
    }
}

-(void)moveToPreviousSentenceWithSelectedText: (UITextRange *)selectedText {
    
    id<UITextInputTokenizer> tokenizer = [delegate tokenizer];
    UITextPosition *position = [selectedText start];
    
    if ([position isEqual:[delegate beginningOfDocument]]) {
        return;
    }
    
    UITextPosition *startOfSentence = [tokenizer positionFromPosition:position toBoundary:UITextGranularitySentence inDirection:UITextStorageDirectionBackward];
   
    
    if (startOfSentence && ![startOfSentence isEqual:position]) {
        
        UITextRange *oneBeforeSelectedThingRange = [delegate textRangeFromPosition:startOfSentence toPosition:startOfSentence];
        [delegate setSelectedTextRange:oneBeforeSelectedThingRange];
        
        // Speak
        NSString *previousSentence = [delegate textInRange:[delegate textRangeFromPosition:startOfSentence toPosition:position]];
        [self speakForFunctionWithString:previousSentence];
    } else {
        [self moveToPreviousCharacterWithSelectedText:selectedText];
        [self moveToPreviousSentenceWithSelectedText:[delegate selectedTextRange]];
    }
}

-(void)moveToNextCharacterWithSelectedText: (UITextRange *)selectedText {
    
    UITextPosition *position = [selectedText start];
    UITextPosition *oneAfterSelectedThingPosition = [delegate positionFromPosition:position offset:1];
    if (!oneAfterSelectedThingPosition) {
        return;
    }
    
    UITextRange *oneAfterSelectedThingRange = [delegate textRangeFromPosition:oneAfterSelectedThingPosition toPosition:oneAfterSelectedThingPosition];
    [delegate setSelectedTextRange:oneAfterSelectedThingRange];
    
    // Speak
    NSString *nextCharacter = [delegate textInRange:[delegate textRangeFromPosition:position toPosition:oneAfterSelectedThingPosition]];
    [self speakForFunctionWithString:nextCharacter];
}

-(void)moveToNextWordWithSelectedText: (UITextRange *)selectedText {
    
    id<UITextInputTokenizer> tokenizer = [delegate tokenizer];
    UITextPosition *position = [selectedText start];
    UITextPosition *endOfWord = [tokenizer positionFromPosition:position toBoundary:UITextGranularityWord inDirection:UITextStorageDirectionForward];
    
    if (endOfWord) {
        
        UITextRange *oneBeforeSelectedThingRange = [delegate textRangeFromPosition:endOfWord toPosition:endOfWord];
        [delegate setSelectedTextRange:oneBeforeSelectedThingRange];
        
        // Speak
        NSString *nextWord = [delegate textInRange:[delegate textRangeFromPosition:position toPosition:endOfWord]];
        [self speakForFunctionWithString:nextWord];
    }
}

-(void)moveToNextSentenceWithSelectedText: (UITextRange *)selectedText {
    
    id<UITextInputTokenizer> tokenizer = [delegate tokenizer];
    UITextPosition *position = [selectedText start];
    UITextPosition *endOfSentence = [tokenizer positionFromPosition:position toBoundary:UITextGranularitySentence inDirection:UITextStorageDirectionForward];
    
    if (endOfSentence && ![endOfSentence isEqual:position]) {
        
        UITextRange *oneBeforeSelectedThingRange = [delegate textRangeFromPosition:endOfSentence toPosition:endOfSentence];
        [delegate setSelectedTextRange:oneBeforeSelectedThingRange];
        
        // Speak
        NSString *nextSentence = [delegate textInRange:[delegate textRangeFromPosition:position toPosition:endOfSentence]];
        [self speakForFunctionWithString:nextSentence];
    }
}

#pragma mark - 
#pragma mark Selection of text

-(void)selectAllTheTextWithSelectedText: (UITextRange *)selectedText {
    
    UITextPosition *beginningOfTextPosition = [delegate beginningOfDocument];
    UITextRange *range =  [delegate textRangeFromPosition:beginningOfTextPosition toPosition:[selectedText end]];
    [delegate setSelectedTextRange:range];
}

-(void)selectNextWordWithSelectedText: (UITextRange *)selectedText {
    
}

-(void)selectNextSentenceWithSelectedText: (UITextRange *)selectedText {
    
}

-(void)selectNextCharacterWithSelectedText: (UITextRange *)selectedText {
    
}

-(void)selectPreviousWordWithSelectedText: (UITextRange *)selectedText {
    
}

-(void)selectPreviousSentenceWithSelectedText: (UITextRange *)selectedText {
    
}

-(void)selectPreviousCharacterWithSelectedText: (UITextRange *)selectedText {
    
}

@end
