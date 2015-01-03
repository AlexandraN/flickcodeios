//
//  CreateSMSTextViewController.m
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 05/03/13.
//  Copyright (c) 2013 fandaliu. All rights reserved.
//

#import "CreateSMSTextViewController.h"
#import "SelectedPeopleViewController.h"

@interface CreateSMSTextViewController ()

@end

@implementation CreateSMSTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarButtonItem *)createRightButton {
    UIBarButtonItem *smsDestinationButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@"SMS Destination"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(goToSMSDestinationScreen)];
    return smsDestinationButton;
}

- (void)goToSMSDestinationScreen {
    SelectedPeopleViewController *selectedPeopleViewController = [[SelectedPeopleViewController alloc] initWithNibName:@"SelectedPeopleViewController" bundle:nil];
    selectedPeopleViewController.title = @"Destination";
    [self.navigationController pushViewController:selectedPeopleViewController animated:YES];
}

@end
