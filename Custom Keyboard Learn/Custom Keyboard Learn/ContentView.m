//
//  ContentView.m
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 19/10/12.
//  Copyright (c) 2012 fandaliu. All rights reserved.
//

#import "ContentView.h"
#import "FlickCodeKeyboard.h"

@interface ContentView()

@property(nonatomic, readwrite, strong) IBOutlet FlickCodeKeyboard *inputView;

- (void) loadInputView;

@end

@implementation ContentView

@synthesize inputView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        [self loadInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadInputView];
    }
    return self;
}

- (void)loadInputView {

    UINib *inputViewNib = [UINib nibWithNibName:@"FlickCodeKeyboard" bundle:nil];
    [inputViewNib instantiateWithOwner:self options:nil];
}

-(void)accessibilityElementDidBecomeFocused {
    
//    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.accessibilityLabel);
}

-(BOOL)isAccessibilityElement {
    return YES;
}

//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}

@end
