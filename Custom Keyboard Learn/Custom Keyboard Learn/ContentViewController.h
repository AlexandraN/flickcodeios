//
//  ViewController.h
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 19/10/12.
//
//

#import <UIKit/UIKit.h>
#import "ContentView.h"

@interface ContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet ContentView *view;
@property (nonatomic, copy) NSString *title;
@property BOOL keyboardVisible;

- (void)keyboardDidShow: (NSNotification *)notification;
- (void)keyboardDidHide: (NSNotification *)notification;
- (UIBarButtonItem *) createRightButton;
- (IBAction)copyText;

@end
