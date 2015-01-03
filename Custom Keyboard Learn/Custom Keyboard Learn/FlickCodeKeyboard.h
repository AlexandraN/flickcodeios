//
//  FlickCodeKeyboard.h
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 19/10/12.
//
//

#import <UIKit/UIKit.h>

@interface FlickCodeKeyboard : UILabel<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipeGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipeGestureRecognizer;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *twoTouchTapGestureRecognizer;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *twoTouchLongPressGestureRecognizer;

@property (nonatomic, weak) IBOutlet id <UITextInput> delegate;

- (IBAction)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
- (IBAction)handleOneTapFrom:(UITapGestureRecognizer *)recognizer;
- (IBAction)handleTwoTouchTapFrom:(UITapGestureRecognizer *)recognizer;
- (IBAction)handleTwoTouchLongPressFrom:(UILongPressGestureRecognizer *)recognizer;

- (void)configureGestureRecognizers;
- (void)resetFlickSequence;
@end
