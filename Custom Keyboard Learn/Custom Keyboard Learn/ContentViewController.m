//
//  ViewController.m
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 19/10/12.
//
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize title, keyboardVisible;

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationItem.title = self.title;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    // Initially, the keyboard is not hidden
    self.keyboardVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view becomeFirstResponder];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)keyboardDidShow: (NSNotification *)notification {

    if (!keyboardVisible) {
        return;
    }

    // Get the size of the keyboard
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

    // Resize the scroll view to make room for the keyboard
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.view.contentInset = contentInsets;
    self.view.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardDidHide: (NSNotification *)notification {

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.view.contentInset = contentInsets;
    self.view.scrollIndicatorInsets = contentInsets;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *copyButton = [self createRightButton];
    self.navigationItem.rightBarButtonItem = copyButton;
}

- (UIBarButtonItem* )createRightButton {
    UIBarButtonItem *copyButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Copy"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(copyText)];
    return copyButton;
}

- (void)viewDidUnload {
    [self setView:nil];
    [super viewDidUnload];
}

- (void)copyText {
    NSString *string = [self.view text];
    [UIPasteboard generalPasteboard].string = string;

    NSLog(@"%@", [[UIPasteboard generalPasteboard] string]);
}

@end
